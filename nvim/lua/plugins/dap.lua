------------------------------------------------------------------------------
-- nvim-dap: デバッグアダプタープロトコル
------------------------------------------------------------------------------
-- ブレークポイント、ステップ実行、変数監視などのデバッグ機能

return {
  -- メインのDAP
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- DAP UI
      {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'nvim-neotest/nvim-nio' },
        config = function()
          local dap = require('dap')
          local dapui = require('dapui')

          dapui.setup({
            -- アイコン設定
            icons = {
              expanded = '▾',
              collapsed = '▸',
              current_frame = '▸',
            },

            -- UIレイアウト設定
            layouts = {
              {
                elements = {
                  { id = 'scopes', size = 0.25 },
                  { id = 'breakpoints', size = 0.25 },
                  { id = 'stacks', size = 0.25 },
                  { id = 'watches', size = 0.25 },
                },
                position = 'left',
                size = 40,
              },
              {
                elements = {
                  { id = 'repl', size = 0.5 },
                  { id = 'console', size = 0.5 },
                },
                position = 'bottom',
                size = 10,
              },
            },

            -- フロートウィンドウ設定
            floating = {
              max_height = nil,
              max_width = nil,
              border = 'rounded',
              mappings = {
                close = { 'q', '<Esc>' },
              },
            },
          })

          -- DAP イベントと連携してUIを自動表示/非表示
          dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close()
          end
        end,
      },

      -- 仮想テキストで変数値表示
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {
          enabled = true,
          enabled_commands = true,
          highlight_changed_variables = true,
          highlight_new_as_changed = false,
          show_stop_reason = true,
          commented = false,
          virt_text_pos = 'eol',
        },
      },

      -- Mason連携
      {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        opts = {
          ensure_installed = {
            'python',            -- Python (debugpy)
            'delve',             -- Go
            'codelldb',          -- Rust/C/C++
            'js',                -- JavaScript/TypeScript (js-debug-adapter)
            'php',               -- PHP (php-debug-adapter)
          },
          automatic_installation = true,
          handlers = {},
        },
      },
    },

    keys = {
      -- 基本操作
      { '<leader>dc', function() require('dap').continue() end, desc = 'デバッグ: 続行/開始' },
      { '<leader>ds', function() require('dap').step_over() end, desc = 'デバッグ: ステップオーバー' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'デバッグ: ステップイン' },
      { '<leader>do', function() require('dap').step_out() end, desc = 'デバッグ: ステップアウト' },

      -- ブレークポイント
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'デバッグ: ブレークポイント切替' },
      { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'デバッグ: 条件付きブレークポイント' },
      { '<leader>dl', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = 'デバッグ: ログポイント設定' },

      -- 制御
      { '<leader>dr', function() require('dap').repl.open() end, desc = 'デバッグ: REPL表示' },
      { '<leader>dR', function() require('dap').run_last() end, desc = 'デバッグ: 前回を再実行' },
      { '<leader>dq', function() require('dap').terminate() end, desc = 'デバッグ: 終了' },

      -- UI操作
      { '<leader>du', function() require('dapui').toggle() end, desc = 'デバッグ: UI切替' },
      { '<leader>de', function() require('dapui').eval() end, mode = { 'n', 'v' }, desc = 'デバッグ: 式を評価' },
    },

    config = function()
      local dap = require('dap')

      -- ブレークポイントのアイコン設定
      vim.fn.sign_define('DapBreakpoint', {
        text = '●',
        texthl = 'DapBreakpoint',
        linehl = '',
        numhl = '',
      })
      vim.fn.sign_define('DapBreakpointCondition', {
        text = '◐',
        texthl = 'DapBreakpointCondition',
        linehl = '',
        numhl = '',
      })
      vim.fn.sign_define('DapLogPoint', {
        text = '◆',
        texthl = 'DapLogPoint',
        linehl = '',
        numhl = '',
      })
      vim.fn.sign_define('DapStopped', {
        text = '▶',
        texthl = 'DapStopped',
        linehl = 'DapStoppedLine',
        numhl = '',
      })
      vim.fn.sign_define('DapBreakpointRejected', {
        text = '○',
        texthl = 'DapBreakpointRejected',
        linehl = '',
        numhl = '',
      })

      -- ハイライト設定
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#e5a500' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef' })
      vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379' })
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2e4d3d' })
      vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { fg = '#888888' })

      ----------------------------------------------------------------------
      -- 言語別デバッガー設定
      ----------------------------------------------------------------------

      -- Python (debugpy)
      dap.adapters.python = {
        type = 'executable',
        command = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python',
        args = { '-m', 'debugpy.adapter' },
      }
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          pythonPath = function()
            -- venv があれば使用、なければシステムの python
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return '/usr/bin/python3'
            end
          end,
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file with arguments',
          program = '${file}',
          args = function()
            local args_string = vim.fn.input('Arguments: ')
            return vim.split(args_string, ' ')
          end,
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return '/usr/bin/python3'
            end
          end,
        },
      }

      -- Go (delve)
      dap.adapters.delve = {
        type = 'server',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath('data') .. '/mason/bin/dlv',
          args = { 'dap', '-l', '127.0.0.1:${port}' },
        },
      }
      dap.configurations.go = {
        {
          type = 'delve',
          name = 'Debug',
          request = 'launch',
          program = '${file}',
        },
        {
          type = 'delve',
          name = 'Debug test',
          request = 'launch',
          mode = 'test',
          program = '${file}',
        },
        {
          type = 'delve',
          name = 'Debug test (go.mod)',
          request = 'launch',
          mode = 'test',
          program = './${relativeFileDirname}',
        },
      }

      -- JavaScript/TypeScript (js-debug-adapter)
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = {
            vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
            '${port}',
          },
        },
      }
      dap.configurations.javascript = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to process',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
      }
      dap.configurations.typescript = dap.configurations.javascript

      -- Rust/C/C++ (codelldb)
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
          args = { '--port', '${port}' },
        },
      }
      dap.configurations.rust = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
      dap.configurations.c = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
      dap.configurations.cpp = dap.configurations.c

      -- PHP (php-debug-adapter / Xdebug)
      dap.adapters.php = {
        type = 'executable',
        command = 'node',
        args = {
          vim.fn.stdpath('data') .. '/mason/packages/php-debug-adapter/extension/out/phpDebug.js',
        },
      }
      dap.configurations.php = {
        {
          type = 'php',
          request = 'launch',
          name = 'Listen for Xdebug',
          port = 9003,
        },
      }
    end,
  },
}

-- 使い方:
--
-- 基本操作:
--   <leader>dc - デバッグ開始/続行
--   <leader>ds - ステップオーバー（次の行へ）
--   <leader>di - ステップイン（関数の中へ）
--   <leader>do - ステップアウト（関数から出る）
--   <leader>dq - デバッグ終了
--
-- ブレークポイント:
--   <leader>db - ブレークポイント設定/解除
--   <leader>dB - 条件付きブレークポイント
--   <leader>dl - ログポイント（停止せずログ出力）
--
-- UI操作:
--   <leader>du - デバッグUIの表示/非表示
--   <leader>de - カーソル下の変数を評価
--   <leader>dr - REPL（対話モード）を開く
--   <leader>dR - 前回のデバッグを再実行
--
-- 対応言語:
--   - Python (debugpy)
--   - Go (delve)
--   - JavaScript/TypeScript (js-debug-adapter)
--   - Rust/C/C++ (codelldb)
--   - PHP (php-debug-adapter + Xdebug)
