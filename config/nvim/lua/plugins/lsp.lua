return {
  -- {{{2 neodev.nvim
  {
    'folke/neodev.nvim',
    opts = {}
  },
  -- }}}2
  -- {{{2 nvim-lspconfig
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      {
        'hrsh7th/cmp-nvim-lsp',
        opts = {}
      }
    },
    config = function()
      require('lspconfig.ui.windows').default_options.border = require('config.ui').borders

      -- LSP handlers
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
        { border = require('config.ui').borders })
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover,
        { border = require('config.ui').borders })

      -- diagnostic handling
      local diagnostic_signs = require('config.ui').icons.diagnostics
      local diagnostic_severity_fullnames = { 'Error', 'Warning', 'Information', 'Hint', 'Ok' }
      local diagnostic_severity_shortnames = { 'Error', 'Warn', 'Info', 'Hint', 'Ok' }
      for index, icon in ipairs(diagnostic_signs) do
        local fullname = diagnostic_severity_fullnames[index]
        local shortname = diagnostic_severity_shortnames[index]

        vim.fn.sign_define('DiagnosticSign' .. shortname, {
          text = icon,
          texthl = 'Diagnostic' .. shortname,
          linehl = '',
          numhl = '',
        })

        vim.fn.sign_define('LspDiagnosticsSign' .. fullname, {
          text = icon,
          texthl = 'LspDiagnosticsSign' .. fullname,
          linehl = '',
          numhl = '',
        })
      end

      local enabled = true
      local function toggle_diagnostics()
        enabled = not enabled
        if enabled then
          vim.diagnostic.enable()
          vim.notify('Diagnostics enabled', vim.log.levels.INFO, { title = '[LSP]' })
        else
          vim.diagnostic.disable()
          vim.notify('Diagnostics disabled', vim.log.levels.INFO, { title = '[LSP]' })
        end
      end

      vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev({ float = false }) end,
        { desc = 'Diagnostic: got to previous error' })
      vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next({ float = false }) end,
        { desc = 'Diagnostic: got to next error' })
      vim.keymap.set('n', ',dt', function() toggle_diagnostics() end, { desc = 'Diagnostics: toggle' })
      vim.keymap.set('n', ',df', vim.diagnostic.open_float, { desc = 'Diagnostics: open floating window' })
      vim.keymap.set('n', ',dl', vim.diagnostic.setloclist, { desc = 'Diagnostics: populate location list' })
      vim.keymap.set('n', ',dq', vim.diagnostic.setqflist, { desc = 'Diagnostics: populate quickfix' })

      vim.diagnostic.config({
        float = {
          border = require('config.ui').borders,
          focusable = false,
          header = '',
          scope = 'line',
          source = 'always'
        },
        virtual_text = {
          source = 'always'
        }
      })

      -- LSP functions
      local on_attach = function(client, bufnr)
        local unpack = unpack or table.unpack
        local lsp_messages = ''
        local lsp_msg_sep = ' ∷ '
        lsp_messages = lsp_msg_sep .. 'LSP attached' .. lsp_msg_sep
        -- options
        if vim.bo[bufnr].filetype == 'lua' then
          vim.bo[bufnr].omnifunc = 'v:lua.vim.lua_omnifunc'
        else
          vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
        end
        -- keybindings
        vim.keymap.set('n', ',lI', vim.cmd.LspInfo,
          { desc = 'LSP: info' }, { buffer = bufnr })
        vim.keymap.set('n', ',lrs', vim.cmd.LspRestart,
          { desc = 'LSP: restart' }, { buffer = bufnr })
        vim.keymap.set('n', ',lF', function() require('fzf-lua').lsp_finder() end,
          { desc = 'LSP: finder' }, { buffer = bufnr })
        vim.keymap.set('n', ',ly', require('fzf-lua').lsp_document_symbols,
          { desc = 'LSP: document symbols' }, { buffer = bufnr })
        vim.keymap.set('n', ',lY', require('fzf-lua').lsp_live_workspace_symbols,
          { desc = 'LSP: workspace symbols' }, { buffer = bufnr })
        vim.keymap.set('n', ',ld', require('fzf-lua').lsp_document_diagnostics,
          { desc = 'Diagnostics: document diagnostics' }, { buffer = bufnr })
        vim.keymap.set('n', ',lD', require('fzf-lua').lsp_workspace_diagnostics,
          { desc = 'Diagnostics: workspace diagnostics' }, { buffer = bufnr })
        vim.keymap.set('n', ',lrn',
          function()
            if pcall(require, 'inc_rename') then
              return ':IncRename ' .. vim.fn.expand('<cword>')
            else
              vim.lsp.buf.rename()
            end
          end,
          { desc = 'LSP: rename', expr = true, replace_keycodes = false }, { buffer = bufnr })
        vim.keymap.set('n', ',lw', function() Dump(vim.lsp.buf.list_workspace_folders()) end,
          { desc = 'LSP: list workspace folders' }, { buffer = bufnr })
        if client.supports_method('textDocument/codeAction') then
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
        if client.supports_method('textDocument/formatting') then
          local fmt_opts = vim.bo[bufnr].ft == 'lua'
            and 'async=true,bufnr=0,name="lua_ls"'
            or 'async=true,bufnr=0'
          vim.keymap.set('n', ',lf', function() vim.lsp.buf.format(fmt_opts) end,
            { desc = 'LSP: formatting' }, { buffer = bufnr })
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
                name    = vim.bo[bufnr].ft == 'lua' and 'lua_ls' or nil,
                start   = { csrow, cscol },
                ['end'] = { cerow, cecol },
              }
              vim.lsp.buf.format(fmt_opts)
            end,
            { desc = 'LSP: range formatting' }, { buffer = bufnr })
        else
          lsp_messages = lsp_messages .. 'no rangeFormat' .. lsp_msg_sep
        end
        if client.supports_method('textDocument/hover') then
          vim.keymap.set('n', ',lh', vim.lsp.buf.hover,
            { desc = 'LSP: hover' }, { buffer = bufnr })
        else
          vim.keymap.set('n', ',lh', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no hovering' .. lsp_msg_sep
        end
        if client.supports_method('textDocument/implementation') then
          vim.keymap.set('n', ',li', function() require('fzf-lua').lsp_implementations() end,
            { desc = 'LSP: implementations' }, { buffer = bufnr })
        else
          vim.keymap.set('n', ',li', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no implementation' .. lsp_msg_sep
        end
        if client.supports_method('textDocument/inlayHint') then
          vim.keymap.set('n', ',lH', function() vim.lsp.buf.inlay_hint(0) end,
            { desc = 'LSP: hints' }, { buffer = bufnr })
        else
          vim.keymap.set('n', ',lH', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no hints' .. lsp_msg_sep
        end
        if client.supports_method('textDocument/signatureHelp') then
          vim.keymap.set('i', '<C-s>',
            function() vim.lsp.buf.signature_help({ border = require('config.ui').borders }) end,
            { desc = 'LSP: signature help' }, { buffer = bufnr })
          vim.keymap.set('n', ',ls',
            function() vim.lsp.buf.signature_help({ border = require('config.ui').borders }) end,
            { desc = 'LSP: signature help' }, { buffer = bufnr })
        else
          vim.keymap.set('n', ',ls', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no signatureHelp' .. lsp_msg_sep
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
        lua_ls = {
          cmd = { vim.fn.stdpath('data') .. '/lspconfig/lua-language-server/bin/lua-language-server' },
          settings = {
            Lua = {
              completion = {
                callsnippet = 'Replace'
              },
              diagnostics = {
                neededFileStatus = {
                  ['codestyle-check'] = 'Any'
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
              },
              workspace = {
                checkThirdParty = false
              }
            }
          }
        },
        rust_analyzer = {},
        vimls = {},
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
  -- }}}2
  -- {{{2 nvim-lightbulb
  {
    'kosayoda/nvim-lightbulb',
    event = {
      'CursorHold',
      'CursorHoldI'
    },
    opts = function()
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
  -- }}}2
  -- {{{2 hover.nvim
  {
    'lewis6991/hover.nvim',
    keys = {
      { 'H', function() require('hover').hover() end, desc = 'hover.nvim' },
      { 'gH', function() require('hover').hover_select() end, desc = 'hover.nvim (select)' }
    },
    config = function()
      require('hover').setup({
        init = function()
          require('hover.providers.lsp')
          require('hover.providers.man')
        end,
        preview_opts = {
          border = nil
        },
        title = true
      })
    end
  },
  -- }}}2
  -- {{{2 symbols-outline.nvim
  {
    'simrat39/symbols-outline.nvim',
    keys = {
      { '<Leader>s', vim.cmd.SymbolsOutline, desc = 'SymbolsOutline: toggle' },
    },
    opts = {
      preview_bg_highlight = 'Normal',
      symbols = {
        File = { icon = require('config.ui').icons.kinds.File, hl = 'TSURI' },
        Module = { icon = require('config.ui').icons.kinds.Module, hl = 'TSNamespace' },
        Namespace = { icon = require('config.ui').icons.kinds.Namespace, hl = 'TSNamespace' },
        Package = { icon = require('config.ui').icons.kinds.Package, hl = 'TSNamespace' },
        Class = { icon = require('config.ui').icons.kinds.Class, hl = 'TSType' },
        Method = { icon = require('config.ui').icons.kinds.Method, hl = 'TSMethod' },
        Property = { icon = require('config.ui').icons.kinds.Property, hl = 'TSMethod' },
        Field = { icon = require('config.ui').icons.kinds.Field, hl = 'TSField' },
        Constructor = { icon = require('config.ui').icons.kinds.Constructor, hl = 'TSConstructor' },
        Enum = { icon = require('config.ui').icons.kinds.Enum, hl = 'TSType' },
        Interface = { icon = require('config.ui').icons.kinds.Interface, hl = 'TSType' },
        Function = { icon = require('config.ui').icons.kinds.Function, hl = 'TSFunction' },
        Variable = { icon = require('config.ui').icons.kinds.Variable, hl = 'TSConstant' },
        Constant = { icon = require('config.ui').icons.kinds.Constant, hl = 'TSConstant' },
        String = { icon = require('config.ui').icons.kinds.String, hl = 'TSString' },
        Number = { icon = require('config.ui').icons.kinds.Number, hl = 'TSNumber' },
        Boolean = { icon = require('config.ui').icons.kinds.Boolean, hl = 'TSBoolean' },
        Array = { icon = require('config.ui').icons.kinds.Array, hl = 'TSConstant' },
        Object = { icon = require('config.ui').icons.kinds.Object, hl = 'TSType' },
        Key = { icon = require('config.ui').icons.kinds.Keyword, hl = 'TSType' },
        Null = { icon = 'NULL', hl = 'TSType' },
        EnumMember = { icon = require('config.ui').icons.kinds.EnumMember, hl = 'TSField' },
        Struct = { icon = require('config.ui').icons.kinds.Struct, hl = 'TSType' },
        Event = { icon = require('config.ui').icons.kinds.Event, hl = 'TSType' },
        Operator = { icon = require('config.ui').icons.kinds.Operator, hl = 'TSOperator' },
        TypeParameter = { icon = require('config.ui').icons.kinds.TypeParameter, hl = 'TSParameter' }
      }
    }
  },
  -- }}}2
  -- {{{2 inc-rename.nvim
  {
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    opts = {}
  }
  -- }}}2
}
-- vim: foldmethod=marker foldlevel=1
