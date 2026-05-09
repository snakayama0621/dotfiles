# Neovim チートシート

> リーダーキー: `<Space>`

---

## 基本操作

| キー | モード | 説明 |
|------|--------|------|
| `jk` | I | ESC（インサートモード終了） |
| `<C-s>` | N/I | ファイル保存 |
| `<C-q>` | N | 終了 |
| `<Esc>` | N | 検索ハイライト解除 |
| `H` | N/V | 行頭へ移動 |
| `L` | N/V | 行末へ移動 |

---

## 移動・スクロール

| キー | モード | 説明 |
|------|--------|------|
| `<C-d>` | N | 半画面下（中央揃え） |
| `<C-u>` | N | 半画面上（中央揃え） |
| `n` / `N` | N | 次/前の検索結果（中央揃え） |
| `]d` / `[d` | N | 次/前の診断エラー |
| `]c` / `[c` | N | 次/前のGit変更箇所 |
| `]f` / `[f` | N | 次/前の関数 |
| `]q` / `[q` | N | 次/前のQuickfixアイテム |

---

## ウィンドウ操作

| キー | モード | 説明 |
|------|--------|------|
| `<C-h/j/k/l>` | N | ウィンドウ間移動 |
| `<leader>wv` | N | 垂直分割 |
| `<leader>wh` | N | 水平分割 |
| `<leader>wc` | N | ウィンドウを閉じる |
| `<leader>wo` | N | 他のウィンドウを閉じる |
| `<C-Up/Down>` | N | 高さ増減 |
| `<C-Left/Right>` | N | 幅増減 |

---

## バッファ操作

| キー | モード | 説明 |
|------|--------|------|
| `<leader>bn` | N | 次のバッファ |
| `<leader>bp` | N | 前のバッファ |
| `<leader>bd` | N | バッファ削除 |
| `<leader>ba` | N | 他のバッファを全削除 |

---

## Telescope（ファジーファインダー）

| キー | モード | 説明 |
|------|--------|------|
| `<leader>ff` | N | ファイル検索 |
| `<leader>fg` | N | grep検索（内容検索） |
| `<leader>fb` | N | バッファ検索 |
| `<leader>fr` | N | 最近使用ファイル |
| `<leader>fh` | N | ヘルプ検索 |
| `<leader>fk` | N | キーマップ検索 |
| `<leader>fc` | N | コマンド検索 |
| `<leader>gc` | N | Gitコミット検索 |
| `<leader>gf` | N | Gitファイル検索 |

### Telescope内操作

| キー | 説明 |
|------|------|
| `<C-j>/<C-k>` | 上下移動 |
| `<C-v>` | 垂直分割で開く |
| `<C-x>` | 水平分割で開く |
| `<C-t>` | 新しいタブで開く |
| `<C-q>` | Quickfixに送る |
| `q` | 閉じる |

---

## LSP操作

| キー | モード | 説明 |
|------|--------|------|
| `gd` | N | 定義へジャンプ |
| `gD` | N | 宣言へジャンプ |
| `gr` | N | 参照一覧 |
| `gi` | N | 実装へジャンプ |
| `<leader>gt` | N | 型定義へジャンプ |
| `K` | N | ホバー情報表示 |
| `<leader>k` | N | シグネチャヘルプ |
| `<leader>ca` | N | コードアクション |
| `<leader>rn` | N | リネーム |
| `<leader>fm` | N | フォーマット |
| `<leader>e` | N | 診断フロート表示 |
| `<leader>q` | N | 診断リスト表示 |

---

## Git操作（Gitsigns）

| キー | モード | 説明 |
|------|--------|------|
| `<leader>gs` | N/V | Hunkをステージ |
| `<leader>gr` | N/V | Hunkをリセット |
| `<leader>gS` | N | バッファ全体をステージ |
| `<leader>gR` | N | バッファ全体をリセット |
| `<leader>gu` | N | ステージ取り消し |
| `<leader>gp` | N | Hunkプレビュー |
| `<leader>gb` | N | blame行表示 |
| `<leader>gB` | N | blame表示トグル |
| `<leader>gd` | N | diff表示 |
| `ih` | O/X | Hunkテキストオブジェクト |

---

## Copilot（AI補完）

