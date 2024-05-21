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
  -- {{{2 vim-simple-align
  {
    'kg8m/vim-simple-align',
    cmd = 'SimpleAlign'
  }
  -- }}}2
}
-- vim: foldmethod=marker foldlevel=1

