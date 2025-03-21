return {
  {
    'folke/lazydev.nvim',
    event = 'VeryLazy',
    opts = {}
  },
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    config = function()

      -- Diagnostic
      vim.keymap.set('n', ',dt', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = 'Diagnostic: toggle' })
      vim.keymap.set('n', ',dd', function() Snacks.picker.diagnostics_buffer() end, { desc = 'Diagnostic: document diagnostics' })
      vim.keymap.set('n', ',dD', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostic: workspace diagnostics' })
      vim.keymap.set('n', ',df', vim.diagnostic.open_float, { desc = 'Diagnostic: open floating window' })
      vim.keymap.set('n', ',dl', vim.diagnostic.setloclist, { desc = 'Diagnostic: populate location list' })
      vim.keymap.set('n', ',dq', vim.diagnostic.setqflist, { desc = 'Diagnostic: populate quickfix' })
      vim.keymap.set('n', ',dL', function()
        local new_config = not vim.diagnostic.config().virtual_lines
        vim.diagnostic.config({ virtual_lines = new_config })
      end, { desc = 'Diagnostic: toggle virtual_lines' })

      vim.diagnostic.config({
        float = {
          focusable = false,
          header = '',
          scope = 'line',
          source = 'always'
        },
        signs = {
          text = {
            [1] = require('config.ui').icons.diagnostics[1],
            [2] = require('config.ui').icons.diagnostics[2],
            [3] = require('config.ui').icons.diagnostics[3],
            [4] = require('config.ui').icons.diagnostics[4],
            [5] = require('config.ui').icons.diagnostics[5]
          }
        },
        virtual_lines = {
          enabled = true,
          virt_lines_overflow = 'scroll'
        }
      })

      -- LSP config
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(event)
          local unpack = unpack or table.unpack
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local lsp_messages = ''
          local lsp_msg_sep = ' ∷ '
          lsp_messages = lsp_msg_sep .. 'LSP attached' .. lsp_msg_sep
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[event.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

          -- Buffer local mappings.
          local opts = { buffer = event.buf }
          vim.keymap.del('n', 'K', opts)
          vim.keymap.set('n', ',lI', vim.cmd.LspInfo,
            { desc = 'LSP: info' }, opts)
          vim.keymap.set('n', ',lrs', vim.cmd.LspRestart,
            { desc = 'LSP: restart' }, opts)
          vim.keymap.set('n', ',lr', function() Snacks.picker.lsp_references() end,
            { desc = 'LSP: references' }, opts)
          vim.keymap.set('n', ',ly', function() Snacks.picker.lsp_symbols() end,
            { desc = 'LSP: document symbols' }, opts)
          vim.keymap.set('n', ',lY', function() Snacks.picker.lsp_workspace_symbols() end,
            { desc = 'LSP: workspace symbols' }, opts)
          vim.keymap.set('n', ',ld', function() Snacks.picker.lsp_definitions() end,
            { desc = 'LSP: definitions' }, opts)
          vim.keymap.set('n', ',lt', function() Snacks.picker.lsp_type_definitions() end,
            { desc = 'LSP: type definitions' }, opts)
          vim.keymap.set('n', ',lD', function() Snacks.picker.lsp_declarations() end,
            { desc = 'LSP: declarations' }, opts)
          vim.keymap.set('n', ',lrn', function() vim.lsp.buf.rename() end,
            { desc = 'LSP: rename' }, opts)
          vim.keymap.set('n', ',lw', function() Dump(vim.lsp.buf.list_workspace_folders()) end,
            { desc = 'LSP: list workspace folders' }, opts)
          if client:supports_method('textDocument/codeAction', event.buf) then
            vim.keymap.set('n', ',lca', function() vim.lsp.buf.code_action() end,
              { desc = 'LSP: code actions' }, opts)
          else
            lsp_messages = lsp_messages .. 'no codeAction' .. lsp_msg_sep
          end
          if client:supports_method('textDocument/foldingRange', event.buf) then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldmethod = 'expr'
            vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
          else
            lsp_messages = lsp_messages .. 'no folding' .. lsp_msg_sep
          end
          if client:supports_method('textDocument/formatting', event.buf) then
            local fmt_opts = vim.bo[event.buf].ft == 'lua'
              and 'async=true,bufnr=0,name="lua_ls"'
              or 'async=true,bufnr=0'
            vim.keymap.set('n', ',lf', function() vim.lsp.buf.format(fmt_opts) end,
              { desc = 'LSP: formatting' }, opts)
          else
            lsp_messages = lsp_messages .. 'no format' .. lsp_msg_sep
          end
          if client:supports_method('textDocument/rangeFormatting', event.buf) then
            vim.keymap.set('v', ',lf',
              function()
                local _, csrow, cscol, cerow, cecol
                local mode = vim.fn.mode()
                assert(mode == 'v' or mode == 'V' or mode == '')
                _, csrow, cscol, _ = unpack(vim.fn.getpos('.'))
                _, cerow, cecol, _ = unpack(vim.fn.getpos('v'))
                if mode == 'V' then
                  cscol, cecol = 0, 999
                end
                local fmt_opts = {
                  async   = true,
                  bufnr   = 0,
                  name    = vim.bo[event.buf].ft == 'lua' and 'lua_ls' or nil,
                  start   = { csrow, cscol },
                  ['end'] = { cerow, cecol },
                }
                vim.lsp.buf.format(fmt_opts)
              end,
              { desc = 'LSP: range formatting' }, opts)
          else
            lsp_messages = lsp_messages .. 'no rangeFormat' .. lsp_msg_sep
          end
          if client:supports_method('textDocument/hover', event.buf) then
            vim.keymap.set('n', ',lh', function() vim.lsp.buf.hover() end,
              { desc = 'LSP: hover' }, opts)
          else
            vim.keymap.set('n', ',lh', [[<Nop>]], opts)
            lsp_messages = lsp_messages .. 'no hovering' .. lsp_msg_sep
          end
          if client:supports_method('textDocument/implementation', event.buf) then
            vim.keymap.set('n', ',li', function() Snacks.picker.lsp_implementations() end,
              { desc = 'LSP: implementations' }, opts)
          else
            vim.keymap.set('n', ',li', [[<Nop>]], opts)
            lsp_messages = lsp_messages .. 'no implementation' .. lsp_msg_sep
          end
          if client:supports_method('textDocument/inlayHint', event.buf) then
            vim.keymap.set('n', ',lH', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
              { desc = 'LSP: hints' }, opts)
          else
            vim.keymap.set('n', ',lH', [[<Nop>]], opts)
            lsp_messages = lsp_messages .. 'no hints' .. lsp_msg_sep
          end
          if client:supports_method('textDocument/signatureHelp', event.buf) then
            vim.keymap.set({ 'i', 's' }, '<C-s>',
              function() vim.lsp.buf.signature_help() end,
              { desc = 'LSP: signature help' }, opts)
            vim.keymap.set('n', ',ls',
              function() vim.lsp.buf.signature_help() end,
              { desc = 'LSP: signature help' }, opts)
          else
            vim.keymap.set('n', ',ls', [[<Nop>]], opts)
            lsp_messages = lsp_messages .. 'no signatureHelp' .. lsp_msg_sep
          end

          -- messages
          vim.notify(lsp_messages, vim.log.levels.INFO, { title = '[LSP]' })
        end
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }

      -- LSP servers
      local servers = {
        bashls = {
          filetypes = {
            'sh',
            'bash'
          }
        },
        cssls = {
          provideFormatter = true
        },
        html = {
          filetypes = {
            'html',
            'html-eex',
            'liquid'
          },
          settings = {
            css = {
              lint = {
                validProperties = {}
              },
            },
            html = {
              format = {
                templating = true,
                wrapLineLength = 120,
                wrapAttributes = 'auto'
              },
              hover = {
                documentation = true,
                references = true
              }
            }
          }
        },
        intelephense = {},
        jsonls = {},
        lua_ls = {
          cmd = { vim.fn.stdpath('data') .. '/lspconfig/lua-language-server/bin/lua-language-server' },
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                return
              end
            end
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT'
              },
              workspace = {
                library = {
                  lua,
                  vim.env.VIMRUNTIME,
                  '${3rd}/luv/library'
                }
              }
            })
            client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
          end,
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Both',
                keyworsSnippet = 'Both'
              },
              diagnostics = {
                neededFileStatus = {
                  ['codestyle-check'] = 'Any',
                  ['need-check-nil'] = 'None'
                },
                globals = {
                  'use',
                  'vim'
                }
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = 'space',
                  indent_size = '2',
                  continuation_indent = '2',
                  quote_style = 'single',
                  align_array_table = 'false'
                }
              },
              hint = {
                enable = true
              }
            }
          }
        },
        taplo = {},
        rust_analyzer = {},
        vimls = {}
      }
      for name, opts in pairs(servers) do
        if type(opts) == 'function' then
          opts()
        else
          local client = require('lspconfig')[name]
          client.setup(vim.tbl_extend('force', {
            on_attach = on_attach,
            capabilities = capabilities,
          }, opts))
        end
      end
    end
  },
  {
    'IsaacShelton/clear-action.nvim',
    event = 'LspAttach',
    keys = {
      { ',tc', vim.cmd.CodeActionToggleSigns, desc = 'Toggle: code actions' }
    },
    opts = {
      signs = {
        enable = true,
        silent = false,
        combine = false,
        position = 'eol',
        show_label = true,
        icons = {
          quickfix = ' ' .. require('config.ui').icons.diagnostics[6],
          refactor = ' ' .. require('config.ui').icons.diagnostics[4],
          source = ' ' .. require('config.ui').icons.diagnostics[7],
          combined = ' ' .. require('config.ui').icons.diagnostics[4]
        },
        highlights = {
          quickfix = '@markup.italic',
          refactor = '@markup.italic',
          source = '@markup.italic',
          combined = '@markup.italic',
          label = '@markup.italic'
        }
      }
    }
  },
  {
    'lewis6991/hover.nvim',
    event = 'VeryLazy',
    config = function()
      require('hover').setup({
        init = function()
          require('hover.providers.lsp')
          require('hover.providers.man')
          require('hover.providers.diagnostic')
          require('hover.providers.fold_preview')
        end,
        title = true
      })
      vim.keymap.set('n', 'H', require('hover').hover, { desc = 'hover.nvim' })
      vim.keymap.set('n', 'gH', require('hover').hover_select, { desc = 'hover.nvim (select)' })
    end
  },
  {
    'oskarrrrrrr/symbols.nvim',
    config = function()
      local r = require('symbols.recipes')
      require('symbols').setup(r.DefaultFilters, r.AsciiSymbols, {
        sidebar = {
          open_direction = 'try-right',
          preview = {
            show_always = false
          }
        }
      })
    end,
    keys = {
      { '<Leader>Y', vim.cmd.SymbolsToggle, desc = 'Symbols: toggle' },
    },
  }
}
