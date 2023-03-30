return {
  -- {{{2 lush
  'rktjmp/lush.nvim',
  'rktjmp/shipwright.nvim',
  -- }}}2
  -- {{{2 vim-artesanal
  {
    'wimstefan/vim-artesanal',
    event = 'VeryLazy',
    config = function()
      vim.g.artesanal_dimmed = false
      vim.g.artesanal_transparent = true
    end
  },
  -- }}}2
  -- {{{2 tokyonight
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
  -- }}}2
  -- {{{2 nightfox
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
  -- }}}2
  -- {{{2 catppuccin
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        comments = { 'italic' },
        functions = { 'bold' }
      },
      color_overrides = {
        frappe = {
          rosewater = '#f2d5cf',
          flamingo = '#eebebe',
          pink = '#f4b8e4',
          mauve = '#ca9ee6',
          red = '#e78284',
          maroon = '#ea999c',
          peach = '#ef9f76',
          yellow = '#e5c890',
          green = '#35b5b5',
          teal = '#62b1d9',
          sky = '#99d1db',
          sapphire = '#85c1dc',
          blue = '#8caaee',
          lavender = '#babbf1',
          text = '#c6d0f5',
          subtext1 = '#b5bfe2',
          subtext0 = '#a5adce',
          overlay2 = '#949cbb',
          overlay1 = '#838ba7',
          overlay0 = '#737994',
          surface2 = '#626880',
          surface1 = '#51576d',
          surface0 = '#414559',
          base = '#303446',
          mantle = '#292c3c',
          crust = '#232634',
        },
        latte = {
          rosewater = '#e19f91',
          flamingo = '#de8080',
          pink = '#e974ca',
          mauve = '#a860d6',
          red = '#bb2427',
          maroon = '#dd585d',
          peach = '#e76e30',
          yellow = '#e39909',
          green = '#298c8c',
          teal = '#5193b4',
          sky = '#6ebdcc',
          sapphire = '#57aacf',
          blue = '#3f5ca0',
          lavender = '#898be7',
          text = '#414559',
          subtext1 = '#51576d',
          subtext0 = '#626880',
          overlay2 = '#737994',
          overlay1 = '#838ba7',
          overlay0 = '#949cbb',
          surface2 = '#a5adce',
          surface1 = '#b5bfe2',
          surface0 = '#c6d0f5',
          base = '#f8f9fe',
          mantle = '#f0f0fa',
          crust = '#ebebfa'
        }
      }
    }
  },
  -- }}}2
  -- {{{2 rose-pine
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
  -- }}}2
  -- {{{2 zenbones
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
  -- }}}2
  -- {{{2 nvim-base16
  {
    'RRethy/nvim-base16',
    event = 'VeryLazy'
  }
  -- }}}2
}
-- vim: foldmethod=marker foldlevel=1
