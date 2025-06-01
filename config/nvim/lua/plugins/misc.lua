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
    opts = {}
  },
  {
    'benoror/gpg.nvim',
    lazy = false
  },
  {
    'MTDL9/vim-log-highlighting',
    ft = 'log'
  }
}
