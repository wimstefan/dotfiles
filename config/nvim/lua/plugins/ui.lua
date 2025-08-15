-- Messaging
require('vim._extui').enable({})

return {
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
        padding = { 2, 2, 2, 2 }
      }
    }
  },
  {
    'chrisgrieser/nvim-origami',
    event = 'VeryLazy',
    opts = {
      foldtext = {
        enabled = true,
        padding = 4,
        lineCount = {
          template = '.. [ %d lines ] ..'
        }
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
