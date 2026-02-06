# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"

# ============================================================================
# 基本設定
# ============================================================================

# Ctrl+Dでログアウトしない
setopt IGNOREEOF

# 日本語使用
export LANG=ja_JP.UTF-8

# 色の使用
autoload -Uz colors
colors

# 補完機能の使用
autoload -Uz compinit
compinit

# cdなしでディレクトリ移動
setopt auto_cd

# キーバインド（Viモード）
bindkey -v

# ディレクトリスタック
setopt auto_pushd
setopt pushd_ignore_dups

# スペルチェック
setopt correct

# ファイル上書き防止
setopt no_clobber

# ============================================================================
# ヒストリー設定
# ============================================================================

# ヒストリーファイル
HISTFILE=~/.zsh_history

# ヒストリーサイズ
export HISTSIZE=10000

# ヒストリーファイルサイズ
export SAVEHIST=10000

# タイムスタンプフォーマット
HIST_STAMPS="yyyy-mm-dd"

# 重複したコマンドを無視
setopt hist_ignore_dups

# すべての重複を無視
setopt hist_ignore_all_dups

# スペースで始まるコマンドを無視
setopt hist_ignore_space

# ヒストリー実行前に確認
setopt hist_verify

# ヒストリーを共有
setopt share_history

# ヒストリーにタイムスタンプを記録
setopt extended_history

# 余分な空白を削除
setopt hist_reduce_blanks

# historyコマンド自体は保存しない
setopt hist_no_store

# ヒストリー展開を有効化
setopt hist_expand

# 履歴をインクリメンタルに追加
setopt inc_append_history

# ============================================================================
# 環境変数
# ============================================================================

# エディタ
export EDITOR=nvim

# nvim設定ファイルの場所
export XDG_CONFIG_HOME=~/.config

# グローバルnpmモジュールのパス（czg等で必要）
export NODE_PATH="/opt/homebrew/lib/node_modules"

# ============================================================================
# PATH設定（すべてのPATH追加をここに集約）
# ============================================================================

# pyenv（Pythonバージョン管理）
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

