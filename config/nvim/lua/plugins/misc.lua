return {
  -- {{{2 plenary.nvim
  'nvim-lua/plenary.nvim',
  -- }}}2
  -- {{{2 nvim-luapad
  {
    'rafcamlet/nvim-luapad',
    cmd = 'Luapad',
    dependencies = 'antoinemadec/FixCursorHold.nvim'
  },
  -- }}}2
  -- {{{2 Projects
  {
    'gennaro-tedesco/nvim-possession',
    keys = {
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
  -- }}}2
  -- {{{2 vim-repeat
  {
    'tpope/vim-repeat',
    keys = '.'
  },
  -- }}}2
  -- {{{2 vim-unimpaired
  {
    'tpope/vim-unimpaired',
    event = 'VeryLazy'
  },
  -- }}}2
  -- {{{2 nvim-bqf
  {
    'kevinhwang91/nvim-bqf',
    dependencies = 'junegunn/fzf',
    event = 'BufReadPost',
    opts = {
      auto_enable = true,
      auto_resize_height = true
    }
  },
  -- }}}2
  -- {{{2 toggleterm.nvim
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
  -- }}}2
  -- {{{2 fm-nvim
  {
    'is0n/fm-nvim',
    cmd = {
      'Fzf',
      'Lazygit',
      'Vifm'
    },
    keys = {
      { '<Leader>Z', vim.cmd.Fzf, desc = 'Fzf' },
      { '<Leader>L', vim.cmd.Lazygit, desc = 'Lazygit' },
      { '<Leader>X', vim.cmd.Vifm, desc = 'Vifm' }
    },
    opts = {
      ui = {
        default = 'float',
        float = {
          border = require('config.ui').borders,
          float_hl = 'Normal',
          border_hl = 'FloatBorder'
        }
      }
    }
  },
  -- }}}2
  -- {{{2 vim-gnupg
  {
    'jamessan/vim-gnupg',
    lazy = false
  },
  -- }}}2
  -- {{{2 vim-log-highlighting
  {
    'MTDL9/vim-log-highlighting',
    ft = 'log'
  },
  -- }}}2
  -- {{{2 rasi.vim
  {
    'Fymyte/rasi.vim',
    ft = 'rasi',
    build = ':TSInstall rasi'
  },
  -- }}}2
  -- {{{2 unicode.vim
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
  -- }}}2
}
-- vim: foldmethod=marker foldlevel=1
