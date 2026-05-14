# Dotfiles

個人的な開発環境設定ファイルの管理リポジトリです。

## リポジトリの役割

- macOS の開発環境を再現するための dotfiles を管理します
- `setup.sh` で Homebrew パッケージ、npm グローバルパッケージ、各種シンボリックリンクをまとめてセットアップします
- 個人情報を含む Git 設定は `.gitconfig.local` に分離し、リポジトリでは `.gitconfig.local.example` だけを管理します
- Codex / Claude の許可設定も含め、AI コーディング環境の共通設定を管理します

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
| `htop/` | htopプロセスビューア設定 | `~/.config/htop` | - |
| `neofetch/` | Neofetchシステム情報表示設定 | `~/.config/neofetch` | - |
| `.claude/` | Claude Code設定（権限・フック・スクリプト） | `~/.claude/` | - |
| `.codex/` | Codex設定（MCP・指示ファイル） | `~/.codex/` | `config.toml` もシンボリックリンクで管理 |
| `commitlint.config.js` | コミットメッセージ検証設定（cz-git） | `~/commitlint.config.js` | - |
| `Brewfile` | Homebrewパッケージ管理 | - | - |
| `scripts/` | Claude フック共通処理 | - | - |
| `tests/` | セットアップスクリプトのテスト | - | - |

## 管理方針

- 設定ファイルは基本的にこのリポジトリで管理し、`link.sh` でホームディレクトリ配下へシンボリックリンクします
- マシン固有・個人情報を含む設定は、サンプルファイルだけを管理して実体は Git 管理外に置きます
- `node_modules/` は管理対象にせず、`package-lock.json` と `package.json` から再現します
- `setup.sh -d` と `link.sh -d` で、実際に変更する前の dry-run を確認できます

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
