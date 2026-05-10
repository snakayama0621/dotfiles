------------------------------------------------------------------------------
-- live-server.nvim: HTMLライブプレビュー
------------------------------------------------------------------------------
-- ブラウザでライブプレビュー、ファイル保存時に自動リロード

return {
  "barrett-ruth/live-server.nvim",
  cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
  ft = { "html", "css", "javascript" },
  keys = {
    { "<leader>ls", "<cmd>LiveServerToggle<cr>", desc = "Live Server: トグル" },
  },
  config = function()
    require("live-server").setup({
      args = { "--port=5500", "--browser=default" },
    })
  end,
}