| キー | モード | 説明 |
|------|--------|------|
| `<M-l>` (Alt+l) | I | 提案を受け入れ |
| `<M-w>` (Alt+w) | I | 単語単位で受け入れ |
| `<M-j>` (Alt+j) | I | 行単位で受け入れ |
| `<M-]>` (Alt+]) | I | 次の提案 |
| `<M-[>` (Alt+[) | I | 前の提案 |
| `<C-]>` | I | 提案を却下 |
| `<C-CR>` | I | パネル表示 |

---

## Yazi（ファイルマネージャー）

| キー | モード | 説明 |
|------|--------|------|
| `<leader>y` | N | 現在ファイルの場所で開く |
| `<leader>Y` | N | カレントディレクトリで開く |
| `<leader>fy` | N | トグル（前回状態復元） |

---

## Obsidian（Markdownファイル内で有効）

| キー | モード | 説明 |
|------|--------|------|
| `<leader>od` | N | 今日のデイリーノート |
| `<leader>on` | N | 新規ノート |
| `<leader>os` | N | ノート検索 |
| `<leader>ol` | N | リンク一覧 |
| `gf` | N | リンク先へ移動 |

---

## Markdownプレビュー（peek.nvim）

| キー | モード | 説明 |
|------|--------|------|
| `<leader>mp` | N | プレビュー開く |
| `<leader>mc` | N | プレビュー閉じる |

---

## 編集操作

| キー | モード | 説明 |
|------|--------|------|
| `J` / `K` | V | 選択行を下/上に移動 |
| `<` / `>` | V | インデント減/増（選択維持） |
| `p` | X | ペースト（レジスタ保持） |
| `<leader>=` | N | ファイル全体をインデント |
| `<M-e>` | I | 閉じ括弧を追加（fast wrap） |

---

## コメント（Comment.nvim）

| キー | モード | 説明 |
|------|--------|------|
| `gcc` | N | 現在行をコメントトグル |
| `gc{motion}` | N | 範囲をコメントトグル |
| `gbc` | N | 現在行をブロックコメント |
| `gc` / `gb` | V | 選択範囲をコメント |

---

## Surround（囲み操作）

| キー | モード | 説明 |
|------|--------|------|
| `ys{motion}{char}` | N | 囲みを追加 |
| `ds{char}` | N | 囲みを削除 |
| `cs{old}{new}` | N | 囲みを変更 |
| `S{char}` | V | 選択範囲を囲む |

### 使用例
- `ysiw"` → 単語を`"`で囲む
- `ds"` → `"`を削除
- `cs"'` → `"`を`'`に変更
- `cst<div>` → タグを`<div>`に変更

---

## Treesitterテキストオブジェクト

| キー | 説明 |
|------|------|
| `af` / `if` | 関数（outer/inner） |
| `ac` / `ic` | クラス（outer/inner） |
| `aa` / `ia` | 引数（outer/inner） |

---

## 補完（nvim-cmp）

| キー | モード | 説明 |
|------|--------|------|
| `<Tab>` | I | 次の候補 / スニペット展開 / 閉じ括弧を抜ける |
| `<S-Tab>` | I | 前の候補 |
| `<CR>` | I | 候補を確定 |
| `<C-Space>` | I | 補完を開始 |
| `<C-e>` | I | 補完をキャンセル |
| `<C-b>/<C-f>` | I | ドキュメントスクロール |

---

## ターミナル

| キー | モード | 説明 |
|------|--------|------|
| `<leader>tt` | N | ターミナル起動 |
| `<leader>tv` | N | ターミナル（垂直分割） |
| `<leader>th` | N | ターミナル（水平分割） |
| `<Esc><Esc>` | T | ターミナルモード終了 |

---

## フォーマッター（conform.nvim）

| キー | モード | 説明 |
|------|--------|------|
| `<leader>fm` | N/V | フォーマット実行 |

### 対応フォーマッター
| 言語 | フォーマッター |
|------|---------------|
| JavaScript/TypeScript | prettierd, prettier |
| Python | isort, black |
| Go | goimports, gofmt |
| Rust | rustfmt |
| Lua | stylua |
| PHP | php_cs_fixer |
| C/C++ | clang-format |
| Shell | shfmt |
| JSON/YAML | prettierd, prettier |
| Markdown | prettierd, prettier（手動実行） |

---

## リンター（nvim-lint）

| キー | モード | 説明 |
|------|--------|------|
| `<leader>ll` | N | 手動リント実行 |

### 対応リンター
| 言語 | リンター |
|------|---------|
| JavaScript/TypeScript | eslint_d |
| Python | ruff, mypy |
| Go | golangci-lint |
| Lua | luacheck |
| Shell | shellcheck |
| Dockerfile | hadolint |

---

## デバッガー（nvim-dap）

| キー | モード | 説明 |
|------|--------|------|
| `<leader>dc` | N | デバッグ続行/開始 |
| `<leader>ds` | N | ステップオーバー |
| `<leader>di` | N | ステップイン |
| `<leader>do` | N | ステップアウト |
| `<leader>db` | N | ブレークポイント切替 |
| `<leader>dB` | N | 条件付きブレークポイント |
| `<leader>dl` | N | ログポイント設定 |
| `<leader>dr` | N | REPL表示 |
| `<leader>dR` | N | 前回を再実行 |
| `<leader>dq` | N | デバッグ終了 |
| `<leader>du` | N | UI切替 |
| `<leader>de` | N/V | 式を評価 |

### 対応デバッガー
| 言語 | デバッガー |
|------|-----------|
| Python | debugpy |
| Go | delve |
| JavaScript/TypeScript | js-debug-adapter |
| Rust/C/C++ | codelldb |
| PHP | php-debug-adapter |

---

## コマンド

| コマンド | 説明 |
|----------|------|
| `:Lazy` | プラグイン管理画面 |
| `:Mason` | LSPサーバー管理画面 |
| `:Copilot auth` | Copilot認証 |
| `:Copilot status` | Copilot状態確認 |
| `:PeekOpen` | Markdownプレビュー開く |
| `:ConformInfo` | フォーマッター設定確認（追加予定） |
| `:checkhealth` | 設定診断 |

---

## モード記号

| 記号 | 意味 |
|------|------|
| N | ノーマルモード |
| I | インサートモード |
| V | ビジュアルモード |
| X | ビジュアル（行選択） |
| O | オペレーター待機 |
| T | ターミナルモード |
