#!/bin/bash
# ============================================================================
# deny-check.sh テスト
# ============================================================================
# 使い方: bash tests/test_deny_check.sh
# deny-check.sh のパターンマッチング・コマンド分割ロジックを検証する

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DENY_CHECK="$REPO_DIR/.claude/scripts/deny-check.sh"

# テスト用の一時ディレクトリ（$HOME/.claude/settings.json の構造を再現）
TEST_HOME=$(mktemp -d)
TEST_SETTINGS="$TEST_HOME/.claude/settings.json"
mkdir -p "$TEST_HOME/.claude"

# カウンター
PASS=0
FAIL=0
TOTAL=0

# 色付き出力
green() { printf "\033[32m%s\033[0m\n" "$1"; }
red() { printf "\033[31m%s\033[0m\n" "$1"; }
bold() { printf "\033[1m%s\033[0m\n" "$1"; }

# ----------------------------------------------------------------------------
# テストヘルパー
# ----------------------------------------------------------------------------

setup_settings() {
  cat > "$TEST_SETTINGS" << 'SETTINGS'
{
  "permissions": {
    "deny": [
      "Bash(rm -rf /)",
      "Bash(rm -rf /*)",
      "Bash(rm -rf ~)",
      "Bash(sudo:*)",
      "Bash(chmod 777:*)",
      "Bash(export AWS_*)",
      "Bash(export *SECRET*)",
      "Bash(ssh:*)"
    ]
  }
}
SETTINGS
}

# deny-check.sh を実行するヘルパー
# $HOME/.claude/settings.json の代わりにテスト用設定を使用
run_deny_check() {
  local command="$1"
  local tool_name="${2:-Bash}"
  local input
  input=$(jq -n --arg cmd "$command" --arg tool "$tool_name" \
    '{tool_input: {command: $cmd}, tool_name: $tool}')

  # HOME をテスト用ディレクトリに差し替えて実行
  echo "$input" | HOME="$TEST_HOME" bash "$DENY_CHECK" 2>/dev/null
  return $?
}

# テストアサーション: コマンドが許可されることを検証
assert_allowed() {
  local description="$1"
  local command="$2"
  TOTAL=$((TOTAL + 1))

  run_deny_check "$command"
  local exit_code=$?

  if [ $exit_code -eq 0 ]; then
    green "  PASS: $description"
    PASS=$((PASS + 1))
  else
    red "  FAIL: $description (expected: allowed, got: exit code $exit_code)"
    FAIL=$((FAIL + 1))
  fi
}

# テストアサーション: コマンドが拒否されることを検証
assert_denied() {
  local description="$1"
  local command="$2"
  TOTAL=$((TOTAL + 1))

  run_deny_check "$command"
  local exit_code=$?

  if [ $exit_code -eq 2 ]; then
    green "  PASS: $description"
    PASS=$((PASS + 1))
  else
    red "  FAIL: $description (expected: denied(2), got: exit code $exit_code)"
    FAIL=$((FAIL + 1))
  fi
}

# テストアサーション: Bash以外のツールはスキップされることを検証
assert_skipped() {
  local description="$1"
  local command="$2"
  local tool_name="$3"
  TOTAL=$((TOTAL + 1))

  run_deny_check "$command" "$tool_name"
  local exit_code=$?

  if [ $exit_code -eq 0 ]; then
    green "  PASS: $description"
    PASS=$((PASS + 1))
  else
    red "  FAIL: $description (expected: skipped(0), got: exit code $exit_code)"
    FAIL=$((FAIL + 1))
  fi
}

# ----------------------------------------------------------------------------
# テスト前の検証
# ----------------------------------------------------------------------------

# 前提条件チェック
if [ ! -f "$DENY_CHECK" ]; then
  red "Error: deny-check.sh が見つかりません: $DENY_CHECK"
  exit 1
fi

if ! command -v jq &>/dev/null; then
  red "Error: jq がインストールされていません"
  exit 1
fi

# テスト用設定ファイルをセットアップ
setup_settings

# ----------------------------------------------------------------------------
# テスト実行
# ----------------------------------------------------------------------------

bold "=== deny-check.sh テスト ==="
echo ""

# --- 正常系: 許可されるコマンド ---
bold "--- 許可されるコマンド ---"

assert_allowed "通常のlsコマンドは許可" "ls -la"
assert_allowed "gitステータスは許可" "git status"
assert_allowed "npmインストールは許可" "npm install"
assert_allowed "echoコマンドは許可" "echo hello"
assert_allowed "catコマンドは許可" "cat README.md"
assert_allowed "安全なrmは許可" "rm file.txt"
assert_allowed "mkdirは許可" "mkdir -p /tmp/test"

echo ""

# --- 異常系: 拒否されるコマンド ---
bold "--- 拒否されるコマンド ---"

assert_denied "rm -rf / は拒否" "rm -rf /"
assert_denied "rm -rf /* は拒否" "rm -rf /*"
assert_denied "rm -rf ~ は拒否" "rm -rf ~"
assert_denied "sudo コマンドは拒否" "sudo apt install vim"
assert_denied "sudo rm は拒否" "sudo rm -rf /tmp"
assert_denied "chmod 777 は拒否" "chmod 777 /etc/passwd"
assert_denied "export AWS_ は拒否" "export AWS_SECRET_ACCESS_KEY=xxx"
assert_denied "export SECRET は拒否" "export MY_SECRET_KEY=value"
assert_denied "ssh コマンドは拒否" "ssh user@host"

echo ""

# --- コマンド分割テスト ---
bold "--- 複合コマンド(;, &&, ||)のチェック ---"

assert_denied "セミコロン区切りの危険なコマンドを検出" "echo hello; sudo rm -rf /tmp"
assert_denied "&& 区切りの危険なコマンドを検出" "ls -la && sudo apt update"
assert_denied "|| 区切りの危険なコマンドを検出" "test -f file || sudo reboot"

echo ""

# --- 境界値テスト ---
bold "--- 境界値テスト ---"

assert_allowed "空のコマンドは許可" ""
assert_allowed "スペースのみは許可" "   "
assert_denied "rm -rf /path はワイルドカードで拒否" "rm -rf /tmp/mytest"
assert_allowed "カレントディレクトリのrm -rfは許可" "rm -rf ./node_modules"
assert_allowed "パイプは分割しない（安全なコマンド）" "echo hello | grep hello"

echo ""

# --- ツール名フィルタリングテスト ---
bold "--- ツール名フィルタリング ---"

assert_skipped "Readツールはスキップ" "rm -rf /" "Read"
assert_skipped "Writeツールはスキップ" "sudo rm -rf /" "Write"
assert_skipped "Editツールはスキップ" "chmod 777 file" "Edit"

echo ""

# ----------------------------------------------------------------------------
# テスト結果サマリー
# ----------------------------------------------------------------------------

bold "=== テスト結果 ==="
echo "合計: $TOTAL  成功: $PASS  失敗: $FAIL"

# クリーンアップ
rm -rf "$TEST_HOME"

if [ $FAIL -eq 0 ]; then
  green "All tests passed!"
  exit 0
else
  red "$FAIL test(s) failed."
  exit 1
fi
