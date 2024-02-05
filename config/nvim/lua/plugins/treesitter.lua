return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'BufReadPre',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-refactor',
      'windwp/nvim-ts-autotag',
      {
        'HiPhish/rainbow-delimiters.nvim',
        event = 'VeryLazy',
        config = function()
          vim.g.rainbow_delimiters = {
            strategy = {
              [''] = require('rainbow-delimiters').strategy['global']
            },
            query = {
              [''] = 'rainbow-delimiters',
              lua = 'rainbow-blocks'
            }
          }
        end
      }
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        auto_install = true,
        autotag = {
          enable = true
        },
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
    end
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      vim.g.skip_ts_context_commentstring_module = true
      require('ts_context_commentstring').setup({
        enable_autocmd = false
      })
    end
  }
}
-- vim: foldmethod=marker foldlevel=1
