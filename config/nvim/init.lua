--------------------- MY PERSONAL NEOVIM CONFIGURATION -------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('config.lazy')
require('config.options')
require('config.util')
require('config.autocmds')
require('config.keymaps')

Prettify()
