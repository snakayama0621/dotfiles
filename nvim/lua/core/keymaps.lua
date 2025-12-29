------------------------------------------------------------------------------
-- キーマッピング設定
------------------------------------------------------------------------------

-- リーダーキー設定
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

------------------------------------------------------------------------------
-- 1. 基本編集（Better Defaults）
------------------------------------------------------------------------------

-- 検索ハイライト解除
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = '検索ハイライト解除' })

-- 保存
vim.keymap.set({'n', 'i'}, '<C-s>', '<cmd>w<CR><Esc>', { desc = 'ファイル保存' })

-- 終了
vim.keymap.set('n', '<C-q>', '<cmd>q<CR>', { desc = '終了' })

-- jkでESC（インサートモード終了）
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'ESC (jk)' })

-- ビジュアルモードで行移動
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = '選択行を下に移動' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = '選択行を上に移動' })

-- ビジュアルモードでインデント後も選択を維持
vim.keymap.set('v', '<', '<gv', { desc = 'インデント減(選択維持)' })
vim.keymap.set('v', '>', '>gv', { desc = 'インデント増(選択維持)' })

-- ペースト時にヤンクレジスタを保持
vim.keymap.set('x', 'p', '"_dP', { desc = 'ペースト(レジスタ保持)' })

------------------------------------------------------------------------------
-- 2. ウィンドウ・バッファ管理
------------------------------------------------------------------------------

-- ウィンドウ分割
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<CR>', { desc = '垂直分割' })
vim.keymap.set('n', '<leader>wh', '<cmd>split<CR>', { desc = '水平分割' })
vim.keymap.set('n', '<leader>wc', '<cmd>close<CR>', { desc = 'ウィンドウを閉じる' })
vim.keymap.set('n', '<leader>wo', '<cmd>only<CR>', { desc = '他のウィンドウを閉じる' })

-- ウィンドウ間移動
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = '左のウィンドウへ移動' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = '下のウィンドウへ移動' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = '上のウィンドウへ移動' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = '右のウィンドウへ移動' })

-- ウィンドウリサイズ
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<CR>', { desc = 'ウィンドウ高さ増' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<CR>', { desc = 'ウィンドウ高さ減' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'ウィンドウ幅減' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'ウィンドウ幅増' })

-- バッファ操作
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { desc = '次のバッファ' })
vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = '前のバッファ' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'バッファ削除' })
vim.keymap.set('n', '<leader>ba', '<cmd>%bd|e#<CR>', { desc = '他のバッファを全削除' })

------------------------------------------------------------------------------
-- 3. LSP操作（プラグイン導入後に有効化）
------------------------------------------------------------------------------

-- 定義・参照ジャンプ
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP: 定義へジャンプ' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP: 宣言へジャンプ' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'LSP: 参照一覧' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'LSP: 実装へジャンプ' })
vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, { desc = 'LSP: 型定義へジャンプ' })

-- ホバー・シグネチャヘルプ
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP: ホバー情報表示' })
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'LSP: シグネチャヘルプ' })

-- コードアクション・リネーム
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP: コードアクション' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'LSP: リネーム' })

-- フォーマット（conform.nvim で設定）
-- vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format, { desc = 'LSP: フォーマット' })

-- 診断
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = '前の診断へ移動' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = '次の診断へ移動' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = '診断フロート表示' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = '診断リスト表示' })

------------------------------------------------------------------------------
-- 4. Telescope操作（プラグイン導入後に有効化）
------------------------------------------------------------------------------

-- ファイル・バッファ検索
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Telescope: ファイル検索' })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = 'Telescope: grep検索' })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Telescope: バッファ検索' })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'Telescope: ヘルプ検索' })
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<CR>', { desc = 'Telescope: 最近使用ファイル' })
vim.keymap.set('n', '<leader>fc', '<cmd>Telescope commands<CR>', { desc = 'Telescope: コマンド検索' })
vim.keymap.set('n', '<leader>fk', '<cmd>Telescope keymaps<CR>', { desc = 'Telescope: キーマップ検索' })

-- Git検索
vim.keymap.set('n', '<leader>gc', '<cmd>Telescope git_commits<CR>', { desc = 'Telescope: Gitコミット' })
vim.keymap.set('n', '<leader>gf', '<cmd>Telescope git_files<CR>', { desc = 'Telescope: Gitファイル' })

------------------------------------------------------------------------------
-- 5. Git操作（Gitsigns導入後に有効化）
------------------------------------------------------------------------------

-- Hunk操作（プラグインロード時に設定される）
-- これらはgitsigns.lua内で設定されます

------------------------------------------------------------------------------
-- 6. ターミナル操作
------------------------------------------------------------------------------

-- ターミナルモードでのEsc
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'ターミナルモード終了' })

-- ターミナル起動
vim.keymap.set('n', '<leader>tt', '<cmd>terminal<CR>', { desc = 'ターミナル起動' })
vim.keymap.set('n', '<leader>tv', '<cmd>vsplit | terminal<CR>', { desc = 'ターミナル(垂直分割)' })
vim.keymap.set('n', '<leader>th', '<cmd>split | terminal<CR>', { desc = 'ターミナル(水平分割)' })

------------------------------------------------------------------------------
-- 7. タブ操作
------------------------------------------------------------------------------

vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<CR>', { desc = '新しいタブ' })
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<CR>', { desc = 'タブを閉じる' })
vim.keymap.set('n', '<leader>to', '<cmd>tabonly<CR>', { desc = '他のタブを閉じる' })

------------------------------------------------------------------------------
-- 8. ファイルプレビュー
------------------------------------------------------------------------------

-- 現在のファイルをブラウザで開く
vim.keymap.set('n', '<leader>op', function()
  local file = vim.fn.expand('%:p')
  local ft = vim.bo.filetype
  if ft == 'html' or ft == 'markdown' then
    vim.fn.system('open ' .. vim.fn.shellescape(file))
    vim.notify('Opened in browser: ' .. file, vim.log.levels.INFO)
  else
    vim.notify('Not a previewable file type: ' .. ft, vim.log.levels.WARN)
  end
end, { desc = 'ブラウザでプレビュー' })

------------------------------------------------------------------------------
-- 9. その他便利機能
------------------------------------------------------------------------------

-- カーソル位置を保持したままファイル全体をインデント
vim.keymap.set('n', '<leader>=', 'gg=G``', { desc = 'ファイル全体をインデント' })

-- 行頭・行末移動
vim.keymap.set({'n', 'v'}, 'H', '^', { desc = '行頭へ移動' })
vim.keymap.set({'n', 'v'}, 'L', '$', { desc = '行末へ移動' })

-- 中央揃えで移動
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = '半画面下へ(中央揃え)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = '半画面上へ(中央揃え)' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = '次の検索(中央揃え)' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = '前の検索(中央揃え)' })

-- Quickfix/Loclistナビゲーション
vim.keymap.set('n', '[q', '<cmd>cprev<CR>', { desc = '前のQuickfixアイテム' })
vim.keymap.set('n', ']q', '<cmd>cnext<CR>', { desc = '次のQuickfixアイテム' })
vim.keymap.set('n', '[l', '<cmd>lprev<CR>', { desc = '前のLoclistアイテム' })
vim.keymap.set('n', ']l', '<cmd>lnext<CR>', { desc = '次のLoclistアイテム' })
