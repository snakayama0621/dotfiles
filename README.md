# Dotfiles

個人的な開発環境設定ファイルの管理リポジトリです。

## 含まれる設定

| ファイル/ディレクトリ | 説明 | リンク先 | 詳細 |
|-------------------|------|----------|------|
| `.zshrc` | Zsh設定 | `~/.zshrc` | - |
| `.gitconfig` | Git設定（delta含む。ユーザー情報は除く） | `~/.gitconfig` | - |
| `.gitconfig.local.example` | Git ローカル設定テンプレート（ユーザー情報） | `~/.gitconfig.local` | セットアップ時に自動生成 |
| `.tmux.conf` | Tmux設定 | `~/.tmux.conf` | - |
| `starship.toml` | Starshipプロンプト設定 | `~/.config/starship.toml` | - |
| `nvim/` | Neovim設定 | `~/.config/nvim` | [README](nvim/README.md) |
| `wezterm/` | WezTerm設定 | `~/.config/wezterm` | [README](wezterm/README.md) |
| `yazi/` | Yaziファイルマネージャー設定 | `~/.config/yazi` | [README](yazi/README.md) |
| `sheldon/` | Sheldonプラグイン設定 | `~/.config/sheldon` | [README](sheldon/README.md) |
| `lazygit/` | Lazygit設定 | `~/.config/lazygit` | [README](lazygit/README.md) |
| `aerospace/` | Aerospaceウィンドウマネージャー設定 | `~/.config/aerospace` | [README](aerospace/README.md) |
| `borders/` | Bordersウィンドウボーダー設定 | `~/.config/borders` | [README](borders/README.md) |
| `sketchybar/` | Sketchybarステータスバー設定 | `~/.config/sketchybar` | [README](sketchybar/README.md) |
| `.claude/` | Claude Code設定（権限・フック・スクリプト） | `~/.claude/` | - |
| `commitlint.config.js` | コミットメッセージ検証設定（cz-git） | `~/commitlint.config.js` | - |
| `Brewfile` | Homebrewパッケージ管理 | - | - |
| `tests/` | セットアップスクリプトのテスト | - | - |

## 必要要件

以下のツールがインストールされていることを推奨します：

- **Git** - リポジトリのクローン
- **Zsh** - シェル
- **Homebrew** - パッケージマネージャー

## インストール

### 1. リポジトリのクローン

```bash
cd ~
git clone git@github.com:TetraTechAi/dotfiles.git
```

### 2. セットアップ実行

```bash
cd ~/dotfiles
./setup.sh
```

これにより以下が実行されます：
1. Brewfileからパッケージをインストール
2. npmグローバルパッケージをインストール（czg等）
3. シンボリックリンクを作成
4. sketchybarをセットアップ

### オプション

```bash
# Dry-run（事前確認）
./setup.sh -d

# Brewパッケージのみ
./setup.sh -b

# シンボリックリンクのみ
./setup.sh -l
```

### 3. Git ローカル設定の確認

セットアップ時に `setup_gitconfig_local()` が実行され、以下のいずれかが行われます：

- **～/.gitconfig.local が存在しない場合** - ユーザー名とメールアドレスを対話的に入力するよう促されます
- **既に存在する場合** - スキップされます

手動で設定を変更したい場合：

```bash
# テンプレートから作成
cp .gitconfig.local.example ~/.gitconfig.local

# エディタで編集
vim ~/.gitconfig.local
```

**構成について：**
- `.gitconfig` - 共有設定（aliases, delta設定など）
- `.gitconfig.local` - ローカル設定（user.name, user.email）、`.gitignore` で追跡除外

### 4. 設定の反映

```bash
source ~/.zshrc
```

## 別のマシンへの展開

```bash
git clone git@github.com:TetraTechAi/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
source ~/.zshrc
```

## 設定の更新

```bash
cd ~/dotfiles
git add .
git commit -m "Update configuration"
git push origin develop
```
