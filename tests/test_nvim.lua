local root = vim.env.DOTFILES_TEST_REPO .. '/nvim'
local tmp = vim.env.DOTFILES_TEST_TMP
vim.opt.rtp:prepend(root)

local passed, failed = 0, 0
local function test(name, callback)
  local ok, err = pcall(callback)
  if ok then
    passed = passed + 1
    io.stdout:write('PASS: ' .. name .. '\n')
  else
    failed = failed + 1
    io.stdout:write('FAIL: ' .. name .. '\n' .. tostring(err) .. '\n')
  end
end

local function equal(actual, expected)
  assert(vim.deep_equal(actual, expected), 'expected: ' .. vim.inspect(expected) .. ', got: ' .. vim.inspect(actual))
end

require('core.options')
require('core.keymaps')
require('core.autocmds')

test('キー登録だけでは LSP・診断を読み込まない', function()
  for _, module in ipairs({ 'vim.lsp', 'vim.lsp.buf', 'vim.diagnostic' }) do
    assert(not package.loaded[module], module .. ' was loaded before using a key')
  end
end)

test('遅延登録した診断キーでも次の診断へ移動できる', function()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'first', 'second', 'third' })
  local ns = vim.api.nvim_create_namespace('test_diagnostic_key')
  vim.diagnostic.set(ns, 0, { { lnum = 2, col = 0, message = 'test diagnostic' } })
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  vim.api.nvim_feedkeys(']d', 'xt', false)
  equal(vim.api.nvim_win_get_cursor(0), { 3, 0 })
  local flushed = false
  vim.schedule(function() flushed = true end)
  assert(vim.wait(1000, function() return flushed end, 10))
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, true)
    end
  end
  vim.diagnostic.reset(ns)
end)

local save_cases = {
  { name = '通常ファイルの空白を除去', ft = 'text', bt = '', modifiable = true,
    input = { 'value   ', '   ', 'last\t' }, expected = { 'value', '', 'last' } },
  { name = '空のバッファも保存可能', ft = 'text', bt = '', modifiable = true,
    input = { '' }, expected = { '' } },
  { name = 'Markdown の改行用空白を保持', ft = 'markdown', bt = '', modifiable = true,
    input = { 'text  ' }, expected = { 'text  ' } },
  { name = '変更不可の通常バッファを書き出せる', ft = 'text', bt = '', modifiable = false,
    input = { 'export   ' }, expected = { 'export   ' } },
  { name = 'checkhealth 相当の変更不可バッファを書き出せる', ft = 'checkhealth', bt = 'nofile', modifiable = false,
    input = { 'health result   ' }, expected = { 'health result   ' } },
  { name = '特殊バッファの出力を変更しない', ft = 'text', bt = 'nofile', modifiable = true,
    input = { 'output   ' }, expected = { 'output   ' } },
}

for index, case in ipairs(save_cases) do
  test(case.name, function()
    vim.cmd('enew!')
    vim.bo.buftype = case.bt
    vim.bo.filetype = case.ft
    vim.api.nvim_buf_set_lines(0, 0, -1, false, case.input)
    vim.bo.modifiable = case.modifiable
    vim.fn.setreg('/', 'keep-search')
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    local path = tmp .. '/save-' .. index .. '.txt'
    vim.cmd.write({ args = { path }, mods = { silent = true } })
    equal(vim.fn.readfile(path), case.expected)
    equal(vim.fn.getreg('/'), 'keep-search')
    equal(vim.api.nvim_win_get_cursor(0), { 1, 0 })
  end)
end

test('リサイズで全タブの分割を均等化し元のタブとウィンドウを保つ', function()
  vim.cmd('enew!')
  vim.cmd('vsplit')
  vim.cmd('vertical resize 10')
  local tab = vim.api.nvim_get_current_tabpage()
  local win = vim.api.nvim_get_current_win()
  vim.cmd('tabnew')
  vim.cmd('vsplit')
  vim.cmd('vertical resize 10')
  vim.api.nvim_set_current_tabpage(tab)
  vim.api.nvim_exec_autocmds('VimResized', { group = 'resize_splits' })
  equal(vim.api.nvim_get_current_tabpage(), tab)
  equal(vim.api.nvim_get_current_win(), win)
  for _, page in ipairs(vim.api.nvim_list_tabpages()) do
    local wins = vim.api.nvim_tabpage_list_wins(page)
    assert(math.abs(vim.api.nvim_win_get_width(wins[1]) - vim.api.nvim_win_get_width(wins[2])) <= 1)
  end
end)
vim.cmd('tabonly!')
vim.cmd('only!')

