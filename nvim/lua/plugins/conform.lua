------------------------------------------------------------------------------
-- Conform.nvim: コードフォーマッター
------------------------------------------------------------------------------
-- 複数言語の統一されたフォーマット管理

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>fm',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end,
      mode = { 'n', 'v' },
      desc = 'フォーマット実行',
    },
  },
  opts = {
    -- 言語別フォーマッター設定
    formatters_by_ft = {
      -- JavaScript/TypeScript
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      vue = { 'prettierd', 'prettier', stop_after_first = true },
      svelte = { 'prettierd', 'prettier', stop_after_first = true },

      -- Python
      python = { 'isort', 'black' },

      -- Go
      go = { 'goimports', 'gofmt' },

      -- Rust
      rust = { 'rustfmt' },

      -- Lua
      lua = { 'stylua' },

      -- PHP
      php = { 'php_cs_fixer' },

      -- C/C++
      c = { 'clang-format' },
      cpp = { 'clang-format' },

      -- Web
      html = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      scss = { 'prettierd', 'prettier', stop_after_first = true },

      -- データ・設定ファイル
      json = { 'prettierd', 'prettier', stop_after_first = true },
      jsonc = { 'prettierd', 'prettier', stop_after_first = true },
      yaml = { 'prettierd', 'prettier', stop_after_first = true },
      toml = { 'taplo' },
      markdown = { 'prettierd', 'prettier', stop_after_first = true },

      -- シェル・インフラ
      sh = { 'shfmt' },
      bash = { 'shfmt' },
      zsh = { 'shfmt' },
      terraform = { 'terraform_fmt' },

      -- 全ファイルタイプ共通（末尾の空白除去など）
      ['_'] = { 'trim_whitespace' },
    },

    -- 保存時の自動フォーマット設定
    format_on_save = function(bufnr)
      -- 特定のファイルタイプでは保存時フォーマットを無効化
      local ignore_filetypes = { 'sql', 'java', 'markdown' }
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end
      -- 大きなファイルでは無効化（パフォーマンス対策）
      local lines = vim.api.nvim_buf_line_count(bufnr)
      if lines > 5000 then
        return
      end
      return {
        timeout_ms = 3000,
        lsp_format = 'fallback',
      }
    end,

    -- フォーマッター通知
    notify_on_error = true,
  },

  init = function()
    -- フォーマットコマンドをConformに設定
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}

-- 使い方:
-- <leader>fm       - 手動フォーマット実行
-- :ConformInfo     - フォーマッター設定確認
--
-- 保存時に自動フォーマットが実行されます（5000行以下のファイル）
-- フォーマッターがない場合はLSPにフォールバック
