return {
  -- {{{2 notifier.nvim
  {
    'vigoux/notifier.nvim',
    lazy = false,
    keys = {
      { '<Leader>n', vim.cmd.NotifierReplay, desc = 'Notifications' }
    },
    opts = {}
  },
  -- }}}2
  -- {{{2 dropbar.nvim
  {
    'Bekaboo/dropbar.nvim',
    event = 'VeryLazy',
    config = true,
    keys = {
      { '<Leader>d', function() require('dropbar.api').pick() end, desc = 'Dropbar: Pick mode' }
    }
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
    opts = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldcolumn = 'auto:1'
      vim.opt.foldtext = 'v:lua.vim.treesitter.foldtext()'
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
        },
        provider_selector = function(bufnr, filetype, buftype)
          local ftMap = {
            git = ''
          }
          return ftMap[filetype] or { 'treesitter', 'indent' }
        end
      })
    end
  },
  -- }}}2
  -- {{{2 which-key.nvim
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      window = {
        border = require('config.ui').borders,
        margin = { 0, 0, 2, 0 },
        padding = { 2, 2, 2, 2 }
      },
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 40
        }
      }
    }
  },
  -- }}}2
  -- {{{2 deadcolumn.nvim
  {
    'Bekaboo/deadcolumn.nvim',
    event = 'VeryLazy',
    init = function()
      vim.opt.colorcolumn = '80'
    end,
    opts = {
      blending = {
        threshold = 0.75,
        colorcode = '#f8f9fe'
      },
      warning = {
        alpha = 0.9,
        colorcode = '#e78284'
      }
    }
  },
  -- }}}2
  -- {{{2 indent-blankline.nvim
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
    keys = {
      { ',ti', vim.cmd.IBLToggle, desc = 'IndentBlankline: toggle' }
    },
    main = 'ibl',
    opts = {
      enabled = false,
      indent = {
        highlight = { 'Error', 'Character', 'Type', 'String', 'Label', 'Keyword' },
        char = '▏'
      }
    }
  },
  -- }}}2
  -- {{{2 vim-web-devicons
  {
    'nvim-tree/nvim-web-devicons',
    dependencies = {
      'lifepillar/vim-colortemplate',
      lazy = false
    },
    opts = {}
  },
  -- }}}2
  -- {{{2 nvim-nonicons
  {
    'yamatsum/nvim-nonicons',
    opts = {}
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
    opts = {
      highlighter = {
        auto_enable = true
      }
    }
  }
  -- }}}2
}
-- vim: foldmethod=marker foldlevel=1
