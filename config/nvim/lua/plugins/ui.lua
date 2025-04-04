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