# 開発ツール
[[ -d "$HOME/.console-ninja/.bin" ]] && export PATH="$HOME/.console-ninja/.bin:$PATH"          # Console Ninja
[[ -d "$HOME/.codeium/windsurf/bin" ]] && export PATH="$HOME/.codeium/windsurf/bin:$PATH"      # Windsurf
[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"                      # LM Studio CLI

# コンテナ関連（Rancher Desktop）
[[ -d "$HOME/.rd/bin" ]] && export PATH="$HOME/.rd/bin:$PATH"

# その他
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# ============================================================================
# 外部ツール初期化
# ============================================================================

# Sheldon（Zshプラグインマネージャー）
eval "$(sheldon source)"

# pyenv
eval "$(pyenv init -)"

# Starship（プロンプト）
eval "$(starship init zsh)"

# zoxide（スマートcd）
eval "$(zoxide init zsh)"

# ============================================================================
# エイリアス
# ============================================================================

# ls
alias ls='ls -l --color=auto'
alias ll='ls -alF --color=auto'

# ディレクトリ移動
alias d='cd ~/dotfiles'
alias proot='cd $(git rev-parse --show-toplevel)'

# neovim
alias vi='nvim'
alias vim='nvim'

# lazygit
alias lg='lazygit'

# cd（zoxide + ls）
alias cd='zls'
alias zz='z'

# VPN
alias vpns='check_vpn_status'
alias vpnc='vpn_connect_with_fzf'
alias vpnd='vpn_disconnect_if_connected'

# gibo
alias gia='create_gitignore'

# ============================================================================
# 略語展開（abbr）
# ============================================================================

abbr -S -qq vpn='vpnutil' >>/dev/null
abbr -S -qq -='cd -' >>/dev/null

# ============================================================================
# 関数
# ============================================================================

# ------------------------------
# yazi（ファイルマネージャー）
# ------------------------------
# 終了時にディレクトリ変更を反映
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ------------------------------
# iTerm2
# ------------------------------
iterm2_print_user_vars() {
  iterm2_set_user_var test $(badge)
}

# バッジ表示
function badge() {
  printf "\e]1337;SetBadgeFormat=%s\a"\
  $(echo -n "$1" | base64)
}

# ------------------------------
# SSH（fzfでサーバー選択）
# ------------------------------
function ssh_local() {
  local config_files=("$HOME/.ssh/config")

  # config.dディレクトリが存在する場合、*.configファイルを追加
  if [[ -d "$HOME/.ssh/config.d" ]]; then
    config_files+=("$HOME/.ssh/config.d"/*.config(N))
  fi

  # 全ての設定ファイルからHost定義を抽出
  local server=$(cat "${config_files[@]}" 2>/dev/null | \
    grep "^Host " | \
    sed "s/^Host //g" | \
    grep -v '\*' | \
    sort -u | \
    fzf)

  if [ -z "$server" ]; then
    return
  fi

  badge "$server"
  ssh "$server"
}

# ------------------------------
# fzf連携
# ------------------------------

# fzfでヒストリー検索
function fzf-history-selection() {
  BUFFER=$(history -n 1 | tac -r | awk '!a[$0]++' | fzf --prompt="History > " --height=40% --reverse)
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N fzf-history-selection

# cdr（最近訪れたディレクトリ）設定
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':completion:*' recent-dirs-insert both
  zstyle ':chpwd:*' recent-dirs-default true
  zstyle ':chpwd:*' recent-dirs-max 1000
  zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

# fzfで最近訪れたディレクトリに移動
function fzf-cdr () {
  local selected_dir="$(cdr -l | awk '{$1=""; sub(" ", ""); print $0}' | fzf --prompt="cdr > " --query="$LBUFFER" --height=40% --reverse)"
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N fzf-cdr

# ghqで管理しているリポジトリに移動
function fzf-src () {
  local selected_dir=$(ghq list -p | fzf --prompt="repositories > " --query="$LBUFFER" --height=40% --reverse)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-src

# ------------------------------
# コマンド実行時刻表示
# ------------------------------
autoload -Uz add-zsh-hook
_cmd_executed=0

# コマンド開始時刻を表示
_show_start_time() {
  _cmd_executed=1
  echo -e "\e[32m[開始 $(date '+%H:%M:%S')]\e[0m"
}

# コマンド終了時刻を表示
_show_end_time() {
  if [[ $_cmd_executed -eq 1 ]]; then
    echo -e "\e[32m[終了 $(date '+%H:%M:%S')]\e[0m"
    _cmd_executed=0
  fi
}

add-zsh-hook preexec _show_start_time
add-zsh-hook precmd _show_end_time

# ------------------------------
# zoxide wrapper
# ------------------------------
# zoxideのzコマンドをラップして、移動後にlsを実行
zls() {
  z "$@" && ls
}

# ------------------------------
# VPN（vpnutil for Mac）
# ------------------------------
_check_vpn_deps() {
  if ! command -v vpnutil &>/dev/null; then
    echo "Error: vpnutil がインストールされていません (brew install vpnutil)" >&2
    return 1
  fi
  if ! command -v jq &>/dev/null; then
    echo "Error: jq がインストールされていません (brew install jq)" >&2
    return 1
  fi
  return 0
}

check_vpn_status() {
  _check_vpn_deps || return 1
  vpn_data=$(vpnutil list)
  connected_vpns=$(echo "$vpn_data" | jq -r '.VPNs[] | select(.status == "Connected") | "\(.name) (\(.status))"')

  if [[ -z "$connected_vpns" ]]; then
    echo "No Connected"
  else
    echo "Connected VPN:"
    echo "$connected_vpns"
  fi
}

vpn_connect_with_fzf() {
  _check_vpn_deps || return 1
  if ! command -v fzf &>/dev/null; then
    echo "Error: fzf がインストールされていません (brew install fzf)" >&2
    return 1
  fi
  vpn_data=$(vpnutil list)
  selected_vpn=$(echo "$vpn_data" | jq -r '.VPNs[] | "\(.name) (\(.status))"' | fzf --prompt="choose a vpn: ")

  if [[ -z "$selected_vpn" ]]; then
    echo "VPN selection canceled."
    return
  fi

  vpn_name=$(echo "$selected_vpn" | sed 's/ (.*)//')
  echo "connection: $vpn_name"
  vpnutil start "$vpn_name"
}

vpn_disconnect_if_connected() {
  _check_vpn_deps || return 1
  vpn_data=$(vpnutil list)
  connected_vpns=$(echo "$vpn_data" | jq -r '.VPNs[] | select(.status == "Connected") | .name')

  if [[ -z "$connected_vpns" ]]; then
    echo "No vpn connected."
  else
    echo "Disconnect the following VPN connections:"
    echo "$connected_vpns"

    for vpn in $connected_vpns; do
      echo "cutting: $vpn"
      vpnutil stop "$vpn"
    done
    echo "Disconnected all vpn connections."
  fi
}

# ------------------------------
# gibo（gitignoreボイラープレート）
# ------------------------------
create_gitignore() {
    for cmd in gibo fzf bat; do
        if ! command -v "$cmd" &>/dev/null; then
            echo "Error: $cmd がインストールされていません (brew install $cmd)" >&2
            return 1
        fi
    done

    local input_file="$1"

    if [[ -z "$input_file" ]]; then
        input_file=".gitignore"
    fi

    local selected=$(gibo list | fzf \
        --multi \
        --preview "gibo dump {} | bat --style=numbers --color=always --paging=never")

    if [[ -z "$selected" ]]; then
        echo "No templates selected. Exiting."
        return
    fi

    echo "$selected" | xargs gibo dump >> "$input_file"
    bat "$input_file"
}

# ============================================================================
# キーバインド
# ============================================================================

bindkey '^R' fzf-history-selection
bindkey '^E' fzf-cdr
bindkey '^X' fzf-src

# ============================================================================
# 外部ツール連携
# ============================================================================

# iTerm2 Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# CodeWhisperer post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh"
