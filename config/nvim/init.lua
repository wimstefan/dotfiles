--------------------- MY PERSONAL NEOVIM CONFIGURATION -------------------------
-- {{{1 --------------------- CREDITS ------------------------------------------
----------------- mjlbach for encouraging me to switch to lua ------------------
---------- elianiva for the inspiration for statusline and lazy-loading --------
--------------- All involved developers for their tremendous work! ----- 1}}} --
-- {{{1 --------------------- OPTIONS ------------------------------------------
-- disable unused built-in plugins
vim.g.loaded_2html_plugin = false
vim.g.loaded_matchit      = false
vim.g.loaded_matchparen   = false
vim.g.loaded_spec         = false

local indent = 2

-- define leader keys
vim.g.mapleader = ' '

vim.bo.expandtab = true
vim.bo.nrformats = vim.bo.nrformats .. ',alpha'
vim.bo.shiftwidth = indent
vim.bo.smartindent = true
vim.bo.softtabstop = indent
vim.bo.spellfile = vim.fn.stdpath('config') .. '/spell/myspell.utf-8.add'
vim.bo.spelllang = [[en,de,es,nl]]
vim.bo.tabstop = indent
vim.o.autowrite = true
vim.o.backupcopy = 'auto'
vim.o.backup = false
vim.o.breakindent = true
vim.o.completeopt = [[menuone,noinsert,noselect]]
vim.o.diffopt = vim.o.diffopt .. ',vertical,indent-heuristic,algorithm:histogram'
vim.o.fillchars = [[vert:█,foldclose:▾,foldopen:▴,foldsep:🮍,msgsep:⁘]]
if vim.fn.executable('ugrep') == 1 then
  vim.o.grepprg = 'ugrep -RInk -j -u --tabs=1'
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
vim.o.timeoutlen = 500
vim.o.updatetime = 300
vim.o.writebackup = true
vim.wo.cursorcolumn = true
vim.wo.cursorline = true
vim.wo.foldcolumn = 'auto:4'
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
vim.api.nvim_command[[set undofile]]
vim.g.netrw_winsize = 14
vim.g.netrw_banner =  0
vim.g.netrw_liststyle =  3
vim.g.netrw_preview =  0
vim.g.netrw_alto =  0
-- }}}1 --------------------- OPTIONS ------------------------------------------
-- {{{1 --------------------- MAPPINGS -----------------------------------------
vim.api.nvim_set_keymap('', 'cd', '<Cmd>cd %:h | pwd<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>g', ':grep ', {noremap = true, silent = false})
vim.api.nvim_set_keymap('n', '<Leader>l', ':set hlsearch!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>x', '<Cmd>Lexplore<CR>', {noremap = true, silent = true})
-- {{{2 editing
vim.api.nvim_set_keymap('n', '<Leader>ev', '<Cmd>edit $MYVIMRC<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>sv', '<Cmd>luafile $MYVIMRC<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>w', '<Cmd>w!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>wa', '<Cmd>wa!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>q', '<Cmd>q!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>qa', '<Cmd>qa!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>wqa', '<Cmd>wqa!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', ',ul', '<Cmd>undolist<CR>', {noremap = true, silent = true})
-- }}}
-- {{{2 buffers
vim.api.nvim_set_keymap('n', '<Tab>', '<Cmd>bnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-Tab>', '<Cmd>bprev<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader><Leader>', '<C-^>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>bd', '<Cmd>bdelete<CR>', {noremap = true, silent = true})
-- }}}
-- {{{2 tabs
vim.api.nvim_set_keymap('n', '<Leader>td', '<Cmd>tabclose<CR>', {noremap = true, silent = true})
-- }}}
-- {{{2 terminals
vim.api.nvim_set_keymap('n', '<Leader>t', [[<Cmd> split term://$SHELL<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>vt', [[<Cmd> vnew term://$SHELL<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-N>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<A-h>', [[<C-\><C-N><C-w>h]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<A-j>', [[<C-\><C-N><C-w>j]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<A-k>', [[<C-\><C-N><C-w>k]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<A-l>', [[<C-\><C-N><C-w>l]], {noremap = true, silent = true})
-- }}}
--{{{2 signatures
vim.api.nvim_set_keymap('n', '<Leader>sa', [[ 1G:s#\(Stefan Wimmer\) <.*>#\1 <stefan@tangoartisan.com>#<CR> G?--<CR> jVGd :r ~/.mutt/short-signature-artisan<CR> /^To:<CR> ]] , {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>sg', [[ 1G:s#\(Stefan Wimmer\) <.*>#\1 <wimstefan@gmail.com>#<CR> G?--<CR> jVGd :r ~/.mutt/short-signature-gmail<CR> /^To:<CR> ]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>st', [[ G?--<CR>jVGd :r ~/.mutt/short-signature-tango<CR> ]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>ss', [[ G?--<CR>jVGd :r ~/.mutt/short-signature<CR> ]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>sl', [[ G?--<CR>jVGd :r ~/.mutt/signature<CR> ]], {noremap = true, silent = true})
-- }}}
-- {{{2 toggle to disable mouse mode and indentlines for easier paste
ToggleMouse = function()
  if vim.o.mouse == 'a' then
    vim.wo.signcolumn='no'
    vim.o.mouse = 'v'
    vim.wo.number = false
    vim.wo.relativenumber = false
    print('Mouse disabled')
  else
    vim.wo.signcolumn='yes'
    vim.o.mouse = 'a'
    vim.wo.number = true
    vim.wo.relativenumber = true
    print('Mouse enabled')
  end
end
vim.api.nvim_set_keymap('n', '<F10>', '<Cmd>lua ToggleMouse()<CR>', { noremap = true })
-- }}}
-- {{{2 abbreviations
vim.api.nvim_exec([[
" generic
inoreabbrev dATE <C-R>=strftime('%Y-%m-%d')<CR>
inoreabbrev svw stefan@vos-wimmer.nl
inoreabbrev kvw komala@vos-wimmer.nl

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

  " Reload $MYVIMRC after changes
  autocmd BufWritePost init.lua luafile $MYVIMRC

  " Automatically chmod +x Shell and Perl scripts
  autocmd BufWritePost {*.sh,*.pl,*.py} silent !chmod +x %

  " Commentstrings
  autocmd FileType pfmain set commentstring=#\%s
  autocmd FileType toml set commentstring=#\%s
  autocmd FileType xdefaults set commentstring=!\%s

  " mail specific configuration
  autocmd BufRead /tmp/mutt* silent! %s/^\([>|]\s\?\)\+/\=substitute(submatch(0), '\s', '', 'g').' '
  autocmd BufRead /tmp/mutt* %s/\s\+$//e
  autocmd BufRead /tmp/mutt* %s/^>\n>/>/e
  autocmd BufRead /tmp/mutt* setlocal nonumber nohls nolist filetype=mail formatoptions=tcroqwln21
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
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | execute "normal! g`\"" | endif

  " Enable yank highlighting
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup='WildMenu', timeout=800}

augroup END
]], false)
-- }}}1 --------------------- AUTOCMDS -----------------------------------------
-- {{{1 --------------------- FUNCTIONS ----------------------------------------
function _G.inspect(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end
-- }}}1 --------------------- FUNCTIONS ----------------------------------------
-- {{{1 --------------------- PLUGINS ------------------------------------------
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.api.nvim_command[[packadd packer.nvim]]
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd FileType packer set previewheight=36
    autocmd BufWritePost init.lua PackerCompile
    autocmd User PackerComplete luafile $MYVIMRC
  augroup end
]], false)

local packer = require('packer')
local use = packer.use
packer.startup(function()
  packer.init({
    display = {
      open_cmd = '84vnew [packer]',
      working_sym = '… '
    }
  })
-- {{{2 packer.nvim
  use {
    'wbthomason/packer.nvim',
    opt = true,
    setup = function()
      vim.api.nvim_set_keymap('n', ',pc', '<Cmd>PackerClean<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', ',pi', '<Cmd>PackerInstall<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', ',pq', '<Cmd>PackerStatus<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', ',ps', '<Cmd>PackerSync<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', ',pu', '<Cmd>PackerUpdate<CR>', {noremap = true, silent = true})
    end
  }
-- }}}
-- {{{2 LSP
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'kabouzeid/nvim-lspinstall',
      'nvim-lua/lsp-status.nvim',
      'onsails/lspkind-nvim',
      {'RishabhRD/nvim-lsputils', requires = 'RishabhRD/popfix'},
      {'folke/trouble.nvim', requires = 'folke/lsp-colors.nvim'}
    },
    config = function()
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
      lsp_install.post_install_hook = function()
        setup_servers()
        vim.api.nvim_command[[bufdo e]] -- this triggers the FileType autocmd that starts the server
      end
    end
  }
-- }}}
-- {{{2 Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufRead',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = 'maintained',
        autotag = {
          enable = true
        },
        highlight = {
          enable = true,
          use_languagetree = true
        },
        incremental_selection = {
          enable = true
        },
        indent = {
          enable = false
        },
        matchup = {
          enable = true
        }
      }
    end
  }
  use {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    after = 'nvim-treesitter'
  }
-- }}}
-- {{{2 Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
        config = function()
          require('telescope').load_extension('fzf')
        end
      }
    },
    config = function()
      vim.api.nvim_set_keymap('n', '<Leader>T', [[<Cmd>lua require('telescope.builtin').builtin(require('telescope.themes').get_dropdown({previewer = false}))<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>b', [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>c', [[<Cmd>lua require('telescope.builtin').colorscheme(require('telescope.themes').get_dropdown({}))<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>f', [[<Cmd>lua require('telescope.builtin').find_files({follow = true})<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>h', [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>M', [[<Cmd>lua require('telescope.builtin').man_pages()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>m', [[<Cmd>lua require('telescope.builtin').marks()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>r', [[<Cmd>lua require('telescope.builtin').registers()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Tgb', [[<Cmd>lua require('telescope.builtin').git_bcommits()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Tgc', [[<Cmd>lua require('telescope.builtin').git_commits()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Tgf', [[<Cmd>lua require('telescope.builtin').git_files()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Tgs', [[<Cmd>lua require('telescope.builtin').git_status()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Tf', [[<Cmd>lua require('telescope.builtin').filetypes(require('telescope.themes').get_dropdown({}))<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Tg', [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Tm', [[<Cmd>lua require('telescope.builtin').keymaps()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Ts', [[<Cmd>lua require('telescope.builtin').spell_suggest()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Tw', [[<Cmd>lua require('telescope.builtin').grep_string()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_exec([[
        augroup Telescope
          autocmd!
          autocmd User TelescopePreviewerLoaded setlocal wrap
        augroup END
      ]], false)
      require('telescope').setup {
        defaults = {
          dynamic_preview_title = true,
          file_ignore_patterns = {'gif', 'jpeg', 'jpg', 'pdf', 'png', 'svg'},
          layout_strategy = 'flex',
          mappings = {
            i = {
              ['<C-n>'] = require('telescope.actions').cycle_previewers_next,
              ['<C-p>'] = require('telescope.actions').cycle_previewers_prev,
              ['<C-s>'] = require('telescope.actions').select_horizontal,
              ['<Tab>'] = require('telescope.actions').toggle_selection,
              ['<C-t>'] = require('trouble.providers.telescope').open_with_trouble,
              ['<C-q>'] = require('telescope.actions').smart_send_to_qflist +require('telescope.actions').open_qflist,
              ['<M-q>'] = require('telescope.actions').smart_add_to_qflist +require('telescope.actions').open_qflist,
            },
            n = {
              ['<C-t>'] = require('trouble.providers.telescope').open_with_trouble,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                            -- the default case_mode is "smart_case"
          }
        }
      }
    end
  }
-- }}}
-- {{{2 which-key.nvim
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {
        window = { border = "double" }
      }
    end
  }
-- }}}
-- {{{2 nvim-compe
  use {
    'hrsh7th/nvim-compe',
    event = 'InsertEnter',
    wants = 'LuaSnip',
    requires = {
      {
        'L3MON4D3/LuaSnip',
        after = 'nvim-compe',
        event = 'InsertCharPre',
        wants = 'friendly-snippets',
        config = function()
          require('luasnip').config.set_config({
            history = true,
            updateevents = 'TextChanged,TextChangedI'
          })
          require('luasnip/loaders/from_vscode').load()
        end
      },
      {
        'rafamadriz/friendly-snippets',
        event = 'InsertCharPre'
      },
      {
        'andersevenrud/compe-tmux',
        event = 'InsertEnter'
      }
    },
    config = function()
      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end
      local check_back_space = function()
          local col = vim.fn.col('.') - 1
          return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end
      _G.tab_complete = function()
        if vim.fn.pumvisible() == 1 then
          return t '<C-n>'
        elseif require('luasnip').expand_or_jumpable() then
          return t '<Plug>luasnip-expand-or-jump'
        elseif check_back_space() then
          return t '<Tab>'
        else
          return vim.fn['compe#complete']()
        end
      end
      _G.s_tab_complete = function()
        if vim.fn.pumvisible() == 1 then
          return t '<C-p>'
        elseif require('luasnip').jumpable(-1) then
          return t '<Plug>luasnip-jump-prev'
        else
          return t '<S-Tab>'
        end
      end
      vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', {expr = true})
      vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', {expr = true})
      vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
      vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
      vim.api.nvim_set_keymap('i', '<C-Space>', [[compe#complete()]], {silent = true, expr = true})
      vim.api.nvim_set_keymap('i', '<CR>', [[compe#confirm('<CR>')]], {silent = true, expr = true})
      vim.api.nvim_set_keymap('i', '<C-e>', [[compe#close('<C-e>')]], {silent = true, expr = true})
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
        documentation = {
          border = "rounded",
          winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
          max_width = 120,
          min_width = 60,
          max_height = math.floor(vim.o.lines * 0.3),
          min_height = 1,
        },
        source = {
          buffer = true,
          calc = true,
          luasnip = true,
          nvim_lsp = true,
          nvim_lua = true,
          omni = false,
          path = true,
          spell = true,
          tags = false,
          tmux = {
            all_panes = true
          },
          treesitter = true
        }
      }
    end
  }
-- }}}
-- {{{2 vim-abolish
  use {
    'tpope/vim-abolish',
    event = 'BufRead'
  }
-- }}}
-- {{{2 vim-commentary
  use {
    'tpope/vim-commentary',
    keys = {'gci', 'gc'},
    config = function()
      vim.api.nvim_set_keymap('v', 'gci', ':g/./Commentary<CR>', {noremap = false, silent = false})
    end
  }
-- }}}
-- {{{2 vim-eunuch
  use {'tpope/vim-eunuch', cmd = {'Delete', 'Unlink', 'Remove', 'Move', 'Rename', 'Chmod', 'Mkdir', 'Sudo'}}
-- }}}
-- {{{2 vim-fugitive
  use {
    'tpope/vim-fugitive',
    cmd = {'Git', 'Gdiffsplit', 'Gclog'},
    setup = function()
      vim.api.nvim_set_keymap('n', '<Leader>gc', '<Cmd>Git commit -v %<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>gd', '<Cmd>Gdiffsplit<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>gl', '<Cmd>0Gclog!<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>gp', '<Cmd>Git push<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>gs', '<Cmd>Git<CR>', {noremap = true, silent = true})
    end
  }
-- }}}
-- {{{2 vim-obsession
  use {
    'tpope/vim-obsession',
    cmd = 'Obsession',
    setup = function()
      vim.api.nvim_set_keymap('n', ',to', '<Cmd>Obsession<CR>', {noremap = true, silent = true})
    end
  }
-- }}}
-- {{{2 vim-repeat
  use {
    'tpope/vim-repeat',
    event = 'BufRead'
  }
-- }}}
-- {{{2 vim-unimpaired
  use {
    'tpope/vim-unimpaired',
    event = 'BufRead'
  }
-- }}}
-- {{{2 gitsigns.nvim
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'plenary.nvim',
    },
    event = 'BufRead',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = {
            hl = 'GitSignsAdd',
            show_count = true,
            numhl = 'GitSignsAddNr'
          },
          change = {
            hl = 'GitSignsChange',
            numhl = 'GitSignsChangeNr'},
          delete = {
            hl = 'GitSignsDelete',
            show_count = true,
            numhl = 'GitSignsDeleteNr'
          },
          topdelete = {
            hl = 'GitSignsDelete',
            show_count = true,
            numhl = 'GitSignsDeleteNr'
          },
          changedelete = {
            hl = 'GitSignsChange',
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
    end
  }
-- }}}
-- {{{2 vim-sandwich
  use {
    'machakann/vim-sandwich',
    after = 'nvim-treesitter',
    keys = 's'
  }
-- }}}
-- {{{2 vim-matchup
  use {
    'andymass/vim-matchup',
    event = 'VimEnter',
    after = 'nvim-treesitter'
  }
-- }}}
-- {{{2 vim-qf
  use {
    'romainl/vim-qf',
    event = {'BufRead', 'QuickFixCmdPre', 'QuickFixCmdPost'},
    config = function()
      vim.g.qf_mapping_ack_style = true
      vim.g.qf_auto_open_quickfix = true
    end,
    setup = function()
      vim.api.nvim_set_keymap('n', '<C-q>', '<Plug>(qf_qf_switch)', {})
      vim.api.nvim_set_keymap('n', '<C-c>', '<Plug>(qf_qf_toggle)', {})
      vim.api.nvim_set_keymap('n', '<F6>', '<Plug>(qf_loc_toggle)', {})
      vim.api.nvim_set_keymap('n', '<Home>', '<Plug>(qf_qf_previous)', {})
      vim.api.nvim_set_keymap('n', '<End>', '<Plug>(qf_qf_next)', {})
      vim.api.nvim_set_keymap('n', '<C-Home>', '<Plug>(qf_loc_previous)', {})
      vim.api.nvim_set_keymap('n', '<C-End>', '<Plug>(qf_loc_next)', {})
    end
  }
-- }}}
-- {{{2 vim-qlist
  use {
    'romainl/vim-qlist',
    event = {'BufRead', 'QuickFixCmdPre', 'QuickFixCmdPost'}
  }
-- }}}
-- {{{2 nvim-bqf
  use {
    'kevinhwang91/nvim-bqf',
    event = {'BufRead', 'QuickFixCmdPre', 'QuickFixCmdPost'},
    config = function()
      require('bqf').setup {
        auto_enable = true
      }
    end
  }
-- }}}
-- {{{2 nvim-spectre
  use {
    'windwp/nvim-spectre',
    config = function()
      require('spectre').setup()
    end,
    setup = function()
      vim.api.nvim_set_keymap('n', '<Leader>S', [[<Cmd>lua require('spectre').open()<CR>]], {noremap = true, silent = true})
    end
  }
-- }}}
-- {{{2 undotree
  use {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = function()
      vim.g.undotree_WindowLayout= 2
      vim.g.undotree_SetFocusWhenToggle= 1
      vim.g.undotree_ShortIndicators= 1
      vim.api.nvim_set_keymap('n', ',tu', '<Cmd>UndotreeToggle<CR>', {})
    end
  }
-- }}}
-- {{{2 vim-dirdiff
  use {
    'will133/vim-dirdiff',
    cmd = 'DirDiff'
  }
-- }}}
-- {{{2 vim-renamer
  use {
    'qpkorr/vim-renamer',
    cmd = {'Ren', 'Renamer'}
  }
-- }}}
-- {{{2 vim-simple-align
  use {
    'kg8m/vim-simple-align',
    cmd = 'SimpleAlign'
  }
-- }}}
-- {{{2 vim-gnupg
  use {'jamessan/vim-gnupg'}
-- }}}
-- {{{2 editorconfig-vim
  use {
    'editorconfig/editorconfig-vim',
    event = 'BufRead'
  }
-- }}}
-- {{{2 startuptime.vim
  use {
    'tweekmonster/startuptime.vim',
    cmd = 'StartupTime'
  }
-- }}}
-- {{{2 vim-asciidoctor
  use {
    'habamax/vim-asciidoctor',
    ft = {'asciidoc', 'asciidoctor'}
  }
-- }}}
-- {{{2 vim-log-highlighting
  use {
    'MTDL9/vim-log-highlighting',
    ft = 'log'
  }
-- }}}
-- {{{2 unicode.vim
  use {
    'chrisbra/unicode.vim',
    config = function()
      vim.g.Unicode_data_directory = vim.fn.stdpath('data') .. '/site/pack/packer/opt/unicode.vim/autoload/unicode/'
    end,
    setup = function()
      vim.api.nvim_set_keymap('n', '<Leader>ut', '<Cmd>UnicodeTable<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', 'ga', '<Cmd>UnicodeName<CR>', {noremap = true, silent = true})
    end
  }
-- }}}
-- {{{2 nvim-colorizer.lua
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
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
    end
  }
-- }}}
-- {{{2 vim-colortemplate
  use {
    'lifepillar/vim-colortemplate',
    setup = function()
      vim.g.colortemplate_toolbar = 0
    end
  }
-- }}}
-- {{{2 Colour schemes
-- {{{3 artesanal
  use 'wimstefan/vim-artesanal'
  vim.g.artesanal_dimmed = false
  vim.g.artesanal_transparent = true
-- }}}
-- {{{3 edge
  use 'sainnhe/edge'
  vim.g.edge_style = 'neon'
  vim.g.edge_enable_italic = 1
  vim.g.edge_transparent_background = 1
  vim.g.edge_diagnostic_line_highlight = 1
  vim.g.edge_diagnostic_text_highlight = 1
  vim.g.edge_diagnostic_virtual_text = 1
  vim.g.edge_current_word = 'bold'
-- }}}
-- {{{3 tokyonight-nvim
  use 'folke/tokyonight.nvim'
  vim.g.tokyonight_italic_functions = 1
  vim.g.tokyonight_sidebars = {'qf', 'netrw', 'terminal'}
  vim.g.tokyonight_dark_float = 1
  vim.g.tokyonight_dark_sidebar = 1
  vim.g.tokyonight_transparent = 1
  vim.g.tokyonight_day_brightness = '0.3'
-- }}}
-- {{{3 material.nvim
  use 'marko-cerovac/material.nvim'
  vim.g.material_italic_comments = true
  vim.g.material_italic_keywords = true
  vim.g.material_italic_functions = false
  vim.g.material_italic_variables = false
  vim.g.material_contrast = false
  vim.g.material_lighter_contrast = true
  vim.g.material_borders = true
  vim.g.material_disable_background = true
  vim.api.nvim_set_keymap('n', '<Leader>mm', [[<Cmd>lua require('material.functions').toggle_style()<CR>]], {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>ml', [[<Cmd>lua require('material.functions').change_style('lighter')<CR>]], {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>md', [[<Cmd>lua require('material.functions').change_style('darker')<CR>]], {noremap = true, silent = true})
-- }}}
-- }}}
end)
-- }}}1 --------------------- PLUGINS ------------------------------------------
-- {{{1 --------------------- VISUALS ------------------------------------------
if vim.fn.filereadable(vim.fn.expand('$HOME/.config/colours/nvim_theme.lua')) == 1 then
  vim.api.nvim_command[[luafile $HOME/.config/colours/nvim_theme.lua]]
else
  vim.api.nvim_command[[colorscheme slate]]
end
require('statusline')
-- }}}1 --------------------- VISUALS ------------------------------------------
-- vim: foldmethod=marker foldlevel=0
