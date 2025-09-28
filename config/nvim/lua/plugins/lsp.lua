-- Diagnostic
vim.keymap.set('n', ',dt', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
  { desc = 'Diagnostic: toggle' })
vim.keymap.set('n', ',dd', function() Snacks.picker.diagnostics_buffer() end,
  { desc = 'Diagnostic: document diagnostics' })
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
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo'
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo'
    }
  },
  virtual_text = {
    current_line = true,
    severity = {
      min = 'INFO',
      max = 'WARN'
    }
  },
  virtual_lines = {
    current_line = true,
    severity = {
      min = 'ERROR'
    }
  }
})

-- LSP config
vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true
        }
      },
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
    }
  },
  root_markers = { '.git' },
  single_file_support = true
})

vim.lsp.config['bash'] = {
  cmd = { 'bash-language-server', 'start' },
  filetypes = {
    'sh',
    'bash',
    'zsh'
  }
}
vim.lsp.config['basics'] = {
  cmd = { 'basics-language-server' },
  settings = {
    buffer = {
      enable = true,
      minCompletionLength = 4
    },
    path = {
      enable = true
    },
    snippet = {
      enable = false,
      sources = {}
    }
  }
}
vim.lsp.config['css'] = {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json', '.git' },
  settings = {
    provideFormatter = true,
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true }
  }
}
vim.lsp.config['html'] = {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = {
    'html',
    'html-eex',
    'liquid',
    'templ'
  },
  on_attach = function(client)
    vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
  end,
  settings = {
    provideFormatter = true,
    embeddedLanguages = {
      css = true,
      javascript = true
    },
    configurationSection = {
      'html',
      'css',
      'javascript'
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
}
vim.lsp.config['json'] = {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  settings = {
    provideFormatter = true
  }
}
vim.lsp.config['lua_ls'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      codeLens = {
        enable = true
      },
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
      },
      runtime = {
        version = 'LuaJIT'
      },
      telemetry = {
        enable = false
      },
      workspace = {
        checkThirdParty = false
      }
    }
  }
}
vim.lsp.config['marksman'] = {
  cmd = { 'marksman', 'server' },
  filetypes = { 'markdown', 'markdown.mdx' },
  root_markers = { '.marksman.toml', '.git' }
}
vim.lsp.config['taplo'] = {
  cmd = { 'taplo', 'lsp', 'stdio' },
  filetypes = { 'toml' }
}
vim.lsp.config['vim'] = {
  cmd = { 'vim-language-server', '--stdio' },
  filetypes = { 'vim' }
}
vim.lsp.config['zk'] = {
  cmd = { 'zk', 'lsp' },
  filetypes = { 'markdown' },
  root_markers = { '.zk' }
}

