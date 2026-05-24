#!/bin/bash
# ============================================================================
# deny-check.sh テスト
# ============================================================================
# 使い方: bash tests/test_deny_check.sh
# deny-check.sh のパターンマッチング・コマンド分割ロジックを検証する

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DENY_CHECKS=(
  "$REPO_DIR/.claude/scripts/deny-check.sh"
  "$REPO_DIR/scripts/deny-check.sh"
)

# テスト用の一時ディレクトリ
TEST_HOME=$(mktemp -d)
trap 'rm -rf "$TEST_HOME"' EXIT

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

# deny-check.sh を実行するヘルパー
run_deny_check() {
  local deny_check="$1"
  local command="$2"
  local tool_name="${3:-Bash}"
  local input
  input=$(jq -n --arg cmd "$command" --arg tool "$tool_name" \
    '{tool_input: {command: $cmd}, tool_name: $tool}')

  echo "$input" | HOME="$TEST_HOME" bash "$deny_check" 2>/dev/null
  return $?
}

assert_exit_code() {
  local description="$1"
  local expected="$2"
  local command="$3"
  local tool_name="${4:-Bash}"
  local deny_check

  for deny_check in "${DENY_CHECKS[@]}"; do
    local label
    local exit_code
    label=$(basename "$(dirname "$(dirname "$deny_check")")")
    TOTAL=$((TOTAL + 1))

    run_deny_check "$deny_check" "$command" "$tool_name"
    exit_code=$?

    if [ "$exit_code" -eq "$expected" ]; then
      green "  PASS: [$label] $description"
      PASS=$((PASS + 1))
    else
      red "  FAIL: [$label] $description (expected: $expected, got: $exit_code)"
      FAIL=$((FAIL + 1))
    fi
  done
}

assert_allowed() { assert_exit_code "$1" 0 "$2"; }
assert_denied() { assert_exit_code "$1" 2 "$2"; }
assert_skipped() { assert_exit_code "$1" 0 "$2" "$3"; }

# ----------------------------------------------------------------------------
# テスト前の検証
# ----------------------------------------------------------------------------

if ! command -v jq &>/dev/null; then
  red "Error: jq がインストールされていません"
  exit 1
fi

for deny_check in "${DENY_CHECKS[@]}"; do
  if [ ! -f "$deny_check" ]; then
    red "Error: deny-check.sh が見つかりません: $deny_check"
    exit 1
  fi
done

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
bold "--- 複合コマンドのチェック ---"

assert_denied "セミコロン区切りの危険なコマンドを検出" "echo hello; sudo rm -rf /tmp"
assert_denied "&& 区切りの危険なコマンドを検出" "ls -la && sudo apt update"
assert_denied "|| 区切りの危険なコマンドを検出" "test -f file || sudo reboot"
assert_denied "パイプ区切りの危険なコマンドを検出" "echo hello | sudo tee /tmp/hello"
assert_denied "コマンド置換内の危険なコマンドを検出" "echo \$(sudo whoami)"
assert_denied "バッククォート内の危険なコマンドを検出" "echo \`sudo whoami\`"

echo ""

# --- 境界値テスト ---
bold "--- 境界値テスト ---"

assert_allowed "空のコマンドは許可" ""
assert_allowed "スペースのみは許可" "   "
assert_denied "rm -rf /path はワイルドカードで拒否" "rm -rf /tmp/mytest"
assert_allowed "カレントディレクトリのrm -rfは許可" "rm -rf ./node_modules"
assert_allowed "安全なパイプラインは許可" "echo hello | grep hello"

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

if [ $FAIL -eq 0 ]; then
  green "All tests passed!"
  exit 0
else
  red "$FAIL test(s) failed."
  exit 1
fi
