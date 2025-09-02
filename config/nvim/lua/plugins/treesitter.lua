vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' }
})
require('nvim-treesitter.configs').setup({
  ensure_installed = {},
  sync_install = true,
  auto_install = true,
  ignore_install = {},
  modules = {},
  highlight = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = 'v',
      node_decremental = 'V',
    }
  },
  indent = {
    enable = true
  },
  refactor = {
    highlight_current_scope = {
      enable = false
    },
    highlight_definitions = {
      enable = true
    },
    navigation = {
      enable = true
    },
    smart_rename = {
      enable = true
    }
  }
})

vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-refactor' }
})

vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' }
})

vim.pack.add({
  { src = 'https://github.com/folke/ts-comments.nvim' }
})

vim.pack.add({
  { src = 'https://github.com/windwp/nvim-ts-autotag' }
})
require('nvim-ts-autotag').setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false
  }
})

vim.pack.add({
  { src = 'https://github.com/HiPhish/rainbow-delimiters.nvim' }
})
require('rainbow-delimiters.setup').setup({
  strategy = {
    [''] = require('rainbow-delimiters').strategy['global']
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks'
  }
})

