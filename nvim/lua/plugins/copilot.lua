------------------------------------------------------------------------------
-- GitHub Copilot: AI補完
------------------------------------------------------------------------------
-- AIによるコード補完・提案

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      -- パネル設定（候補一覧表示）
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<C-CR>",  -- Ctrl+Enter でパネル表示
        },
        layout = {
          position = "bottom",  -- bottom, top, left, right
          ratio = 0.4,
        },
      },

      -- 提案設定（インライン補完）
      suggestion = {
        enabled = true,
        auto_trigger = true,  -- 自動で提案を表示
        debounce = 75,        -- 入力後の待機時間(ms)
        keymap = {
          accept = "<C-l>",         -- Ctrl+l で提案を受け入れ
          accept_word = "<C-;>",    -- Ctrl+; で単語単位で受け入れ
          accept_line = "<C-y>",    -- Ctrl+y で行単位で受け入れ
          next = "<M-]>",           -- Alt+] で次の提案
          prev = "<M-[>",           -- Alt+[ で前の提案
          dismiss = "<C-]>",        -- Ctrl+] で提案を却下
        },
      },

      -- ファイルタイプ設定
      filetypes = {
        yaml = false,
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,  -- 隠しファイルは無効
      },

      -- Copilotサーバー設定
      copilot_node_command = "node",  -- Node.jsのパス

      -- 追加設定
      server_opts_overrides = {},
    })
  end,
}

-- 使い方:
-- 1. 初回セットアップ
--    :Copilot auth     -- GitHubアカウントで認証
--    :Copilot status   -- 接続状態を確認
--
-- 2. インライン補完
--    コードを入力すると自動で提案が表示される（グレーのゴーストテキスト）
--    <C-l> (Ctrl+l)    -- 提案を受け入れ
--    <C-;> (Ctrl+;)    -- 単語単位で受け入れ
--    <C-y> (Ctrl+y)    -- 行単位で受け入れ
--    <M-]> (Alt+])     -- 次の提案
--    <M-[> (Alt+[)     -- 前の提案
--    <C-]> (Ctrl+])    -- 提案を却下
--
-- 3. パネル表示
--    <C-CR> (Ctrl+Enter) -- 候補一覧パネルを開く
--    [[/]]             -- パネル内で前/次の候補へ移動
--    <CR>              -- 候補を選択
--    gr                -- 候補を更新
--
-- 4. コマンド
--    :Copilot enable   -- Copilotを有効化
--    :Copilot disable  -- Copilotを無効化
--    :Copilot toggle   -- Copilotをトグル
--    :Copilot panel    -- パネルを開く
