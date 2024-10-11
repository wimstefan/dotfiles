return {
  -- {{{2 noice.nvim
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim'
    },
    event = 'VeryLazy',
    keys = {
      { '<Leader>N', vim.cmd.NoiceAll, desc = 'Notifications' },
      { '<Leader>Np', vim.cmd.NoicePick, desc = 'Notification picker' }
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
  -- {{{2 hlchunk.nvim
  {
    'shellRaining/hlchunk.nvim',
    event = 'VeryLazy',
    keys = {
      { ',tie', vim.cmd.EnableHLIndent, desc = 'Enable indent highlight' },
      { ',tid', vim.cmd.DisableHLIndent, desc = 'Disable indent highlight' }
    },
    opts = {
      exclude_filetypes = {
        mail = true
      },
      chunk = {
        enable = true
      },
      indent = {
        enable = true
      }
    }
  },
  -- }}}2
  -- {{{2 foldtext.nvim
  {
    'OXY2DEV/foldtext.nvim',
    lazy = false,
    opts = {
      default = {
        { type = 'indent' },
        {
          type = 'raw',
          text = function(_)
            local lines = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldend + 1, false)
            local offset = 1
            while lines[offset]:find('%w') == nil do
              offset = offset + 1
            end
            return lines[offset]:match('^%s*(.-)%s*$'):sub(1, 30)
          end,
          hl = 'Comment',
          gradient_repeat = true
        },
        {
          type = 'fold_size',
          prefix = ' --- ',
          postfix = ' lines --- '
        }
      }
    }
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
  -- {{{2 markview.nvim
  {
    'OXY2DEV/markview.nvim',
    ft = 'markdown',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.icons'
    },
    keys = {
      { ',tm', function() require('markview').commands.toggle() end, desc = 'Markview: toggle' },
      { ',tms', function() require('markview').commands.splitEnable() end, desc = 'Markview: split toggle' }
    },
    opts = function()
      require('markview').setup({
        modes = { 'n', 'I' },
        hybrid_modes = { 'i' }
      })
    end,
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
