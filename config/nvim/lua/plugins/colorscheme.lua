return {
  'rktjmp/lush.nvim',
  'rktjmp/shipwright.nvim',
  {
    'wimstefan/vim-artesanal',
    event = 'VeryLazy',
    config = function()
      vim.g.artesanal_dimmed = false
      vim.g.artesanal_transparent = true
    end
  },
  {
    'folke/tokyonight.nvim',
    event = 'VeryLazy',
    opts = function()
      return {
        style = 'moon',
        light_style = 'day',
        transparent = true,
        styles = {
          comments = { italic = true },
          keywords = {},
          functions = { italic = true },
          variables = {},
          sidebars = 'transparent',
          floats = 'dark'
        },
        on_colors = function(colours)
          colours.green = '#50b498'
          colours.yellow = '#ffb450'
        end,
      }
    end
  },
  {
    'EdenEast/nightfox.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        transparent = true,
        dim_inactive = false,
        terminal_colors = true,
        styles = {
          comments = 'italic',
          functions = 'italic',
          keywords = 'bold',
          strings = 'NONE',
          variables = 'NONE',
        },
        inverse = {
          match_paren = true,
          visual = false,
          search = true,
        }
      },
      groups = {
        all = {
          Folded = { bg = 'NONE' }
        }
      }
    }
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    event = 'VeryLazy',
    opts = {
      styles = {
        comments = { 'italic' },
        functions = { 'bold' }
      }
    }
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    event = 'VeryLazy',
    opts = {
      dark_variant = 'moon',
      disable_background = true,
      disable_float_background = false,
      bold_vert_split = true,
      groups = {},
      highlight_groups = {}
    }
  },
  {
    'mcchrish/zenbones.nvim',
    event = 'VeryLazy',
    config = function()
      local flavours = { 'zenbones', 'zenwritten', 'neobones', 'nordbones', 'seoulbones', 'tokyobones' }
      for _, flavour in ipairs(flavours) do
        vim.g[flavour] = {
          lightness = 'bright',
          darkness = 'stark',
          darken_comments = 30,
          lighten_comments = 30,
          solid_float_border = true,
          colorize_diagnostic_underline_text = true,
          transparent_background = true
        }
      end
    end
  },
  {
    'RRethy/nvim-base16',
    event = 'VeryLazy'
  }
}
