-- インストール済みプラグインとの契約を検証する。外部サーバー・インストーラーは起動しない。
local root = vim.env.DOTFILES_TEST_REPO .. '/nvim'
local plugins = vim.env.DOTFILES_NVIM_PLUGINS
for _, name in ipairs({ 'mason.nvim', 'mason-nvim-dap.nvim', 'copilot.lua' }) do
  assert(vim.fn.isdirectory(plugins .. '/' .. name) == 1, 'plugin missing: ' .. name)
  vim.opt.rtp:prepend(plugins .. '/' .. name)
end

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

test('DAP の導入対象が実際の Mason パッケージに解決される', function()
  local mapping = require('mason-nvim-dap.mappings.source').nvim_dap_to_package
  local resolved = {}
  for _, dependency in ipairs(dofile(root .. '/lua/plugins/dap.lua')[1].dependencies) do
    if dependency[1] == 'jay-babu/mason-nvim-dap.nvim' then
      for _, adapter in ipairs(dependency.opts.ensure_installed) do
        assert(mapping[adapter], 'unknown DAP adapter: ' .. adapter)
        resolved[mapping[adapter]] = true
      end
    end
  end
  for _, package in ipairs({ 'debugpy', 'delve', 'codelldb', 'js-debug-adapter', 'php-debug-adapter' }) do
    assert(resolved[package], 'package not resolved: ' .. package)
  end
end)

local options
package.loaded.copilot = { setup = function(opts) options = opts end }
dofile(root .. '/lua/plugins/copilot.lua').config()
package.loaded.copilot = nil
require('copilot.config').merge_with_user_configs(options)

-- RPC の通信先だけをプロセス内で置き換え、Neovim の実際の LSP 接続・切断を使う。
local function rpc(dispatchers)
  local closing = false
  return {
    request = function(method, _, callback)
      if method == 'initialize' then
        callback(nil, { capabilities = { textDocumentSync = { openClose = true, change = 1 } } })
      elseif method == 'shutdown' then
        callback(nil, nil)
      end
      return true, 1
    end,
    notify = function(method)
      if method == 'exit' then
        closing = true
        dispatchers.on_exit(0, 0)
      end
      return true
    end,
    is_closing = function() return closing end,
    terminate = function()
      closing = true
      dispatchers.on_exit(0, 0)
    end,
  }
end

for _, case in ipairs({
  { name = '.env', attached = false },
  { name = '.settings.lua', attached = false },
  { name = 'renamed.lua', attached = true },
}) do
  test('改名後の Copilot 接続: ' .. case.name, function()
    vim.cmd('enew!')
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_name(buf, vim.env.DOTFILES_TEST_TMP .. '/original-' .. buf .. '.lua')
    vim.bo.filetype = 'lua'
    local copilot_id = assert(vim.lsp.start({ name = 'copilot', cmd = rpc }, { bufnr = buf }))
    local other_id = assert(vim.lsp.start({ name = 'other-lsp', cmd = rpc }, { bufnr = buf }))
    assert(vim.wait(1000, function()
      return vim.lsp.get_client_by_id(copilot_id).initialized and vim.lsp.get_client_by_id(other_id).initialized
    end, 10), 'LSP initialization timed out')
    require('copilot.client').id = copilot_id
    assert(vim.lsp.buf_is_attached(buf, copilot_id), 'Copilot was not attached before rename')
    vim.api.nvim_buf_set_name(buf, vim.env.DOTFILES_TEST_TMP .. '/' .. case.name)
    assert(vim.lsp.buf_is_attached(buf, copilot_id) == case.attached, 'unexpected Copilot attachment after rename')
    assert(vim.lsp.buf_is_attached(buf, other_id), 'unrelated LSP was detached')
  end)
end

io.stdout:write(('Neovim plugin tests: %d passed, %d failed\n'):format(passed, failed))
vim.cmd(failed == 0 and 'qa!' or 'cquit 1')
