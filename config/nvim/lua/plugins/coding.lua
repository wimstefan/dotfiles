return {
  -- {{{2 nvim-snippy
  {
    'dcampos/nvim-snippy',
    dependencies = {
      'honza/vim-snippets'
    }
  },
  -- }}}2
  -- {{{2 nvim-cmp
  {
    'hrsh7th/nvim-cmp',
    event = {
      'CmdlineEnter',
      'InsertEnter'
    },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'dcampos/cmp-snippy'
    },
    opts = function()
      local unpack = unpack or table.unpack
      local cmp = require('cmp')
      local cmp_buffer = require('cmp_buffer')
      local snippy = require('snippy')

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            snippy.expand_snippet(args.body)
          end
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-10),
          ['<C-f>'] = cmp.mapping.scroll_docs(10),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-z>'] = cmp.mapping.confirm { select = true },
          ['<CR>'] = cmp.config.disable,
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif snippy.can_expand_or_advance() then
              snippy.can_expand_or_advance()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif snippy.can_jump(-1) then
              snippy.previous()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'snippy' },
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
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            if entry.source.name == 'nvim_lsp' then
              vim_item.menu = '<' .. entry.source.source.client.name .. '>'
            else
              vim_item.menu = '[' .. entry.source.name .. ']'
            end
            vim_item.kind = require('config.ui').icons.kinds[vim_item.kind]
            return vim_item
          end
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered()
        },
        experimental = {
          ghost_text = {
            enabled = true
          }
        },
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
        sources = {
          { name = 'buffer' }
        }
      })
    end
  },
  -- }}}2
  -- {{{2 ultimate-autopair.nvim
  {
    'altermo/ultimate-autopair.nvim',
    event = 'VeryLazy',
    opts = {}
  },
  -- }}}2
  -- {{{2 nvim-surround
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    opts = {}
  },
  -- }}}2
  -- {{{2 Comment.nvim
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    keys = {
      {
        'gci',
        [[:g/./lua require('Comment.api').toggle.linewise.current()<CR><Cmd>nohls<CR>]],
        mode = 'x',
        silent = true,
        desc = 'Invert comments'
      }
    },
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
      })
      vim.keymap.set('n', 'g>', require('Comment.api').call('comment.linewise', 'g@'),
        { expr = true, desc = 'Comment region linewise' })
      vim.keymap.set('n', 'g>c', require('Comment.api').call('comment.linewise.current', 'g@$'),
        { expr = true, desc = 'Comment current line' })
      vim.keymap.set('n', 'g>b', require('Comment.api').call('comment.blockwise.current', 'g@$'),
        { expr = true, desc = 'Comment current block' })
      vim.keymap.set('n', 'g<', require('Comment.api').call('uncomment.linewise', 'g@'),
        { expr = true, desc = 'Uncomment region linewise' })
      vim.keymap.set('n', 'g<c', require('Comment.api').call('uncomment.linewise.current', 'g@$'),
        { expr = true, desc = 'Uncomment current line' })
      vim.keymap.set('n', 'g<b', require('Comment.api').call('uncomment.blockwise.current', 'g@$'),
        { expr = true, desc = 'Uncomment current block' })
      vim.keymap.set('x', 'g>', function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<ESC>', true, false, true), 'nx', false)
        require('Comment.api').locked('comment.linewise')(vim.fn.visualmode())
      end, { desc = 'Comment region linewise (visual)' })
      vim.keymap.set('x', 'g<', function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<ESC>', true, false, true), 'nx', false)
        require('Comment.api').locked('uncomment.linewise')(vim.fn.visualmode())
      end, { desc = 'Uncomment region linewise (visual)' })
    end
  },
  -- }}}2
  -- {{{2 multicursors.nvim
  {
    'smoka7/multicursors.nvim',
    event = 'VeryLazy',
    dependencies = {
      'smoka7/hydra.nvim',
    },
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
      {
        mode = { 'v', 'n' },
        '<Leader>v',
        '<cmd>MCstart<CR>',
        desc = 'Create a selection for selected text or word under the cursor',
      },
    },
  },
  -- }}}2
  -- {{{2 smartyank.nvim
  {
    'ibhagwan/smartyank.nvim',
    event = 'VeryLazy',
    config = true
  },
  -- }}}2
  -- {{{2 text-case.nvim
  {
    'johmsalas/text-case.nvim',
    event = 'VeryLazy',
    opts = {}
  },
  -- }}}2
  -- undotree
  {
    'jiaoshijie/undotree',
    keys = {
      { ',tu', function() require('undotree').toggle() end, noremap = true, silent = true, desc = 'Undotree' }
    },
    opts = {
      window = {
        winblend = 0
      }
    }
  },
  -- }}}2
  -- {{{2 autolist.nvim
  {
    'gaoDean/autolist.nvim',
    ft = {
      'markdown',
      'text'
    },
    config = function()
      require('autolist').setup({
        cycle = {
          '*',
          '-',
          '.',
          '1)',
          'a)'
        }
      })

      vim.keymap.set('i', '<CR>', '<CR><Cmd>AutolistNewBullet<CR>')
      vim.keymap.set('i', '<Tab>', function()
        require('autolist').cycle_next_dr()
        require('autolist').tab()
      end, { desc = 'Autolist: increase indentation' })
      vim.keymap.set('i', '<S-Tab>', function()
        require('autolist').cycle_prev_dr()
        require('autolist').shift_tab()
      end, { desc = 'Autolist: decrease indentation' })
      vim.keymap.set('n', 'o', 'o<Cmd>AutolistNewBullet<CR>')
      vim.keymap.set('n', 'O', 'O<Cmd>AutolistNewBulletBefore<CR>')
      vim.keymap.set('n', '<CR>', '<Cmd>AutolistToggleCheckbox<CR>')
      vim.keymap.set('n', '<C-r>', '<Cmd>AutolistRecalculate<CR>')

      vim.keymap.set('n', '<Leader>an', require('autolist').cycle_next_dr, { expr = true })
      vim.keymap.set('n', '<Leader>ap', require('autolist').cycle_prev_dr, { expr = true })

      vim.keymap.set('n', '>>', '>><Cmd>AutolistRecalculate<CR>')
      vim.keymap.set('n', '<<', '<<<Cmd>AutolistRecalculate<CR>')
      vim.keymap.set('n', 'dd', 'dd<Cmd>AutolistRecalculate<CR>')
      vim.keymap.set('v', 'd', 'd<Cmd>AutolistRecalculate<CR>')

    end
  },
  -- }}}2
  -- {{{2 vim-simple-align
  {
    'kg8m/vim-simple-align',
    cmd = 'SimpleAlign'
  },
  -- }}}2
  -- {{{2 dial.nvim
  {
    'monaqa/dial.nvim',
    keys = {
      { '<C-a>', function() return require('dial.map').inc_normal() end, expr = true, noremap = true, desc = 'Increment' },
      { '<C-x>', function() return require('dial.map').dec_normal() end, expr = true, noremap = true, desc = 'Decrement' },
      { '<C-a>', function() return require('dial.map').inc_visual() end, mode = 'v', expr = true, noremap = true, desc = 'Increment visual selection' },
      { '<C-x>', function() return require('dial.map').dec_visual() end, mode = 'v', expr = true, noremap = true, desc = 'Decrement visual selection' },
      { 'g<C-a>', function() return require('dial.map').inc_gnormal() end, mode = 'n', expr = true, noremap = true, desc = 'Increment visual selection' },
      { 'g<C-x>', function() return require('dial.map').dec_gnormal() end, mode = 'n', expr = true, noremap = true, desc = 'Decrement visual selection' },
      { 'g<C-a>', function() return require('dial.map').inc_gvisual() end, mode = 'v', expr = true, noremap = true, desc = 'Increment visual selection' },
      { 'g<C-x>', function() return require('dial.map').dec_gvisual() end, mode = 'v', expr = true, noremap = true, desc = 'Decrement visual selection' }
    },
    config = function()
      local augend = require('dial.augend')
      require('dial.config').augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.bool,
          augend.semver.alias.semver
        }
      })
    end
  }
  -- }}}2
}
-- vim: foldmethod=marker foldlevel=1
