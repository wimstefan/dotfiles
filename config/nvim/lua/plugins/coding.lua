return {
  -- {{{2 autocomplete.nvim
  {
    'deathbeam/autocomplete.nvim',
    event = {
      'CmdlineEnter',
      'InsertEnter'
    },
    config = function()
      vim.keymap.set('i', '<Tab>', function()
        return vim.fn.pumvisible() ~= 0 and '<C-y>' or '<Tab>'
      end, { expr = true, replace_keycodes = true })
      vim.keymap.set('i', '<CR>', function()
        return vim.fn.pumvisible() ~= 0 and '<C-e><CR>' or '<CR>'
      end, { expr = true, replace_keycodes = true })

      require('autocomplete.buffer').setup({
        border = require('config.ui').borders,
        server_side_filtering = true,
        entry_mapper = function(entry)
          local icons = require('config.ui').icons
          local kind = entry.kind
          local icon = icons.kinds[kind]
          entry.kind = icon and icon .. ' ' .. kind or kind
          return entry
        end
      })
      require('autocomplete.cmd').setup()
      require('autocomplete.signature').setup({
        border = require('config.ui').borders
      })
    end
  },
  -- }}}2
  -- {{{2 smartyank.nvim
  {
    'ibhagwan/smartyank.nvim',
    event = 'VeryLazy',
    config = true
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
  -- {{{2 text-case.nvim
  {
    'johmsalas/text-case.nvim',
    event = 'VeryLazy',
    opts = {}
  },
  -- }}}2
  -- {{{2 undotree
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
