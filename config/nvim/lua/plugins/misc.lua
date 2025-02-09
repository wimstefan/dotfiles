return {
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
  }
}
