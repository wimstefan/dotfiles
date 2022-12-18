--------------------- MY PERSONAL NEOVIM CONFIGURATION -------------------------
-- {{{1 --------------------- First things first -------------------------------
local is_bootstrap = false
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
  vim.cmd [[packadd packer.nvim]]
else
  local ok, impatient = pcall(require, 'impatient')
  if ok then
    impatient.enable_profile()
  else
    vim.notify(impatient)
  end
end
-- }}}
-- {{{1 --------------------- OPTIONS ------------------------------------------
-- define leader keys
vim.g.mapleader = ' '

local indent = 2
local limited = '80'

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
  'linematch:60',
  'algorithm:histogram'
})
vim.opt.diffopt:remove({
  'internal'
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
  vim.opt.grepprg = 'ugrep -RIjnkzs --hidden --ignore-files --exclude-dir=".git"'
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
  Package = ' ', -- '  ',
  Property = ' ', -- ' ', -- ' ',
  Reference = ' ', -- '  ', -- ' ' -- ' ',
  Snippet = ' ', -- ' ', -- ' ',
  String = ' ',
  Struct = ' ', --'פּ ', -- ' ',
  Text = '  ', -- ' ',
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
    json = 'jsonc',
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
vim.keymap.set({ 'n', 'x' }, 'j', function() return vim.v.count > 0 and 'j' or 'gj' end,
  { expr = true, replace_keycodes = false })
vim.keymap.set({ 'n', 'x' }, 'k', function() return vim.v.count > 0 and 'k' or 'gk' end,
  { expr = true, replace_keycodes = false })
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
local aucmd = vim.api.nvim_create_autocmd
local function augroup(name, fnc)
  fnc(vim.api.nvim_create_augroup(name, { clear = true }))
end

augroup('General', function(g)
  aucmd('BufWritePost', {
    group = g,
    pattern = {
      '*.{,z}sh',
      '*.pl',
      '*.py'
    },
    desc = 'Make files executable',
    callback = function()
      vim.fn.system({ 'chmod', '+x', vim.fn.expand('%') })
    end
  })
  aucmd('BufWritePost', {
    group = g,
    pattern = 'X{resources,defaults}',
    desc = 'Reload X settings',
    callback = function()
      vim.fn.system({ 'xrdb', vim.fn.expand('%') })
    end
  })
  aucmd({ 'BufNewFile', 'BufRead' }, {
    group = g,
    pattern = {
      '*.m3u*',
      '*cddb*'
    },
    desc = 'Format playlist & cddb files',
    callback = function()
      vim.opt_local.encoding = 'utf-8'
      vim.opt_local.fileencoding = 'utf-8'
      vim.opt_local.fileformat = 'unix'
    end
  })
  aucmd('FileType', {
    group = g,
    pattern = {
      'txt',
      'markdown',
      'asciidoc*',
      'rst',
      'gitcommit'
    },
    desc = 'Enable spelling',
    callback = function()
      if not vim.bo.filetype ~= ({ 'man', 'help' }) then
        vim.opt_local.spell = true
      end
    end
  })
  aucmd('FileType', {
    group = g,
    pattern = '*',
    desc = 'Enable colorcolumn',
    callback = function()
      if not (
        vim.bo.filetype == 'man'
        or vim.bo.filetype == 'help'
        or vim.bo.filetype == 'noice'
        or vim.bo.filetype == 'packer'
        or vim.bo.filetype == 'qf'
        or vim.bo.filetype == 'whichkey'
      ) then
        vim.opt_local.colorcolumn = limited
      end
    end
  })
  aucmd('FileType', {
    group = g,
    pattern = 'checkhealth',
    desc = 'Format checkhealth output',
    callback = function()
      vim.opt_local.list = false
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.colorcolumn = ''
    end
  })
  aucmd('BufReadPost', {
    group = g,
    desc = 'Jump back to previous cursor position',
    callback = function()
      local previous_pos = vim.api.nvim_buf_get_mark(0, '"')[1]
      local last_line = vim.api.nvim_buf_line_count(0)
      if previous_pos >= 1
          and previous_pos <= last_line
          and vim.bo.filetype ~= 'commit'
      then
        vim.cmd 'normal! g`"'
      end
    end,
  })
  aucmd('BufWinEnter', {
    group = g,
    desc = 'Disable folding in preview window',
    callback = function()
      if vim.wo.previewwindow then
        vim.opt_local.foldenable = false
      end
    end
  })
end)

augroup('Commentstrings', function(g)
  aucmd('FileType', {
    group = g,
    pattern = {
      'pfmain',
      'toml'
    },
    desc = 'commentstring for pfmain & toml',
    callback = function()
      vim.opt_local.commentstring = '#%s'
    end
  })
  aucmd('FileType', {
    group = g,
    pattern = 'vifm',
    desc = 'commentstring for vifm',
    callback = function()
      vim.opt_local.commentstring = '"%s'
    end
  })
  aucmd('FileType', {
    group = g,
    pattern = 'xdefaults',
    desc = 'commentstring for xdefaults',
    callback = function()
      vim.opt_local.commentstring = '!%s'
    end
  })
end)

augroup('Help', function(g)
  local function open_vert()
    local cfg = vim.api.nvim_win_get_config(0)
    if cfg and (cfg.external or cfg.relative and #cfg.relative > 0)
        or vim.api.nvim_win_get_height(0) == 1 then
      return
    end
    local width = math.floor(vim.o.columns * 0.44)
    vim.cmd('wincmd L')
    vim.cmd('vertical resize ' .. width)
  end

  local function simple_quit()
    vim.keymap.set('n', 'q', '<Cmd>q<CR>', { buffer = true })
  end

  aucmd('FileType', {
    group = g,
    pattern = {
      'help',
      'man'
    },
    callback = open_vert,
  })
  aucmd('FileType', {
    group = g,
    pattern = {
      'help',
      'man',
      'startuptime',
      'qf',
      'checkhealth'
    },
    callback = simple_quit,
  })
  aucmd('BufEnter', {
    group = g,
    pattern = '*.txt',
    callback = function()
      if vim.bo.buftype == 'help' then
        open_vert()
      end
    end
  })
  aucmd('BufHidden', {
    group = g,
    pattern = 'man://*',
    callback = function()
      if vim.bo.filetype == 'man' then
        local bufnr = vim.api.nvim_get_current_buf()
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end, 0)
      end
    end
  })
end)

augroup('Packer', function(g)
  -- aucmd('VimEnter', {
  --   group = g,
  --   desc = 'Packer: call packer.sync() on VimEnter',
  --   callback = function()
  --     require('packer').sync()
  --   end
  -- })
  aucmd('FileType', {
    group = g,
    pattern = 'packer',
    desc = 'Packer: set preview height',
    callback = function()
      vim.opt_local.previewheight = 38
    end
  })
  aucmd('FileType', {
    group = g,
    pattern = 'git',
    desc = 'Packer: format git output',
    callback = function()
      vim.opt_local.list = false
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.colorcolumn = ''
    end
  })
  aucmd('BufWritePost', {
    group = g,
    pattern = 'init.lua',
    desc = 'Packer: clean & sync after writing',
    callback = function()
      if vim.fn.expand('%:p') == vim.fn.stdpath('config') .. '/nvim/init.lua'
          or vim.fn.expand('%:p') == vim.fn.getenv('HOME') .. '/.dotfiles/config/nvim/init.lua'
          and not (vim.fn.expand('%:p') == '^fugitive://*' or vim.fn.expand('%:p') == '^scp://*')
      then
        vim.cmd('source <afile>')
        require('packer').sync()
      end
    end
  })
end)
-- }}}1 --------------------- AUTOCMDS -----------------------------------------
-- {{{1 --------------------- FUNCTIONS ----------------------------------------
function Dump(...)
  vim.pretty_print(...)
end

function MDump(...)
  local msg = vim.inspect(...)
  vim.notify('```lua\n' .. msg .. '\n```', vim.log.levels.INFO, {
    title = '[DEBUG]',
    on_open = function(win)
      vim.api.nvim_win_set_option(win, 'conceallevel', 3)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
      vim.api.nvim_win_set_option(win, 'spell', false)
    end,
  })
end

function Debug(note)
  vim.notify(note, vim.log.levels.DEBUG, { title = '[DEBUG]' })
end

-- {{{2 apply visual tweaks
function Prettify()
  -- colorscheme
  if vim.fn.filereadable(vim.fn.expand(vim.fn.getenv('HOME') .. '/.config/colours/nvim_theme.lua')) == 1 then
    vim.cmd.luafile(vim.fn.getenv('HOME') .. '/.config/colours/nvim_theme.lua')
  else
    vim.cmd.colorscheme('quiet')
  end
  -- highlights
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'Folded', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'ColorColumn', { link = 'Visual' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
  vim.api.nvim_set_hl(0, 'FloatNormal', { link = 'Normal' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
  vim.api.nvim_set_hl(0, 'LspFloatWinNormal', { link = 'Normal' })
end

-- }}}

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
    vim.opt.colorcolumn = limited
    vim.notify('Details enabled', vim.log.levels.INFO, { title = '[UI]' })
  end
end

-- }}}

-- {{{2 quickfix/location toggle made by ibhagwan
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
  if #windows > 0 then
    for _, win in ipairs(windows) do
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
require('packer').startup(function(use)
  require('packer').init({
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
    'wbthomason/packer.nvim',
    config = function()
      vim.keymap.set('n', ',pc', function()
        require('packer').clean()
        vim.notify('All clean', vim.log.levels.INFO, { title = '[Packer]' })
      end, { desc = 'Packer: clean' })
      vim.keymap.set('n', ',pi', require('packer').install, { desc = 'Packer: install' })
      vim.keymap.set('n', ',pq', require('packer').status, { desc = 'Packer: status' })
      vim.keymap.set('n', ',ps', function()
        require('packer').sync({ preview_updates = true })
        vim.notify('Syncing ...', vim.log.levels.INFO, { title = '[Packer]' })
      end, { desc = 'Packer: sync with preview' })
    end
  })
  -- }}}
  -- {{{2 impatient.nvim
  use('lewis6991/impatient.nvim')
  -- }}}
  -- {{{2 Startuptime
  use('dstein64/vim-startuptime')
  -- }}}
  -- {{{2 Treesitter
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'RRethy/nvim-treesitter-textsubjects',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      'windwp/nvim-ts-autotag',
      'p00f/nvim-ts-rainbow',
      'JoosepAlviste/nvim-ts-context-commentstring'
    },
    config = function()
      vim.g.ts_highlight_lua = true
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
          enable = true
        },
        indent = {
          enable = false
        },
        rainbow = {
          enable = true,
          extended_mode = true
        },
        refactor = {
          highlight_current_scope = {
            enable = false
          },
          highlight_definitions = {
            enable = true
          },
          navigation = {
            enable = true
          },
          smart_rename = {
            enable = true
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
        },
        textsubjects = {
          enable = true,
          prev_selection = ',',
          keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = 'textsubjects-container-inner',
          }
        }
      })
    end
  })
  -- }}}
  -- {{{2 FZF
  use({
    'ibhagwan/fzf-lua',
    requires = {
      { 'junegunn/fzf', run = './install --all --xdg' }
    },
    config = function()
      local fzf_lua = require('fzf-lua')

      local bottom_row = {
        height = 0.4,
        width = 1,
        row = 1,
        col = 0,
        preview = {
          layout = 'horizontal',
          horizontal = 'right:55%',
        }
      }
      local right_popup = {
        height = 0.97,
        width = 0.2,
        row = 0.3,
        col = 1
      }
      local right_column = {
        height = 1,
        width = 0.45,
        row = 0,
        col = 1,
        preview = {
          layout = 'vertical',
          vertical = 'down:65%'
        }
      }

      vim.keymap.set('n', '<Leader>F', require('fzf-lua').builtin, { desc = 'Fzf: builtin' })
      vim.keymap.set('n', '<Leader>c', require('fzf-lua').colorschemes, { desc = 'Fzf: colorschemes' })
      vim.keymap.set('n', '<Leader>f', require('fzf-lua').files, { desc = 'Fzf: files' })
      vim.keymap.set('n', '<Leader>o', require('fzf-lua').oldfiles, { desc = 'Fzf: oldfiles' })
      vim.keymap.set('n', '<Leader>fg', require('fzf-lua').lgrep_curbuf, { desc = 'Fzf: grep current file' })
      vim.keymap.set('n', '<Leader>fG', require('fzf-lua').live_grep_native, { desc = 'Fzf: grep all files' })
      vim.keymap.set('n', '<Leader>h', require('fzf-lua').help_tags, { desc = 'Fzf: help' })
      vim.keymap.set('n', '<Leader>M', require('fzf-lua').man_pages, { desc = 'Fzf: man' })
      vim.keymap.set('n', '<Leader>m', require('fzf-lua').marks, { desc = 'Fzf: marks' })
      vim.keymap.set('n', '<Leader>r', require('fzf-lua').registers, { desc = 'Fzf: registers' })
      vim.keymap.set('n', '<Leader>fgb', require('fzf-lua').git_bcommits, { desc = 'Fzf: git buffer commits' })
      vim.keymap.set('n', '<Leader>fgc', require('fzf-lua').git_commits, { desc = 'Fzf: git commits' })
      vim.keymap.set('n', '<Leader>fgf', require('fzf-lua').git_files, { desc = 'Fzf: git files' })
      vim.keymap.set('n', '<Leader>fgs', require('fzf-lua').git_status, { desc = 'Fzf: git status' })
      vim.keymap.set('n', '<Leader>fc', require('fzf-lua').command_history, { desc = 'Fzf: command history' })
      vim.keymap.set('n', '<Leader>fm', require('fzf-lua').keymaps, { desc = 'Fzf: keymaps' })
      vim.keymap.set('n', '<Leader>fq', require('fzf-lua').quickfix, { desc = 'Fzf: quickfix' })
      vim.keymap.set('n', '<Leader>fs', require('fzf-lua').spell_suggest, { desc = 'Fzf: spell suggest' })
      vim.keymap.set('n', '<Leader>ft', require('fzf-lua').filetypes, { desc = 'Fzf: filetypes' })
      vim.keymap.set('n', '<Leader>fw', require('fzf-lua').grep_cword, { desc = 'Fzf: grep string' })

      fzf_lua.setup({
        global_resume = true,
        winopts = bottom_row,
        builtin = {
          winopts = right_column
        },
        colorschemes = {
          winopts = right_popup
        },
        diagnostics = {
          winopts = right_column
        },
        files = {
          prompt = 'Files❯ ',
        },
        filetypes = {
          winopts = {
            relative = 'cursor',
            width = 0.14,
            row = 1.01
          }
        },
        git = {
          branches = {
            winopts = right_column
          },
          bcommits = {
            winopts = right_column
          },
          commits = {
            winopts = right_column
          },
          status = {
            winopts = right_column
          },
        },
        grep = {
          cmd = 'ugrep -RIjnkzs --hidden --ignore-files --exclude-dir=".git"',
          winopts = right_column
        },
        highlights = {
          winopts = right_column
        },
        spell_suggest = {
          winopts = {
            relative = 'cursor',
            width = 0.2,
            row = 1.01
          }
        }
      })
    end
  })
  -- }}}
  -- {{{2 Completion
  use({
    'hrsh7th/nvim-cmp',
    requires = {
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
      }
    },
    config = function()
      local cmp = require('cmp')
      local cmp_buffer = require('cmp_buffer')

      require('luasnip/loaders/from_snipmate').lazy_load()
      local luasnip = require('luasnip')
      luasnip.config.set_config {
        history = true,
        updateevents = 'TextChanged,TextChangedI',
        enable_autosnippets = true,
        ext_opts = {
          [require('luasnip.util.types').choiceNode] = {
            active = {
              hl_mode = 'combine',
              virt_text = { { '●', 'Operator' } },
            },
          },
          [require('luasnip.util.types').insertNode] = {
            active = {
              hl_mode = 'combine',
              virt_text = { { '●', 'Type' } },
            },
          },
        }
      }
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
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip', option = { show_autosnippets = true } },
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
                return vim.api.nvim_list_bufs()
              end,
            },
          }
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
          { name = 'cmdline' }
        })
      })
      cmp.setup.cmdline({ '/', '?' }, {
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
      'folke/neodev.nvim',
      {
        'kosayoda/nvim-lightbulb',
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
          vim.keymap.set('n', '<Leader>s', vim.cmd.SymbolsOutline, { desc = 'Symbols Outline toggle' })
          vim.keymap.set('n', ',tso', vim.cmd.SymbolsOutlineOpen, { desc = 'Symbols Outline open' })
          vim.keymap.set('n', ',tsc', vim.cmd.SymbolsOutlineClose, { desc = 'Symbols Outline close' })
        end
      },
      {
        'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        config = function()
          require('lsp_lines').setup()
          vim.keymap.set('', ',ll', require('lsp_lines').toggle, { desc = 'LSP: toggle lsp_lines' })
        end,
      },
      {
        'smjonas/inc-rename.nvim',
        config = function()
          require('inc_rename').setup()
        end,
      }
    },
    config = function()
      require('lspconfig.ui.windows').default_options.border = My_Borders
      require('cmp_nvim_lsp').setup()
      require('neodev').setup()
      local lsp_config = require('lspconfig')

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
          { desc = 'LSP: workspace diagnostics' } , { buffer = bufnr })
        vim.keymap.set('n', ',lrn', function()
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
          vim.keymap.set('v', ',lf', function()
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
                  'packer_plugins',
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
  })
  -- }}}
  -- {{{2 nvim-luapad
  use({
    'rafcamlet/nvim-luapad',
    requires = 'antoinemadec/FixCursorHold.nvim'
  })
  -- }}}
  -- {{{2 nvim-luaref
  use('milisims/nvim-luaref')
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
  -- {{{2 spaceless.nvim
  use({
    'lewis6991/spaceless.nvim',
    config = function()
      require('spaceless').setup()
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
  -- {{{2 nvim-surround
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
  -- {{{2 buffer-manager.nvim
  use({
    'j-morano/buffer_manager.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      vim.keymap.set({ 't', 'n' }, '<Leader>b', require('buffer_manager.ui').toggle_quick_menu, { noremap = true })
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
  -- {{{2 nvim-ufo
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
        close_fold_kinds = { 'imports', 'comment' },
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
          return { 'treesitter', 'indent' }
        end
      })
      local bufnr = vim.api.nvim_get_current_buf()
      require('ufo').setFoldVirtTextHandler(bufnr, handler)
    end
  })
  -- }}}
  -- {{{2 zk-nvim
  use({
    'mickael-menu/zk-nvim',
    config = function()
      local function make_edit_fn(defaults, picker_options)
        return function(options)
          options = vim.tbl_extend('force', defaults, options or {})
          require('zk').edit(options, picker_options)
        end
      end

      require('zk').setup({
        picker = 'fzf'
      })

      require('zk.commands').add('ZkRecents', make_edit_fn({ createdAfter = '1 week ago' }, { title = 'Zk Recents' }))

      vim.keymap.set('n', '<Leader>zf', [[<Cmd>ZkNotes { match = { vim.fn.input('Search: ') } }<CR>]])
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
      require('mkdnflow').setup({
        mappings = {
          MkdnTableNextCell = { 'i', '<M-Tab>' },
          MkdnTablePrevCell = { 'i', '<M-S-Tab>' },
          MkdnTableNewRowBelow = { 'n', ',mir' },
          MkdnTableNewRowAbove = { 'n', ',miR' },
          MkdnTableNewColAfter = { 'n', ',mic' },
          MkdnTableNewColBefore = { 'n', ',miC' },
          MkdnFoldSection = { 'n', ',mf' },
          MkdnUnfoldSection = { 'n', ',mF' },
          MkdnUpdateNumbering = { 'n', ',mn' }
        }
      })
    end
  })
  -- }}}
  -- {{{2 pantran.nvim
  use({
    'potamides/pantran.nvim',
    config = function()
      local keylock = vim.env.HOME .. '/system/.deepl_key.gpg'
      if vim.fn.filereadable(keylock) then
        local unlocked = vim.fn.system({
          'gpg',
          '-q',
          '--no-verbose',
          '-d',
          '--batch',
          keylock
        })
        unlocked = unlocked:gsub('\n', '')
        vim.env.DEEPL_AUTH_KEY = unlocked
      else
        vim.notify('No DEEPL_AUTH_KEY available', vim.log.levels.WARN)
      end
      require('pantran').setup({
        default_engine = 'deepl'
      })
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
  -- {{{2 smartyank.nvim
  use('ibhagwan/smartyank.nvim')
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
              '-RIjnkzs',
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
        window = {
          winblend = 0,
        }
      })
      vim.keymap.set('n', ',tu', require('undotree').toggle, { noremap = true, silent = true }, { desc = 'Undo tree' })
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
        provider_options = {},
        notifier = vim.notify or print
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
  use('MTDL9/vim-log-highlighting')
  -- }}}
  -- {{{2 rasi.vim
  use('Fymyte/rasi.vim')
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
    requires = 'wimstefan/nvim-web-devicons',
    config = function()
      require('nvim-nonicons').setup()
    end
  })
  -- }}}
  -- {{{3 lualine.nvim
  use({
    'nvim-lualine/lualine.nvim',
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
              color = { fg = 'brown' },
            },
          },
          lualine_x = {
            {
              require('noice').api.status.message.get_hl,
              cond = require('noice').api.status.message.has
            },
            {
              require('noice').api.status.command.get_hl,
              cond = require('noice').api.status.command.has
            },
            {
              require('noice').api.status.mode.get_hl,
              cond = require('noice').api.status.mode.has
            },
            {
              require('noice').api.status.search.get_hl,
              cond = require('noice').api.status.search.has
            },
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
      require('lualine').refresh()
      Prettify()
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
        diff_opts = {
          linematch = 60
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
          vim.keymap.set('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'",
            { expr = true, replace_keycodes = false },
            { desc = 'Gitsigns: next hunk' })
          vim.keymap.set('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'",
            { expr = true, replace_keycodes = false },
            { desc = 'Gitsigns: previous hunk' })
          vim.keymap.set('n', ',sp', gs.preview_hunk_inline, { desc = 'Gitsigns: preview hunk' }, { buffer = bufnr })
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
      vim.keymap.set('n', ',ti', vim.cmd.IndentBlanklineToggle)
    end
  })
  -- }}}
  -- {{{3 which-key.nvim
  use({
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup({
        window = {
          border = My_Borders,
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
  })
  -- }}}
  -- {{{3 noice.nvim
  use({
    'folke/noice.nvim',
    requires = 'MunifTanjim/nui.nvim',
    config = function()
      require('noice').setup({
        cmdline = {
          view = 'cmdline',
          format = {
            cmdline = { pattern = '^:', icon = '❱', lang = 'vim' },
            search_down = { kind = 'search', pattern = '^/', icon = ' 🢗', lang = 'regex' },
            search_up = { kind = 'search', pattern = '^%?', icon = ' 🢕', lang = 'regex' },
            filter = { pattern = '^:%s*!', icon = '＄', lang = 'bash' },
            lua = { pattern = '^:%s*lua%s+', icon = ' ', lang = 'lua' },
            input = {}
          }
        },
        format = {
          level = {
            icons = {
              error = vim.fn.sign_getdefined('DiagnosticSignError')[1].text,
              warn = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text,
              info = vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text,
            }
          }
        },
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = true
        },
        views = {
          popupmenu = {
            win_options = {
              winhighlight = {
                Normal = 'Normal',
                FloatBorder = 'FloatBorder'
              }
            }
          },
          split = {
            win_options = {
              winhighlight = {
                Normal = 'Normal',
                FloatBorder = 'FloatBorder'
              }
            }
          }
        },
      })
      vim.keymap.set('n', '<Leader>n', vim.cmd.Noice, { desc = 'Make some noice' })
      Prettify()
    end
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
  -- {{{3 nvim-base16
  use('RRethy/nvim-base16' )
  -- }}}
  -- {{{3 ccc.nvim
  use({
    'uga-rosa/ccc.nvim',
    config = function()
      require('ccc').setup({
        highlighter = {
          auto_enable = true
        }
      })
      vim.keymap.set('n', ',ct', vim.cmd.CccHighlighterToggle)
      vim.keymap.set('n', ',cp', vim.cmd.CccPick)
    end
  })
  -- }}}
  -- }}}
  if is_bootstrap then
    require('packer').sync()
  end
end)
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end
-- }}}1 --------------------- PLUGINS ------------------------------------------
-- vim: foldmethod=marker foldlevel=0
