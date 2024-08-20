return {
  -- {{{2 noice.nvim
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim'
    },
    event = 'VeryLazy',
    keys = {
      { '<Leader>n', vim.cmd.NoiceAll, desc = 'Notifications' },
      { '<Leader>np', vim.cmd.NoicePick, desc = 'Notification picker' }
    },
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true
        }
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        lsp_doc_border = true
      }
    }
  },
  -- }}}2
  -- {{{2 statuscol.nvim
  {
    'luukvbaal/statuscol.nvim',
    event = 'UiEnter',
    config = true,
    opts = function()
      local builtin = require('statuscol.builtin')
      return {
        relculright = true,
        setopt = true,
        segments = {
          { text = { builtin.foldfunc, '' }, click = 'v:lua.ScFa' },
          { text = { ' %s' }, click = 'v:lua.ScSa' },
          { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' }
        }
      }
    end
  },
  -- }}}2
  -- {{{2 which-key.nvim
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'modern',
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 40
        }
      },
      win = {
        border = require('config.ui').borders,
        padding = { 2, 2, 2, 2 }
      }
    }
  },
  -- }}}2
  -- {{{2 deadcolumn.nvim
  {
    'Bekaboo/deadcolumn.nvim',
    event = 'VeryLazy',
    init = function()
      vim.opt.colorcolumn = '80'
    end,
    opts = {
      blending = {
        threshold = 0.75,
        colorcode = '#f8f9fe'
      },
      warning = {
        alpha = 0.9,
        colorcode = '#b3003f'
      }
    }
  },
  -- }}}2
  -- {{{2 indent-blankline.nvim
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'VeryLazy',
    keys = {
      { ',ti', vim.cmd.IBLToggle, desc = 'IndentBlankline: toggle' }
    },
    opts = {
      enabled = false,
      indent = {
        highlight = { 'Error', 'Character', 'Type', 'String', 'Label', 'Keyword' },
        char = '▏'
      },
      scope = {
        highlight = { 'NonText' }
      }
    }
  },
  -- }}}2
  -- {{{2 markview.nvim
  {
    'OXY2DEV/markview.nvim',
    ft = 'markdown',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.icons'
    },
    opts = function()
      require('markview').setup({
        modes = { 'n', 'I' },
        hybrid_modes = { 'i' }
      })
    end
  },
  -- }}}2
  -- {{{2 helpview.nvim
  {
    'OXY2DEV/helpview.nvim',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    }
  },
  -- }}}2
  -- {{{2 mini.icons
  {
    'echasnovski/mini.icons',
    version = false,
    config = function()
      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()
    end
  },
  -- }}}2
  -- {{{2 ccc.nvim
  {
    'uga-rosa/ccc.nvim',
    event = 'BufReadPost',
    keys = {
      { ',ct', vim.cmd.CccHighlighterToggle, desc = 'Ccc: toggle highlights' },
      { ',cp', vim.cmd.CccPick, desc = 'Ccc: edit color' }
    },
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true
      }
    }
  }
  -- }}}2
}
-- vim: foldmethod=marker foldlevel=1
