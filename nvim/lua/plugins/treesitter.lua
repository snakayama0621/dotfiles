------------------------------------------------------------------------------
-- Treesitter: 構文ハイライト・コード理解
------------------------------------------------------------------------------

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',  -- テキストオブジェクト拡張
  },
  config = function()
    require('nvim-treesitter.configs').setup({
      -- 自動インストールする言語パーサー
      ensure_installed = {
        -- スクリプト言語
        'lua',
        'javascript',
        'typescript',
        'tsx',
        'python',
        'php',
        'ruby',

        -- コンパイル言語
        'go',
        'gomod',
        'gosum',
        'rust',
        'c',
        'cpp',

        -- Web
        'html',
        'css',
        'scss',

        -- データ・設定ファイル
        'json',
        'jsonc',
        'yaml',
        'toml',
        'xml',

        -- シェル・インフラ
        'bash',
        'dockerfile',
        'terraform',
        'hcl',

        -- ドキュメント
        'markdown',
        'markdown_inline',

        -- エディタ
        'vim',
        'vimdoc',
        'regex',
        'query',  -- Treesitterクエリ

        -- Git
        'git_config',
        'gitcommit',
        'gitignore',
        'diff',
      },

      -- パーサーを同期的にインストール（起動時のみ）
      sync_install = false,

      -- 自動インストール有効化
      auto_install = true,

      -- ハイライト設定
      highlight = {
        enable = true,
        -- 無効化したい言語があれば追加
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },

      -- インクリメンタル選択
      -- Note: <CR>との競合を避けるため、gnnなどの別のキーを使用
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },

      -- インデント
      indent = {
        enable = true,
        disable = { 'python' },  -- Pythonは別のインデントロジックを使用
      },

      -- テキストオブジェクト
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = '@class.outer',
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']C'] = '@class.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[C'] = '@class.outer',
          },
        },
      },
    })

    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
}
