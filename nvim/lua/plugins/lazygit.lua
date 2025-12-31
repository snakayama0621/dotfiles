------------------------------------------------------------------------------
-- Lazygit: ターミナルベースのGit UI統合
------------------------------------------------------------------------------
-- toggletermを使用してLazygitをフローティングウィンドウで起動する

return {
  'akinsho/toggleterm.nvim',
  keys = {
    {
      '<leader>lg',
      function()
        local Terminal = require('toggleterm.terminal').Terminal
        local lazygit = Terminal:new({
          cmd = 'lazygit',
          direction = 'float',
          float_opts = {
            border = 'rounded',
          },
          on_open = function(_)
            vim.cmd('startinsert!')
          end,
        })
        lazygit:toggle()
      end,
      desc = 'Lazygit: 起動',
    },
  },
}
