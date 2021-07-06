local lsp_config = require('lspconfig')
local lsp_install = require('lspinstall')
require('lspkind').init()
local lsp_status = require('lsp-status')
lsp_status.config {
  current_function = true,
  indicator_separator = ':',
  indicator_errors = 'E',
  indicator_warnings = 'W',
  indicator_info = 'I',
  indicator_hint = 'H',
  indicator_ok = 'OK',
  status_symbol = '[LSP] ',
}
lsp_status.register_progress()
local lsp_trouble = require('trouble')

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  signs = true,
  underline = true,
  update_in_insert = true,
  virtual_text = {spacing = 4, prefix = '❰'}
})
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = 'double'
})
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'double'
})

-- trouble config
lsp_trouble.setup {
  icons = false,
  mode = 'lsp_document_diagnostics'
}
vim.api.nvim_set_keymap('n', '<Leader>xx', '<Cmd>TroubleToggle<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>xd', '<Cmd>TroubleToggle lsp_definitions<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>xr', '<Cmd>TroubleToggle lsp_references<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>xq', '<Cmd>TroubleToggle quickfix<CR>', {noremap = true, silent = true})

-- lsputils config
local border_chars = {
  TOP_LEFT = '╭',
  TOP_RIGHT = '╮',
  MID_HORIZONTAL = '─',
  MID_VERTICAL = '│',
  BOTTOM_LEFT = '╰',
  BOTTOM_RIGHT = '╯',
}
vim.g.lsp_utils_location_opts = {
  mode = 'split',
  list = {
    border = true,
    border_chars = border_chars,
    numbering = false
  },
  preview = {
    title = 'Location Preview',
    border = true,
    border_chars = border_chars
  },
  keymaps = {
    n = {
      ['<C-n>'] = 'j',
      ['<C-p>'] = 'k',
    }
  },
  prompt = {
    border = true,
    border_chars = border_chars
  },
}
vim.g.lsp_utils_symbols_opts = {
  mode = 'split',
  list = {
    border = true,
    border_chars = border_chars,
    numbering = false
  },
  preview = {
    title = 'Symbols Preview',
    border = true,
    border_chars = border_chars
  },
  prompt = {
    border = true,
    border_chars = border_chars
  },
}
vim.lsp.handlers['textDocument/codeAction'] = require('lsputil.codeAction').code_action_handler
vim.lsp.handlers['textDocument/references'] = require('lsputil.locations').references_handler
vim.lsp.handlers['textDocument/definition'] = require('lsputil.locations').definition_handler
vim.lsp.handlers['textDocument/declaration'] = require('lsputil.locations').declaration_handler
vim.lsp.handlers['textDocument/typeDefinition'] = require('lsputil.locations').typeDefinition_handler
vim.lsp.handlers['textDocument/implementation'] = require('lsputil.locations').implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] = require('lsputil.symbols').document_handler
vim.lsp.handlers['workspace/symbol'] = require('lsputil.symbols').workspace_handler

