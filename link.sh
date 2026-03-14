#!/bin/bash

# ============================================================================
# Dotfile Symlink Setup Script
# ============================================================================
# このスクリプトは、dotfileリポジトリ内の設定ファイルを
# ホームディレクトリや~/.configディレクトリにシンボリックリンクとして配置します。
#
# 使用方法:
#   ./link.sh       # 実際にリンクを作成
#   ./link.sh -d    # Dry-run（何が実行されるか確認のみ）
# ============================================================================

set -e  # エラー時に停止

# ----------------------------------------------------------------------------
# 変数定義
# ----------------------------------------------------------------------------

# このスクリプトがあるディレクトリ（dotfileディレクトリ）のパスを取得
DOTFILE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Dry-runフラグ
DRY_RUN=false

# リンク設定（配列形式）
# 形式: "リンク先:リンク元"
LINKS=(
  "$HOME/.tmux.conf:$DOTFILE_DIR/.tmux.conf"
  "$HOME/.zshrc:$DOTFILE_DIR/.zshrc"
  "$HOME/.gitconfig:$DOTFILE_DIR/.gitconfig"
  "$HOME/.config/starship.toml:$DOTFILE_DIR/starship.toml"
  "$HOME/.config/wezterm:$DOTFILE_DIR/wezterm"
  "$HOME/.config/nvim:$DOTFILE_DIR/nvim"
  "$HOME/.config/sheldon:$DOTFILE_DIR/sheldon"
  "$HOME/.config/yazi:$DOTFILE_DIR/yazi"
  "$HOME/.config/aerospace:$DOTFILE_DIR/aerospace"
  "$HOME/.config/borders:$DOTFILE_DIR/borders"
  "$HOME/.config/sketchybar:$DOTFILE_DIR/sketchybar"
  "$HOME/.claude/settings.json:$DOTFILE_DIR/.claude/settings.json"
  "$HOME/.claude/CLAUDE.md:$DOTFILE_DIR/.claude/CLAUDE.md"
  "$HOME/.claude/scripts:$DOTFILE_DIR/.claude/scripts"
  "$HOME/.config/lazygit:$DOTFILE_DIR/lazygit"
  "$HOME/commitlint.config.js:$DOTFILE_DIR/commitlint.config.js"
)

# 色定義
COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_RED='\033[0;31m'
COLOR_BLUE='\033[0;34m'

# ----------------------------------------------------------------------------
# 関数定義
# ----------------------------------------------------------------------------

# ログ出力関数
log_info() {
  echo -e "${COLOR_BLUE}[INFO]${COLOR_RESET} $1"
}

log_success() {
  echo -e "${COLOR_GREEN}[SUCCESS]${COLOR_RESET} $1"
}

log_warning() {
  echo -e "${COLOR_YELLOW}[WARNING]${COLOR_RESET} $1"
}

log_error() {
  echo -e "${COLOR_RED}[ERROR]${COLOR_RESET} $1"
}

# バックアップ関数
backup_file() {
  local file=$1

  # シンボリックリンクでない実ファイル/ディレクトリが存在する場合のみバックアップ
  if [ -e "$file" ] && [ ! -L "$file" ]; then
    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"

    if [ "$DRY_RUN" = true ]; then
      log_warning "[DRY-RUN] Would backup: $file -> $backup"
    else
      mv "$file" "$backup"
      log_warning "Backed up: $file -> $backup"
    fi
  fi
}

# シンボリックリンク作成関数
create_link() {
  local target=$1
  local source=$2

  # リンク元のファイル/ディレクトリが存在するか確認
  if [ ! -e "$source" ]; then
    log_error "Source does not exist: $source"
    return 1
  fi

  # リンク先のディレクトリを作成（必要な場合）
  local target_dir=$(dirname "$target")
  if [ ! -d "$target_dir" ]; then
    if [ "$DRY_RUN" = true ]; then
      log_info "[DRY-RUN] Would create directory: $target_dir"
    else
      mkdir -p "$target_dir"
      log_info "Created directory: $target_dir"
    fi
  fi

  # 既存のシンボリックリンクをチェック
  if [ -L "$target" ]; then
    local current_link=$(readlink "$target")
    if [ "$current_link" = "$source" ]; then
      log_info "Already correctly linked: $target -> $source"
      return 0
    else
      log_warning "Link exists but points to different location: $target -> $current_link"
      if [ "$DRY_RUN" = true ]; then
        log_warning "[DRY-RUN] Would remove and re-create link"
      else
        rm "$target"
        log_info "Removed old link: $target"
      fi
    fi
  fi

  # 既存ファイル/ディレクトリのバックアップ
  backup_file "$target"

  # シンボリックリンク作成
  if [ "$DRY_RUN" = true ]; then
    log_info "[DRY-RUN] Would create link: $target -> $source"
  else
    ln -s "$source" "$target"
    log_success "Created link: $target -> $source"
  fi
}

