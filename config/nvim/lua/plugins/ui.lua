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
  -- {{{2 Statusline
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
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
              color = { fg = 'grey', bg = 'none' },
            },
            {
              get_modified,
              padding = 0,
              color = { fg = 'red', bg = 'none' },
            },
            {
              get_spell,
              padding = 1,
              color = { fg = 'brown', bg = 'none' },
            },
            {
              get_session,
              padding = 1,
              color = { fg = 'brown', bg = 'none' },
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
                error = require('config.ui').icons.diagnostics[0],
                warn = require('config.ui').icons.diagnostics[1],
                info = require('config.ui').icons.diagnostics[2],
                hint = require('config.ui').icons.diagnostics[3]
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
              symbols = {
                added = require('config.ui').icons.git.added,
                modified = require('config.ui').icons.git.modified,
                removed = require('config.ui').icons.git.removed
              },
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
      vim.defer_fn(function() Prettify() end, 0)
    end
  },
  -- }}}2
  -- {{{2 Statuscolumn
  {
    'luukvbaal/statuscol.nvim',
    event = 'VeryLazy',
    opts = function()
      return {
        relculright = true,
        setopt = true,
        order = 'FsSNs'
      }
    end,
    config = true
  },
  -- }}}
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
    'wimstefan/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup({
        padding = true
      })
    end
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
    config = function()
      vim.g.artesanal_dimmed = false
      vim.g.artesanal_transparent = true
    end
  },
  -- }}}2
  -- {{{2 tokyonight.nvim
  {
    'folke/tokyonight.nvim',
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
          floats = 'transparent'
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
  -- {{{2 zenbones.nvim
  {
    'mcchrish/zenbones.nvim',
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
  'RRethy/nvim-base16',
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
