#!/bin/bash
# Neovim のコールバックを一時環境で検証する（プラグインの導入・外部接続なし）
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEST_TMP="$(mktemp -d)"
trap 'rm -rf "$TEST_TMP"' EXIT

export DOTFILES_TEST_REPO="$REPO_DIR"
export DOTFILES_TEST_TMP="$TEST_TMP"
export XDG_CONFIG_HOME="$TEST_TMP/config"
export XDG_DATA_HOME="$TEST_TMP/data"
export XDG_STATE_HOME="$TEST_TMP/state"
export XDG_CACHE_HOME="$TEST_TMP/cache"
export NVIM_LOG_FILE="$TEST_TMP/nvim.log"

cd "$TEST_TMP"
nvim --clean --headless -n -i NONE -l "$SCRIPT_DIR/test_nvim.lua"

if [ -n "${DOTFILES_NVIM_PLUGINS:-}" ]; then
  nvim --clean --headless -n -i NONE -l "$SCRIPT_DIR/test_nvim_plugins.lua"
fi
