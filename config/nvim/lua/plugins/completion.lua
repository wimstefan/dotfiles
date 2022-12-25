return {
  {
    'hrsh7th/nvim-cmp',
    event = {
      'CmdlineEnter',
      'InsertEnter'
    },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'honza/vim-snippets'
    },
    config = function()
      local cmp = require('cmp')
      local cmp_buffer = require('cmp_buffer')

      require('luasnip/loaders/from_snipmate').lazy_load()
      local luasnip = require('luasnip')
      luasnip.config.set_config {
        history = true,
        updateevents = 'TextChanged,TextChangedI',
        enable_autosnippets = true,
        ext_opts = {
          [require('luasnip.util.types').choiceNode] = {
            active = {
              hl_mode = 'combine',
              virt_text = { { '●', 'Operator' } },
            },
          },
          [require('luasnip.util.types').insertNode] = {
            active = {
              hl_mode = 'combine',
              virt_text = { { '●', 'Type' } },
            },
          },
        }
      }
      luasnip.filetype_extend('all', { '_' })

      local check_backspace = function()
        local col = vim.fn.col '.' - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s'
      end

      vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = true,
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            if entry.source.name == 'nvim_lsp' then
              vim_item.menu = '<' .. entry.source.source.client.name .. '>'
            else
              vim_item.menu = '[' .. entry.source.name .. ']'
            end
            vim_item.kind = My_Symbols[vim_item.kind]
            return vim_item
          end
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-10), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(10), { 'i', 'c' }),
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-e>'] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          },
          ['<CR>'] = cmp.config.disable,
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif check_backspace() then
              fallback()
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
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip', option = { show_autosnippets = true } },
          {
            name = 'path',
            option = {
              trailing_slash = true
            }
          },
          {
            name = 'buffer',
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          }
        }),
        sorting = {
          comparators = {
            function(...) return cmp_buffer:compare_locality(...) end,
          }
        }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          {
            name = 'path',
            option = {
              trailing_slash = true
            }
          },
        }, {
          { name = 'cmdline' }
        })
      })
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'buffer' }
        })
      })
    end
  }
}
