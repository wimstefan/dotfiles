return {
  {
    'xzbdmw/colorful-menu.nvim',
    opts = {}
  },
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = '*',
    opts = {
      keymap = {
        preset = 'super-tab'
      },
      appearance = {
        nerd_font_variant = 'normal'
      },
      completion = {
        menu = {
          border = require('config.ui').borders,
          draw = {
            columns = { { 'kind_icon' }, { 'label', gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require('colorful-menu').blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require('colorful-menu').blink_components_highlight(ctx)
                end,
              }
            }
          }
        },
        documentation = {
          auto_show = true,
          window = {
            border = require('config.ui').borders
          }
        },
      },
      signature = {
        window = {
          border = require('config.ui').borders
        }
      },
      sources = {
        default = { 'cmdline', 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'omni' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100
          }
        }
      }
    },
    opts_extend = { 'sources.default' }
  }
}
