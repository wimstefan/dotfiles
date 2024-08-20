--------------------- MY PERSONAL NEOVIM CONFIGURATION -------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.loader.enable()

require('config.lazy')
require('config.options')
require('config.util')
require('config.autocmds')
require('config.keymaps')
require('config.statusline')
