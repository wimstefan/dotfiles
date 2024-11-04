return {
  'nvim-lua/plenary.nvim',
  {
    'gennaro-tedesco/nvim-possession',
    keys = {
      { '<leader>pd', function() require('nvim-possession').delete() end, desc = 'Projects: delete' },
      { '<leader>pl', function() require('nvim-possession').list() end, desc = 'Projects: list' },
      { '<leader>pn', function() require('nvim-possession').new() end, desc = 'Projects: new' },
      { '<leader>pu', function() require('nvim-possession').update() end, desc = 'Projects: update' }
    },
    opts = {
      sessions = {
        sessions_icon = '󱜤  '
      },
      autoswitch = {
        enable = true
      }
    }
  },
  {
    'tpope/vim-repeat',
    keys = '.'
  },
  {
    'idanarye/nvim-impairative',
    event = 'VeryLazy',
    opts = {
      replicate_unimpaired = true
    }
  },
  {
    'kevinhwang91/nvim-bqf',
    dependencies = 'junegunn/fzf',
    event = 'BufReadPost',
    opts = {
      auto_enable = true,
      auto_resize_height = true
    }
  },
  {
    'mikavilpas/yazi.nvim',
    event = 'VeryLazy',
    keys = {
      { '<Leader>y', '<Cmd>Yazi<CR>', desc = 'Open yazi at the current file' },
      { '<Leader>yw', '<Cmd>Yazi cwd<CR>', desc = "Open the file manager in nvim's working directory" },
      { ',ty', '<Cmd>Yazi toggle<CR>', desc = 'Resume the last yazi session' }
    },
    opts = {}
  },
  {
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    keys = {
      { '<C-\\>' },
      { '<Leader>Tf', [[<Cmd>ToggleTerm direction=float<CR>]], desc = 'ToggleTerm: floating' },
      { '<Leader>Th', [[<Cmd>ToggleTerm direction=horizontal<CR>]], desc = 'ToggleTerm: horizontal' },
      { '<Leader>Tv', [[<Cmd>ToggleTerm direction=vertical<CR>]], desc = 'ToggleTerm: vertical' }
    },
    opts = {
      size = function(term)
        if term.direction == 'horizontal' then
          return vim.o.lines * 0.44
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.44
        end
      end,
      open_mapping = [[<C-\>]],
      shade_terminals = false,
      direction = 'float',
      float_opts = {
        border = require('config.ui').borders
      }
    }
  },
  {
    'jamessan/vim-gnupg',
    lazy = false
  },
  {
    'MTDL9/vim-log-highlighting',
    ft = 'log'
  },
  {
    'chrisbra/unicode.vim',
    cmd = {
      'UnicodeName',
      'UnicodeTable'
    },
    keys = {
      { '<Leader>ut', vim.cmd.UnicodeTable, desc = 'Open unicode table' },
      { 'gu', vim.cmd.UnicodeName, desc = 'Lookup Unicode character' }
    }
  }
}
