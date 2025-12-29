------------------------------------------------------------------------------
-- Dev Container: コンテナ開発環境統合
------------------------------------------------------------------------------
-- devcontainer CLIを使用してコンテナ内での開発を可能にする
-- 依存: npm install -g @devcontainers/cli

return {
  -- ToggleTerm (依存関係として必要)
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      direction = 'horizontal',  -- 下部に表示（VS Code風）
      shade_terminals = true,
      shading_factor = 2,
    },
  },

  -- DevContainer CLI統合
  {
    'erichlf/devcontainer-cli.nvim',
    dependencies = { 'akinsho/toggleterm.nvim' },
    cmd = {
      'DevcontainerUp',
      'DevcontainerDown',
      'DevcontainerConnect',
      'DevcontainerExec',
      'DevContainerToggle',
      'DevcontainerLogs',
    },
    keys = {
      -- コンテナ基本操作
      { '<leader>Du', '<cmd>DevcontainerUp<CR>', desc = 'DevContainer: ビルド・起動' },
      { '<leader>Dd', '<cmd>DevcontainerDown<CR>', desc = 'DevContainer: 停止・削除' },
      { '<leader>Dt', '<cmd>DevContainerToggle<CR>', desc = 'DevContainer: ターミナル切替' },

      -- コンテナ内でシェルを起動（推奨）
      {
        '<leader>Dc',
        function()
          -- コンテナ内でzshを起動（下部に表示）
          vim.cmd("DevcontainerExec cmd='zsh' direction='horizontal'")
        end,
        desc = 'DevContainer: シェル接続',
      },

      -- Neovimごとコンテナに接続（全バッファ保存して終了）
      {
        '<leader>DN',
        function()
          -- 無名バッファを削除してからconnect
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
              local name = vim.api.nvim_buf_get_name(buf)
              if name == '' and not vim.bo[buf].modified then
                vim.api.nvim_buf_delete(buf, { force = true })
              end
            end
          end
          vim.cmd('DevcontainerConnect')
        end,
        desc = 'DevContainer: Neovim再起動して接続',
      },

      -- コマンド実行
      {
        '<leader>De',
        function()
          vim.ui.input({ prompt = 'Command to execute: ' }, function(cmd)
            if cmd and cmd ~= '' then
              vim.cmd("DevcontainerExec cmd='" .. cmd .. "'")
            end
          end)
        end,
        desc = 'DevContainer: コマンド実行',
      },

      -- 垂直分割でコマンド実行
      {
        '<leader>Dv',
        "<cmd>DevcontainerExec direction='vertical' size='40'<CR>",
        desc = 'DevContainer: 実行(垂直分割)',
      },

      -- 水平分割でコマンド実行
      {
        '<leader>Dh',
        "<cmd>DevcontainerExec direction='horizontal' size='15'<CR>",
        desc = 'DevContainer: 実行(水平分割)',
      },
    },
    config = function()
      require('devcontainer-cli').setup({
        -- 対話モード（状態変更前に確認を求める）
        interactive = true,

        -- プロジェクトルートから.devcontainerを探す
        toplevel = true,

        -- 既存コンテナを削除して再構築
        remove_existing_container = false,

        -- コンテナ内で使用するシェル
        shell = 'zsh',

        -- コンテナ内のNeovimバイナリ
        nvim_binary = 'nvim',

        -- ログ設定
        log_level = 'info',
        console_level = 'info',
      })
    end,
  },
}

-- 使い方:
--
-- 基本操作:
--   <leader>Du - コンテナをビルド・起動
--   <leader>Dc - コンテナ内でシェル（zsh）を起動
--   <leader>Dt - ターミナル表示切替
--   <leader>Dd - コンテナを停止・削除
--   <leader>DN - Neovimを終了してコンテナ内で再起動（上級者向け）
--
-- コマンド実行:
--   <leader>De - コンテナ内でコマンドを実行（入力プロンプト）
--   <leader>Dv - 垂直分割でコマンド実行
--   <leader>Dh - 水平分割でコマンド実行
--
-- ターミナル:
--   <C-\>      - フローティングターミナル切替
--
-- ワークフロー:
--   1. .devcontainer/devcontainer.json があるプロジェクトを開く
--   2. <leader>Du でコンテナをビルド・起動
--   3. <leader>Dc でコンテナ内シェルに接続
--   4. コンテナ内で作業
--   5. <leader>Dd で作業終了時にコンテナ停止
