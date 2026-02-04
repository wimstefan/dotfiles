vim.pack.add({
  { src = 'https://github.com/tpope/vim-repeat' }
})

vim.pack.add({
  { src = 'https://github.com/nvim-lua/plenary.nvim' }
})

vim.pack.add({
  { src = 'https://github.com/mikavilpas/yazi.nvim' }
})
vim.g.loaded_netrwPlugin = 1
vim.api.nvim_create_autocmd('UiEnter', {
  callback = function()
    require('yazi').setup({
      open_for_directories = true,
      yazi_floating_window_border = require('config.ui').borders
    })
    vim.keymap.set('n', '<Leader>y', '<Cmd>Yazi<CR>', { desc = 'Open yazi at the current file' })
    vim.keymap.set('n', '<Leader>yw', '<Cmd>Yazi cwd<CR>', { desc = "Open the file manager in nvim's working directory" })
    vim.keymap.set('n', ',ty', '<Cmd>Yazi toggle<CR>', { desc = 'Resume the last yazi session' })
  end
})

vim.pack.add({
  { src = 'https://github.com/benoror/gpg.nvim' }
})

vim.pack.add({
  { src = 'https://github.com/fei6409/log-highlight.nvim' }
})
