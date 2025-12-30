# ============================================================================
# Brewfile - Homebrew パッケージ管理
# ============================================================================
# 使用方法:
#   brew bundle           # パッケージをインストール
#   brew bundle cleanup   # Brewfileにないパッケージを削除
#   brew bundle check     # 全てインストール済みか確認
# ============================================================================

# Taps
tap "aws/tap"
tap "daipeihust/tap"       # im-select用
tap "homebrew/services"
tap "sanemat/font"

# ============================================================================
# CLI Tools
# ============================================================================

# シェル・ターミナル
brew "sheldon"            # Zshプラグインマネージャー
brew "lua"                # Lua（sketchybar用）
brew "switchaudio-osx"    # オーディオ切替（sketchybar用）
brew "nowplaying-cli"     # メディア情報取得（sketchybar用）
brew "starship"           # プロンプトカスタマイズ
brew "tmux"               # ターミナルマルチプレクサ
brew "zoxide"             # スマートcd
brew "im-select"          # IME切り替えツール（Neovim用）

# ファイル操作・検索
brew "yazi"               # ターミナルファイルマネージャー
brew "fd"                 # findの代替
brew "ripgrep"            # grepの代替
brew "fzf"                # ファジー検索
brew "bat"                # catの代替（シンタックスハイライト付き）
brew "exa"                # lsの代替
brew "tree"               # ディレクトリツリー表示

# yazi依存パッケージ（プレビュー機能用）
brew "ffmpegthumbnailer"  # 動画サムネイル
brew "unar"               # アーカイブプレビュー
brew "poppler"            # PDFプレビュー
brew "imagemagick"        # 画像処理

# エディタ
brew "neovim"             # Vim後継エディタ

# Git関連
brew "gh"                 # GitHub CLI
brew "ghq"                # リポジトリ管理
brew "git-secrets"        # シークレットスキャン
brew "lazygit"            # Git TUI
brew "tig"                # Git TUI（詳細表示）

# 開発言語・ランタイム
brew "deno"               # JavaScript/TypeScriptランタイム
brew "go"                 # Go言語
brew "node"               # Node.js
brew "pnpm"               # Node.jsパッケージマネージャー
brew "php"                # PHP
brew "composer"           # PHPパッケージマネージャー
brew "python@3.11"        # Python 3.11
brew "python-tk@3.13"     # Python Tkinter
brew "python-tk@3.14"     # Python Tkinter
brew "pyenv"              # Pythonバージョン管理
brew "uv"                 # Python高速パッケージマネージャー
brew "luarocks"           # Luaパッケージマネージャー
brew "tcl-tk"             # Tcl/Tk

# AWS・クラウド
brew "awscli"             # AWS CLI
brew "aws-sam-cli"        # AWS SAM CLI
brew "cfn-lint"           # CloudFormation Linter
brew "tfenv"              # Terraformバージョン管理

# システムモニタリング
brew "btop"               # リソースモニタ
brew "htop"               # プロセスビューア
brew "procs"              # psの代替
brew "neofetch"           # システム情報表示

# ネットワーク
brew "wget"               # ダウンローダー
brew "nmap"               # ネットワークスキャナ

# ユーティリティ
brew "jq"                 # JSON処理
brew "coreutils"          # GNU Core Utilities
brew "gawk"               # GNU awk
brew "peco"               # インタラクティブフィルタ
brew "pastel"             # カラー操作ツール
brew "mas"                # Mac App Store CLI
brew "act"                # GitHub Actions ローカル実行
brew "topgrade"           # 一括アップグレード
brew "chezmoi"            # Dotfile管理
brew "gibo"               # gitignoreボイラープレート生成

# AI/LLM
brew "gemini-cli"         # Gemini CLI

# 日本語処理
brew "mecab"              # 形態素解析
brew "mecab-ipadic"       # MeCab辞書

