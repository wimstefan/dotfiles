return {
  {
    'echasnovski/mini.ai',
    version = false,
    event = 'VeryLazy',
    opts = {}
  },
  {
    'echasnovski/mini.align',
    version = false,
    event = 'VeryLazy',
    opts = {}
  },
  {
    'echasnovski/mini.completion',
    version = false,
    dependencies = 'echasnovski/mini.icons',
    event = 'VeryLazy',
    config = function()
      require('mini.icons').setup()
      MiniIcons.tweak_lsp_kind()
      require('mini.completion').setup({
        window = {
          info = {
            border = require('config.ui').borders
          },
          signature = {
            border = require('config.ui').borders
          }
        },
        lsp_completion = {
          source_func = 'omnifunc',
          auto_setup = false
        }
      })
      vim.keymap.set('i', '<Tab>', [[pumvisible() ? '<C-n>' : '<Tab>']], { desc = 'Completion: next', expr = true })
      vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? '<C-p>' : '<S-Tab>']], { desc = 'Completion: prev', expr = true })

    end
  },
  {
    'echasnovski/mini.surround',
    version = false,
    event = 'VeryLazy',
    opts = {}
  },
  {
    'echasnovski/mini.sessions',
    event = 'BufReadPre',
    keys = {
      { '<Leader>pd', function() require('mini.sessions').delete() end, desc = 'Session: delete' },
      { '<Leader>pr', function() require('mini.sessions').read() end, desc = 'Session: read' },
      { '<Leader>ps', function() require('mini.sessions').select() end, desc = 'Session: select' },
      { '<Leader>pw', function() require('mini.sessions').write() end, desc = 'Session: write' }
    },
    config = function()
      require('mini.sessions').setup({
        directory = vim.fn.stdpath('state') .. '/sessions/',
        force = {
          delete = true
        }
      })
    end
  }
}

