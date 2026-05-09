------------------------------------------------------------------------------
-- im-select.nvim: IME自動切り替え
------------------------------------------------------------------------------
-- ノーマルモードで自動的に英数入力に切り替え

return {
  "keaising/im-select.nvim",
  event = { "InsertEnter", "CmdlineEnter" },
  config = function()
    local im_select = vim.fn.exepath("im-select")
    if im_select == "" then
      im_select = "im-select"
    end

    require("im_select").setup({
      -- im-selectコマンドのパス
      default_command = im_select,

      -- macOSの英数入力ソース
      default_im_select = "com.apple.keylayout.ABC",

      -- インサートモード離脱時にIMEを切り替え
      set_default_events = { "InsertLeave", "CmdlineLeave" },

      -- インサートモードに入った時に前回のIME状態を復元
      set_previous_events = { "InsertEnter" },

      -- バイナリがない場合のエラー抑制
      keep_quiet_on_no_binary = true,
    })
  end,
}

-- 動作:
-- Insert → Normal: 自動で半角英数に切り替え
-- Normal → Insert: 前回のIME状態を復元
-- コマンドライン離脱: 自動で半角英数に切り替え
--
-- 依存: brew install im-select
