--------------------- MY PERSONAL NEOVIM CONFIGURATION -------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.loader.enable()

require('config.options')
require('config.util')
require('config.autocmds')
require('config.keymaps')
require('config.statusline')
require('plugins.coding')
require('plugins.editor')
require('plugins.lsp')
require('plugins.mini')
require('plugins.misc')
require('plugins.snacks')
require('plugins.treesitter')
require('plugins.ui')
