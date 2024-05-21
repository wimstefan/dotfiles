return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'BufReadPre',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-refactor',
      {
        'folke/ts-comments.nvim',
        opts = {},
        event = 'VeryLazy',
        enabled = vim.fn.has('nvim-0.10.0') == 1,
      },
      {
        'windwp/nvim-ts-autotag',
        event = 'VeryLazy',
        config = function()
          require('nvim-ts-autotag').setup({
            opts = {
              enable_close = true,
              enable_rename = true,
              enable_close_on_slash = false
            }
          })
        end
      },
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
  }
}
-- vim: foldmethod=marker foldlevel=1
