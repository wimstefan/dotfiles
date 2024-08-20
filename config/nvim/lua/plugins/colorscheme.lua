return {
  -- {{{2 vim-artesanal
  {
    'wimstefan/vim-artesanal',
    event = { 'ColorScheme', 'UiEnter' },
    config = function()
      vim.g.artesanal_dimmed = false
      vim.g.artesanal_transparent = true
    end
  },
  -- }}}2
  -- {{{2 tokyonight
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
  -- }}}2
  -- {{{2 cyberdream
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
  -- }}}2
}
-- vim: foldmethod=marker foldlevel=1