# その他ライブラリ
brew "certifi"            # CA証明書
brew "glib"               # GLib
brew "harfbuzz"           # テキストシェーピング
brew "pango"              # テキストレンダリング
brew "fontforge"          # フォントエディタ
brew "librsvg"            # SVGレンダリング
brew "graphviz"           # グラフ可視化

# MySQL
brew "mysql"              # データベース

# ============================================================================
# GUI Applications (Casks)
# ============================================================================

# ターミナル
cask "iterm2"             # ターミナルエミュレータ
cask "warp"               # モダンターミナル
cask "wezterm"            # GPU加速ターミナル

# 開発ツール
cask "visual-studio-code" # エディタ
cask "orbstack"           # Docker代替
cask "rancher"            # Kubernetes管理
cask "wireshark-app"      # パケット解析

# 仮想化
cask "utm"                # 仮想マシン

# ユーティリティ
cask "raycast"            # ランチャー
cask "karabiner-elements" # キーボードカスタマイズ
cask "jordanbaird-ice"    # メニューバー管理
cask "xquartz"            # X11

# ウィンドウマネージャー・ステータスバー
cask "nikitabobko/tap/aerospace"  # タイルウィンドウマネージャー
brew "FelixKratz/formulae/borders" # ウィンドウボーダー
brew "FelixKratz/formulae/sketchybar" # ステータスバー

# AI
cask "kiro-cli"           # AI CLI

# フォント
cask "font-hack-nerd-font"          # Nerd Font (Hack)
cask "font-symbols-only-nerd-font"  # Nerd Font (Symbols Only)
cask "sf-symbols"                   # Appleシンボルフォント（sketchybar用）
cask "font-sf-mono"                 # 数字表示用フォント（sketchybar用）
cask "font-sf-pro"                  # テキスト表示用フォント（sketchybar用）


# ============================================================================
# VS Code Extensions
# ============================================================================

vscode "4ops.terraform"
vscode "aaron-bond.better-comments"
vscode "ahmadawais.shades-of-purple"
vscode "alefragnani.project-manager"
vscode "amazonwebservices.codewhisperer-for-command-line-companion"
vscode "asvetliakov.vscode-neovim"
vscode "dzhavat.bracket-pair-toggler"
vscode "eamodio.gitlens"
vscode "ecmel.vscode-html-css"
vscode "equinusocio.vsc-community-material-theme"
vscode "equinusocio.vsc-material-theme"
vscode "equinusocio.vsc-material-theme-icons"
vscode "esbenp.prettier-vscode"
vscode "firejump.frame-indent-rainbow"
vscode "github.copilot"
vscode "github.copilot-chat"
vscode "github.copilot-labs"
vscode "glenn2223.live-sass"
vscode "golang.go"
vscode "gruntfuggly.todo-tree"
vscode "hediet.vscode-drawio"
vscode "htmlhint.vscode-htmlhint"
vscode "mechatroner.rainbow-csv"
vscode "ms-ceintl.vscode-language-pack-ja"
vscode "ms-python.debugpy"
vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "ms-toolsai.jupyter"
vscode "ms-toolsai.jupyter-keymap"
vscode "ms-toolsai.jupyter-renderers"
vscode "ms-toolsai.vscode-jupyter-cell-tags"
vscode "ms-toolsai.vscode-jupyter-slideshow"
vscode "ms-vscode-remote.remote-wsl"
vscode "ms-vscode.live-server"
vscode "oderwat.indent-rainbow"
vscode "pkief.material-icon-theme"
vscode "pranaygp.vscode-css-peek"
vscode "ritwickdey.liveserver"
vscode "rooveterinaryinc.roo-cline"
vscode "smelukov.vscode-csstree"
vscode "streetsidesoftware.code-spell-checker"
vscode "trixnz.go-to-method"
vscode "unthrottled.doki-theme"
vscode "withfig.fig"
vscode "yzhang.markdown-all-in-one"
