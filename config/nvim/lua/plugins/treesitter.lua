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
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack', { clear = true }),
  callback = function(args)
    local spec = args.data.spec
    local cwd_path = args.data.path
    vim.notify('Installation path:' .. cwd_path, vim.log.levels.INFO)
    if spec and spec.name == 'nvim-treesitter' and args.data.kind == 'update' then
      vim.schedule(function()
        require('nvim-treesitter').update()
      end)
    end
  end
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

