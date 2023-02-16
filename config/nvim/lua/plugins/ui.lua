return {
  -- {{{2 notifier.nvim
  {
    'vigoux/notifier.nvim',
    lazy = false,
    keys = {
      { '<Leader>n', vim.cmd.NotifierReplay, desc = 'Notifications' }
    },
    config = true
  },
  -- }}}2
  -- {{{2 nvim-ufo
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'BufReadPost',
    keys = {
      { '[z', function() require('ufo').goPreviousClosedFold() end, desc = 'Ufo: go to previous closed fold' },
      { ']z', function() require('ufo').goNextClosedFold() end, desc = 'Ufo: go to next closed fold' },
      { 'zR', function() require('ufo').openAllFolds() end, desc = 'Ufo: open all folds' },
      { 'zM', function() require('ufo').closeAllFolds() end, desc = 'Ufo: close all folds' },
      { 'zr', function() require('ufo').openFoldsExceptKinds() end, desc = 'Ufo: open folds except kinds' },
      { 'zm', function() require('ufo').closeFoldsWith() end, desc = 'Ufo: close folds' },
      { 'zp',
        function()
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = 'Ufo: preview'
      }
    },
    config = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldcolumn = 'auto:1'
      vim.opt.fillchars:append({
        foldsep = '🮍',
        foldopen = '',
        foldclose = ''
      })

      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' ··· %d lines ···'):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end

      require('ufo').setup({
        fold_virt_text_handler = handler,
        preview = {
          win_config = {
            winhighlight = 'Normal:Folded',
            winblend = 0
          },
          mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>'
          }
        }
      })
    end
  },
  -- }}}2
  -- {{{2 which-key.nvim
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup({
        window = {
          border = require('config.ui').borders,
          margin = { 0, 0, 2, 0 },
          padding = { 2, 2, 2, 2 }
        },
        plugins = {
          spelling = {
            enabled = true,
            suggestions = 40
          }
        }
      })
    end
  },
  -- }}}2
  -- {{{2 indent-blankline.nvim
  {
    'lukas-reineke/indent-blankline.nvim',
    keys = {
      { ',ti', vim.cmd.IndentBlanklineToggle, desc = 'IndentBlankline: toggle' }
    },
    config = function()
      require('indent_blankline').setup({
        char = '▏',
        filetype_exclude = {
          'help',
          'man',
          'diagnosticpopup',
          'lspinfo',
          '',
        },
        disable_with_nolist = true,
        use_treesitter = true,
        show_current_context = true,
        show_current_context_start = true,
        show_current_context_start_on_current_line = true,
        context_patterns = {
          'class',
          'function',
          'method',
          '^if',
          '^while',
          '^for',
          '^object',
          '^table',
          'block',
          'arguments',
          'element'
        }
      })
    end
  },
  -- }}}2
  -- {{{2 nvim-web-devicons
  {
    'nvim-tree/nvim-web-devicons',
    config = true
  },
  -- }}}2
  -- {{{2 nvim-nonicons
  {
    'yamatsum/nvim-nonicons',
    config = true
  },
  -- }}}2
  -- {{{2 lush.nvim
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
  -- {{{2 tokyonight.nvim
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
  -- {{{2 nightfox.nvim
  {
    'EdenEast/nightfox.nvim',
    event = 'VeryLazy',
    config = function()
      require('nightfox').setup({
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
      })
    end
  },
  -- }}}2
  -- {{{2 rose-pine
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    event = 'VeryLazy',
    config = function()
      require('rose-pine').setup({
        dark_variant = 'moon',
        disable_background = true,
        disable_float_background = false,
        bold_vert_split = true,
        groups = {},
        highlight_groups = {}
      })
    end
  },
  -- }}}2
  -- {{{2 zenbones.nvim
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
  },
  -- }}}2
  -- {{{2 ccc.nvim
  {
    'uga-rosa/ccc.nvim',
    event = 'BufReadPost',
    keys = {
      { ',ct', vim.cmd.CccHighlighterToggle, desc = 'Ccc: toggle highlights' },
      { ',cp', vim.cmd.CccPick, desc = 'Ccc: edit color' }
    },
    config = function()
      require('ccc').setup({
        highlighter = {
          auto_enable = true
        }
      })
    end
  }
  -- }}}2
}
-- vim: foldmethod=marker foldlevel=1
