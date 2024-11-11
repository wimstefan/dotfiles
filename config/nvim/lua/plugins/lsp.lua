return {
  {
    'folke/lazydev.nvim',
    event = 'VeryLazy',
    opts = {}
  },
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    config = function()
      require('lspconfig.ui.windows').default_options.border = require('config.ui').borders

      -- Diagnostic
      vim.keymap.set('n', ',dt', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = 'Diagnostic: toggle' })
      vim.keymap.set('n', ',df', vim.diagnostic.open_float, { desc = 'Diagnostic: open floating window' })
      vim.keymap.set('n', ',dl', vim.diagnostic.setloclist, { desc = 'Diagnostic: populate location list' })
      vim.keymap.set('n', ',dq', vim.diagnostic.setqflist, { desc = 'Diagnostic: populate quickfix' })

      vim.diagnostic.config({
        float = {
          border = require('config.ui').borders,
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
        virtual_text = {
          source = 'always'
        }
      })

      -- LSP config
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(args)
          local unpack = unpack or table.unpack
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local lsp_messages = ''
          local lsp_msg_sep = ' ∷ '
          lsp_messages = lsp_msg_sep .. 'LSP attached' .. lsp_msg_sep
          -- Enable completion triggered by <c-x><c-o>
          if vim.bo[args.buf].filetype == 'lua' then
            vim.bo[args.buf].omnifunc = 'v:lua.vim.lua_omnifunc'
          else
            vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
          end

          -- Buffer local mappings.
          local opts = { buffer = args.buf }
          vim.keymap.del('n', 'K', opts)
          vim.keymap.set('n', ',lI', vim.cmd.LspInfo,
            { desc = 'LSP: info' }, opts)
          vim.keymap.set('n', ',lrs', vim.cmd.LspRestart,
            { desc = 'LSP: restart' }, opts)
          vim.keymap.set('n', ',lF', function() require('fzf-lua').lsp_finder() end,
            { desc = 'LSP: finder' }, opts)
          vim.keymap.set('n', ',ly', require('fzf-lua').lsp_document_symbols,
            { desc = 'LSP: document symbols' }, opts)
          vim.keymap.set('n', ',lY', require('fzf-lua').lsp_live_workspace_symbols,
            { desc = 'LSP: workspace symbols' }, opts)
          vim.keymap.set('n', ',ld', require('fzf-lua').lsp_document_diagnostics,
            { desc = 'Diagnostic: document diagnostics' }, opts)
          vim.keymap.set('n', ',lD', require('fzf-lua').lsp_workspace_diagnostics,
            { desc = 'Diagnostic: workspace diagnostics' }, opts)
          vim.keymap.set('n', ',lrn', function() vim.lsp.buf.rename() end,
            { desc = 'LSP: rename' }, opts)
          vim.keymap.set('n', ',lw', function() Dump(vim.lsp.buf.list_workspace_folders()) end,
            { desc = 'LSP: list workspace folders' }, opts)
          if client.supports_method('textDocument/codeAction') then
            vim.keymap.set('n', ',lca',
              function()
                require('fzf-lua').lsp_code_actions({
                  winopts = { relative = 'cursor', height = 0.4, width = 0.8, col = 0.9, row = 1.01 }
                })
              end,
              { desc = 'LSP: code actions' }, opts)
          else
            lsp_messages = lsp_messages .. 'no codeAction' .. lsp_msg_sep
          end
          if client.supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
            vim.keymap.set({ 'i', 's' }, '<C-y>', function() return vim.fn.pumvisible() and '<C-y>' or '<CR>' end,
              { expr = true, desc = 'Completion: accept' }, opts)
            vim.keymap.set({ 'i', 's' }, '<C-e>', function() return vim.fn.pumvisible() and '<C-e>' or '/' end,
              { expr = true, desc = 'Completion: dismiss' }, opts)
            vim.keymap.set({ 'i', 's' }, '<C-n>', function()
              if vim.fn.pumvisible() then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, false, true), 'n', true)
              else
                if next(vim.lsp.get_clients { bufnr = 0 }) then
                  vim.lsp.completion.trigger()
                else
                  if vim.bo.omnifunc == '' then
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-x><C-n>', true, false, true), 'n', true)
                  else
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true), 'n', true)
                  end
                end
              end
            end, { desc = 'Completion: next' }, opts)
            vim.keymap.set({ 'i', 's' }, '<Tab>', function()
              if vim.fn.pumvisible() then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, false, true), 'n', true)
              elseif vim.snippet.active { direction = 1 } then
                vim.snippet.jump(1)
              else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', true)
              end
            end, { desc = 'Completion: next snippet or completion' }, opts)
            vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
              if vim.fn.pumvisible() then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, false, true), 'n', true)
              elseif vim.snippet.active { direction = -1 } then
                vim.snippet.jump(-1)
              else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<S-Tab>', true, false, true), 'n', true)
              end
            end, { desc = 'Completion: previous snippet or completion' }, opts)
            vim.keymap.set('s', '<BS>', '<C-o>s', { desc = 'Completion: remove snippet placeholder' }, opts)
          else
            lsp_messages = lsp_messages .. 'no completion' .. lsp_msg_sep
          end
          if client.supports_method('textDocument/formatting') then
            local fmt_opts = vim.bo[args.buf].ft == 'lua'
              and 'async=true,bufnr=0,name="lua_ls"'
              or 'async=true,bufnr=0'
            vim.keymap.set('n', ',lf', function() vim.lsp.buf.format(fmt_opts) end,
              { desc = 'LSP: formatting' }, opts)
          else
            lsp_messages = lsp_messages .. 'no format' .. lsp_msg_sep
          end
          if client.supports_method('textDocument/rangeFormatting') then
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
                  name    = vim.bo[args.buf].ft == 'lua' and 'lua_ls' or nil,
                  start   = { csrow, cscol },
                  ['end'] = { cerow, cecol },
                }
                vim.lsp.buf.format(fmt_opts)
              end,
              { desc = 'LSP: range formatting' }, opts)
          else
            lsp_messages = lsp_messages .. 'no rangeFormat' .. lsp_msg_sep
          end
          if client.supports_method('textDocument/hover') then
            vim.keymap.set('n', ',lh', vim.lsp.buf.hover,
              { desc = 'LSP: hover' }, opts)
          else
            vim.keymap.set('n', ',lh', [[<Nop>]], opts)
            lsp_messages = lsp_messages .. 'no hovering' .. lsp_msg_sep
          end
          if client.supports_method('textDocument/implementation') then
            vim.keymap.set('n', ',li', function() require('fzf-lua').lsp_implementations() end,
              { desc = 'LSP: implementations' }, opts)
          else
            vim.keymap.set('n', ',li', [[<Nop>]], opts)
            lsp_messages = lsp_messages .. 'no implementation' .. lsp_msg_sep
          end
          if client.supports_method('textDocument/inlayHint') then
            vim.keymap.set('n', ',lH', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
              { desc = 'LSP: hints' }, opts)
          else
            vim.keymap.set('n', ',lH', [[<Nop>]], opts)
            lsp_messages = lsp_messages .. 'no hints' .. lsp_msg_sep
          end
          if client.supports_method('textDocument/signatureHelp') then
            vim.keymap.set('i', '<C-s>',
              function() vim.lsp.buf.signature_help({ border = require('config.ui').borders }) end,
              { desc = 'LSP: signature help' }, opts)
            vim.keymap.set('n', ',ls',
              function() vim.lsp.buf.signature_help({ border = require('config.ui').borders }) end,
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
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
      capabilities.textDocument.completion.completionItem.snippetSupport = true

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
            local path = client.workspace_folders[1].name
            if vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
              return
            end
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT'
              },
              workspace = {
                library = { vim.env.VIMRUNTIME }
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
    keys = {
      { 'H', function() require('hover').hover() end, desc = 'hover.nvim' },
      { 'gH', function() require('hover').hover_select() end, desc = 'hover.nvim (select)' }
    },
    opts = {
      init = function()
        require('hover.providers.lsp')
        require('hover.providers.man')
        require('hover.providers.diagnostic')
        require('hover.providers.fold_preview')
      end,
      preview_opts = {
        border = require('config.ui').borders
      },
      title = true
    }
  },
  {
    'oskarrrrrrr/symbols.nvim',
    keys = {
      { '<Leader>s', vim.cmd.SymbolsToggle, desc = 'Symbols: toggle' },
    },
    opts = {
      sidebar = {
        open_direction = 'try-right'
      }
    }
  }
}