vim.lsp.enable({ 'bash', 'basics', 'css', 'html', 'json', 'lua_ls', 'marksman', 'taplo', 'vim', 'zk' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(event)
    local unpack = unpack or table.unpack
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local lsp_messages = ''
    local lsp_msg_sep = ' ∷ '
    lsp_messages = lsp_msg_sep .. 'LSP [' .. client.name .. ']' .. lsp_msg_sep
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[event.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

    -- Buffer local mappings.
    local opts = { buffer = event.buf }
    vim.keymap.set('n', ',lI', function() vim.cmd.checkhealth('lsp') end,
      { desc = 'LSP: info' }, opts)
    vim.keymap.set('n', ',lL', function() vim.cmd(string.format('tabnew %s', vim.lsp.log.get_filename())) end,
      { desc = 'LSP: log' }, opts)
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
      vim.keymap.set({ 'n', 'v' }, ',lca', function() require('actions-preview').code_actions() end,
        { desc = 'LSP: code actions' }, opts)
      lsp_messages = lsp_messages .. 'code actions' .. lsp_msg_sep
    end
    if client:supports_method('textDocument/formatting', event.buf) then
      local fmt_opts = vim.bo[event.buf].ft == 'lua'
        and 'async = true, name = "lua_ls", bufnr = ' .. event.buf
        or 'async = true, bufnr = ' .. event.buf
      vim.keymap.set('n', ',lf', function() vim.lsp.buf.format({ fmt_opts }) end,
        { desc = 'LSP: formatting' }, opts)
      lsp_messages = lsp_messages .. 'formatting' .. lsp_msg_sep
    end
    if client:supports_method('textDocument/onTypeFormatting', event.buf) then
      vim.lsp.on_type_formatting.enable()
      lsp_messages = lsp_messages .. 'on-type formatting' .. lsp_msg_sep
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
      lsp_messages = lsp_messages .. 'range formatting' .. lsp_msg_sep
    end
    if client:supports_method('textDocument/hover', event.buf) then
      vim.keymap.set('n', ',lh', function() vim.lsp.buf.hover() end, { desc = 'LSP: hover' }, opts)
      lsp_messages = lsp_messages .. 'hovering' .. lsp_msg_sep
    end
    if client:supports_method('textDocument/implementation', event.buf) then
      vim.keymap.set('n', ',li', function() Snacks.picker.lsp_implementations() end,
        { desc = 'LSP: implementations' }, opts)
      lsp_messages = lsp_messages .. 'implementations' .. lsp_msg_sep
    end
    if client:supports_method('textDocument/inlayHint', event.buf) then
      vim.keymap.set('n', ',lH', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
        { desc = 'LSP: hints' }, opts)
      lsp_messages = lsp_messages .. 'hints' .. lsp_msg_sep
    end
    if client:supports_method('textDocument/signatureHelp', event.buf) then
      vim.keymap.set({ 'i', 's' }, '<C-s>',
        function() vim.lsp.buf.signature_help() end,
        { desc = 'LSP: signature help' }, opts)
      vim.keymap.set('n', ',ls',
        function() vim.lsp.buf.signature_help() end,
        { desc = 'LSP: signature help' }, opts)
      lsp_messages = lsp_messages .. 'signature_help' .. lsp_msg_sep
    end

    -- messages
    vim.notify(lsp_messages, vim.log.levels.INFO, { title = '[LSP]' })
  end
})

vim.pack.add({
  {
    src = 'https://github.com/folke/lazydev.nvim',
    data = {
      ft = 'lua'
    }
  }
})
require('lazydev').setup({
  runtime = vim.env.VIMRUNTIME,
  library = {
    { path = 'snacks.nvim', words = { 'Snacks' } },
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    { path = 'wezterm-types', mods = { 'wez', 'wezterm' } }
  }
})

vim.pack.add({
  { src = 'https://github.com/IsaacShelton/clear-action.nvim' }
})
require('clear-action').setup({
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
})
vim.keymap.set('n', ',tc', vim.cmd.CodeActionToggleSigns, { desc = 'Toggle: code actions' })

vim.pack.add({
  { src = 'https://github.com/aznhe21/actions-preview.nvim' }
})
require('actions-preview').setup({
  snacks = {
    layout = {
      preset = 'ivy'
    }
  }
})

vim.pack.add({
  { src = 'https://github.com/lewis6991/hover.nvim' }
})
require('hover').setup({
  init = function()
    require('hover.providers.lsp')
    require('hover.providers.man')
    require('hover.providers.diagnostic')
    require('hover.providers.fold_preview')
    require('hover.providers.highlight')
  end,
  title = true
})
vim.keymap.set('n', 'H', require('hover').hover, { desc = 'hover.nvim' })
vim.keymap.set('n', 'gH', require('hover').hover_select, { desc = 'hover.nvim (select)' })

vim.pack.add({
  { src = 'https://github.com/oskarrrrrrr/symbols.nvim' }
})
local r = require('symbols.recipes')
require('symbols').setup(r.DefaultFilters, r.AsciiSymbols, {
  sidebar = {
    open_direction = 'try-right',
    preview = {
      show_always = false
    }
  }
})
vim.keymap.set('n', '<Leader>Y', vim.cmd.SymbolsToggle, { desc = 'Symbols: toggle' })
