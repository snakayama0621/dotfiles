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

      -- 自動インストール + ハンドラー設定
      require('mason-lspconfig').setup({
        ensure_installed = {
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
          'emmet_ls',         -- Emmet

          -- データ・設定ファイル
          'jsonls',           -- JSON
          'yamlls',           -- YAML
          'taplo',            -- TOML

          -- シェル・インフラ
          'bashls',           -- Bash/Zsh
          'dockerls',         -- Dockerfile
          'docker_compose_language_service',  -- Docker Compose
          'terraformls',      -- Terraform
        },
        automatic_installation = true,
        handlers = {
          -- デフォルトハンドラー（全サーバー共通）
          function(server_name)
            require('lspconfig')[server_name].setup({
              capabilities = capabilities,
            })
          end,

          -- lua_ls専用設定
          ['lua_ls'] = function()
            require('lspconfig').lua_ls.setup({
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
          end,

          -- ts_ls専用設定
          ['ts_ls'] = function()
            require('lspconfig').ts_ls.setup({
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
          end,

          -- pyright専用設定
          ['pyright'] = function()
            require('lspconfig').pyright.setup({
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
          end,
        },
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
