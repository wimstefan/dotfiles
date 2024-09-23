local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
  defaults = {
    lazy = true
  },
  spec = {
    import = 'plugins'
  },
  git = {
    timeout = 24
  },
  ui = {
    border = require('config.ui').borders,
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
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'tohtml',
        'tutor'
      }
    }
  }
})
require('lazy.view.config').keys.profile_filter = '<C-p>'
