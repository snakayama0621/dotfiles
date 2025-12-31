# Neovim 設定ガイド

プロフェッショナルグレードのNeovim IDE環境

## 📋 目次

- [概要](#概要)
- [機能](#機能)
- [インストール](#インストール)
- [キーマッピング](#キーマッピング)
- [プラグイン](#プラグイン)
- [トラブルシューティング](#トラブルシューティング)

---

## 概要

この設定は、NeovimをモダンなIDE環境に変えるための包括的な構成です。

**特徴:**
- 🚀 高速起動（50-100ms目標）
- 🎯 LSP統合（補完・診断・定義ジャンプ）
- 🔍 強力なファジー検索（Telescope + ripgrep）
- 🌳 高度な構文ハイライト（Treesitter）
- 📝 インテリジェントな補完（nvim-cmp）
- 🎨 Git統合（Gitsigns）

---

## 機能

### 1. LSP（Language Server Protocol）

**対応言語:**
- TypeScript/JavaScript
- Python
- Go
- Rust
- Lua
- HTML/CSS
- JSON/YAML

**自動インストール:** Mason経由でLSPサーバーを自動管理

### 2. 補完システム

- LSP補完
- バッファ補完
- パス補完
- スニペット（LuaSnip）

### 3. ファイル検索

- ファイル名検索（Telescope）
- grep検索（ripgrep統合）
- バッファ検索
- ヘルプ検索

### 4. Git統合

- 変更箇所のサインカラム表示
- Hunkステージング/リセット
- Git blame表示
- 差分表示

### 5. Dev Container統合

- VS Code互換のdevcontainer.json対応
- コンテナ内でのコマンド実行
- ターミナル統合（toggleterm）

---

## インストール

### 前提条件

```bash
# 必須
brew install neovim ripgrep node

# 推奨
brew install fd lazygit

# Dev Container使用時
npm install -g @devcontainers/cli
```

### セットアップ

1. **初回起動:**
```bash
nvim
```

lazy.nvimが自動的にプラグインをインストールします（初回は1-2分かかります）

2. **LSPサーバーインストール確認:**
```vim
:Mason
```

3. **健全性チェック:**
```vim
:checkhealth
```

---

## キーマッピング

### リーダーキー

**スペースキー** = リーダーキー

### 基本操作

| キー | モード | 説明 |
|------|--------|------|
| `<Esc>` | ノーマル | 検索ハイライト解除 |
| `<C-s>` | ノーマル/インサート | ファイル保存 |
| `<C-q>` | ノーマル | 終了 |
| `J/K` | ビジュアル | 選択行を上下に移動 |
| `H/L` | ノーマル/ビジュアル | 行頭/行末へ移動 |

### ウィンドウ管理

| キー | 説明 |
|------|------|
| `<leader>wv` | 垂直分割 |
| `<leader>wh` | 水平分割 |
| `<leader>wc` | ウィンドウを閉じる |
| `<C-h/j/k/l>` | ウィンドウ間移動 |
| `<C-Arrow>` | ウィンドウリサイズ |

### バッファ操作

| キー | 説明 |
|------|------|
| `<leader>bn` | 次のバッファ |
| `<leader>bp` | 前のバッファ |
| `<leader>bd` | バッファ削除 |
| `<leader>ba` | 他のバッファを全削除 |

### LSP操作

| キー | 説明 |
|------|------|
| `gd` | 定義へジャンプ |
| `gD` | 宣言へジャンプ |
| `gr` | 参照一覧 |
| `gi` | 実装へジャンプ |
| `K` | ホバー情報表示 |
| `<leader>ca` | コードアクション |
| `<leader>rn` | リネーム |
| `<leader>fm` | フォーマット |
| `[d` / `]d` | 前/次の診断へ移動 |

### Telescope検索

| キー | 説明 |
|------|------|
| `<leader>ff` | ファイル検索 |
| `<leader>fg` | grep検索 |
| `<leader>fb` | バッファ検索 |
| `<leader>fh` | ヘルプ検索 |
| `<leader>fr` | 最近使用ファイル |
| `<leader>fk` | キーマップ検索 |

### Git操作

| キー | 説明 |
|------|------|
| `<leader>lg` | Lazygit起動（フローティング） |
| `]c` / `[c` | 次/前の変更箇所へ移動 |
| `<leader>gs` | Hunkをステージ |
| `<leader>gr` | Hunkをリセット |
| `<leader>gp` | Hunkをプレビュー |
| `<leader>gb` | Git blame表示 |
| `<leader>gd` | Git diff表示 |

### 補完操作（インサートモード）

| キー | 説明 |
|------|------|
| `<Tab>` | 次の候補へ移動 |
| `<S-Tab>` | 前の候補へ移動 |
| `<CR>` | 選択を確定 |
| `<C-Space>` | 補完を手動起動 |
| `<C-e>` | 補完をキャンセル |

### ターミナル

| キー | 説明 |
|------|------|
| `<leader>tt` | ターミナル起動 |
| `<leader>tv` | ターミナル（垂直分割） |
| `<leader>th` | ターミナル（水平分割） |
| `<C-\>` | ターミナル表示/非表示トグル |
| `<Esc><Esc>` | ターミナルモード終了 |

### Dev Container操作

| キー | 説明 |
|------|------|
| `<leader>Du` | コンテナをビルド・起動 |
| `<leader>Dc` | コンテナ内シェルに接続 |
| `<leader>Dt` | コンテナターミナル切替 |
| `<leader>Dd` | コンテナを停止・削除 |
| `<leader>De` | コンテナ内でコマンド実行 |
| `<leader>DN` | Neovim終了してコンテナ内で再起動 |

**使い方:**
```
1. .devcontainer/devcontainer.json があるプロジェクトを開く
2. <leader>Du でコンテナをビルド・起動
3. <leader>Dc でコンテナ内シェルに接続（画面下部に表示）
4. <C-\> でターミナルの表示/非表示を切替
5. ターミナル内で <C-\><C-n> → <C-w>k でファイルへ移動
6. <leader>Dd で作業終了時にコンテナ停止
```

---

## プラグイン

### プラグインマネージャー

**lazy.nvim** - 遅延ロード対応の高速プラグインマネージャー

```vim
:Lazy              " プラグイン管理UI
:Lazy update       " 全プラグイン更新
:Lazy sync         " インストール+更新+クリーン
:Lazy profile      " 起動時間プロファイル
```

### インストール済みプラグイン

#### 基本セット
- **nvim-treesitter** - 構文ハイライト・コード解析
- **telescope.nvim** - ファジーファインダー
- **plenary.nvim** - Lua関数ライブラリ（Telescope依存）

#### LSP環境
- **nvim-lspconfig** - LSPクライアント設定
- **mason.nvim** - LSPサーバー管理UI
- **mason-lspconfig.nvim** - Mason↔lspconfig連携

#### 補完環境
- **nvim-cmp** - 補完エンジン
- **cmp-nvim-lsp** - LSP補完ソース
- **cmp-buffer** - バッファ補完ソース
- **cmp-path** - パス補完ソース
- **LuaSnip** - スニペットエンジン
- **cmp_luasnip** - スニペット補完統合

#### Git統合
- **gitsigns.nvim** - Git変更可視化・操作
- **lazygit統合** - toggletermでLazygit起動（`<leader>lg`）

#### Dev Container
- **devcontainer-cli.nvim** - Dev Container CLI統合
- **toggleterm.nvim** - ターミナル統合

---

## ディレクトリ構成

```
~/.config/nvim/
├── init.lua                 # エントリーポイント
├── lua/
│   ├── core/
│   │   ├── options.lua      # 基本設定
│   │   ├── keymaps.lua      # キーマッピング
│   │   └── autocmds.lua     # オートコマンド
│   └── plugins/
│       ├── init.lua         # lazy.nvim設定
│       ├── treesitter.lua   # 構文ハイライト
│       ├── telescope.lua    # ファジーファインダー
│       ├── lsp.lua          # LSP設定
│       ├── completion.lua   # 補完設定
│       ├── gitsigns.lua     # Git統合
│       └── lazygit.lua      # Lazygit統合
└── README.md                # このファイル
```

---

## トラブルシューティング

### プラグインがインストールされない

```vim
:Lazy sync
```

lazy.nvimを手動で再インストール:
```bash
rm -rf ~/.local/share/nvim/lazy/
nvim
```

### LSPが動作しない

1. **LSPサーバー状態確認:**
```vim
:LspInfo
:Mason
```

2. **健全性チェック:**
```vim
:checkhealth lspconfig
```

3. **手動インストール例（TypeScript）:**
```bash
npm install -g typescript typescript-language-server
```

### 補完が表示されない

```vim
:CmpStatus
```

インサートモードで `<C-Space>` を押して手動起動を試す

### Telescope grep検索が失敗する

ripgrepがインストールされているか確認:
```bash
which rg
# なければ: brew install ripgrep
```

### Treesitterハイライトが不安定

```vim
:TSUpdate              " パーサー更新
:TSInstall javascript  " 特定言語の再インストール
```

### 起動が遅い

起動時間を確認:
```vim
:Lazy profile
```

問題のあるプラグインを特定して、遅延ロード設定を調整

### 設定をリセットしたい

```bash
# バックアップから復元
cp ~/.config/nvim/lua/core/options.lua.backup ~/.config/nvim/lua/core/options.lua

# 完全リセット
rm -rf ~/.config/nvim/
rm -rf ~/.local/share/nvim/
rm -rf ~/.local/state/nvim/
```

---

## カスタマイズ

### 新しいキーマッピングを追加

`lua/core/keymaps.lua` を編集:

```lua
vim.keymap.set('n', '<leader>xx', '<cmd>YourCommand<CR>', { desc = '説明' })
```

### 新しいLSPサーバーを追加

`lua/plugins/lsp.lua` の `ensure_installed` に追加:

```lua
ensure_installed = {
  'lua_ls',
  'ts_ls',
  'your_new_lsp',  -- 追加
}
```

### 新しいプラグインを追加

`lua/plugins/` に新しいファイルを作成:

```lua
-- lua/plugins/your-plugin.lua
return {
  'author/plugin-name',
  config = function()
    -- 設定
  end,
}
```

`lua/plugins/init.lua` に追加:
```lua
{ import = 'plugins.your-plugin' },
```

---

## よくある質問

### Q: どのファイルから編集すればいい？

**A:** 目的別に以下を編集してください：
- 基本設定: `lua/core/options.lua`
- キーマッピング: `lua/core/keymaps.lua`
- 自動化: `lua/core/autocmds.lua`
- プラグイン設定: `lua/plugins/*.lua`

### Q: プラグインを削除するには？

**A:** 該当ファイルを `lua/plugins/` から削除して、`:Lazy sync`

### Q: タブ幅を変更するには？

**A:** `lua/core/options.lua` で設定:
```lua
vim.opt.tabstop = 2      -- タブ幅
vim.opt.shiftwidth = 2   -- インデント幅
```

### Q: テーマを変更するには？

**A:** カラースキームプラグインを追加:
```lua
-- lua/plugins/colorscheme.lua
return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme tokyonight]])
  end,
}
```

---

## パフォーマンス

### 期待される起動時間

- 初回起動: 1-2分（プラグインインストール）
- 通常起動: 50-100ms
- プラグインなし起動: 20-30ms

### 最適化のヒント

1. **遅延ロード活用:** プラグインに `event`、`cmd`、`ft` を設定
2. **不要なプラグイン無効化:** `performance.rtp.disabled_plugins` に追加
3. **大規模ファイル対策:** `autocmds.lua` の大規模ファイル最適化が自動適用

---

## 更新履歴

- **2024-12**: 初期リリース
  - LSP統合
  - Telescope検索
  - Treesitter構文ハイライト
  - nvim-cmp補完
  - Gitsigns Git統合

---

## ライセンス

このNeovim設定はMITライセンスの下で公開されています。

## 参考リンク

- [Neovim公式](https://neovim.io/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
