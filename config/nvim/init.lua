-------------- My personal not so 300 lines of neovim config -------------------
-- All credits to mjlbach for his thread at neovim.discourse.com:
-- https://neovim.discourse.group/t/the-300-line-init-lua-challenge/
-- {{{1 --------------------- OPTIONS ------------------------------------------
local indent = 2
local opts = { noremap = true, silent = true }

-- define leader keys
vim.g.mapleader = " "

vim.bo.expandtab = true
vim.bo.nrformats = vim.bo.nrformats .. ',alpha'
vim.bo.shiftwidth = indent
vim.bo.softtabstop = indent
vim.bo.spellfile = vim.fn.stdpath('config') .. '/spell/myspell.utf-8.add'
vim.bo.spelllang = [[en,de,es,nl]]
vim.o.autowrite = true
vim.o.backupcopy = 'auto'
vim.o.backup = false
vim.o.breakindent = true
vim.o.completeopt = [[menuone,noinsert,noselect]]
vim.o.diffopt = vim.o.diffopt .. ',vertical,indent-heuristic,algorithm:histogram'
vim.o.fillchars = [[vert:┃,foldopen:▾,foldclose:▴,foldsep:┃,msgsep:⁘]]
if vim.fn.executable('ugrep') == 1 then
  vim.o.grepprg = 'ugrep -RInk -j -u --tabs=1 --ignore-files'
  vim.o.grepformat = '%f:%l:%c:%m,%f+%l+%c+%m,%-G%f\\|%l\\|%c\\|%m'
elseif vim.fn.executable('git') == 1 then
  vim.o.grepprg = 'git'
elseif vim.fn.executable('ack') == 1 then
  vim.o.grepprg = 'ack --nogroup --column --smart-case --nocolor --follow $*'
end
vim.o.gdefault = true
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.inccommand = 'split'
vim.o.joinspaces = true
vim.o.listchars = [[tab:›\ ,trail:·,eol:«,extends:>,precedes:<]]
vim.o.modelineexpr = true
vim.o.mouse = 'a'
vim.o.pastetoggle = '<F3>'
vim.o.pumblend = 10
vim.o.selection = 'exclusive'
vim.o.shiftround = true
vim.o.showbreak = '  » '
vim.o.showtabline = 2
vim.o.smartcase = true
vim.o.smarttab = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = true
vim.o.termguicolors = true
vim.o.updatetime = 300
vim.o.writebackup = true
vim.wo.cursorcolumn = true
vim.wo.cursorline = true
vim.wo.foldlevel = 99
if vim.wo.foldmethod == '' then
  vim.wo.foldmethod = 'expr'
  vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
else
  vim.wo.foldmethod = vim.wo.foldmethod
end
vim.wo.linebreak = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'auto'
vim.cmd[[set undofile]]
-- }}}1 --------------------- OPTIONS ------------------------------------------
-- {{{1 --------------------- PLUGINS ------------------------------------------
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd[[packadd packer.nvim]]
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd FileType packer set previewheight=40
    autocmd BufWritePost init.lua PackerCompile
    autocmd BufWritePost init.lua luafile $MYVIMRC
    " autocmd BufWritePost init.lua PackerSync
    autocmd User PackerComplete luafile $MYVIMRC
  augroup end
]], false)

local packer = require('packer')
local use = packer.use
packer.startup(function()
  packer.init({ display = {open_cmd = '84vnew [packer]'}})
  use {'wbthomason/packer.nvim', opt = true}
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use {'nvim-telescope/telescope.nvim', requires = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim'
  }}
  use {'neovim/nvim-lspconfig', requires = {
    'kabouzeid/nvim-lspinstall',
    'nvim-lua/lsp-status.nvim',
    'onsails/lspkind-nvim',
    'ray-x/lsp_signature.nvim'
  }}
  use 'hrsh7th/nvim-compe'
  use 'andersevenrud/compe-tmux'
  use 'tpope/vim-abolish'
  use 'tpope/vim-commentary'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-obsession'
  use 'tpope/vim-repeat'
  use 'tpope/vim-unimpaired'
  use 'lewis6991/gitsigns.nvim'
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use 'machakann/vim-sandwich'
  use 'andymass/vim-matchup'
  use 'romainl/vim-cool'
  use 'romainl/vim-qf'
  use 'romainl/vim-qlist'
  use 'kevinhwang91/nvim-bqf'
  use 'mbbill/undotree'
  use 'ChristianChiarulli/far.vim'
  use 'will133/vim-dirdiff'
  use 'qpkorr/vim-renamer'
  use 'kg8m/vim-simple-align'
  use 'jamessan/vim-gnupg'
  use 'editorconfig/editorconfig-vim'
  use 'habamax/vim-asciidoctor'
  use 'chrisbra/unicode.vim'
  use {'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons'}
  use 'norcalli/nvim-colorizer.lua'
  use 'lifepillar/vim-colortemplate'
  use 'wimstefan/vim-artesanal'
  use 'sainnhe/edge'
  use 'Th3Whit3Wolf/one-nvim'
  use 'AlxHnr/clear_colors'
