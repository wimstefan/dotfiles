--------------------- MY PERSONAL NEOVIM CONFIGURATION -------------------------
-- {{{1 --------------------- First things first. ------------------------------
require('impatient')
-- }}}
-- {{{1 --------------------- OPTIONS ------------------------------------------
-- define leader keys
vim.g.mapleader = ' '

local indent = 2

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showtabline = 2
vim.opt.linebreak = true
vim.opt.showbreak = '  » '
vim.opt.conceallevel = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.list = true
vim.opt.listchars = {
  tab = '› ',
  trail = '·',
  eol = '«',
  extends = '>',
  precedes = '<'
}
vim.opt.laststatus = 3
vim.opt.fillchars:append({
  horiz = '─',
  horizup = '┴',
  horizdown = '┬',
  vert = '│',
  vertleft = '┤',
  vertright = '├',
  verthoriz = '┼',
  msgsep = '🮑'
})
vim.opt.mouse = 'a'

vim.opt.shiftwidth = indent
vim.opt.shiftround = true
vim.opt.softtabstop = indent
vim.opt.tabstop = indent
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.gdefault = true
vim.opt.inccommand = 'split'
vim.opt.selection = 'exclusive'
vim.opt.pastetoggle = '<F3>'
vim.opt.diffopt:append({
  'vertical',
  'indent-heuristic',
  'algorithm:histogram'
})
vim.opt.spellfile = vim.fn.stdpath('config') .. '/spell/myspell.utf-8.add'
vim.opt.spelllang = {
  'en',
  'de',
  'es',
  'nl'
}
vim.opt.spelloptions = 'camel'
vim.opt.nrformats:append({
  'alpha'
})
if vim.fn.executable('ugrep') == 1 then
  vim.opt.grepprg = 'ugrep -RIjnkz --hidden --ignore-files --exclude-dir=".git"'
  vim.opt.grepformat = '%f:%l:%c:%m,%f+%l+%c+%m,%-G%f\\|%l\\|%c\\|%m'
elseif vim.fn.executable('git') == 1 then
  vim.opt.grepprg = 'git'
elseif vim.fn.executable('ack') == 1 then
  vim.opt.grepprg = 'ack --nogroup --column --smart-case --nocolor --follow $*'
end
vim.opt.keywordprg = ':help'

vim.opt.timeoutlen = 500
vim.opt.updatetime = 100
vim.opt.autowrite = true
vim.opt.backup = false
vim.opt.backupcopy = 'auto'
vim.opt.writebackup = true
vim.opt.undofile = true
vim.opt.modelineexpr = true

vim.g.netrw_winsize = 20
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 0
vim.g.netrw_alto = 0

-- Visual configuration options
-- symbols --
My_Symbols = {
  Array = ' ', -- '謹',
  Boolean = ' ', --'ﬧ ',
  Class = ' ', -- ' ', -- ' ',
  Color = ' ', -- ' ', -- ' ',
  Constant = ' ', -- ' ',
  Constructor = ' ', -- ' ', -- ' ',
  Enum = ' ', -- '練 ', -- ' ',
  EnumMember = ' ', -- ' ',
  Event = ' ', -- ' ', -- ' ',
  Field = ' ', -- ' ', -- ' ',
  File = ' ', -- ' ',
  Folder = ' ', -- ' ',
  Function = ' ', -- ' ',
  Interface = ' ', -- '﨡', -- ' ',
  Keyword = ' ', -- ' ', -- ' ',
  Method = ' ', -- ' ',
  Module = ' ', -- ' ',
  Namespace = ' ', -- ' ',
  Number = ' ', -- '濫',
  Object = '謹',
  Operator = '璉 ', -- ' ',
  Package = ' ', -- ' ',
  Property = ' ', -- ' ', -- ' ',
  Reference = ' ', -- ' ', -- ' ' -- ' ',
  Snippet = ' ', -- ' ', -- ' ',
  Struct = ' ', --'פּ ', -- ' ',
  Text = ' ', -- ' ',
  TypeParameter = ' ', -- ' ', -- ' ', -- ' ',
  Unit = ' ', -- '塞 ', -- 'ﰩ '  --' ',
  Value = ' ', -- ' ',
  Variable = ' ', -- ' ', -- ' ',
}
-- borders --
-- My_Borders = { '╤', '═', '╤', '│', '╧', '═', '╧', '│' }
-- My_Borders = { '╓', '─', '╖', '║', '╜', '─', '╙', '║' }
-- My_Borders = { '┯', '━', '┯', '│', '┷', '━', '┷', '│' }
-- My_Borders = { '┎', '─', '┒', '┃', '┚', '─', '┖', '┃' }
-- My_Borders = { '┬', '─', '┬', '│', '┴', '─', '┴', '│' }
My_Borders = 'rounded'

-- diagnostic handling
local diagnostic_signs = { '', '', '', '' }
local diagnostic_severity_fullnames = { 'Error', 'Warning', 'Information', 'Hint' }
local diagnostic_severity_shortnames = { 'Error', 'Warn', 'Info', 'Hint' }
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
vim.diagnostic.config({
  float = {
    border = My_Borders,
    header = '',
    focusable = false,
    scope = 'cursor',
    source = 'always'
  },
  virtual_text = false
})
vim.keymap.set('n', ',de', function()
  vim.diagnostic.enable()
  vim.notify('Diagnostics enabled', vim.log.levels.INFO, { title = '[LSP]' })
end,
  { desc = 'Diagnostic: enable' })
vim.keymap.set('n', ',dd', function()
  vim.diagnostic.disable()
  vim.notify('Diagnostics disabled', vim.log.levels.INFO, { title = '[LSP]' })
end,
  { desc = 'Diagnostic: disable' })
vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev({ float = false }) end,
  { desc = 'Diagnostic: got to previous error' })
vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next({ float = false }) end,
  { desc = 'Diagnostic: got to next error' })
vim.keymap.set('n', ',df', vim.diagnostic.open_float, { desc = 'Diagnostic: open floating window' })
vim.keymap.set('n', ',dl', vim.diagnostic.setloclist, { desc = 'Diagnostic: populate location list' })
vim.keymap.set('n', ',dq', vim.diagnostic.setqflist, { desc = 'Diagnostic: populate quickfix' })

-- filetype handling
vim.filetype.add({
  extension = {
    conf = 'config',
    config = 'config',
    htp = 'xhtml',
    htt = 'xhtml',
    rc = 'rc',
    xmp = 'xml',
  },
  pattern = {
    ['/tmp/mutt.*'] = 'mail',
    ['/tmp/.*tangoartisan.*'] = 'html',
    ['/tmp/.*voswimmer.nl.*'] = 'html',
    ['~/%.mutt/.*rc'] = 'muttrc',
  },
})

-- }}}1 --------------------- OPTIONS ------------------------------------------
-- {{{1 --------------------- MAPPINGS -----------------------------------------
vim.keymap.set('', 'cd', [[<Cmd>cd %:h | pwd<CR>]])
vim.keymap.set('n', '<Leader>g', [[:grep<Space>]])
vim.keymap.set('n', '<C-l>', [[<Cmd>set nohlsearch|diffupdate|highlight clear ColorColumn|normal! <C-l><CR>]])
vim.keymap.set('n', 'M', function() ShowMan() end, { desc = 'Search man pages for current word' })
vim.keymap.set('n', '<F10>', function() ToggleDetails() end, { desc = 'Toggle decorations' })
-- {{{2 navigation
vim.keymap.set({ 'n', 'x' }, 'j', function() return vim.v.count > 0 and 'j' or 'gj' end, { expr = true, replace_keycodes = false })
vim.keymap.set({ 'n', 'x' }, 'k', function() return vim.v.count > 0 and 'k' or 'gk' end, { expr = true, replace_keycodes = false })
-- }}}
-- {{{2 editing
vim.keymap.set('n', '<Leader>ev', [[<Cmd>edit $MYVIMRC<CR>]])
vim.keymap.set('n', '<Leader>sv', [[<Cmd>luafile $MYVIMRC<CR>]])
vim.keymap.set('n', '<Leader>w', [[<Cmd>w!<CR>]])
vim.keymap.set('n', '<Leader>wa', [[<Cmd>wa!<CR>]])
vim.keymap.set('n', '<Leader>q', [[<Cmd>q!<CR>]])
vim.keymap.set('n', '<Leader>qa', [[<Cmd>qa!<CR>]])
vim.keymap.set('n', '<Leader>wqa', [[<Cmd>wqa!<CR>]])
vim.keymap.set('n', 'cn', '*``cgn')
vim.keymap.set('n', 'cN', '*``cgN')
-- }}}
-- {{{2 buffers
vim.keymap.set('n', '<Tab>', vim.cmd.bnext)
vim.keymap.set('n', '<S-Tab>', vim.cmd.bprev)
vim.keymap.set('n', '<Leader><Leader>', '<C-^>')
vim.keymap.set('n', '<Leader>bd', vim.cmd.bdelete)
-- }}}
-- {{{2 tabs
vim.keymap.set('n', '<Leader>td', vim.cmd.tabclose)
-- }}}
-- {{{2 terminals
vim.keymap.set('t', '<Esc>', [[<C-\><C-N>]])
vim.keymap.set('t', '<A-h>', [[<C-\><C-N><C-w>h]])
vim.keymap.set('t', '<A-j>', [[<C-\><C-N><C-w>j]])
vim.keymap.set('t', '<A-k>', [[<C-\><C-N><C-w>k]])
vim.keymap.set('t', '<A-l>', [[<C-\><C-N><C-w>l]])
-- }}}
-- {{{2 quickfix
vim.keymap.set('n', '<C-c>', function() ToggleQF('q') end, { desc = 'Toggle quickfix window' })
vim.keymap.set('n', '<A-c>', function() ToggleQF('l') end, { desc = 'Toggle location list window' })
vim.keymap.set('n', '[\\', vim.cmd.colder)
vim.keymap.set('n', ']\\', vim.cmd.cnewer)
-- }}}
-- {{{2 signatures
vim.keymap.set('n', '<Leader>sa',
  [[1G:s#\(Stefan Wimmer\) <.*>#\1 <stefan@tangoartisan.com>#<CR>G?--<CR>jVGd :r ~/.mutt/short-signature-artisan<CR>/^To:<CR>]])
vim.keymap.set('n', '<Leader>sg',
  [[1G:s#\(Stefan Wimmer\) <.*>#\1 <wimstefan@gmail.com>#<CR>G?--<CR>jVGd :r ~/.mutt/short-signature-gmail<CR>/^To:<CR>]])
vim.keymap.set('n', '<Leader>st', [[G?--<CR>jVGd :r ~/.mutt/short-signature-tango<CR>]])
vim.keymap.set('n', '<Leader>ss', [[G?--<CR>jVGd :r ~/.mutt/short-signature<CR>]])
vim.keymap.set('n', '<Leader>sl', [[G?--<CR>jVGd :r ~/.mutt/signature<CR>]])
-- }}}
-- }}}1 --------------------- MAPPINGS -----------------------------------------
-- {{{1 --------------------- AUTOCMDS -----------------------------------------
vim.cmd([[
augroup General
  autocmd!
  autocmd BufWritePost *.sh,*.pl,*.py silent !chmod +x %
  autocmd BufNewFile,BufRead *.m3u set encoding=utf-8 fileencoding=utf-8 ff=unix
  autocmd BufWritePost X{resources,defaults} silent !xrdb %
  autocmd BufNewFile,BufRead *cddb* set encoding=utf-8 fileencoding=utf-8 ff=unix
  autocmd FileType txt,markdown,asciidoc*,rst,gitcommit if &filetype !~ 'man\|help' | setlocal spell | endif
  autocmd FileType help,man,startuptime,qf,lspinfo,checkhealth nnoremap <buffer><silent>q :bdelete<CR>
  autocmd BufWinEnter * if &previewwindow | setlocal nofoldenable | endif
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | execute "normal! g`\"" | endif
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup='WildMenu', timeout=4444}
augroup END
augroup Commentstrings
  autocmd!
  autocmd FileType pfmain,toml set commentstring=#\%s
  autocmd FileType vifm set commentstring=\"\ %s
  autocmd FileType xdefaults set commentstring=!\%s
  autocmd FileType json syntax match Comment +\/\/.\+$+
augroup END
augroup Help
  autocmd!
  autocmd BufWinEnter * if &filetype =~ 'help' | wincmd L | vertical resize 84 | endif
  autocmd BufWinEnter * if &filetype =~ 'man' | wincmd L | wincmd = | endif
  autocmd FileType man,help,*doc setlocal nonumber norelativenumber nospell nolist nocursorcolumn
augroup END
augroup Colors
  autocmd!
  autocmd ColorScheme * highlight clear ColorColumn
  autocmd ColorScheme,VimEnter,WinEnter,BufEnter * call v:lua.NotifyColors()
augroup END
]])
vim.cmd(string.format([[
augroup Packer
  autocmd!
  autocmd VimEnter call v:lua.require('packer').sync()
  autocmd FileType packer set previewheight=30
  autocmd FileType git set nolist nonumber norelativenumber
  autocmd BufWritePost init.lua if expand('%s') =~ '%s' || expand('%s') =~ '%s' && expand('%s') !~ 'fugitive\|scp' | source <afile> | call v:lua.require('packer').sync() | endif
augroup end
]], '%:p', vim.fn.stdpath('config'), '%:p', vim.fn.getenv('HOME') .. '/.dotfiles/', '%'))
-- }}}1 --------------------- AUTOCMDS -----------------------------------------
-- {{{1 --------------------- FUNCTIONS ----------------------------------------
function Dump(...)
  vim.pretty_print(...)
end

function NotifyColors()
  vim.cmd.highlight('link NotifyERRORBorder DiagnosticVirtualTextError')
  vim.cmd.highlight('link NotifyWARNBorder DiagnosticVirtualTextWarn')
  vim.cmd.highlight('link NotifyINFOBorder DiagnosticVirtualTextInfo')
  vim.cmd.highlight('link NotifyDEBUGBorder PmenuSel')
  vim.cmd.highlight('link NotifyTRACEBorder DiagnosticVirtualTextHint')
  vim.cmd.highlight('link NotifyERRORIcon DiagnosticSignError')
  vim.cmd.highlight('link NotifyWARNIcon DiagnosticSignWarn')
  vim.cmd.highlight('link NotifyINFOIcon DiagnosticSignInfo')
  vim.cmd.highlight('link NotifyDEBUGIcon ModeMsg')
  vim.cmd.highlight('link NotifyTRACEIcon DiagnosticSignHint')
  vim.cmd.highlight('link NotifyERRORTitle DiagnosticError')
  vim.cmd.highlight('link NotifyWARNTitle DiagnosticWarn')
  vim.cmd.highlight('link NotifyINFOTitle DiagnosticInfo')
  vim.cmd.highlight('link NotifyDEBUGTitle ModeMsg')
  vim.cmd.highlight('link NotifyTRACETitle DiagnosticHint')
  vim.cmd.highlight('link NotifyERRORBody Normal')
  vim.cmd.highlight('link NotifyWARNBody Normal')
  vim.cmd.highlight('link NotifyINFOBody Normal')
  vim.cmd.highlight('link NotifyDEBUGBody Normal')
  vim.cmd.highlight('link NotifyTRACEBody Normal')
end

-- {{{2 toggle detailed information for easier paste
function ToggleDetails()
  local mouse_opts = vim.api.nvim_get_option_value('mouse', {})
  if mouse_opts == 'a' then
    vim.opt.mouse = 'v'
    vim.opt.cursorcolumn = false
    vim.opt.cursorline = false
    vim.opt.signcolumn = 'no'
    vim.opt.foldenable = false
    vim.opt.list = false
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.colorcolumn = ''
    vim.notify('Details disabled', vim.log.levels.INFO, { title = '[UI]' })
  else
    vim.opt.mouse = 'a'
    vim.opt.cursorcolumn = true
    vim.opt.cursorline = true
    vim.opt.signcolumn = 'yes'
    vim.opt.foldenable = true
    vim.opt.list = true
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.colorcolumn = '80'
    vim.notify('Details enabled', vim.log.levels.INFO, { title = '[UI]' })
  end
end

-- }}}

-- {{{2 quickfix/location toggle made by iBaghwan
function TableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function FindQF(type)
  local wininfo = vim.fn.getwininfo()
  local win_tbl = {}
  for _, win in pairs(wininfo) do
    local found = false
    if type == 'l' and win['loclist'] == 1 then
      found = true
    end
    if type == 'q' and win['quickfix'] == 1 and win['loclist'] == 0 then
      found = true
    end
    if found then
      table.insert(win_tbl, { winid = win['winid'], bufnr = win['bufnr'] })
    end
  end
  return win_tbl
end

function OpenQF()
  local qf_name = 'quickfix'
  local qf_empty = function() return vim.tbl_isempty(vim.fn.getqflist()) end
  if not qf_empty() then
    vim.cmd.copen()
    vim.cmd.wincmd('J')
  else
    print(string.format('%s is empty.', qf_name))
  end
end

function OpenLoclistAll()
  local wininfo = vim.fn.getwininfo()
  local qf_name = 'loclist'
  local qf_empty = function(winnr) return vim.tbl_isempty(vim.fn.getloclist(winnr)) end
  for _, win in pairs(wininfo) do
    if win['quickfix'] == 0 then
      if not qf_empty(win['winnr']) then
        vim.api.nvim_set_current_win(win['winid'])
        vim.cmd.lopen()
      else
        print(string.format('%s is empty.', qf_name))
      end
    end
  end
end

function ToggleQF(type)
  local windows = FindQF(type)
  if TableLength(windows) > 0 then
    for _, win in pairs(windows) do
      vim.api.nvim_win_hide(win.winid)
    end
  else
    if type == 'l' then
      OpenLoclistAll()
    else
      OpenQF()
    end
  end
end

-- }}}

-- {{{2 show manpage of current word
function ShowMan()
  local cword = vim.fn.expand('<cword>')
  vim.cmd.Man(cword)
end

-- }}}

-- }}}1 --------------------- FUNCTIONS ----------------------------------------
-- {{{1 --------------------- PLUGINS ------------------------------------------
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/shadmansaleh/packer.nvim', install_path })
end

local packer = require('packer')
local use = packer.use
packer.startup(function()
  packer.init({
    compile_path = vim.fn.stdpath('config') .. '/lua/packer_compiled.lua',
    display = {
      open_cmd = '84vnew [packer]',
      working_sym = '北 ',
      error_sym = '✗  ',
      done_sym = '✓  ',
      removed_sym = '  ',
      moved_sym = '-> ',
      prompt_border = My_Borders
    }
  })
  -- {{{2 packer.nvim
  use({
    'shadmansaleh/packer.nvim',
    config = function()
      vim.keymap.set('n', ',pc', vim.cmd.PackerClean)
      vim.keymap.set('n', ',pi', vim.cmd.PackerInstall)
      vim.keymap.set('n', ',pq', vim.cmd.PackerStatus)
      vim.keymap.set('n', ',ps', vim.cmd.PackerSync)
      vim.keymap.set('n', ',pu', vim.cmd.PackerUpdate)
    end
  })
  -- }}}
  -- {{{2 impatient.nvim
  use('lewis6991/impatient.nvim')
  -- }}}
  -- {{{2 FixCursorHold.nvim
  use('antoinemadec/FixCursorHold.nvim')
  -- }}}
  -- {{{2 startuptime
  use('dstein64/vim-startuptime')
  -- }}}
  -- {{{2 Treesitter
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      'windwp/nvim-ts-autotag',
      'p00f/nvim-ts-rainbow',
      'JoosepAlviste/nvim-ts-context-commentstring'
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        auto_install = true,
        autotag = {
          enable = true
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false
        },
        highlight = {
          enable = true
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
          },
        },
        indent = {
          enable = false
        },
        rainbow = {
          enable = true,
          extended_mode = true
        },
        refactor = {
          highlight_current_scope = { enable = false },
          highlight_definitions = { enable = true },
          navigation = {
            enable = true,
            keymaps = {
              goto_definition = 'gnd',
              list_definitions_lsp_fallback = 'gnD',
              list_definitions_toc = 'gO',
              goto_next_usage = '<a-*>',
              goto_previous_usage = '<a-#>'
            }
          },
          smart_rename = {
            enable = true,
            keymaps = {
              smart_rename = 'grr'
            }
          }
        },
        textobjects = {
          lookahead = true,
          lsp_interop = {
            enable = true,
            border = My_Borders,
            peek_definition_code = {
              ['df'] = '@function.outer',
              ['dF'] = '@class.outer'
            }
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['aa'] = '@attribute.outer',
              ['ia'] = '@attribute.inner',
              ['ab'] = '@block.outer',
              ['ib'] = '@block.inner',
              ['at'] = '@call.outer',
              ['it'] = '@call.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['a/'] = '@comment.outer',
              ['i/'] = '@comment.inner',
              ['ai'] = '@conditional.outer',
              ['ii'] = '@conditional.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
              ['ap'] = '@parameter.outer',
              ['ip'] = '@parameter.inner',
            }
          }
        }
      })
    end
  })
  -- }}}
  -- {{{2 Telescope
  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make'
      }
    },
    config = function()
      vim.keymap.set('n', '<Leader>t', require('telescope.builtin').builtin, { desc = 'Telescope: builtin' })
      vim.keymap.set('n', '<Leader>b', require('telescope.builtin').buffers, { desc = 'Telescope: buffers' })
      vim.keymap.set('n', '<Leader>c', require('telescope.builtin').colorscheme, { desc = 'Telescope: colorschemes' })
      vim.keymap.set('n', '<Leader>f', require('telescope.builtin').find_files, { desc = 'Telescope: find files' })
      vim.keymap.set('n', '<Leader>o', require('telescope.builtin').oldfiles, { desc = 'Telescope: oldfiles' })
      vim.keymap.set('n', '<Leader>tg', function() require('telescope.builtin').live_grep({ grep_open_files = true }) end
        , { desc = 'Telescope: grep current file' })
      vim.keymap.set('n', '<Leader>tG', require('telescope.builtin').live_grep, { desc = 'Telescope: grep all files' })
      vim.keymap.set('n', '<Leader>h', require('telescope.builtin').help_tags, { desc = 'Telescope: help' })
      vim.keymap.set('n', '<Leader>M', require('telescope.builtin').man_pages, { desc = 'Telescope: man' })
      vim.keymap.set('n', '<Leader>m', require('telescope.builtin').marks, { desc = 'Telescope: marks' })
      vim.keymap.set('n', '<Leader>r', require('telescope.builtin').registers, { desc = 'Telescope: registers' })
      vim.keymap.set('n', '<Leader>tgb', require('telescope.builtin').git_bcommits,
        { desc = 'Telescope: git buffer commits' })
      vim.keymap.set('n', '<Leader>tgc', require('telescope.builtin').git_commits, { desc = 'Telescope: git commits' })
      vim.keymap.set('n', '<Leader>tgf', require('telescope.builtin').git_files, { desc = 'Telescope: git files' })
      vim.keymap.set('n', '<Leader>tgs', require('telescope.builtin').git_status, { desc = 'Telescope: git status' })
      vim.keymap.set('n', '<Leader>tc', require('telescope.builtin').command_history,
        { desc = 'Telescope: command history' })
      vim.keymap.set('n', '<Leader>tf', require('telescope.builtin').filetypes, { desc = 'Telescope: filetypes' })
      vim.keymap.set('n', '<Leader>tm', require('telescope.builtin').keymaps, { desc = 'Telescope: keymaps' })
      vim.keymap.set('n', '<Leader>tq', require('telescope.builtin').quickfix, { desc = 'Telescope: quickfix' })
      vim.keymap.set('n', '<Leader>ts', require('telescope.builtin').spell_suggest, { desc = 'Telescope: spell suggest' })
      vim.keymap.set('n', '<Leader>tw', require('telescope.builtin').grep_string, { desc = 'Telescope: grep string' })
      vim.keymap.set('n', '<Leader>tz', require('telescope.builtin').current_buffer_fuzzy_find,
        { desc = 'Telescope: fuzzy find buffer' })
      require('telescope').setup({
        defaults = {
          prompt_prefix = '∷ ',
          selection_caret = '» ',
          dynamic_preview_title = true,
          wrap_results = true,
          file_ignore_patterns = { '^.git/', 'db', 'gif', 'jpeg', 'jpg', 'ods', 'odt', 'pdf', 'png', 'svg', 'xcf', 'xls' },
          layout_strategy = 'bottom_pane',
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position = 'top',
            center = {
              mirror = true
            },
            horizontal = {
              anchor = 'NE',
              height = 0.99,
              width = 0.66,
              preview_width = 0.55
            },
            vertical = {
              anchor = 'NE',
              width = 0.50,
              height = 0.99,
              preview_cutoff = 4,
              preview_height = 0.66,
              mirror = true
            },
          },
          mappings = {
            i = {
              ['<C-h>'] = 'which_key',
              ['<C-w>'] = require('telescope.actions.layout').toggle_preview,
              ['<C-q>'] = require('telescope.actions').smart_send_to_qflist + require('telescope.actions').open_qflist,
              ['<M-q>'] = require('telescope.actions').smart_add_to_qflist + require('telescope.actions').open_qflist,
            },
            n = {
              ['<C-h>'] = 'which_key',
              ['<C-w>'] = require('telescope.actions.layout').toggle_preview,
              ['<C-q>'] = require('telescope.actions').smart_send_to_qflist + require('telescope.actions').open_qflist,
              ['<M-q>'] = require('telescope.actions').smart_add_to_qflist + require('telescope.actions').open_qflist,
            },
          },
          preview = {
            msg_bg_fillchar = '░',
          },
          vimgrep_arguments = {
            'ugrep',
            '-RIjnkz',
            '--color=never',
            '--hidden',
            '--ignore-files',
            '--exclude-dir=".git"'
          }
        },
        pickers = {
          builtin = {
            layout_strategy = 'vertical',
            previewer = false
          },
          colorscheme = {
            theme = 'dropdown',
            enable_preview = true
          },
          diagnostics = {
            layout_strategy = 'vertical'
          },
          find_files = {
            find_command = { 'fd', '--exclude', '.git/' },
            follow = true,
            hidden = true,
            no_ignore = false
          },
          filetypes = {
            theme = 'dropdown'
          },
          git_branches = {
            layout_strategy = 'vertical'
          },
          lsp_declarations = {
            layout_strategy = 'vertical'
          },
          lsp_definitions = {
            layout_strategy = 'vertical'
          },
          lsp_implementations = {
            layout_strategy = 'vertical'
          },
          lsp_references = {
            layout_strategy = 'vertical'
          },
          oldfiles = {
            layout_strategy = 'vertical',
            previewer = false
          },
          spell_suggest = {
            theme = 'cursor',
            layout_config = {
              height = 14
            }
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case'
          }
        }
      })
      require('telescope').load_extension('fzf')
    end
  })
  -- }}}
  -- {{{2 nvim-cmp
  use({
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      {
        'saadparwaiz1/cmp_luasnip',
        requires = {
          'L3MON4D3/LuaSnip',
          'honza/vim-snippets'
        }
      },
      'f3fora/cmp-spell'
    },
    config = function()
      require('luasnip/loaders/from_snipmate').lazy_load()
      local cmp = require('cmp')
      local cmp_buffer = require('cmp_buffer')
      local luasnip = require('luasnip')
      luasnip.filetype_extend('all', { '_' })

      local check_backspace = function()
        local col = vim.fn.col '.' - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s'
      end

      vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
      cmp.setup({
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = true,
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            if entry.source.name == 'nvim_lsp' then
              vim_item.menu = '<' .. entry.source.source.client.name .. '>'
            else
              vim_item.menu = '[' .. entry.source.name .. ']'
            end
            vim_item.kind = My_Symbols[vim_item.kind]
            return vim_item
          end
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-10), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(10), { 'i', 'c' }),
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-e>'] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          },
          ['<CR>'] = cmp.config.disable,
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif check_backspace() then
              fallback()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lua' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip' },
          {
            name = 'path',
            option = {
              trailing_slash = true
            }
          },
          {
            name = 'buffer',
            option = {
              get_bufnrs = function()
                local buf = vim.api.nvim_get_current_buf()
                local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                if byte_size > 2048 * 2048 then
                  return {}
                end
                return { buf }
              end
            }
          },
          { name = 'spell' },
        }),
        sorting = {
          comparators = {
            function(...) return cmp_buffer:compare_locality(...) end,
          }
        }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          {
            name = 'path',
            option = {
              trailing_slash = true
            }
          },
        }, {
          { name = 'nvim_lua' }
        }, {
          { name = 'cmdline' }
        })
      })
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'buffer' }
        })
      })
    end
  })
  -- }}}
  -- {{{2 LSP
  use({
    'neovim/nvim-lspconfig',
    requires = {
      'folke/lua-dev.nvim',
      {
        'kosayoda/nvim-lightbulb',
        config = function()
          vim.fn.sign_define('LightBulbSign', { text = ' ', texthl = 'WarningMsg', linehl = '', numhl = '' })
          vim.cmd([[autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]])
          require('nvim-lightbulb').update_lightbulb()
        end
      },
      {
        'stevearc/aerial.nvim',
        config = function()
          require('aerial').setup({
            placement_editor_edge = true,
            icons = My_Symbols,
            on_attach = function(bufnr)
              vim.keymap.set('n', '<Leader>a', require('aerial').toggle, { buffer = bufnr }, { desc = 'LSP: aerial outline toggle' })
              vim.keymap.set('n', '{', vim.cmd.AerialPrev, { buffer = bufnr }, { desc = 'LSP: aerial jump backwards' })
              vim.keymap.set('n', '}', vim.cmd.AerialNext, { buffer = bufnr }, { desc = 'LSP: aerial jump forewards' })
              vim.keymap.set('n', '{{', vim.cmd.AerialPrevUp, { buffer = bufnr }, { desc = 'LSP: aerial jump up tree level' })
              vim.keymap.set('n', '}}', vim.cmd.AerialNextUp, { buffer = bufnr }, { desc = 'LSP: aerial jump down tree level' })
            end
          })
          require('telescope').load_extension('aerial')
        end
      },
      {
        'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        config = function()
          require('lsp_lines').setup()
          vim.keymap.set('', ',ll', require('lsp_lines').toggle, { desc = 'LSP: toggle lsp_lines' })
        end,
      },
    },
    config = function()
      local lsp_aerial = require('aerial')
      local lsp_cmp = require('cmp_nvim_lsp')
      local lsp_config = require('lspconfig')

      -- LSP handlers
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
        { border = My_Borders })
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = My_Borders })

      -- LSP functions
      local on_attach = function(client, bufnr)
        lsp_aerial.on_attach(client, bufnr)
        local lsp_messages = ''
        local lsp_msg_sep = ' ∷ '
        lsp_messages = lsp_msg_sep .. 'LSP attached' .. lsp_msg_sep
        -- options
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        -- keybindings
        vim.keymap.set('n', ',lR', require('telescope.builtin').lsp_definitions, { desc = 'LSP: definitions' },
          { buffer = bufnr })
        vim.keymap.set('n', ',lr', require('telescope.builtin').lsp_references, { desc = 'LSP: references' },
          { buffer = bufnr })
        vim.keymap.set('n', ',ly', require('telescope.builtin').lsp_document_symbols,
          { desc = 'LSP: document symbols' }, { buffer = bufnr })
        vim.keymap.set('n', ',lY', require('telescope.builtin').lsp_workspace_symbols,
          { desc = 'LSP: workspace symbols' }, { buffer = bufnr })
        vim.keymap.set('n', ',ld', function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end,
          { desc = 'LSP: document diagnostics' }, { buffer = bufnr })
        vim.keymap.set('n', ',lD', require('telescope.builtin').diagnostics,
          { desc = 'LSP: workspace diagnostics' }, { buffer = bufnr })
        vim.keymap.set('n', ',lrn', vim.lsp.buf.rename, { desc = 'LSP: rename' }, { buffer = bufnr })
        vim.keymap.set('n', ',lw', function() Dump(vim.lsp.buf.list_workspace_folders()) end,
          { desc = 'LSP: list workspace folders' }, { buffer = bufnr })
        if client.server_capabilities.codeActionProvider then
          vim.keymap.set('n', ',lca', vim.lsp.buf.code_action,
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
          vim.keymap.set('n', ',lf', function() vim.lsp.buf.format({ async = true }) end,
            { desc = 'LSP: formatting' }, { buffer = bufnr })
        else
          lsp_messages = lsp_messages .. 'no format' .. lsp_msg_sep
        end
        if client.server_capabilities.documentRangeFormattingProvider then
          vim.keymap.set({ 'v', 'x' }, ',lf', ':<C-u>call v:lua.vim.lsp.buf.range_formatting()<CR>',
            { desc = 'LSP: range formatting' }, { buffer = bufnr })
        else
          lsp_messages = lsp_messages .. 'no rangeFormat' .. lsp_msg_sep
        end
        if client.server_capabilities.implementationProvider then
          vim.keymap.set('n', ',li', vim.lsp.buf.implementation, { desc = 'LSP: implementation' }, { buffer = bufnr })
        else
          vim.keymap.set('n', ',li', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no implementation' .. lsp_msg_sep
        end
        if client.server_capabilities.hoverProvider then
          vim.keymap.set('n', ',lh', vim.lsp.buf.hover, { desc = 'LSP: hover' }, { buffer = bufnr })
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
          vim.keymap.set('n', ',ltd', vim.lsp.buf.type_definition, { desc = 'LSP: type definition' }, { buffer = bufnr })
        else
          vim.keymap.set('n', ',ltd', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no typeDefinition' .. lsp_msg_sep
        end

        -- autocmds
        if client.server_capabilities.codeLensProvider then
          vim.keymap.set('n', ',ll', function() vim.lsp.buf.codelens.run({ border = My_Borders }) end,
            { desc = 'LSP: code lens' }, { buffer = bufnr })
          vim.cmd([[autocmd BufEnter,CursorHold,InsertLeave * lua vim.lsp.codelens.refresh()]])
        else
          lsp_messages = lsp_messages .. 'no codeLens' .. lsp_msg_sep
        end

        -- messages
        vim.notify(lsp_messages, vim.log.levels.INFO, { title = '[LSP]' })
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
      capabilities = lsp_cmp.update_capabilities(capabilities)

      -- LSP servers
      local servers = {
        bashls = {
          filetypes = {
            'sh',
            'bash',
            'zsh'
          }
        },
        cssls = {},
        html = {
          filetypes = {
            'html',
            'html-eex',
            'liquid'
          }
        },
        jsonls = {},
        marksman = {},
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

      -- lua
      local sumneko_binary = vim.fn.stdpath('data') .. '/lspconfig/lua-language-server/bin/lua-language-server'
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, 'lua/?.lua')
      table.insert(runtime_path, 'lua/?/init.lua')
      local lua_dev = require('lua-dev').setup({
        library = {
          vimruntime = true,
          types = true,
          plugins = true
        },
        lspconfig = {
          capabilities = capabilities,
          cmd = { sumneko_binary },
          on_attach = on_attach,
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
                path = runtime_path
              },
              diagnostics = {
                enable_check_codestyle = true,
                globals = {
                  'packer_plugins',
                  'use',
                  'vim'
                },
                neededFileStatus = {
                  codestyle_check = 'Any'
                }
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
              workspace = {
                library = {
                  vim.api.nvim_get_runtime_file('', true)
                },
                preloadFileSize = 500
              },
              telemetry = {
                enable = false
              },
            },
          }
        }
      })
      lsp_config.sumneko_lua.setup(lua_dev)

    end
  })
  -- }}}
  -- {{{2 which-key.nvim
  use({
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup({
        plugins = {
          spelling = {
            enabled = true,
            suggestions = 40
          }
        }
      })
    end
  })
  -- }}}
  -- {{{2 vim-fugitive
  use({
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<Leader>gc', [[<Cmd>Git commit -v %<CR>]])
      vim.keymap.set('n', '<Leader>gd', [[<Cmd>Gdiffsplit<CR>]])
      vim.keymap.set('n', '<Leader>gl', [[<Cmd>0Gclog!<CR>]])
      vim.keymap.set('n', '<Leader>gp', [[<Cmd>Git push<CR>]])
      vim.keymap.set('n', '<Leader>gs', [[<Cmd>Git<CR>]])
    end
  })
  -- }}}
  -- {{{2 vim-obsession
  use({
    'tpope/vim-obsession',
    config = function()
      vim.keymap.set('n', ',to', vim.cmd.Obsession)
    end
  })
  -- }}}
  -- {{{2 vim-repeat
  use('tpope/vim-repeat')
  -- }}}
  -- {{{2 vim-unimpaired
  use('tpope/vim-unimpaired')
  -- }}}
  -- {{{2 leap.nvim
  use({
    'ggandor/leap.nvim',
    config = function()
      require('leap').set_default_keymaps()
    end
  })
  -- }}}
  -- {{{2 spellsitter.nvim
  use({
    'lewis6991/spellsitter.nvim',
    config = function()
      require('spellsitter').setup()
    end
  })
  -- }}}
  -- {{{2 hover.nvim
  use({
    'lewis6991/hover.nvim',
    config = function()
      require('hover').setup {
        init = function()
          require('hover.providers.lsp')
          require('hover.providers.man')
        end,
        preview_opts = {
          border = nil
        },
        title = true
      }
      vim.keymap.set('n', 'H', require('hover').hover, { desc = 'hover.nvim' })
      vim.keymap.set('n', 'gH', require('hover').hover_select, { desc = 'hover.nvim (select)' })
    end
  })
  -- }}}
  -- {{{2 nvim-retrail
  use({
    'zakharykaplan/nvim-retrail',
    config = function()
      require('retrail').setup({
        hlgroup = 'Substitute'
      })
    end
  })
  -- }}}
  -- {{{2 nvim-surround
  -- Lua
  use({
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup()
    end
  })
  -- }}}
  -- {{{2 Comment.nvim
  use({
    'numToStr/Comment.nvim',
    config = function()
      vim.keymap.set('x', 'gci', [[:g/./lua require('Comment.api').toggle.linewise.current()<CR><Cmd>nohls<CR>]],
        { silent = true },
        { desc = 'Invert comments' })
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
      })
    end
  })
  -- }}}
  -- {{{2 text-case.nvim
  use({
    'johmsalas/text-case.nvim',
    config = function()
      require('textcase').setup()
    end
  })
  -- }}}
  -- {{{2 nvim-bqf
  use({
    'kevinhwang91/nvim-bqf',
    config = function()
      vim.api.nvim_command([[packadd cfilter]])
      require('bqf').setup({
        auto_enable = true,
        auto_resize_height = true
      })
    end
  })
  -- }}}
  -- {{{2 nvim-hlslens
  use({
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup()
      vim.opt.shortmess:append('S')
      vim.keymap.set('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        { desc = 'Hlslens: n' })
      vim.keymap.set('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        { desc = 'Hlslens: N' })
      vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], { desc = 'Hlslens: *' })
      vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], { desc = 'Hlslens: #' })
      vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], { desc = 'Hlslens: g*' })
      vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], { desc = 'Hlslens: g#' })
    end
  })
  -- }}}
  -- {{{2 zk-nvim
  use({
    'mickael-menu/zk-nvim',
    config = function()
      local zk = require('zk')
      local commands = require('zk.commands')
      local function make_edit_fn(defaults, picker_options)
        return function(options)
          options = vim.tbl_extend('force', defaults, options or {})
          zk.edit(options, picker_options)
        end
      end

      require('telescope').load_extension('zk')
      zk.setup({
        picker = 'telescope'
      })

      commands.add('ZkRecents', make_edit_fn({ createdAfter = '1 week ago' }, { title = 'Zk Recents' }))

      vim.keymap.set('n', '<Leader>zf', [[<Cmd>ZkNotes { match = vim.fn.input('Search: ') }<CR>]])
      vim.keymap.set('v', '<Leader>zf', [[:'<,'>ZkMatch<CR>]])
      vim.keymap.set('n', '<Leader>zn', [[<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>]])
      vim.keymap.set('n', '<Leader>zl', [[<Cmd>ZkNotes<CR>]])
      vim.keymap.set('n', '<Leader>zr', [[<Cmd>ZkRecents<CR>]])
      vim.keymap.set('n', '<Leader>zt', [[<Cmd>ZkTags<CR>]])
    end
  })
  -- }}}
  -- {{{2 mkdnflow.nvim
  use({
    'jakewvincent/mkdnflow.nvim',
    config = function()
      require('mkdnflow').setup({})
    end
  })
  -- }}}
  -- {{{2 vim-simple-align
  use('kg8m/vim-simple-align')
  -- }}}
  -- {{{2 fm-nvim
  use({
    'is0n/fm-nvim',
    config = function()
      vim.keymap.set('n', '<Leader>z', vim.cmd.Fzf, {})
      vim.keymap.set('n', '<Leader>x', vim.cmd.Vifm, {})
      require('fm-nvim').setup({
        ui = {
          default = 'float',
          float = {
            border = My_Borders,
            float_hl = 'Normal',
            border_hl = 'FloatBorder'
          }
        }
      })
    end
  })
  -- }}}
  -- {{{2 toggleterm.nvim
  use({
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup({
        size = function(term)
          if term.direction == 'horizontal' then
            return vim.o.lines * 0.44
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.44
          end
        end,
        open_mapping = [[<C-\>]],
        shade_terminals = false,
        direction = 'float',
        float_opts = {
          border = My_Borders
        }
      })
      vim.keymap.set('n', '<Leader>Tf', [[<Cmd>ToggleTerm direction=float<CR>]])
      vim.keymap.set('n', '<Leader>Th', [[<Cmd>ToggleTerm direction=horizontal<CR>]])
      vim.keymap.set('n', '<Leader>Tv', [[<Cmd>ToggleTerm direction=vertical<CR>]])
    end
  })
  -- }}}
  -- {{{2 nvim-osc52
use({
  'ojroques/nvim-osc52',
  config = function()
    require('osc52').setup()
    local function copy()
      if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
        require('osc52').copy_register('"')
      end
    end

    vim.api.nvim_create_autocmd('TextYankPost', { callback = copy })
  end
})
  -- }}}
  -- {{{2 nvim-spectre
  use({
    'windwp/nvim-spectre',
    config = function()
      require('spectre').setup({
        find_engine = {
          ['rg'] = {
            cmd = 'ugrep',
            args = {
              '-RIjnkz',
              '--color=never',
              '--ignore-files',
              '--exclude-dir=".git"'
            },
            options = {
              ['ignore-case'] = {
                value = '--ignore-case',
                icon = '[I]',
                desc = 'ignore case'
              },
              ['hidden'] = {
                value = '--hidden',
                desc = 'hidden file',
                icon = '[H]'
              },
            }
          }
        }
      })
      vim.keymap.set('n', '<Leader>S', require('spectre').open, { desc = 'Open spectre' })
    end
  })
  -- }}}
  -- {{{2 undotree
  use({
    'jiaoshijie/undotree',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('undotree').setup({
        float_diff = true,
        ignore_filetype = { 'Undotree', 'UndotreeDiff', 'qf', 'TelescopePrompt', 'spectre_panel' },
        window = {
          winblend = 0,
        },
        keymaps = {
          ['j'] = "move_next",
          ['k'] = "move_prev",
          ['J'] = "move_change_next",
          ['K'] = "move_change_prev",
          ['<cr>'] = "action_enter",
          ['p'] = "enter_diffbuf",
          ['q'] = "quit",
        }
      })
      vim.keymap.set('n', ',tu', require('undotree').toggle, { desc = 'Undo tree' })
    end
  })
  -- }}}
  -- {{{2 vim-dirdiff
  use('will133/vim-dirdiff')
  -- }}}
  -- {{{2 paperplanes.nvim
  use({
    'rktjmp/paperplanes.nvim',
    config = function()
      require('paperplanes').setup({
        register = '+',
        provider = 'dpaste.org',
        provider_options = { 'https' },
        cmd = 'curl'
      })
    end
  })
  -- }}}
  -- {{{2 vim-renamer
  use('qpkorr/vim-renamer')
  -- }}}
  -- {{{2 vim-gnupg
  use('jamessan/vim-gnupg')
  -- }}}
  -- {{{2 vim-log-highlighting
  use({
    'MTDL9/vim-log-highlighting',
    ft = 'log'
  })
  -- }}}
  -- {{{2 rasi.vim
  use({
    'Fymyte/rasi.vim',
    ft = 'rasi',
  })
  -- }}}
  -- {{{2 unicode.vim
  use({
    'chrisbra/unicode.vim',
    config = function()
      vim.keymap.set('n', '<Leader>ut', vim.cmd.UnicodeTable)
      vim.keymap.set('n', 'gu', vim.cmd.UnicodeName)
    end
  })
  -- }}}
  -- {{{2 Visuals
  -- {{{3 nvim-highlight-colors
  use({
    'brenoprata10/nvim-highlight-colors',
    config = function()
      vim.keymap.set('n', ',tc', vim.cmd.HighlightColorsToggle)
      require('nvim-highlight-colors').setup({
        render = 'background'
      })
    end
  })
  -- }}}
  -- {{{3 nvim-web-devicons
  use({
    'wimstefan/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup({
        padding = true
      })
    end
  })
  -- }}}
  -- {{{3 nvim-nonicons
  use({
    'yamatsum/nvim-nonicons',
    requires = 'wimstefan/nvim-web-devicons'
  })
  -- }}}
  -- {{{3 lush.nvim
  use('rktjmp/lush.nvim')
  -- }}}
  -- {{{3 artesanal
  use({
    'wimstefan/vim-artesanal',
    config = function()
      vim.g.artesanal_dimmed = false
      vim.g.artesanal_transparent = true
    end
  })
  -- }}}
  -- {{{3 nightfox.nvim
  use({
    'EdenEast/nightfox.nvim',
    config = function()
      require('nightfox').setup({
        options = {
          transparent = true,
          dim_inactive = true,
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
  })
  -- }}}
  -- {{{3 zenbones.nvim
  use({
    'mcchrish/zenbones.nvim',
    requires = {
      'rktjmp/lush.nvim',
      'rktjmp/shipwright.nvim'
    },
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
  })
  -- }}}
  -- {{{3 onedark.nvim
  use({
    'navarasu/onedark.nvim',
    config = function()
      require('onedark').setup({
        transparent = true,
        code_style = {
          comments = 'italic',
          keywords = 'none',
          functions = 'bold',
          strings = 'none',
          variables = 'none'
        },
        diagnostics = {
          background = false
        },
        toggle_style_key = ',tos',
        toggle_style_list = { 'cool', 'deep', 'light' },
      })
    end
  })
  -- }}}
  -- {{{3 lualine.nvim
  use({
    'nvim-lualine/lualine.nvim',
    config = function()
      if vim.fn.filereadable(vim.fn.expand('$HOME/.config/colours/nvim_theme.lua')) == 1 then
        vim.api.nvim_command [[luafile $HOME/.config/colours/nvim_theme.lua]]
      else
        vim.api.nvim_command [[colorscheme desert]]
      end
      local check_width = function()
        return vim.fn.winwidth(0) > 100
      end
      local check_width_wide = function()
        return vim.fn.winwidth(0) > 140
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
          for _, progress in pairs(client.messages.progress) do
            if not progress.done then
              msg = progress.title
              if progress.message then
                msg = msg .. ' ' .. progress.message
              end
              if progress.percentage then
                msg = string.format('%s%2d%s', '⸢', progress.percentage, '%%⸥')
              end
              return msg
            end
          end
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
        filetypes = { 'help', 'packer', 'qf' }
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
              color = { fg = 'yellow' },
            },
          },
          lualine_x = {
            {
              'aerial',
              cond = check_width_wide
            },
            {
              lsp_status,
              cond = check_width
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
            },
            {
              'branch',
              icon = 'שׂ '
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
          lualine_c = { 'buffers' },
          lualine_b = { get_path },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            {
              'tabs',
              mode = 2
            }
          }
        },
        extensions = { 'aerial', 'fugitive', 'fzf', 'man', minimal_extension, 'quickfix', 'toggleterm' },
      })
    end
  })
  -- }}}
  -- {{{3 gitsigns.nvim
  use({
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup({
        signs = {
          add = {
            hl = 'GitSignsAdd',
            numhl = 'GitSignsAddNr',
            show_count = true
          },
          change = {
            hl = 'GitSignsChange',
            numhl = 'GitSignsChangeNr',
            show_count = true
          },
          delete = {
            hl = 'GitSignsDelete',
            numhl = 'GitSignsDeleteNr',
            show_count = true
          },
          topdelete = {
            hl = 'GitSignsDelete',
            numhl = 'GitSignsDeleteNr',
            show_count = true
          },
          changedelete = {
            hl = 'GitSignsChange',
            numhl = 'GitSignsChangeNr',
            show_count = true
          }
        },
        count_chars = {
          [1] = '¹',
          [2] = '²',
          [3] = '³',
          [4] = '⁴',
          [5] = '⁵',
          [6] = '⁶',
          [7] = '⁷',
          [8] = '⁸',
          [9] = '⁹',
          ['+'] = '⁺'
        },
        numhl = true,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          vim.keymap.set('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true, replace_keycodes = false },
            { desc = 'Gitsigns: next hunk' })
          vim.keymap.set('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true, replace_keycodes = false },
            { desc = 'Gitsigns: previous hunk' })
          vim.keymap.set('n', ',sp', gs.preview_hunk, { desc = 'Gitsigns: preview hunk' }, { buffer = bufnr })
          vim.keymap.set('n', ',sb', function() gs.blame_line { full = true } end, { desc = 'Gitsigns: blame line' },
            { buffer = bufnr })
          vim.keymap.set('n', ',sd', gs.diffthis, { desc = 'Gitsigns: diffthis' }, { buffer = bufnr })
          vim.keymap.set('n', ',sD', function() gs.diffthis('~') end, { desc = 'Gitsigns: diffthis ~' },
            { buffer = bufnr })
          vim.keymap.set('n', ',ss', gs.stage_hunk, { desc = 'Gitsigns: stage hunk' }, { buffer = bufnr })
          vim.keymap.set('n', ',su', gs.undo_stage_hunk, { desc = 'Gitsigns: undo stage hunk' }, { buffer = bufnr })
          vim.keymap.set('n', ',sx', gs.toggle_deleted, { desc = 'Gitsigns: toggle deleted' }, { buffer = bufnr })
        end,
        preview_config = {
          border = My_Borders,
        }
      })
    end
  })
  -- }}}
  -- {{{3 nvim-ufo
  use({
    'kevinhwang91/nvim-ufo',
    requires = 'kevinhwang91/promise-async',
    config = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldcolumn = 'auto:5'
      vim.opt.fillchars:append({
        foldsep = '🮍',
        foldopen = '',
        foldclose = ''
      })
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
        close_fold_kinds = {'imports', 'comment'},
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
          return {'treesitter', 'indent'}
        end
      })
      local bufnr = vim.api.nvim_get_current_buf()
      require('ufo').setFoldVirtTextHandler(bufnr, handler)
    end
  })
  -- }}}
  -- {{{3 indent-blankline.nvim
  use({
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup({
        char = '▏',
        filetype_exclude = {
          'help',
          'man',
          'diagnosticpopup',
          'lspinfo',
          'packer',
          'TelescopePrompt',
          'TelescopeResults',
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
        },
      })
      vim.keymap.set('n', ',ti', vim.cmd.IndentBlanklineToggle)
    end
  })
  -- }}}
  -- {{{3 virt-column.nvim
  use({
    'lukas-reineke/virt-column.nvim',
    config = function()
      vim.opt.colorcolumn = '80'
      require('virt-column').setup({
        char = '▕',
      })
    end
  })
  -- }}}
  -- {{{3 nvim-notify
  use({
    'rcarriga/nvim-notify',
    config = function()
      local highlights = require('notify.config.highlights')
      function highlights.setup()
        NotifyColors()
      end

      require('notify').setup({
        stages = 'static',
        timeout = 2000,
        background_colour = function()
          local group_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('Normal')), 'bg#')
          if group_bg == '' or group_bg == 'none' then
            group_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('Float')), 'bg#')
            if group_bg == '' or group_bg == 'none' then
              return '#000000'
            end
          end
          return group_bg
        end,
        icons = {
          ERROR = ' ',
          WARN = ' ',
          INFO = ' ',
          DEBUG = ' ',
          TRACE = '變'
        }
      })
      vim.notify = require('notify')
      vim.keymap.set('n', '<Leader>tn', require('telescope').extensions.notify.notify,
        { desc = 'Telescope: notify' })
    end
  })
  -- }}}
  -- {{{3 dressing.nvim
  use({
    'stevearc/dressing.nvim',
    config = function()
      require('dressing').setup({
        input = {
          enable = true,
          override = function(conf)
            conf.col = -1
            conf.row = 0
            return conf
          end,
          winblend = 0,
          winhighlight = 'Normal:ModeMsg,FloatBorder:TelescopeBorder'
        },
        select = {
          enable = true,
          telescope = require('telescope.themes').get_cursor {
            layout_config = {
              height = function(self, _, max_lines)
                local results = #self.finder.results
                local PADDING = 4
                local LIMIT = math.floor(max_lines / 2)
                return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
              end,
            },
          },
          winblend = 0,
          winhighlight = 'Normal:ModeMsg,FloatBorder:TelescopeBorder'
        },
      })
    end
  })
  -- }}}
  -- }}}
end)
require('packer_compiled')
-- }}}1 --------------------- PLUGINS ------------------------------------------
-- vim: foldmethod=marker foldlevel=0
