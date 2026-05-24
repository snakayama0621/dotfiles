------------------------------------------------------------------------------
-- nvim-ts-autotag: HTMLタグ自動補完・リネーム
------------------------------------------------------------------------------
-- <div> と入力すると </div> を自動追加
-- 開始タグをリネームすると終了タグも自動で変更

return {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("nvim-ts-autotag").setup({
      opts = {
        enable_close = true,          -- 自動で閉じタグを追加
        enable_rename = true,         -- タグリネーム時に対応タグも変更
        enable_close_on_slash = true, -- <div></と入力すると自動で閉じる
      },
      -- 対応するファイルタイプ
      filetypes = {
        "html",
        "xhtml",
        "xml",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
        "php",
        "markdown",
      },
    })
  end,
}
