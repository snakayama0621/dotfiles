#!/bin/bash
# ============================================================================
# 構文チェック
# ============================================================================
# 使い方: bash tests/test_syntax.sh
# shell / zsh / JSON / JS / Lua 設定ファイルの構文を検証する

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=tests/helpers.sh
source "$SCRIPT_DIR/helpers.sh"

bold "=== 構文チェック ==="
echo ""

bold "--- bash scripts ---"

while IFS= read -r script; do
  bash -n "$script"
  assert_eq "bash 構文: ${script#$REPO_DIR/}" "0" "$?"
done < <(
  {
    printf '%s\n' "$REPO_DIR/setup.sh"
    printf '%s\n' "$REPO_DIR/link.sh"
    find "$REPO_DIR/scripts" "$REPO_DIR/.claude/scripts" "$REPO_DIR/tests" -name '*.sh' -type f
  } | sort -u
)

echo ""
bold "--- zsh ---"

zsh -n "$REPO_DIR/.zshrc"
assert_eq "zsh 構文: .zshrc" "0" "$?"

echo ""
bold "--- JSON ---"

for json_file in \
  "$REPO_DIR/package.json" \
  "$REPO_DIR/package-lock.json" \
  "$REPO_DIR/.claude/settings.example.json"
do
  jq empty "$json_file"
  assert_eq "JSON 構文: ${json_file#$REPO_DIR/}" "0" "$?"
done

echo ""
bold "--- JavaScript ---"

node --check "$REPO_DIR/commitlint.config.js" >/dev/null
assert_eq "JavaScript 構文: commitlint.config.js" "0" "$?"

echo ""
bold "--- Lua ---"

if ! command -v luac >/dev/null 2>&1; then
  red "Error: luac がインストールされていません"
  exit 1
fi

while IFS= read -r lua_file; do
  luac -p "$lua_file"
  assert_eq "Lua 構文: ${lua_file#$REPO_DIR/}" "0" "$?"
done < <(find "$REPO_DIR/nvim" "$REPO_DIR/sketchybar" -name '*.lua' -type f | sort)

echo ""
bold "--- Yazi ---"

if ! command -v yazi >/dev/null 2>&1; then
  red "Error: yazi がインストールされていません"
  exit 1
fi

YAZI_CONFIG_HOME="$REPO_DIR/yazi" yazi --version >/dev/null
assert_eq "Yazi 設定を読み込める" "0" "$?"

finish_tests
