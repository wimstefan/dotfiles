return {
  {
    'wimstefan/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup({
        padding = true
      })
    end
  },
  {
    'yamatsum/nvim-nonicons',
    config = function()
      require('nvim-nonicons').setup()
    end
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPre',
    init = function()
      vim.keymap.set('n', ',ti', vim.cmd.IndentBlanklineToggle)
    end,
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
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'BufReadPost',
    init = function()
      vim.keymap.set('n', '[z', require('ufo').goPreviousClosedFold, { desc = 'ufo: go to previous closed fold' })
      vim.keymap.set('n', ']z', require('ufo').goNextClosedFold, { desc = 'ufo: go to next closed fold' })
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'ufo: open all folds' })
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'ufo: close all folds' })
      vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = 'ufo: open folds except kinds' })
      vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = 'ufo: close folds' })
      vim.keymap.set('n', 'zp', function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = 'ufo: preview' })
    end,
    config = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldcolumn = 'auto:5'
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
            border = 'double',
            winhighlight = 'Normal:Folded',
            winblend = 0
          },
          mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>'
          }
        },
        ---@diagnostic disable-next-line: unused-local
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end
      })
      local bufnr = vim.api.nvim_get_current_buf()
      require('ufo').setFoldVirtTextHandler(bufnr, handler)
    end
  },
  -- }}}
  {
    'folke/which-key.nvim',
    event = 'BufReadPre',
    config = function()
      require('which-key').setup({
        window = {
          border = My_Borders,
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
  'rktjmp/lush.nvim',
  'rktjmp/shipwright.nvim',
  {
    'wimstefan/vim-artesanal',
    lazy = false,
    config = function()
      vim.g.artesanal_dimmed = false
      vim.g.artesanal_transparent = true
    end
  },
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
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
  {
    'mcchrish/zenbones.nvim',
    lazy = false,
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
    lazy = false,
  },
  {
    'uga-rosa/ccc.nvim',
    event = 'BufReadPre',
    init = function()
      vim.keymap.set('n', ',ct', vim.cmd.CccHighlighterToggle)
      vim.keymap.set('n', ',cp', vim.cmd.CccPick)
    end,
    config = function()
      require('ccc').setup({
        highlighter = {
          auto_enable = true
        }
      })
    end
  },
  {
    'vigoux/notifier.nvim',
    event = 'BufReadPre',
    init = function()
      vim.keymap.set('n', '<Leader>n', vim.cmd.NotifierReplay, { desc = 'Notifications' })
    end,
    config = function()
      require('notifier').setup()
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    config = function()
      local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
        return function(str)
          local win_width = vim.fn.winwidth(0)
          if hide_width and win_width < hide_width then return ''
          elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
            return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
          end
          return str
        end
      end

      local get_modified = function()
        return '%m' or ''
      end
      local get_readonly = function()
        if not vim.bo.readonly then
          return ''
        end
        return '[RO]'
      end
      local get_session = function()
        if not vim.g.loaded_obsession then
          return ''
        end
        return '%{ObsessionStatus("\\\\o/", "_o_")}'
      end
      local get_spell = function()
        if not vim.wo.spell then
          return ''
        end
        return '[SP]'
      end
      local get_path = function()
        return '[' .. vim.fn.expand('%:p:h') .. ']'
      end
      local lsp_status = function()
        local msg = ''
        if #vim.lsp.get_active_clients() > 0 then
          msg = '[LSP]'
        end
        for _, client in ipairs(vim.lsp.get_active_clients()) do
          msg = msg .. '‹' .. client.name .. '›'
        end
        return msg
      end
      local diff_source = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
        end
      end
      local window = function()
        return vim.api.nvim_win_get_number(0)
      end
      local minimal_extension = {
        sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = { 'location', 'progress' },
          lualine_z = { 'filetype' },
        },
        filetypes = { 'help', 'qf' }
      }

      require('lualine').setup({
        options = {
          icons_enabled = true,
          globalstatus = true,
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'location', 'progress' },
          lualine_c = {
            {
              'filename',
              file_status = false
            },
            {
              get_readonly,
              padding = 0,
              color = { fg = 'grey' },
            },
            {
              get_modified,
              padding = 0,
              color = { fg = 'red' },
            },
            {
              get_spell,
              padding = 1,
              color = { fg = 'brown' },
            },
            {
              get_session,
              padding = 1,
              color = { fg = 'brown' },
            },
          },
          lualine_x = {
            {
              lsp_status,
              fmt = trunc(80, 40, 100),
              on_click = function()
                vim.cmd('LspInfo')
              end
            },
            {
              'diagnostics',
              always_visible = false,
              sources = { 'nvim_diagnostic' },
              symbols = {
                error = vim.fn.sign_getdefined('DiagnosticSignError')[1].text .. ' ',
                warn = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text .. ' ',
                info = vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text .. ' ',
                hint = vim.fn.sign_getdefined('DiagnosticSignHint')[1].text .. ' '
              },
              on_click = function()
                vim.diagnostic.setqflist()
              end
            },
          },
          lualine_y = {
            {
              'diff',
              source = diff_source,
              diff_color = { added = 'GitSignsAdd', modified = 'GitSignsChange', removed = 'GitSignsDelete' },
              -- symbols = { added = '洛 ', modified = '  ', removed = '  ' },
              -- symbols = { added = 'ﰂ  ', modified = '  ', removed = 'ﯰ  ' },
              symbols = { added = '落 ', modified = '  ', removed = '  ' },
              on_click = function()
                vim.cmd('Lazygit')
                vim.defer_fn(function() vim.cmd('startinsert') end, 300)
              end
            },
            {
              'branch',
              icon = require('nvim-nonicons').get('git-branch'),
              on_click = function()
                vim.cmd('Lazygit')
                vim.defer_fn(function() vim.cmd('startinsert') end, 300)
              end
            }
          },
          lualine_z = { 'filetype' },
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = { 'location' },
          lualine_z = { 'filetype' },
        },
        tabline = {
          lualine_a = { window },
          lualine_b = {
            {
              get_path,
              on_click = function()
                vim.cmd('Vifm')
                vim.defer_fn(function() vim.cmd('startinsert') end, 300)
              end
            }
          },
          lualine_c = { 'buffers' },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            {
              'tabs',
              mode = 2
            }
          }
        },
        extensions = { 'fugitive', 'fzf', 'man', minimal_extension, 'quickfix', 'symbols-outline', 'toggleterm' },
      })
      require('lualine').refresh()
      Prettify()
    end
  },
}
-- vim: foldmethod=marker foldlevel=0
