return {
  {
    'wimstefan/vim-artesanal',
    event = { 'ColorScheme', 'UiEnter' },
    config = function()
      vim.g.artesanal_dimmed = false
      vim.g.artesanal_transparent = true
    end
  },
  {
    'folke/tokyonight.nvim',
    event = { 'ColorScheme', 'UiEnter' },
    opts = function()
      return {
        style = 'night',
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
        plugins = {
          all = package.loaded.lazy == nil,
          auto = true
        }
      }
    end
  },
  {
    'scottmckendry/cyberdream.nvim',
    event = { 'ColorScheme', 'UiEnter' },
    opts = {
      italic_comments = true,
      theme = {
        variant = 'auto'
      }
    }
  }
}
