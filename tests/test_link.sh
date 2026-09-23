#!/bin/bash
# ============================================================================
# link.sh テスト
# ============================================================================
# 使い方: bash tests/test_link.sh
# link.sh の dry-run、テンプレート展開、バックアップ、symlink 作成を検証する

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=tests/helpers.sh
source "$SCRIPT_DIR/helpers.sh"

TMP_ROOT=$(mktemp -d)
trap 'rm -rf "$TMP_ROOT"' EXIT

bold "=== link.sh テスト ==="
echo ""

bold "--- dry-run ---"

dry_fixture="$TMP_ROOT/dry-fixture"
dry_home="$TMP_ROOT/dry-home"
mkdir -p "$dry_home"
make_dotfiles_fixture "$dry_fixture"

dry_output=$(HOME="$dry_home" "$dry_fixture/link.sh" -d 2>&1)
dry_status=$?

assert_eq "dry-run は成功する" "0" "$dry_status"
assert_contains "dry-run は Codex 設定生成予定を表示する" "$dry_output" "Would render Codex config"
assert_not_exists "dry-run は Codex 生成物を書き込まない" "$dry_fixture/.codex/user-config.toml"
assert_not_exists "dry-run は HOME 配下に .config を作らない" "$dry_home/.config"
assert_not_exists "dry-run は HOME 配下に .codex を作らない" "$dry_home/.codex"
assert_contains "dry-run は Claude 設定の作成予定を表示する" "$dry_output" "Would create Claude settings"
assert_not_exists "dry-run は Claude 設定を書き込まない" "$dry_fixture/.claude/settings.json"

echo ""
bold "--- 実行時のリンク作成 ---"

link_fixture="$TMP_ROOT/link-fixture"
link_home="$TMP_ROOT/link-home"
wrong_target="$TMP_ROOT/wrong-target"
mkdir -p "$link_home"
make_dotfiles_fixture "$link_fixture"

printf 'existing git local\n' > "$link_home/.gitconfig.local"
printf 'local_setting = true\n' > "$link_fixture/.codex/user-config.local.toml"
printf 'old zshrc\n' > "$link_home/.zshrc"
printf 'wrong target\n' > "$wrong_target"
ln -s "$wrong_target" "$link_home/.tmux.conf"

link_output=$(HOME="$link_home" "$link_fixture/link.sh" 2>&1)
link_status=$?

assert_eq "link.sh は成功する" "0" "$link_status"
assert_contains "既存ファイルのバックアップを通知する" "$link_output" "Backed up:"
assert_symlink_target ".zshrc をリポジトリへリンクする" "$link_home/.zshrc" "$link_fixture/.zshrc"
assert_symlink_target "誤った .tmux.conf symlink を張り替える" "$link_home/.tmux.conf" "$link_fixture/.tmux.conf"
assert_symlink_target "Codex config を生成物へリンクする" "$link_home/.codex/config.toml" "$link_fixture/.codex/user-config.toml"
assert_symlink_target "Claude hooks をリンクする" "$link_home/.claude/hooks" "$link_fixture/.claude/hooks"
assert_symlink_target "herdr config をファイル単位でリンクする" "$link_home/.config/herdr/config.toml" "$link_fixture/herdr/config.toml"
assert_symlink_target "Claude scripts をリンクする" "$link_home/.claude/scripts" "$link_fixture/.claude/scripts"
assert_file_contains "Codex template の HOME を展開する" "$link_fixture/.codex/user-config.toml" "home = \"$link_home\""
assert_file_contains "Codex template の DOTFILE_DIR を展開する" "$link_fixture/.codex/user-config.toml" "dotfile_dir = \"$link_fixture\""
assert_file_contains "Codex local 設定を追記する" "$link_fixture/.codex/user-config.toml" "local_setting = true"
assert_file_contains "Claude 設定を example から作成する" "$link_fixture/.claude/settings.json" '"example": true'
assert_symlink_target "Claude 設定をリンクする" "$link_home/.claude/settings.json" "$link_fixture/.claude/settings.json"
assert_file_contains ".gitconfig.local は既存内容を保持する" "$link_home/.gitconfig.local" "existing git local"

echo ""
bold "--- 既存 Claude 設定の保持 ---"

keep_fixture="$TMP_ROOT/keep-fixture"
keep_home="$TMP_ROOT/keep-home"
mkdir -p "$keep_home"
make_dotfiles_fixture "$keep_fixture"
printf 'existing git local\n' > "$keep_home/.gitconfig.local"
printf '{"local": true}\n' > "$keep_fixture/.claude/settings.json"

HOME="$keep_home" "$keep_fixture/link.sh" >/dev/null 2>&1
assert_file_contains "既存の Claude 設定を上書きしない" "$keep_fixture/.claude/settings.json" '"local": true'

backup_count=$(find "$link_home" -maxdepth 1 -name '.zshrc.backup.*' -type f | wc -l | tr -d '[:space:]')
assert_eq "既存 .zshrc のバックアップを1つ作る" "1" "$backup_count"
backup_file=$(find "$link_home" -maxdepth 1 -name '.zshrc.backup.*' -type f | head -n 1)
assert_file_contains "バックアップに元の内容を保持する" "$backup_file" "old zshrc"

finish_tests
