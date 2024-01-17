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
  -- {{{2 nougat.nvim
  {
    'MunifTanjim/nougat.nvim',
    event = 'VeryLazy',
    config = function()
      local nougat = require('nougat')
      local core = require('nougat.core')
      local Bar = require('nougat.bar')
      local Item = require('nougat.item')
      local sep = require('nougat.separator')
      local devicons = require('nvim-web-devicons')

      local nut = {
        buf = {
          diagnostic_count = require('nougat.nut.buf.diagnostic_count').create,
          filename = require('nougat.nut.buf.filename').create,
          filestatus = require('nougat.nut.buf.filestatus').create,
          filetype = require('nougat.nut.buf.filetype').create,
          filetype_icon = require('nougat.nut.buf.filetype_icon').create,
          lsp = require('nougat.nut.lsp.servers').create,
          wordcount = require('nougat.nut.buf.wordcount').create
        },
        git = {
          branch = require('nougat.nut.git.branch').create,
          status = require('nougat.nut.git.status')
        },
        tab = {
          tablist = {
            tabs = require('nougat.nut.tab.tablist').create,
            close = require('nougat.nut.tab.tablist.close').create,
            icon = require('nougat.nut.tab.tablist.icon').create,
            label = require('nougat.nut.tab.tablist.label').create,
            modified = require('nougat.nut.tab.tablist.modified').create
          },
        },
        mode = require('nougat.nut.mode').create,
        spacer = require('nougat.nut.spacer').create,
        truncation_point = require('nougat.nut.truncation_point').create
      }

      local color = require('nougat.color').get()

      local mode = nut.mode({
        prefix = ' ',
        suffix = ' ',
      })

      local stl = Bar('statusline')
      stl:add_item(mode)
      stl:add_item(Item({
        hl = { fg = color.blue, bg = color.bg1 },
        prefix = ' ',
        content = core.group({
          core.code('l'),
          ':',
          core.code('c'),
        }),
        suffix = ' '
      }))
      stl:add_item(Item({
        hl = { fg = color.bg, bg = color.blue },
        prefix = ' ',
        content = core.code('P'),
        suffix = ' '
      }))
      local filename = stl:add_item(nut.buf.filename({
        hl = { fg = color.fg, bg = color.bg1 },
        prefix = ' ',
        suffix = ' ',
        on_click = function()
          vim.cmd('Vifm')
          vim.defer_fn(function() vim.cmd('startinsert') end, 300)
        end
      }))
      local filestatus = stl:add_item(nut.buf.filestatus({
        hl = { fg = color.red, bg = color.bg1 },
        suffix = ' ',
        config = {
          modified = '●',
          nomodifiable = '󰅖',
          readonly = '',
          sep = ' ',
        },
      }))
      stl:add_item(nut.spacer())
      stl:add_item(nut.truncation_point())
      stl:add_item(nut.buf.diagnostic_count({
        prefix = ' ',
        suffix = ' ',
        config = {
          error = { prefix = require('config.ui').icons.diagnostics[1] },
          warn = { prefix = require('config.ui').icons.diagnostics[2] },
          info = { prefix = require('config.ui').icons.diagnostics[3] },
          hint = { prefix = require('config.ui').icons.diagnostics[4] },
        },
        on_click = function()
          vim.cmd('FzfLua diagnostics_document')
          vim.defer_fn(function() vim.cmd('startinsert') end, 300)
        end
      }))
      stl:add_item(nut.buf.lsp({
        config = {},
        prefix = '  ',
        suffix = ' ',
        hl = { fg = color.green },
        on_click = function()
          vim.cmd('LspInfo')
        end,
      }))
      stl:add_item(nut.git.branch({
        hl = { bg = color.magenta, fg = color.bg },
        prefix = '  ',
        suffix = ' ',
        on_click = function()
          vim.cmd('Lazygit')
          vim.defer_fn(function() vim.cmd('startinsert') end, 300)
        end
      }))
      stl:add_item(nut.git.status.create({
        content = {
          nut.git.status.count('added', {
            hl = { fg = color.green },
            prefix = ' +',
            suffix = ' ',
            on_click = function()
              vim.cmd('Lazygit')
              vim.defer_fn(function() vim.cmd('startinsert') end, 300)
            end
          }),
          nut.git.status.count('changed', {
            hl = { fg = color.blue },
            prefix = ' ~',
            suffix = ' ',
            on_click = function()
              vim.cmd('Lazygit')
              vim.defer_fn(function() vim.cmd('startinsert') end, 300)
            end
          }),
          nut.git.status.count('removed', {
            hl = { fg = color.red },
            prefix = ' -',
            suffix = ' ',
            on_click = function()
              vim.cmd('Lazygit')
              vim.defer_fn(function() vim.cmd('startinsert') end, 300)
            end
          }),
        },
      }))
      stl:add_item({
        prefix = ' ',
        content = {
          nut.buf.filetype_icon({ suffix = ' ' }),
          nut.buf.filetype({}),
        },
        hidden = function(_, _)
          return vim.bo.filetype == ''
        end,
        suffix = ' ',
      })

      local stl_inactive = Bar('statusline')
      stl_inactive:add_item(mode)
      stl_inactive:add_item(filename)
      stl_inactive:add_item(filestatus)
      stl_inactive:add_item(nut.spacer())

      nougat.set_statusline(function(ctx)
        return ctx.is_focused and stl or stl_inactive
      end)

      local tal = Bar('tabline')
      tal:add_item(nut.tab.tablist.tabs({
        active_tab = {
          hl = { fg = color.fg, bg = color.bg1 },
          prefix = ' ',
          suffix = ' ',
          content = {
            nut.tab.tablist.icon({ suffix = ' ' }),
            nut.tab.tablist.label({}),
            nut.tab.tablist.modified({ prefix = ' ', config = { text = '●' } }),
            nut.tab.tablist.close({ prefix = ' ', config = { text = '󰅖' } }),
          },
          hidden = function(_, _)
            return vim.bo.filetype == ''
          end
        },
        inactive_tab = {
          hl = { fg = color.fg3, bg = color.bg3 },
          prefix = ' ',
          suffix = ' ',
          content = {
            nut.tab.tablist.icon({ suffix = ' ' }),
            nut.tab.tablist.label({}),
            nut.tab.tablist.modified({ prefix = ' ', config = { text = '●' } }),
            nut.tab.tablist.close({ prefix = ' ', config = { text = '󰅖' } }),
          },
          hidden = function(_, _)
            return vim.bo.filetype == ''
          end
        }
      }))
      nougat.set_tabline(tal)
    end
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
