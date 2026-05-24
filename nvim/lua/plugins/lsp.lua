------------------------------------------------------------------------------
-- LSP: Language Server Protocol設定
------------------------------------------------------------------------------

return {
  -- LSPConfig
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- Mason: LSPサーバー管理
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- Mason Tool Installer: フォーマッター・リンターの自動インストール
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        config = function()
          require('mason-tool-installer').setup({
            ensure_installed = {
              -- フォーマッター
              'prettierd',       -- JS/TS/HTML/CSS/JSON/YAML/Markdown
              'prettier',        -- prettierdのフォールバック
              'black',           -- Python
              'isort',           -- Python import整理
              'stylua',          -- Lua
              'goimports',       -- Go
              'shfmt',           -- Shell
              'clang-format',    -- C/C++
              'php-cs-fixer',    -- PHP

              -- リンター
              'eslint_d',        -- JS/TS
              'ruff',            -- Python
              'mypy',            -- Python型チェック
              'golangci-lint',   -- Go
              'luacheck',        -- Lua
              'shellcheck',      -- Shell
              'hadolint',        -- Dockerfile
              'yamllint',        -- YAML
              'markdownlint',    -- Markdown
              'phpcs',           -- PHP
            },
            auto_update = false,
            run_on_start = false,
          })
        end,
      },
    },
    config = function()
      -- Mason setup
      require('mason').setup({
        ui = {
          border = 'rounded',
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      })

      -- Capabilities設定（nvim-cmpとの連携）
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local servers = {
        -- スクリプト言語
        'lua_ls',           -- Lua
        'ts_ls',            -- TypeScript/JavaScript
        'pyright',          -- Python
        'intelephense',     -- PHP

        -- コンパイル言語
        'gopls',            -- Go
        'rust_analyzer',    -- Rust
        'clangd',           -- C/C++

        -- Web
        'html',             -- HTML
        'cssls',            -- CSS
        'tailwindcss',      -- Tailwind CSS

        -- データ・設定ファイル
        'jsonls',           -- JSON
        'yamlls',           -- YAML
        'taplo',            -- TOML

        -- シェル・インフラ
        'bashls',           -- Bash/Zsh
        'dockerls',         -- Dockerfile
        'docker_compose_language_service',  -- Docker Compose
        'terraformls',      -- Terraform
      }

      -- Neovim 0.11+ のネイティブLSP設定APIを使用
      for _, server_name in ipairs(servers) do
        vim.lsp.config(server_name, {
          capabilities = capabilities,
        })
      end

      -- lua_ls専用設定
      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- ts_ls専用設定
      vim.lsp.config('ts_ls', {
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })

      -- pyright専用設定
      vim.lsp.config('pyright', {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = 'basic',
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -- 自動インストール + インストール済みサーバーの自動有効化
      require('mason-lspconfig').setup({
        ensure_installed = servers,
        automatic_enable = true,
      })

      -- 診断表示設定
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          source = 'if_many',
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          source = 'always',
          border = 'rounded',
        },
      })

      -- 診断サイン設定
      local signs = {
        Error = '✘',
        Warn = '▲',
        Hint = '⚑',
        Info = '»',
      }

      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- LSPアタッチ時の設定
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
        callback = function(event)
          -- ホバー情報をフロートウィンドウで表示
          vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover,
            { border = 'rounded' }
          )

          vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help,
            { border = 'rounded' }
          )
        end,
      })
    end,
  },
}
