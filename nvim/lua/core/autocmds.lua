------------------------------------------------------------------------------
-- オートコマンド設定
------------------------------------------------------------------------------

-- オートコマンドグループ作成
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

------------------------------------------------------------------------------
-- 1. ハイライトヤンク
------------------------------------------------------------------------------

autocmd('TextYankPost', {
  group = augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
  desc = 'ヤンク時に一時的にハイライト表示',
})

------------------------------------------------------------------------------
-- 2. 最後のカーソル位置に復帰
------------------------------------------------------------------------------

autocmd('BufReadPost', {
  group = augroup('restore_cursor', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = 'ファイル再オープン時に前回のカーソル位置に戻る',
})

------------------------------------------------------------------------------
-- 3. ファイルタイプ別の設定
------------------------------------------------------------------------------

-- 2スペースインデント: Web開発、設定ファイル
autocmd('FileType', {
  group = augroup('two_space_indent', { clear = true }),
  pattern = {
    -- Web
    'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
    'html', 'css', 'scss', 'vue', 'svelte',
    -- 設定ファイル
    'yaml', 'json', 'jsonc', 'toml', 'xml',
    -- エディタ設定
    'lua', 'vim',
    -- インフラ
    'terraform', 'hcl', 'dockerfile',
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
  desc = '2スペースインデント',
})

-- 4スペースインデント: PHP, Python, Go, Rust, C/C++
autocmd('FileType', {
  group = augroup('four_space_indent', { clear = true }),
  pattern = { 'php', 'python', 'go', 'rust', 'c', 'cpp' },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
  desc = '4スペースインデント',
})

-- Markdown: テキスト編集向け設定
autocmd('FileType', {
  group = augroup('markdown_settings', { clear = true }),
  pattern = 'markdown',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.conceallevel = 0
  end,
  desc = 'Markdown: テキスト編集最適化',
})

------------------------------------------------------------------------------
-- 4. 保存時の自動処理
------------------------------------------------------------------------------

-- 行末の空白を自動削除
autocmd('BufWritePre', {
  group = augroup('trim_whitespace', { clear = true }),
  pattern = '*',
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    local old_query = vim.fn.getreg('/')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
    vim.fn.setreg('/', old_query)
  end,
  desc = '保存時に行末の空白を削除',
})

-- ファイル保存時にディレクトリを自動作成
autocmd('BufWritePre', {
  group = augroup('auto_create_dir', { clear = true }),
  callback = function(event)
    if event.match:match('^%w%w+://') then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
  desc = '保存時にディレクトリを自動作成',
})

------------------------------------------------------------------------------
-- 5. Git関連の設定
------------------------------------------------------------------------------

-- Git commitメッセージ
autocmd('FileType', {
  group = augroup('git_commit', { clear = true }),
  pattern = 'gitcommit',
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 72
  end,
  desc = 'Git commit: スペルチェック有効化、72文字制限',
})

-- Git diffモード
autocmd('OptionSet', {
  group = augroup('git_diff', { clear = true }),
  pattern = 'diff',
  callback = function()
    vim.opt_local.wrap = false
  end,
  desc = 'Git diff: 折り返し無効化',
})

------------------------------------------------------------------------------
-- 6. ターミナルモード最適化
------------------------------------------------------------------------------

autocmd('TermOpen', {
  group = augroup('terminal_settings', { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.scrolloff = 0
    vim.cmd('startinsert')
  end,
  desc = 'ターミナル: 行番号非表示、自動インサートモード',
})

-- ターミナル終了時に自動でウィンドウを閉じる
autocmd('TermClose', {
  group = augroup('terminal_close', { clear = true }),
  callback = function()
    if vim.v.event.status == 0 then
      vim.cmd('bdelete')
    end
  end,
  desc = 'ターミナル終了時に自動クローズ',
})

------------------------------------------------------------------------------
-- 7. ウィンドウ・バッファ関連
------------------------------------------------------------------------------

-- ヘルプウィンドウを垂直分割で開く
autocmd('FileType', {
  group = augroup('help_vertical', { clear = true }),
  pattern = 'help',
  callback = function()
    vim.cmd('wincmd L')  -- 右側に移動
  end,
  desc = 'ヘルプウィンドウを垂直分割',
})

-- Quickfixウィンドウの高さを自動調整
autocmd('FileType', {
  group = augroup('quickfix_height', { clear = true }),
  pattern = 'qf',
  callback = function()
    local height = math.min(vim.fn.line('$'), 10)
    vim.cmd(height .. 'wincmd _')
  end,
  desc = 'Quickfixウィンドウの高さ自動調整',
})

------------------------------------------------------------------------------
-- 8. フォーカス・リサイズ時の更新
------------------------------------------------------------------------------

-- ウィンドウフォーカス時にファイルを再読み込み（変更がある場合のみ）
autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = augroup('auto_read', { clear = true }),
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd('checktime')
    end
  end,
  desc = 'フォーカス時にファイル変更を自動確認',
})

-- ウィンドウリサイズ時に分割サイズを均等化
autocmd('VimResized', {
  group = augroup('resize_splits', { clear = true }),
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
  desc = 'ウィンドウリサイズ時に分割を均等化',
})

------------------------------------------------------------------------------
-- 9. 特定ファイルタイプでのフォーマット無効化
------------------------------------------------------------------------------

-- 特定のファイルタイプで自動コメント挿入を無効化
autocmd('FileType', {
  group = augroup('no_auto_comment', { clear = true }),
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
  end,
  desc = '自動コメント挿入を無効化',
})

------------------------------------------------------------------------------
-- 10. LSP関連（プラグイン導入後に有効化される）
------------------------------------------------------------------------------

-- LSPアタッチ時の設定（lsp.lua内で定義）
-- 診断の自動表示設定なども可能

------------------------------------------------------------------------------
-- 11. Dev Container設定ファイルの検出
------------------------------------------------------------------------------

autocmd({ 'BufRead', 'BufNewFile' }, {
  group = augroup('devcontainer_filetype', { clear = true }),
  pattern = { 'devcontainer.json', '.devcontainer.json' },
  callback = function()
    vim.bo.filetype = 'jsonc'
  end,
  desc = 'devcontainer.jsonをJSONCとして認識',
})

------------------------------------------------------------------------------
-- 12. 大きなファイルの最適化
------------------------------------------------------------------------------

autocmd('BufReadPre', {
  group = augroup('large_file', { clear = true }),
  callback = function(args)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > 100000 then  -- 100KB以上
      vim.opt_local.syntax = ''
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ''
      vim.opt_local.statuscolumn = ''
      vim.opt_local.signcolumn = 'no'
      vim.opt_local.foldcolumn = '0'
      vim.opt_local.winbar = ''
    end
  end,
  desc = '大きなファイル: 機能を無効化してパフォーマンス最適化',
})
