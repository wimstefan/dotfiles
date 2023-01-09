--------------------- MY PERSONAL NEOVIM CONFIGURATION -------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
  spec = {
    import = 'plugins'
  },
  defaults = {
    lazy = true
  },
  ui = {
    border = My_Borders,
    icons = {
      cmd = ' ',
      config = ' ',
      event = ' ',
      ft = ' ',
      import = ' ',
      init = ' ',
      keys = ' ',
      plugin = ' ',
      runtime = ' ',
      source = ' ',
      start = ' ',
      task = ' ',
    }
  },
  diff = {
    cmd = 'git'
  },
  checker = {
    enabled = true
  }
})
