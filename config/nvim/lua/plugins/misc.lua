return {
  'nvim-lua/plenary.nvim',
  {
    'folke/snacks.nvim',
    event = 'VeryLazy',
    opts = {
      statuscolumn = { enabled = true },
      win = { border = require('config.ui').borders }
    },
    keys = {
      { '<Leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
      { '<Leader>L', function() Snacks.lazygit() end, desc = 'Lazygit' },
      { '<Leader>gf', function() Snacks.lazygit.log_file() end, desc = 'Lazygit Current File History' },
      { '<Leader>gl', function() Snacks.lazygit.log() end, desc = 'Lazygit Log (cwd)' },
      { '<C-\\>', mode = { 'n', 't' }, function() Snacks.terminal.toggle({ 'zsh' }) end, desc = 'Terminal' }
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'background' }):map('yob')
          Snacks.toggle.option('hlsearch', { name = 'search highlighting' }):map('yoh')
          Snacks.toggle.option('spell', { name = 'spelling' }):map('yos')
          Snacks.toggle.option('wrap', { name = 'wrap' }):map('yow')
          Snacks.toggle.option('relativenumber', { name = 'relative number' }):map('yor')
          Snacks.toggle.line_number({ name = 'line number' }):map('yol')
        end
      })
    end
  },
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
