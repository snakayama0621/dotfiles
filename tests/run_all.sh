#!/bin/bash
# ============================================================================
# テストランナー
# ============================================================================
# 使い方: bash tests/run_all.sh

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

tests=(
  "$SCRIPT_DIR/test_syntax.sh"
  "$SCRIPT_DIR/test_nvim.sh"
  "$SCRIPT_DIR/test_deny_check.sh"
  "$SCRIPT_DIR/test_link.sh"
  "$SCRIPT_DIR/test_setup.sh"
  "$SCRIPT_DIR/test_zshrc.sh"
  "$SCRIPT_DIR/test_format_edited_files.sh"
)

for test_script in "${tests[@]}"; do
  echo ""
  echo "============================================================================"
  echo "Running: ${test_script#$SCRIPT_DIR/}"
  echo "============================================================================"
  bash "$test_script"
done

echo ""
echo "============================================================================"
echo "All test suites passed."
echo "============================================================================"
