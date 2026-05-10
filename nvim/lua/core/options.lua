------------------------------------------------------------------------------
-- 1. 基本オプション
------------------------------------------------------------------------------

-- 行番号
vim.opt.relativenumber = true
vim.opt.number = true

-- タイトル
vim.opt.title = true

-- 括弧の連携
vim.opt.showmatch = true

-- ヘルプファイル
vim.opt.helplang = 'ja'

-- インデント
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- ヤンクのレジスタを共通にする
vim.opt.clipboard = 'unnamedplus'

-- 検索
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ステータスライン
vim.opt.laststatus = 3

-- カーソル行のハイライト
vim.opt.cursorline = true

-- 見た目
vim.opt.background = 'dark'
vim.opt.termguicolors = true

-- マウス統合
vim.opt.mouse = 'a'

-- 文字エンコーディング
vim.opt.fileencoding = 'utf-8'

------------------------------------------------------------------------------
-- 2. 編集効率（Development Efficiency）
------------------------------------------------------------------------------

-- ファイル管理
vim.opt.autoread = true         -- 外部変更時の自動読み込み
vim.opt.autowrite = false       -- 意図しない保存を避ける
vim.opt.swapfile = false        -- swapファイル無効化
vim.opt.backup = false          -- バックアップファイル無効化
vim.opt.writebackup = false     -- 書き込み前バックアップ無効化

-- 永続的なundo履歴
vim.opt.undofile = true         -- セッション間でundo履歴を保持
vim.opt.undolevels = 10000      -- undo回数上限を拡大

-- LSP最適化補完設定
vim.opt.completeopt = 'menu,menuone,noselect'  -- LSP補完の最適化
vim.opt.pumheight = 15          -- 補完メニューの高さ制限
vim.opt.pumblend = 10           -- 補完メニューの透過度

-- スマートインデント
vim.opt.smartindent = true      -- コンテキスト認識インデント
vim.opt.autoindent = true       -- 自動インデント継承

------------------------------------------------------------------------------
-- 3. 快適性と可読性（Comfort & Readability）
------------------------------------------------------------------------------

-- 空白文字の可視化
vim.opt.list = true
vim.opt.listchars = {
  tab = '▸ ',
  trail = '·',
  nbsp = '␣',
  extends = '❯',
  precedes = '❮'
}

-- コマンドライン表示
vim.opt.showmode = false        -- モード表示をステータスラインに任せる
vim.opt.showcmd = true          -- コマンド表示を有効化
vim.opt.cmdheight = 1           -- コマンドライン高さ

-- サインカラム（LSP診断用）
vim.opt.signcolumn = 'yes'      -- 常時表示で画面のちらつき防止

-- スクロール設定
vim.opt.scrolloff = 8           -- カーソル上下に常時8行表示
vim.opt.sidescrolloff = 8       -- 横スクロール時の余白
vim.opt.smoothscroll = true     -- 滑らかなスクロール（Neovim 0.10+）

-- ウィンドウ分割
vim.opt.splitbelow = true       -- 水平分割時に下に開く
vim.opt.splitright = true       -- 垂直分割時に右に開く
vim.opt.splitkeep = 'screen'    -- 分割時の画面位置保持

-- カーソル形状（モード別）
vim.opt.guicursor = 'n-v-c:block,i-ci-ve:ver25,r-cr-o:hor20'

-- 行表示
vim.opt.wrap = false            -- 行の折り返し無効（コード編集優先）
vim.opt.linebreak = true        -- 折り返し時に単語の途中で切らない
vim.opt.breakindent = true      -- 折り返し行のインデント保持

------------------------------------------------------------------------------
-- 4. パフォーマンス（Performance）
------------------------------------------------------------------------------

-- レスポンス速度
vim.opt.updatetime = 250        -- LSP診断の更新速度（4000ms→250ms）
vim.opt.timeoutlen = 500        -- キーマッピングのタイムアウト
vim.opt.ttimeoutlen = 10        -- キーコードのタイムアウト短縮

-- 検索最適化（ripgrep統合）
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.grepformat = '%f:%l:%c:%m'

-- 差分表示
vim.opt.diffopt = 'internal,filler,closeoff,algorithm:histogram'

-- インクリメンタル機能
vim.opt.inccommand = 'split'    -- 置換コマンドのリアルタイムプレビュー
vim.opt.incsearch = true        -- インクリメンタル検索

-- 大規模ファイル対応
vim.opt.synmaxcol = 500         -- 長い行の構文ハイライト制限
vim.opt.lazyredraw = true       -- マクロ実行中の再描画抑制

------------------------------------------------------------------------------
-- 5. モダン機能（Modern Features）
------------------------------------------------------------------------------

-- コマンドライン補完
vim.opt.wildmenu = true                      -- コマンドライン補完有効化
vim.opt.wildmode = 'longest:full,full'       -- 補完モード設定
vim.opt.wildoptions = 'pum,tagfile'          -- ポップアップメニュー使用

-- 検索機能
vim.opt.hlsearch = true         -- 検索ハイライト
vim.opt.wrapscan = true         -- 検索時のファイル末尾から先頭への折り返し

-- フォールディング（コード折りたたみ）
-- Treesitterロード後にプラグイン側でexprへ切り替える
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99     -- 起動時は全て展開
vim.opt.foldenable = true

-- その他モダン設定
vim.opt.conceallevel = 0        -- Markdown等での文字隠蔽無効
vim.opt.virtualedit = 'block'   -- ビジュアルブロックモードで自由移動

------------------------------------------------------------------------------
-- 6. 用途別最適化（Use Case Specific）
------------------------------------------------------------------------------

-- Web開発（JS/TS/HTML/CSS）
vim.opt.iskeyword:append('-')   -- ケバブケースを1単語として認識
vim.opt.matchpairs:append('<:>')  -- HTMLタグのペアマッチング

-- テキスト編集（Markdown/ドキュメント）
vim.opt.spell = false           -- スペルチェック無効（コード優先）
vim.opt.spelllang = 'en,cjk'    -- 英語・CJK言語設定（必要時に:set spellで有効化）

-- 汎用設定
vim.opt.shortmess:append('c')   -- 補完メッセージの簡略化
vim.opt.formatoptions:remove('cro')  -- コメント行での自動コメント挿入無効化
vim.opt.whichwrap:append('<,>,[,],h,l')  -- 行頭/行末での移動時に次の行へ

------------------------------------------------------------------------------
-- 7. セキュリティ（Security）
------------------------------------------------------------------------------

-- セキュリティベストプラクティス
vim.opt.modeline = false        -- modelineの無効化
vim.opt.exrc = false            -- カレントディレクトリの.vimrcを読み込まない
