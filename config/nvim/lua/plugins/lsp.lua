return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp'
    },
    config = function()
      require('lspconfig.ui.windows').default_options.border = My_Borders
      require('cmp_nvim_lsp').setup()
      require('neodev').setup()
      local lsp_config = require('lspconfig')

      -- LSP handlers
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
        { border = My_Borders })
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = My_Borders })

      -- LSP functions
      local on_attach = function(client, bufnr)
        local lsp_messages = ''
        local lsp_msg_sep = ' ∷ '
        lsp_messages = lsp_msg_sep .. 'LSP attached' .. lsp_msg_sep
        -- options
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        -- keybindings
        vim.keymap.set('n', ',lrs', vim.cmd.LspRestart,
          { desc = 'LSP: restart' }, { buffer = bufnr })
        vim.keymap.set('n', ',lR', require('fzf-lua').lsp_definitions,
          { desc = 'LSP: definitions' }, { buffer = bufnr })
        vim.keymap.set('n', ',lr', require('fzf-lua').lsp_references,
          { desc = 'LSP: references' }, { buffer = bufnr })
        vim.keymap.set('n', ',ly', require('fzf-lua').lsp_document_symbols,
          { desc = 'LSP: document symbols' }, { buffer = bufnr })
        vim.keymap.set('n', ',lY', require('fzf-lua').lsp_live_workspace_symbols,
          { desc = 'LSP: workspace symbols' }, { buffer = bufnr })
        vim.keymap.set('n', ',ld', require('fzf-lua').lsp_document_diagnostics,
          { desc = 'LSP: document diagnostics' }, { buffer = bufnr })
        vim.keymap.set('n', ',lD', require('fzf-lua').lsp_workspace_diagnostics,
          { desc = 'LSP: workspace diagnostics' }, { buffer = bufnr })
        vim.keymap.set('n', ',lrn',
          function()
            return ':IncRename ' .. vim.fn.expand('<cword>')
          end,
          { desc = 'LSP: rename', expr = true, replace_keycodes = false }, { buffer = bufnr })
        vim.keymap.set('n', ',lw', function() Dump(vim.lsp.buf.list_workspace_folders()) end,
          { desc = 'LSP: list workspace folders' }, { buffer = bufnr })
        if client.server_capabilities.codeActionProvider then
          vim.keymap.set('n', ',lca',
            function()
              require('fzf-lua').lsp_code_actions({
                winopts = { relative = 'cursor', height = 0.2, width = 0.4, col = 0.9, row = 1.01 }
              })
            end,
            { desc = 'LSP: code actions' }, { buffer = bufnr })
        else
          lsp_messages = lsp_messages .. 'no codeAction' .. lsp_msg_sep
        end
        if client.server_capabilities.declarationProvider then
          vim.keymap.set('n', ',lc', vim.lsp.buf.declaration,
            { desc = 'LSP: declaration' }, { buffer = bufnr })
        else
          vim.keymap.set('n', ',lc', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no declaration' .. lsp_msg_sep
        end
        if client.server_capabilities.documentFormattingProvider then
          local fmt_opts = vim.bo[bufnr].ft == 'lua'
            and 'async=true,bufnr=0,name="sumneko_lua"'
            or 'async=true,bufnr=0'
          vim.keymap.set('n', ',lf', function() vim.lsp.buf.format(fmt_opts) end,
            { desc = 'LSP: formatting' }, { buffer = bufnr })
        else
          lsp_messages = lsp_messages .. 'no format' .. lsp_msg_sep
        end
        if client.server_capabilities.documentRangeFormattingProvider then
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
                name    = vim.bo[bufnr].ft == 'lua' and 'sumneko_lua' or nil,
                start   = { csrow, cscol },
                ['end'] = { cerow, cecol },
              }
              vim.lsp.buf.format(fmt_opts)
            end,
            { desc = 'LSP: range formatting' }, { buffer = bufnr })
        else
          lsp_messages = lsp_messages .. 'no rangeFormat' .. lsp_msg_sep
        end
        if client.server_capabilities.implementationProvider then
          vim.keymap.set('n', ',li', vim.lsp.buf.implementation,
            { desc = 'LSP: implementation' }, { buffer = bufnr })
        else
          vim.keymap.set('n', ',li', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no implementation' .. lsp_msg_sep
        end
        if client.server_capabilities.hoverProvider then
          vim.keymap.set('n', ',lh', vim.lsp.buf.hover,
            { desc = 'LSP: hover' }, { buffer = bufnr })
        else
          vim.keymap.set('n', ',lh', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no hovering' .. lsp_msg_sep
        end
        if client.server_capabilities.signatureHelpProvider then
          vim.keymap.set('i', '<C-s>', function() vim.lsp.buf.signature_help({ border = My_Borders }) end,
            { desc = 'LSP: signature help' }, { buffer = bufnr })
          vim.keymap.set('n', ',ls', function() vim.lsp.buf.signature_help({ border = My_Borders }) end,
            { desc = 'LSP: signature help' }, { buffer = bufnr })
        else
          vim.keymap.set('n', ',ls', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no signatureHelp' .. lsp_msg_sep
        end
        if client.server_capabilities.typeDefinitionProvider then
          vim.keymap.set('n', ',ltd', vim.lsp.buf.type_definition,
            { desc = 'LSP: type definition' }, { buffer = bufnr })
        else
          vim.keymap.set('n', ',ltd', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no typeDefinition' .. lsp_msg_sep
        end

        -- autocmds
        if client.server_capabilities.codeLensProvider then
          vim.keymap.set('n', ',ll', function() vim.lsp.codelens.run({ border = My_Borders }) end,
            { desc = 'LSP: code lens' }, { buffer = bufnr })
          vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
            desc = 'LSP: code lens',
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh
          })
        else
          lsp_messages = lsp_messages .. 'no codeLens' .. lsp_msg_sep
        end

        -- messages
        vim.notify(lsp_messages, vim.log.levels.INFO, { title = '[LSP]' })
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
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
        cssls = {},
        html = {
          filetypes = {
            'html',
            'html-eex',
            'liquid'
          },
          settings = {
            css = {
              lint = {
                validProperties = {},
              },
            },
          },
        },
        intelephense = {},
        jsonls = {},
        sumneko_lua = {
          cmd = { vim.fn.stdpath('data') .. '/lspconfig/lua-language-server/bin/lua-language-server' },
          settings = {
            Lua = {
              codelens = {
                enable = true
              },
              diagnostics = {
                enable_check_codestyle = true,
                globals = {
                  'use',
                  'vim'
                },
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = 'space',
                  indent_size = 2,
                  continuation_indent_size = 4,
                  quote_style = 'single',
                  call_arg_parentheses = 'keep',
                  local_assign_continuation_align_to_first_expression = true,
                  align_call_args = true,
                  align_function_define_params = true,
                  align_table_field_to_first_field = true,
                  keep_one_space_between_table_and_bracket = true,
                  keep_one_space_between_namedef_and_attribute = false,
                  continuous_assign_statement_align_to_equal_sign = true,
                  continuous_assign_table_field_align_to_equal_sign = true,
                  do_statement_no_indent = false,
                  if_condition_no_continuation_indent = false,
                  if_condition_align_with_each_other = true,
                }
              },
              hint = {
                enable = true
              },
              telemetry = {
                enable = false
              },
              workspace = {
                checkThirdParty = false
              }
            },
          }
        },
        vimls = {},
      }
      for name, opts in pairs(servers) do
        if type(opts) == 'function' then
          opts()
        else
          local client = lsp_config[name]
          client.setup(vim.tbl_extend('force', {
            on_attach = on_attach,
            capabilities = capabilities,
          }, opts))
        end
      end

    end
  },
  'folke/neodev.nvim',
  {
    'kosayoda/nvim-lightbulb',
    event = {
      'CursorHold',
      'CursorHoldI'
    },
    config = function()
      vim.fn.sign_define('LightBulbSign', { text = ' ', texthl = 'WarningMsg', linehl = '', numhl = '' })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        desc = 'LSP: show lightbulb',
        callback = function()
          require('nvim-lightbulb').update_lightbulb()
        end
      })
      require('nvim-lightbulb').update_lightbulb()
    end
  },
  {
    'simrat39/symbols-outline.nvim',
    keys = {
      {
        '<Leader>s',
        vim.cmd.SymbolsOutline,
        desc = 'SymbolsOutline: toggle'
      },
      {
        ',tso',
        vim.cmd.SymbolsOutlineOpen,
        desc = 'SymbolsOutline: open'
      },
      {
        ',tsc',
        vim.cmd.SymbolsOutlineClose,
        desc = 'SymbolsOutline: close'
      }
    },
    config = function()
      require('symbols-outline').setup({
        preview_bg_highlight = 'Normal',
        symbols = {
          File = { icon = My_Symbols.File, hl = 'TSURI' },
          Module = { icon = My_Symbols.Module, hl = 'TSNamespace' },
          Namespace = { icon = My_Symbols.Namespace, hl = 'TSNamespace' },
          Package = { icon = My_Symbols.Package, hl = 'TSNamespace' },
          Class = { icon = My_Symbols.Class, hl = 'TSType' },
          Method = { icon = My_Symbols.Method, hl = 'TSMethod' },
          Property = { icon = My_Symbols.Property, hl = 'TSMethod' },
          Field = { icon = My_Symbols.Field, hl = 'TSField' },
          Constructor = { icon = My_Symbols.Constructor, hl = 'TSConstructor' },
          Enum = { icon = My_Symbols.Enum, hl = 'TSType' },
          Interface = { icon = My_Symbols.Interface, hl = 'TSType' },
          Function = { icon = My_Symbols.Function, hl = 'TSFunction' },
          Variable = { icon = My_Symbols.Variable, hl = 'TSConstant' },
          Constant = { icon = My_Symbols.Constant, hl = 'TSConstant' },
          String = { icon = My_Symbols.String, hl = 'TSString' },
          Number = { icon = My_Symbols.Number, hl = 'TSNumber' },
          Boolean = { icon = My_Symbols.Boolean, hl = 'TSBoolean' },
          Array = { icon = My_Symbols.Array, hl = 'TSConstant' },
          Object = { icon = My_Symbols.Object, hl = 'TSType' },
          Key = { icon = My_Symbols.Keyword, hl = 'TSType' },
          Null = { icon = 'NULL', hl = 'TSType' },
          EnumMember = { icon = My_Symbols.EnumMember, hl = 'TSField' },
          Struct = { icon = My_Symbols.Struct, hl = 'TSType' },
          Event = { icon = My_Symbols.Event, hl = 'TSType' },
          Operator = { icon = My_Symbols.Operator, hl = 'TSOperator' },
          TypeParameter = { icon = My_Symbols.TypeParameter, hl = 'TSParameter' }
        }
      })
    end
  },
  {
    'whynothugo/lsp_lines.nvim',
    url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    keys = {
      {
        ',ll',
        function()
          require('lsp_lines').toggle()
        end,
        desc = 'LSP: toggle lsp_lines'
      }
    },
    config = function()
      require('lsp_lines').setup()
    end
  },
  {
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    config = function()
      require('inc_rename').setup()
    end
  }
}