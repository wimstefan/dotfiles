return {
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
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'helix',
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
  {
    'OXY2DEV/helpview.nvim',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    }
  },
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
        hybrid_modes = { 'i' },
        list_items = {
          marker_star = {
            text = ' ',
            hl = 'MarkviewListItemStar'
          }
        }
      })
    end,
  },
  {
    'echasnovski/mini.icons',
    version = false,
    config = function()
      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()
    end
  },
  {
    'eero-lehtinen/oklch-color-picker.nvim',
    event = 'BufReadPost',
    config = function()
      require('oklch-color-picker').setup({})
      vim.keymap.set('n', ',ct', function()
        require('oklch-color-picker.highlight').toggle()
      end, { desc = 'Toggle color highlighting' })
      vim.keymap.set('n', ',cp', function()
        require('oklch-color-picker').pick_under_cursor()
      end, { desc = 'Color pick under cursor' })
    end
  }
}