local on_attach = function(client,bufnr)
  local lsp_messages = {}
  local lsp_msg_sep = ' ∷ '
  lsp_messages = lsp_msg_sep .. 'LSP attached' .. lsp_msg_sep
  lsp_status.on_attach(client)
  -- options
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- keybindings
  function _G.show_documentation()
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
      vim.api.nvim_command('h ' .. vim.fn.expand('<cword>'))
    else
      vim.api.nvim_command('lua vim.lsp.buf.hover()')
    end
  end
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', [[<Cmd>lua show_documentation({border = 'double'})<CR>]], {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ld', [[<Cmd>lua vim.lsp.buf.definition()<CR>]], {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lr', [[<Cmd>lua vim.lsp.buf.references()<CR>]], {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ly', [[<Cmd>lua vim.lsp.buf.document_symbol()<CR>]], {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lY', [[<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>]], {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',le', [[<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics({border = 'double'})<CR>]], {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', [[<Cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = 'double'}})<CR>]], {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', [[<Cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = 'double'}})<CR>]], {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lq', [[<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]], {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lrn', [[<Cmd>lua vim.lsp.buf.rename()<CR>]], {noremap = true, silent = true})
  if client.resolved_capabilities.code_action then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lca', [[<Cmd>lua vim.lsp.buf.code_action()<CR>]], {noremap = true, silent = true})
  else
    lsp_messages = lsp_messages .. 'no codeAction' .. lsp_msg_sep
  end
  if client.resolved_capabilities.declaration then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lc', [[<Cmd>lua vim.lsp.buf.declaration()<CR>]], {noremap = true, silent = true})
  else
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lc', [[<Nop>]], {noremap = true, silent = true})
    lsp_messages = lsp_messages .. 'no declaration' .. lsp_msg_sep
  end
  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lf', ':lua vim.lsp.buf.formatting()<CR>', {noremap = true, silent = true})
  else
    lsp_messages = lsp_messages .. 'no format' .. lsp_msg_sep
  end
  if client.resolved_capabilities.document_range_formatting then
    vim.api.nvim_buf_set_keymap(bufnr, 'v', ',lf', ':lua vim.lsp.buf.range_formatting()<CR>', {noremap = true, silent = true})
  else
    lsp_messages = lsp_messages .. 'no rangeFormat' .. lsp_msg_sep
  end
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
  end
  if client.resolved_capabilities.implementation then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ',li', [[<Cmd>lua vim.lsp.buf.implementation()<CR>]], {noremap = true, silent = true})
  else
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ',li', [[<Nop>]], {noremap = true, silent = true})
    lsp_messages = lsp_messages .. 'no implementation' .. lsp_msg_sep
  end
  if client.resolved_capabilities.signature_help then
    vim.api.nvim_exec([[
    augroup lsp_signature_help
      autocmd! * <buffer>
      autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help({border = 'double'})
    augroup END
    ]], false)
    vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-k>', [[<Cmd>lua vim.lsp.buf.signature_help({border = 'double'})<CR>]], {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ls', [[<Cmd>lua vim.lsp.buf.signature_help({border = 'double'})<CR>]], {noremap = true, silent = true})
  else
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ls', [[<Nop>]], {noremap = true, silent = true})
    lsp_messages = lsp_messages .. 'no signatureHelp' .. lsp_msg_sep
  end
  if client.resolved_capabilities.type_definition then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ltd', [[<Cmd>lua vim.lsp.buf.type_definition()<CR>]], {noremap = true, silent = true})
  else
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ltd', [[<Nop>]], {noremap = true, silent = true})
    lsp_messages = lsp_messages .. 'no typeDefinition' .. lsp_msg_sep
  end
  print(lsp_messages)
end

-- configure language servers
local css_settings = {
  root_dir = vim.loop.cwd()
}
local lua_settings = {
  Lua = {
    runtime = { version = 'LuaJIT', path = vim.split(package.path, ';'), },
    diagnostics = {
      enable = true,
      globals = {'vim', 'describe', 'it', 'before_each', 'after_each', 'awsesome', 'theme', 'client', 'P'},
    },
    workspace = {
      preloadFileSize = 400,
    },
  }
}
local php_settings = {
  root_dir = vim.loop.cwd()
}

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
  }
  return {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- lsp-install
local function setup_servers()
  lsp_install.setup()
  local servers = lsp_install.installed_servers()
  for _, server in pairs(servers) do
    local config = make_config()
    if server == 'bash' then
      config.filetypes = { 'bash', 'sh', 'zsh' }
    end
    if server == 'css' then
      config.settings = css_settings
    end
    if server == 'lua' then
      config.settings = lua_settings
    end
    if server == 'php' then
      config.settings = php_settings
    end
    lsp_config[server].setup(config)
  end
end
setup_servers()

-- automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lsp_install.post_install_hook = function ()
  setup_servers()
  vim.api.nvim_command[[bufdo e]] -- this triggers the FileType autocmd that starts the server
end