for _, case in ipairs({
  { name = '成功したターミナルだけを閉じ保存済みバッファを保つ', status = 0, modified = false },
  { name = '成功したターミナルだけを閉じ未保存の編集を保つ', status = 0, modified = true },
  { name = '失敗したターミナルは出力確認用に残す', status = 1, modified = true },
}) do
  test(case.name, function()
    vim.cmd('enew!')
    local terminal = vim.api.nvim_get_current_buf()
    local closed = false
    vim.api.nvim_create_autocmd('TermClose', {
      buffer = terminal,
      once = true,
      callback = function() closed = true end,
    })
    local job = vim.fn.jobstart({ 'sh', '-c', 'read -r signal; exit ' .. case.status }, { term = true })
    assert(job > 0, 'terminal job did not start')
    vim.cmd('stopinsert')
    vim.cmd('enew')
    local editing = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(editing, 0, -1, false, { 'keep this text' })
    vim.bo.modified = case.modified
    vim.v.errmsg = ''
    vim.fn.chansend(job, 'finish\n')
    assert(vim.wait(3000, function() return closed end, 10), 'terminal did not exit')
    local flushed = false
    vim.schedule(function() flushed = true end)
    assert(vim.wait(1000, function() return flushed end, 10), 'scheduled cleanup did not run')
    equal(vim.v.errmsg, '')
    equal(vim.api.nvim_buf_is_loaded(terminal), case.status ~= 0)
    equal(vim.api.nvim_get_current_buf(), editing)
    equal(vim.api.nvim_buf_get_lines(editing, 0, -1, false), { 'keep this text' })
    equal(vim.bo[editing].modified, case.modified)
  end)
end

-- setup は外部サーバーを起動するため、設定の受け渡しだけを受け取り、判定関数を実行する。
local copilot_options
package.loaded.copilot = { setup = function(opts) copilot_options = opts end }
dofile(root .. '/lua/plugins/copilot.lua').config()
package.loaded.copilot = nil

for _, case in ipairs({
  { path = '/project/.env', expected = false },
  { path = '/project/.env.local', expected = false },
  { path = '/project/.zshrc', expected = false },
  { path = '/project/.settings.lua', expected = false },
  { path = '/project/main.lua', expected = true },
  { path = '/project/config.test.lua', expected = true },
  { path = '', expected = true },
  { path = '/project/main.lua', listed = false, expected = false, name = '非一覧バッファ' },
  { path = '/project/output', bt = 'nofile', expected = false, name = '特殊バッファ' },
}) do
  test('Copilot 接続判定: ' .. (case.name or (case.path ~= '' and case.path or '無名バッファ')), function()
    vim.cmd('enew!')
    vim.bo.buflisted = case.listed ~= false
    vim.bo.buftype = case.bt or ''
    -- 未指定なら通常バッファへの接続が許可される Copilot の既定動作。
    local allowed = vim.bo.buflisted and vim.bo.buftype == ''
    if copilot_options.should_attach then
      allowed = copilot_options.should_attach(vim.api.nvim_get_current_buf(), case.path)
    end
    equal(allowed, case.expected)
  end)
end
vim.cmd('enew!')

-- Mason の setup はインストールとサーバー有効化を伴うため、この外部境界のみ停止する。
package.loaded.mason = { setup = function() end }
package.loaded['mason-lspconfig'] = { setup = function() end }
package.loaded.cmp_nvim_lsp = { default_capabilities = function() return {} end }
dofile(root .. '/lua/plugins/lsp.lua')[1].config()

test('LSP アタッチで非推奨の handler 設定を呼ばない', function()
  -- 警告の表示は Neovim が抑制する場合があるため、実際の非推奨 API 使用を記録する。
  local deprecations = {}
  local deprecate = vim.deprecate
  vim.deprecate = function(name, ...)
    deprecations[#deprecations + 1] = name
    return deprecate(name, ...)
  end
  local ok, err = pcall(vim.api.nvim_exec_autocmds, 'LspAttach', { data = { client_id = 1 } })
  vim.deprecate = deprecate
  assert(ok, err)
  assert(not vim.tbl_contains(deprecations, 'vim.lsp.with()'), 'LspAttach used vim.lsp.with')
end)

test('LSP フロートが丸い枠で開く', function()
  local _, win = vim.lsp.util.open_floating_preview({ 'hover text' }, 'text', {})
  local border = vim.api.nvim_win_get_config(win).border
  vim.api.nvim_win_close(win, true)
  equal(border, { '╭', '─', '╮', '│', '╯', '─', '╰', '│' })
end)

io.stdout:write(('Neovim tests: %d passed, %d failed\n'):format(passed, failed))
vim.cmd(failed == 0 and 'qa!' or 'cquit 1')