# .gitconfig.local セットアップ関数
setup_gitconfig_local() {
  local local_config="$HOME/.gitconfig.local"
  local example_config="$DOTFILE_DIR/.gitconfig.local.example"

  if [ -f "$local_config" ]; then
    log_info "Git local config already exists: $local_config"
    return 0
  fi

  if [ ! -f "$example_config" ]; then
    log_warning "Example config not found: $example_config"
    return 1
  fi

  if [ "$DRY_RUN" = true ]; then
    log_info "[DRY-RUN] Would create $local_config from example and prompt for git user info"
    return 0
  fi

  log_info "Setting up git local config..."
  echo ""

  # ユーザーに名前とメールアドレスを入力してもらう
  read -rp "Git user.name: " git_name
  read -rp "Git user.email: " git_email

  # 改行・制御文字のバリデーション
  if printf '%s' "$git_name" | grep -qP '[\x00-\x1f]' || printf '%s' "$git_email" | grep -qP '[\x00-\x1f]'; then
    log_error "Name and email must not contain control characters."
    return 1
  fi

  if [ -z "$git_name" ] || [ -z "$git_email" ]; then
    log_warning "Name or email is empty. Copying example file as-is."
    log_warning "Please edit $local_config manually."
    cp "$example_config" "$local_config"
  else
    cat > "$local_config" << EOF
[user]
    name = $git_name
    email = $git_email
EOF
    log_success "Created $local_config with your git user info"
  fi
}

# 使用方法を表示
show_usage() {
  cat << EOF
Usage: $0 [OPTIONS]

Options:
  -d    Dry-run mode (show what would be done without actually doing it)
  -h    Show this help message

Example:
  $0       # Create symlinks
  $0 -d    # Show what would be done (dry-run)
EOF
}

# ----------------------------------------------------------------------------
# オプション解析
# ----------------------------------------------------------------------------

while getopts "dh" opt; do
  case $opt in
    d)
      DRY_RUN=true
      ;;
    h)
      show_usage
      exit 0
      ;;
    *)
      show_usage
      exit 1
      ;;
  esac
done

# ----------------------------------------------------------------------------
# メイン処理
# ----------------------------------------------------------------------------

echo "============================================================================"
echo "  Dotfile Symlink Setup"
echo "============================================================================"
echo ""

if [ "$DRY_RUN" = true ]; then
  log_warning "Running in DRY-RUN mode - no changes will be made"
  echo ""
fi

log_info "Dotfile directory: $DOTFILE_DIR"
echo ""

# .gitconfig.local のセットアップ（失敗してもリンク作成は続行）
setup_gitconfig_local || log_warning "Git local config setup skipped. Create ~/.gitconfig.local manually."
echo ""

# リンク作成ループ
SUCCESS_COUNT=0
ERROR_COUNT=0

for link_entry in "${LINKS[@]}"; do
  # "リンク先:リンク元" の形式を分割
  IFS=':' read -r target source <<< "$link_entry"

  if create_link "$target" "$source"; then
    ((SUCCESS_COUNT++))
  else
    ((ERROR_COUNT++))
  fi
  echo ""
done

# 結果サマリー
echo "============================================================================"
if [ "$DRY_RUN" = true ]; then
  log_info "Dry-run completed"
else
  log_success "Setup completed"
fi
echo "  Successful: $SUCCESS_COUNT"
if [ $ERROR_COUNT -gt 0 ]; then
  echo "  Errors: $ERROR_COUNT"
fi
echo "============================================================================"

if [ "$DRY_RUN" = true ]; then
  echo ""
  log_info "To actually create the links, run: $0"
else
  echo ""
  log_info "Reloading zshrc..."
  if [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
    log_success "zshrc reloaded"
  else
    log_info "Run 'source ~/.zshrc' to apply changes (current shell is not zsh)"
  fi
fi

exit 0