end)
-- }}}1 --------------------- PLUGINS ------------------------------------------
-- {{{1 ------------------- PLUGIN SETTINGS ------------------------------------
-- {{{2 packer.nvim config
vim.api.nvim_set_keymap('n', ',pc', '<Cmd>PackerClean<CR>', opts)
vim.api.nvim_set_keymap('n', ',pi', '<Cmd>PackerInstall<CR>', opts)
vim.api.nvim_set_keymap('n', ',pq', '<Cmd>PackerStatus<CR>', opts)
vim.api.nvim_set_keymap('n', ',ps', '<Cmd>PackerSync<CR>', opts)
vim.api.nvim_set_keymap('n', ',pu', '<Cmd>PackerUpdate<CR>', opts)
-- }}}
-- {{{2 treesitter config
require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  context_commentstring = { enable = true },
  highlight = { enable = true, use_languagetree = true },
  incremental_selection = { enable = false },
  indent = { enable = false },
  matchup = { enable = false },
  textobjects = { enable = false },
}
-- }}}
-- {{{2 telescope config
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-s>"] = require('telescope.actions').select_horizontal,
        -- Experimental - but from the author himself :)
        ["<tab>"] = require('telescope.actions').toggle_selection,
        ["<C-q>"] = require('telescope.actions').send_to_qflist +require('telescope.actions').open_qflist,
        ["<M-q>"] = require('telescope.actions').send_selected_to_qflist +require('telescope.actions').open_qflist,
      },
    },
    layout_strategy = 'flex',
    file_ignore_patterns = {'gif', 'jpeg', 'jpg', 'pdf', 'png', 'svg'},
  }
}
vim.api.nvim_set_keymap('n', '<Leader>T', [[<Cmd>lua require('telescope.builtin').builtin(require('telescope.themes').get_dropdown({previewer = false}))<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>b', [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>c', [[<Cmd>lua require('telescope.builtin').colorscheme(require('telescope.themes').get_dropdown({}))<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>f', [[<Cmd>lua require('telescope.builtin').find_files({follow = true})<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>g', [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>h', [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>M', [[<Cmd>lua require('telescope.builtin').man_pages()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>m', [[<Cmd>lua require('telescope.builtin').marks()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>r', [[<Cmd>lua require('telescope.builtin').registers()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>Tgb', [[<Cmd>lua require('telescope.builtin').git_bcommits()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>Tgc', [[<Cmd>lua require('telescope.builtin').git_commits()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>Tgf', [[<Cmd>lua require('telescope.builtin').git_files()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>Tgs', [[<Cmd>lua require('telescope.builtin').git_status()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>Tf', [[<Cmd>lua require('telescope.builtin').filetypes(require('telescope.themes').get_dropdown({}))<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>Tm', [[<Cmd>lua require('telescope.builtin').keymaps()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>Ts', [[<Cmd>lua require('telescope.builtin').spell_suggest()<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>Tw', [[<Cmd>lua require('telescope.builtin').grep_string()<CR>]], opts)
vim.api.nvim_exec([[
  augroup Telescope
    autocmd!
    autocmd User TelescopePreviewerLoaded setlocal wrap
  augroup END
]], false)
-- }}}
-- {{{2 nvim-compe config
require('compe').setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'enable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,
  source = {
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    nvim_treesitter = true,
    omni = false,
    path = true,
    spell = true,
    tags = false,
    tmux = true
  },
}
-- }}}
-- {{{2 LSP config
local lsp_config = require('lspconfig')
local lsp_install = require('lspinstall')
require('lspkind').init()
local lsp_signature = require('lsp_signature')
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

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  signs = true,
  virtual_text = {spacing = 6, prefix = '❰'},
  underline = true,
  update_in_insert = true
})

local on_attach = function(client,bufnr)
  local lsp_messages = {}
  local lsp_msg_sep = ' ∷ '
  lsp_messages = lsp_msg_sep .. 'LSP attached' .. lsp_msg_sep
  lsp_signature.on_attach(client)
  lsp_status.on_attach(client)
  -- options
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
  -- keybindings
  function _G.show_documentation()
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
      vim.cmd('h ' .. vim.fn.expand('<cword>'))
    else
      vim.cmd('lua vim.lsp.buf.hover()')
    end
  end
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', [[<Cmd>lua show_documentation()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ls', [[<Cmd>lua vim.lsp.buf.signature_help()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ld', [[<Cmd>lua vim.lsp.buf.definition()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ltd', [[<Cmd>lua vim.lsp.buf.type_definition()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lr', [[<Cmd>lua vim.lsp.buf.references()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',li', [[<Cmd>lua vim.lsp.buf.implementation()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lc', [[<Cmd>lua vim.lsp.buf.declaration()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',le', [[<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', [[<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', [[<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lq', [[<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lrn', [[<Cmd>lua vim.lsp.buf.rename()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lwa', [[<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lwl', [[<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lwr', [[<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>]], opts)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.code_action then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lca', [[<Cmd>lua vim.lsp.buf.code_action()<CR>]], opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'v', ',lca', [[<Cmd>lua vim.lsp.buf.range_code_action()<CR>]], opts)
    lsp_messages = lsp_messages .. 'Code actions' .. lsp_msg_sep
  else
    lsp_messages = lsp_messages .. 'No code actions' .. lsp_msg_sep
  end
  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  elseif client.resolved_capabilities.document_range_formatting then
    vim.api.nvim_buf_set_keymap(bufnr, 'v', ',lf', '<Cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  else
    lsp_messages = lsp_messages .. 'No formatting' .. lsp_msg_sep
  end
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
  end
  print(lsp_messages)
end

-- configure lua language server
local lua_settings = {
  Lua = {
    runtime = { version = 'LuaJIT', path = vim.split(package.path, ';'), },
    diagnostics = {
      enable = true,
      globals = {'vim'},
    },
    workspace = {
      preloadFileSize = 400,
    },
  }
}

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

-- lsp-install
local function setup_servers()
  lsp_install.setup()
  local servers = lsp_install.installed_servers()
  for _, server in pairs(servers) do
    local config = make_config()
    if server == "bash" then
      config.filetypes = { 'bash', 'sh', 'zsh' }
    end
    if server == "lua" then
      config.settings = lua_settings
    end
    lsp_config[server].setup(config)
  end
end
setup_servers()

-- automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lsp_install.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
-- }}}
-- {{{2 vim-commentary config
vim.api.nvim_set_keymap('v', 'gci', ':g/./Commentary<CR>', {noremap = false, silent = false})
-- }}}
-- {{{2 vim-fugitive config
vim.api.nvim_set_keymap('n', '<Leader>gc', '<Cmd>Gcommit -v %<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gd', '<Cmd>Gdiff<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gl', '<Cmd>0Glog<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gp', '<Cmd>Gpush<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gs', '<Cmd>Gstatus<CR>', opts)
-- }}}
-- {{{2 vim-obsession config
vim.api.nvim_set_keymap('n', ',to', '<Cmd>Obsession<CR>', opts)
-- }}}
-- {{{2 gitsigns config
require('gitsigns').setup {
  signs = {
    add = {
      hl = 'DiffAdd',
      show_count = true,
      numhl = 'GitSignsAddNr'
    },
    change = {
      hl = 'DiffChange',
      numhl = 'GitSignsChangeNr'},
    delete = {
      hl = 'DiffDelete',
      show_count = true,
      numhl = 'GitSignsDeleteNr'
    },
    topdelete = {
      hl = 'DiffDelete',
      show_count = true,
      numhl = 'GitSignsDeleteNr'
    },
    changedelete = {
      hl = 'DiffChange',
      show_count = true,
      numhl = 'GitSignsChangeNr'
    }
  },
  count_chars = {
    [1] = '₁',
    [2] = '₂',
    [3] = '₃',
    [4] = '₄',
    [5] = '₅',
    [6] = '₆',
    [7] = '₇',
    [8] = '₈',
    [9] = '₉',
    ['+'] = '₊'
  },
  current_line_blame = false,
  numhl = true,
  keymaps = {
    noremap = true,
    buffer = true,
    ['n ]c'] = { expr = true, "&diff ? ']c' : '<Cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<Cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},
    ['n ,st'] = '<Cmd>lua require"gitsigns".toggle_signs()<CR>',
    ['n ,sh'] = '<Cmd>lua require"gitsigns".toggle_linehl()<CR>',
    ['n ,sp'] = '<Cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n ,sb'] = '<Cmd>lua require"gitsigns".blame_line()<CR>',
  }
}
-- }}}
-- {{{2 vim-qf config
vim.g.qf_mapping_ack_style = true
vim.g.qf_auto_open_quickfix = true
vim.api.nvim_set_keymap('n', '<C-q>', '<Plug>(qf_qf_switch)', {})
vim.api.nvim_set_keymap('n', '<C-c>', '<Plug>(qf_qf_toggle)', {})
vim.api.nvim_set_keymap('n', '<F6>', '<Plug>(qf_loc_toggle)', {})
vim.api.nvim_set_keymap('n', '<Home>', '<Plug>(qf_qf_previous)', {})
vim.api.nvim_set_keymap('n', '<End>', '<Plug>(qf_qf_next)', {})
vim.api.nvim_set_keymap('n', '<C-Home>', '<Plug>(qf_loc_previous)', {})
vim.api.nvim_set_keymap('n', '<C-End>', '<Plug>(qf_loc_next)', {})
-- }}}
-- {{{2 nvim-bqf config
require('bqf').setup({ auto_enable = true })
-- }}}
-- {{{2 undotree config
vim.g.undotree_WindowLayout= 2
vim.g.undotree_SetFocusWhenToggle= 1
vim.g.undotree_ShortIndicators= 1
vim.api.nvim_set_keymap('n', ',tu', '<Cmd>UndotreeToggle<CR>', opts)
-- }}}
-- {{{2 unicode.vim config
vim.g.Unicode_data_directory = vim.fn.stdpath('data') .. '/site/pack/packer/start/unicode.vim/autoload/unicode/'
vim.api.nvim_set_keymap('n', '<Leader>ut', '<Cmd>UnicodeTable<CR>', opts)
vim.api.nvim_set_keymap('n', 'ga', '<Cmd>UnicodeName<CR>', opts)
-- }}}
-- {{{2 nvim-tree config
require('nvim-web-devicons').setup()
vim.g.nvim_tree_disable_netrw = 0
vim.g.nvim_tree_hijack_netrw = 0
vim.api.nvim_set_keymap('n', '<Leader>x', '<Cmd>NvimTreeToggle<CR>', opts)
-- }}}
-- {{{2 nvim-colorizer config
require('colorizer').setup {
  '*';
  css = {
    css = true;
    css_fn = true;
  };
  html = {
    names = false;
  }
}
-- }}}
-- {{{2 colortemplate config
vim.g.colortemplate_toolbar = 0
-- }}}
-- {{{2 colorschemes
-- {{{3 artesanal
vim.g.artesanal_dimmed = false
vim.g.artesanal_transparent = true
-- }}}
-- {{{3 edge
vim.g.edge_style = 'neon'
vim.g.edge_enable_italic = true
vim.g.edge_transparent_background = true
vim.g.edge_diagnostic_line_highlight = true
vim.g.edge_diagnostic_text_highlight = true
vim.g.edge_current_word = 'bold'
-- }}}
-- {{{3 one-nvim
vim.g.one_nvim_transparent_bg = true
-- }}}
if vim.fn.filereadable(vim.fn.expand('$HOME/.config/colours/nvim_theme.lua')) == 1 then
  vim.cmd[[luafile $HOME/.config/colours/nvim_theme.lua]]
else
  vim.cmd[[colorscheme slate]]
end
-- }}}
-- {{{2 statusline
require('statusline')
-- }}}
-- }}}1 ------------------- PLUGIN SETTINGS ------------------------------------
-- {{{1 --------------------- MAPPINGS -----------------------------------------
vim.api.nvim_set_keymap('', 'cd', '<Cmd>cd %:h | pwd<CR>', opts)
-- {{{2 editing
vim.api.nvim_set_keymap('n', '<Leader>ev', '<Cmd>edit $MYVIMRC<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>sv', '<Cmd>luafile $MYVIMRC<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>w', '<Cmd>w!<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>wa', '<Cmd>wa!<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>q', '<Cmd>q!<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>qa', '<Cmd>qa!<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>wqa', '<Cmd>wqa!<CR>', opts)
vim.api.nvim_set_keymap('n', ',ul', '<Cmd>undolist<CR>', opts)
-- }}}
-- {{{2 buffers
vim.api.nvim_set_keymap('n', '<Tab>', '<Cmd>bnext<CR>', opts)
vim.api.nvim_set_keymap('n', '<S-Tab>', '<Cmd>bprev<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader><Leader>', '<C-^>', opts)
vim.api.nvim_set_keymap('n', '<Leader>bd', '<Cmd>bdelete<CR>', opts)
-- }}}
-- {{{2 tabs
vim.api.nvim_set_keymap('n', '<Leader>td', '<Cmd>tabclose<CR>', opts)
-- }}}
-- {{{2 terminals
vim.api.nvim_set_keymap('n', '<Leader>t', [[<Cmd> split term://$SHELL<CR>]], opts)
vim.api.nvim_set_keymap('n', '<Leader>vt', [[<Cmd> vnew term://$SHELL<CR>]], opts)
-- }}}
--{{{2 signatures
vim.api.nvim_set_keymap('n', '<Leader>sa', [[ 1G:s#\(Stefan Wimmer\) <.*>#\1 <stefan@tangoartisan.com>#<CR> G?--<CR> jVGd :r $HOME/.mutt/short-signature-artisan<CR> /^To:<CR> ]] , opts)
vim.api.nvim_set_keymap('n', '<Leader>sg', [[ 1G:s#\(Stefan Wimmer\) <.*>#\1 <wimstefan@gmail.com>#<CR> G?--<CR> jVGd :r ~/.mutt/short-signature-gmail<CR> /^To:<CR> ]], opts)
vim.api.nvim_set_keymap('n', '<Leader>st', [[ G?--<CR>jVGd :r ~/.mutt/short-signature-tango<CR> ]], opts)
vim.api.nvim_set_keymap('n', '<Leader>ss', [[ G?--<CR>jVGd :r ~/.mutt/short-signature<CR> ]], opts)
vim.api.nvim_set_keymap('n', '<Leader>sl', [[ G?--<CR>jVGd :r ~/.mutt/signature<CR> ]], opts)
-- }}}
-- {{{2 toggle to disable mouse mode and indentlines for easier paste
ToggleMouse = function()
  if vim.o.mouse == 'a' then
    vim.wo.signcolumn='no'
    vim.o.mouse = 'v'
    vim.wo.number = false
    vim.wo.relativenumber = false
    print("Mouse disabled")
  else
    vim.wo.signcolumn='yes'
    vim.o.mouse = 'a'
    vim.wo.number = true
    vim.wo.relativenumber = true
    print("Mouse enabled")
  end
end
vim.api.nvim_set_keymap('n', '<F10>', '<Cmd>lua ToggleMouse()<CR>', { noremap = true })
-- }}}
-- {{{2 Completion
-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
-- }}}
-- {{{2 abbreviations
vim.api.nvim_exec([[
" generic
inoreabbrev dATE <C-R>=strftime("%Y-%m-%d")<CR>

" english
inoreabbrev grz Greetz, Stefan
inoreabbrev ky Kindly yours,<CR>Stefan

" nederlands
inoreabbrev mvg Met vriendelijke groet,<CR>Stefan
inoreabbrev vg Vriendelijke groet,<CR>Stefan
inoreabbrev lg Lieve groet,<CR>Stefan

" deutsch
inoreabbrev AL Alles Liebe,<CR>Stefan
inoreabbrev LG Lieben Gruß,<CR>Stefan
inoreabbrev VG Mit wohlwollendem Gruß,<CR>Stefan
]], false)
-- }}}
-- }}}1 --------------------- MAPPINGS -----------------------------------------
-- {{{1 --------------------- AUTOCMDS -----------------------------------------
vim.api.nvim_exec([[
  augroup help
    autocmd!
    autocmd WinNew * let w:new = 1
    autocmd FileType help,man if exists('w:new') | unlet w:new | wincmd L | vertical resize 84 | endif
  augroup END
]], false)
vim.api.nvim_exec([[
  augroup Terminal
    autocmd!
    autocmd TermOpen * startinsert
    autocmd TermOpen * set nonumber norelativenumber nolist
  augroup END
  ]], false)
vim.api.nvim_exec([[
augroup RC
  autocmd!

  " Automatically chmod +x Shell and Perl scripts
  autocmd BufWritePost {*.sh,*.pl,*.py} silent !chmod +x %

  " Commentstrings
  autocmd FileType xdefaults setlocal commentstring=!\%s

  " mail specific configuration
  autocmd BufRead /tmp/mutt* silent! %s/^\([>|]\s\?\)\+/\=substitute(submatch(0), '\s', '', 'g').' '
  autocmd BufRead /tmp/mutt* set nonumber nohls nolist filetype=mail formatoptions=tcroqwln21
  autocmd BufRead /tmp/mutt* setlocal spell
  autocmd FileType mail setlocal commentstring=>\%s
  autocmd FileType mail setlocal wildignore-=*.tar.*,*.png,*.jpg,*.gif

  " Syntax for tmux
  autocmd BufNewFile,BufRead *tmux*conf* set filetype=tmux

  " Syntax for htp files
  autocmd BufNewFile,BufRead {*.htp,*.htt} set filetype=xhtml

  " Syntax for xmp files
  autocmd BufNewFile,BufRead {*.xmp} set filetype=xml

  " Syntax for fvwm files
  autocmd BufNewFile,BufRead */.fvwm*/* set filetype=fvwm syntax=fvwm

  " Syntax for Xorg log files
  autocmd BufNewFile,BufRead *Xorg*log* set filetype=msmessages

  " Syntax for rofi themes
  autocmd BufNewFile,BufRead {*.rasi} set filetype=css

  " Change fileformat on playlist files (created by moc)
  autocmd BufNewFile,BufRead *.m3u set encoding=utf-8 fileencoding=utf-8 ff=unix

  " run xrdb whenever Xdefaults or Xresources are updated
  autocmd BufWritePost X{resources,defaults} silent !xrdb %

  " Encoding for cddb files
  autocmd BufNewFile,BufRead *cddb* set encoding=utf-8 fileencoding=utf-8 ff=unix

  " Enable spelling for text files
  " autocmd BuFNewFile,BufRead {*.txt,*.md,*.adoc,*.asciidoc,*.rst} if &filetype !~ 'man\|help\|*doc' | setlocal spell | endif
  autocmd FileType {text,markdown,asciidoc*,rst} if &filetype !~ 'man\|help' | setlocal spell | endif

  " Disable numbers & spell inside manpages
  autocmd FileType {man,help,*doc} setlocal nonumber norelativenumber nospell nolist nocursorcolumn

  " Enable hyphen in css/html completion and disable uppercase tag completion
  " autocmd FileType css,html setlocal iskeyword+=- noignorecase

  " Correct comment highlighting for json config
  autocmd FileType json syntax match Comment +\/\/.\+$+

  " Disable folding in previews
  autocmd BufWinEnter * if &previewwindow | setlocal nofoldenable | endif

  " Remember last cursor position
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' |   exe "normal! g`\"" | endif

augroup END
]], false)
-- }}}1 --------------------- AUTOCMDS -----------------------------------------
-- {{{1 --------------------- FUNCTIONS ----------------------------------------
function _G.inspect(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end
-- }}}1 --------------------- FUNCTIONS ----------------------------------------
-- vim: foldmethod=marker foldlevel=0
