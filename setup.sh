#!/bin/bash

# ============================================================================
# Dotfiles Setup Script
# ============================================================================
# 新しい環境でdotfilesをセットアップするための統合スクリプト
#
# 使用方法:
#   ./setup.sh       # 全てをセットアップ
#   ./setup.sh -d    # Dry-run（何が実行されるか確認のみ）
#   ./setup.sh -b    # Brewfileのみ実行
#   ./setup.sh -l    # link.shのみ実行
# ============================================================================

set -e

# このスクリプトがあるディレクトリのパスを取得
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# フラグ
DRY_RUN=false
BREW_ONLY=false
LINK_ONLY=false

# 色定義
COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_RED='\033[0;31m'
COLOR_BLUE='\033[0;34m'
COLOR_CYAN='\033[0;36m'

# ログ関数
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

log_step() {
  echo -e "${COLOR_CYAN}[STEP]${COLOR_RESET} $1"
}

# 使用方法を表示
show_usage() {
  cat << EOF
Usage: $0 [OPTIONS]

Options:
  -d    Dry-run mode (show what would be done without actually doing it)
  -b    Run only Homebrew bundle
  -l    Run only link.sh (symlinks)
  -h    Show this help message

Example:
  $0       # Full setup (brew bundle + symlinks)
  $0 -d    # Dry-run mode
  $0 -b    # Install packages only
  $0 -l    # Create symlinks only
EOF
}

# Homebrewがインストールされているか確認
check_homebrew() {
  if ! command -v brew &> /dev/null; then
    log_error "Homebrew is not installed."
    log_info "Install Homebrew first: https://brew.sh"
    log_info "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
  fi
}

# Brewfileを実行
run_brew_bundle() {
  log_step "Installing packages from Brewfile..."

  if [ ! -f "$SCRIPT_DIR/Brewfile" ]; then
    log_error "Brewfile not found: $SCRIPT_DIR/Brewfile"
    return 1
  fi

  if [ "$DRY_RUN" = true ]; then
    log_warning "[DRY-RUN] Would run: brew bundle --file=$SCRIPT_DIR/Brewfile"
    log_info "Packages to be installed:"
    grep -E "^(brew|cask|mas) " "$SCRIPT_DIR/Brewfile" | head -20
    echo "  ..."
  else
    cd "$SCRIPT_DIR"
    brew bundle --file=Brewfile
    log_success "Homebrew packages installed"
  fi
}

# sketchybarのセットアップ（SbarLua + フォント）
run_sketchybar_setup() {
  if ! command -v sketchybar &> /dev/null; then
    log_info "sketchybar not installed, skipping setup"
    return 0
  fi

  log_step "Setting up sketchybar..."

  # SbarLua install
  if [ ! -f "$HOME/.local/share/sketchybar_lua/sketchybar.so" ]; then
    log_info "Installing SbarLua..."
    if [ "$DRY_RUN" = true ]; then
      log_warning "[DRY-RUN] Would install SbarLua"
    else
      git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
      (cd /tmp/SbarLua && make install)
      rm -rf /tmp/SbarLua
      log_success "SbarLua installed"
    fi
  else
    log_info "SbarLua already installed"
  fi

  # App fonts
  mkdir -p "$HOME/Library/Fonts"
  for font_url in \
    "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf" \
    "https://github.com/SoichiroYamane/sketchybar-app-font-bg/releases/download/v0.0.2/sketchybar-app-font-bg.ttf"
  do
    font_name=$(basename "$font_url")
    if [ ! -f "$HOME/Library/Fonts/$font_name" ]; then
      if [ "$DRY_RUN" = true ]; then
        log_warning "[DRY-RUN] Would download $font_name"
      else
        curl -sL "$font_url" -o "$HOME/Library/Fonts/$font_name"
        log_success "Installed $font_name"
      fi
    fi
  done

  log_success "sketchybar setup completed"
}

# link.shを実行
run_link_script() {
  log_step "Creating symbolic links..."

  if [ ! -f "$SCRIPT_DIR/link.sh" ]; then
    log_error "link.sh not found: $SCRIPT_DIR/link.sh"
    return 1
  fi

  if [ "$DRY_RUN" = true ]; then
    "$SCRIPT_DIR/link.sh" -d
  else
    "$SCRIPT_DIR/link.sh"
  fi
}

# オプション解析
while getopts "dblh" opt; do
  case $opt in
    d)
      DRY_RUN=true
      ;;
    b)
      BREW_ONLY=true
      ;;
    l)
      LINK_ONLY=true
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

# メイン処理
echo ""
echo "============================================================================"
echo "  Dotfiles Setup"
echo "============================================================================"
echo ""

if [ "$DRY_RUN" = true ]; then
  log_warning "Running in DRY-RUN mode - no changes will be made"
  echo ""
fi

# Homebrewの確認
check_homebrew
log_success "Homebrew found: $(brew --version | head -1)"
echo ""

# 実行
if [ "$LINK_ONLY" = true ]; then
  run_link_script
elif [ "$BREW_ONLY" = true ]; then
  run_brew_bundle
else
  # フルセットアップ
  run_brew_bundle
  echo ""
  run_link_script
  echo ""
  run_sketchybar_setup
fi

echo ""
echo "============================================================================"
if [ "$DRY_RUN" = true ]; then
  log_info "Dry-run completed. Run without -d flag to apply changes."
else
  log_success "Setup completed!"
  echo ""
  log_info "You can now use:"
  log_info "  yazi  - Terminal file manager"
  log_info "  yy    - yazi with directory change on exit"
fi
echo "============================================================================"
