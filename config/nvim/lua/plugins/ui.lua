-- Messaging
require('vim._extui').enable({})

vim.pack.add({
  { src = 'https://github.com/folke/which-key.nvim' }
})
require('which-key').setup({
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
})

vim.pack.add({
  {
    src = 'https://github.com/OXY2DEV/markview.nvim',
    data = {
      ft = 'markdown'
    }
  }
})
require('markview').setup({
  preview = {
    modes = { 'n', 'I' },
    hybrid_modes = { 'i' }
  },
  markdown = {
    list_items = {
      indent_size = 2,
      shift_width = 2,
      marker_minus = {
        add_padding = false,
        text = '',
        hl = 'MarkviewListItemMinus'
      },
      marker_plus = {
        add_padding = false,
        text = '',
        hl = 'MarkviewListItemPlus'
      },
      marker_star = {
        add_padding = true,
        text = '󰓒',
        hl = 'MarkviewListItemStar'
      }
    }
  }
})
vim.keymap.set('n', ',tm', function() require('markview').commands.toggle() end, { desc = 'Markview: toggle' })

vim.pack.add({
  { src = 'https://github.com/Bekaboo/deadcolumn.nvim' },
})
require('deadcolumn').setup({
  function()
    vim.opt.colorcolumn = '80'
  end,
  blending = {
    threshold = 0.75,
    colorcode = '#f8f9fe'
  },
  warning = {
    alpha = 0.9,
    colorcode = '#b3003f'
  }
})

vim.pack.add({
  { src = 'https://github.com/eero-lehtinen/oklch-color-picker.nvim' }
})
require('oklch-color-picker').setup()
vim.keymap.set('n', ',ct', function() require('oklch-color-picker.highlight').toggle() end, { desc = 'Toggle color highlighting' })
vim.keymap.set('n', ',cp', function() require('oklch-color-picker').pick_under_cursor() end, { desc = 'Color pick under cursor' })

vim.pack.add({
  { src = 'https://github.com/folke/twilight.nvim' }
})
require('twilight').setup()
vim.keymap.set('n', 'yot', function() require('twilight').toggle() end, { desc = 'Twilight: toggle' })

vim.pack.add({
  { src = 'https://github.com/folke/zen-mode.nvim' }
})
require('zen-mode').setup({
  window = {
    options = {
      signcolumn = 'no',
      number = false,
      relativenumber = false
    }
  },
  plugins = {
    twilight = {
      enabled = true
    },
    gitsigns = {
      enabled = false
    }
  }
})
vim.keymap.set('n', 'yoz', function() require('zen-mode').toggle() end, { desc = 'Zen mode: toggle' })
