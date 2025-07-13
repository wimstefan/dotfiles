return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'BufReadPre',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-refactor',
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'folke/ts-comments.nvim',
        opts = {},
        enabled = vim.fn.has('nvim-0.10.0') == 1,
      },
      {
        'windwp/nvim-ts-autotag',
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
      },
      {
        'OXY2DEV/markview.nvim',
        ft = 'markdown',
        priority = 1000,
        keys = {
          { ',tm', function() require('markview').commands.toggle() end, desc = 'Markview: toggle' },
        },
        opts = function()
          require('markview').setup({
            preview = {
              modes = { 'n', 'I' },
              hybrid_modes = { 'i' }
            },
            markdown = {
              list_items = {
                indent_size = 2,
                shift_width = 2,
                marker_minus = {
                  add_padding = false,
                  text = '',
                  hl = 'MarkviewListItemMinus'
                },
                marker_plus = {
                  add_padding = false,
                  text = '',
                  hl = 'MarkviewListItemPlus'
                },
                marker_star = {
                  add_padding = true,
                  text = '',
                  hl = 'MarkviewListItemStar'
                }
              }
            }
          })
        end
      }
    },
    config = function()
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
    end
  }
}
