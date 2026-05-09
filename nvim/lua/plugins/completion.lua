------------------------------------------------------------------------------
-- 補完エンジン: nvim-cmp
------------------------------------------------------------------------------

return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- 補完ソース
    'hrsh7th/cmp-nvim-lsp',     -- LSP補完
    'hrsh7th/cmp-buffer',       -- バッファ補完
    'hrsh7th/cmp-path',         -- パス補完
    'hrsh7th/cmp-cmdline',      -- コマンドライン補完

    -- スニペット
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
    },
    'saadparwaiz1/cmp_luasnip',  -- LuaSnip補完統合
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    local function jump_over_closing_pair()
      if vim.api.nvim_get_mode().mode ~= 'i' then
        return false
      end
      local col = vim.fn.col('.')
      local char = vim.fn.getline('.'):sub(col, col)
      if char:match('[%)%]%}\'"`]') then
        local right = vim.api.nvim_replace_termcodes('<Right>', true, false, true)
        vim.api.nvim_feedkeys(right, 'n', true)
        return true
      end
      return false
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif jump_over_closing_pair() then
            return
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),

      sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'buffer', priority = 500 },
        { name = 'path', priority = 250 },
      }),

      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          -- アイコン設定
          local kind_icons = {
            Text = '',
            Method = '󰆧',
            Function = '󰊕',
            Constructor = '',
            Field = '󰇽',
            Variable = '󰂡',
            Class = '󰠱',
            Interface = '',
            Module = '',
            Property = '󰜢',
            Unit = '',
            Value = '󰎠',
            Enum = '',
            Keyword = '󰌋',
            Snippet = '',
            Color = '󰏘',
            File = '󰈙',
            Reference = '',
            Folder = '󰉋',
            EnumMember = '',
            Constant = '󰏿',
            Struct = '',
            Event = '',
            Operator = '󰆕',
            TypeParameter = '󰅲',
          }

          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or '', vim_item.kind)
          vim_item.menu = ({
            nvim_lsp = '[LSP]',
            luasnip = '[Snippet]',
            buffer = '[Buffer]',
            path = '[Path]',
          })[entry.source.name]

          return vim_item
        end,
      },

      experimental = {
        ghost_text = true,
      },
    })

    -- コマンドライン補完設定
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })

    -- LSP capabilities設定（lsp.luaと連携）
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    -- この capabilities は lsp.lua で使用されます
  end,
}
