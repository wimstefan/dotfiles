return {
  {
    'tpope/vim-repeat',
    keys = '.'
  },
  {
    'mikavilpas/yazi.nvim',
    event = 'VeryLazy',
    keys = {
      { '<Leader>y', '<Cmd>Yazi<CR>', desc = 'Open yazi at the current file' },
      { '<Leader>yw', '<Cmd>Yazi cwd<CR>', desc = "Open the file manager in nvim's working directory" },
      { ',ty', '<Cmd>Yazi toggle<CR>', desc = 'Resume the last yazi session' }
    },
    dependencies = 'folke/snacks.nvim',
    opts = {
      yazi_floating_window_border = require('config.ui').borders
    }
  },
  {
    'benoror/gpg.nvim',
    lazy = false
  },
  {
    'fei6409/log-highlight.nvim',
    lazy = false,
    opts = {}
  }
}
