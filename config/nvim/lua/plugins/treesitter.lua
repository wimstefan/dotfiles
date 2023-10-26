return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-refactor',
      'windwp/nvim-ts-autotag',
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        config = function()
          require('ts_context_commentstring').setup({
            enable = true,
            enable_autocmd = false
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
        autotag = {
          enable = true
        },
        highlight = {
          enable = true
        },
        incremental_selection = {
          enable = false
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
