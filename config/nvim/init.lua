--------------------- MY PERSONAL NEOVIM CONFIGURATION -------------------------
-- {{{1 --------------------- First things first -------------------------------
-- define leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- }}}1
-- {{{1 --------------------- OPTIONS ------------------------------------------
local indent = 2
local limited = '80'

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
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
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'Folded', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'ColorColumn', { link = 'Visual' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
  vim.api.nvim_set_hl(0, 'FloatNormal', { link = 'Normal' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
  vim.api.nvim_set_hl(0, 'LspFloatWinNormal', { link = 'Normal' })

  vim.notify('Applying visual tweaks', vim.log.levels.INFO, { title = '[UI]' })
end

-- }}}2

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

-- }}}2

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

-- }}}2

-- {{{2 show manpage of current word
function ShowMan()
  local cword = vim.fn.expand('<cword>')
  vim.cmd.Man(cword)
end

-- }}}2

-- {{{2 toggle foldcolumn
function ToggleFoldColumn()
  local current_fc = vim.api.nvim_get_option_value('foldcolumn', {})
  if current_fc == '0' then
    vim.opt.foldcolumn = 'auto:1'
  else
    vim.opt.foldcolumn = '0'
  end
end

-- }}}2
-- }}}1 --------------------- FUNCTIONS ----------------------------------------
-- {{{1 --------------------- MAPPINGS -----------------------------------------
vim.keymap.set('', 'cd', [[<Cmd>cd %:h | pwd<CR>]])
vim.keymap.set('n', '<C-l>', [[<Cmd>set nohlsearch|diffupdate|highlight clear ColorColumn|normal! <C-l><CR>]])
vim.keymap.set('n', '<Leader>g', [[:grep<Space>]])
vim.keymap.set('n', '<Leader>i', [[<Cmd>Inspect!<CR>]])
vim.keymap.set('n', '<Leader>K', function() ShowMan() end, { desc = 'Search man pages for current word' })
vim.keymap.set('n', '<Leader>m', [[<Cmd>messages<cr>]])
vim.keymap.set('n', '<Leader>p', function() Prettify() end, { desc = 'Apply visual tweaks' })
vim.keymap.set('n', '<F9>', function() ToggleFoldColumn() end, { desc = 'Toggle foldcolumn' })
vim.keymap.set('n', '<F10>', function() ToggleDetails() end, { desc = 'Toggle decorations' })
-- {{{2 navigation
vim.keymap.set({ 'n', 'x' }, 'j', function() return vim.v.count > 0 and 'j' or 'gj' end,
  { expr = true, replace_keycodes = false })
vim.keymap.set({ 'n', 'x' }, 'k', function() return vim.v.count > 0 and 'k' or 'gk' end,
  { expr = true, replace_keycodes = false })
-- }}}2
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
-- }}}2
-- {{{2 buffers
vim.keymap.set('n', '<Tab>', vim.cmd.bnext, { desc = 'Go to next buffer' })
vim.keymap.set('n', '<S-Tab>', vim.cmd.bprev, { desc = 'Go to previous buffer' })
vim.keymap.set('n', '<Leader><Leader>', '<C-^>')
vim.keymap.set('n', '<Leader>bd', function() vim.cmd.bdelete() end, { desc = 'Delete buffer' })
vim.keymap.set('n', '<Leader>bl', function() vim.cmd.buffer('#') end, { desc = 'Go to last buffer' })
-- }}}2
-- {{{2 tabs
vim.keymap.set('n', '<Leader>td', vim.cmd.tabclose)
-- }}}2
-- {{{2 terminals
vim.keymap.set('t', '<Esc>', [[<C-\><C-N>]])
vim.keymap.set('t', '<A-h>', [[<C-\><C-N><C-w>h]])
vim.keymap.set('t', '<A-j>', [[<C-\><C-N><C-w>j]])
vim.keymap.set('t', '<A-k>', [[<C-\><C-N><C-w>k]])
vim.keymap.set('t', '<A-l>', [[<C-\><C-N><C-w>l]])
-- }}}2
-- {{{2 quickfix
vim.keymap.set('n', '<C-c>', function() ToggleQF('q') end, { desc = 'Toggle quickfix window' })
vim.keymap.set('n', '<A-c>', function() ToggleQF('l') end, { desc = 'Toggle location list window' })
vim.keymap.set('n', '[\\', vim.cmd.colder)
vim.keymap.set('n', ']\\', vim.cmd.cnewer)
-- }}}2
-- {{{2 signatures
vim.keymap.set('n', '<Leader>sa',
  [[1G:s#\(Stefan Wimmer\) <.*>#\1 <stefan@tangoartisan.com>#<CR>G?--<CR>jVGd :r ~/.mutt/short-signature-artisan<CR>/^To:<CR>]])
vim.keymap.set('n', '<Leader>sg',
  [[1G:s#\(Stefan Wimmer\) <.*>#\1 <wimstefan@gmail.com>#<CR>G?--<CR>jVGd :r ~/.mutt/short-signature-gmail<CR>/^To:<CR>]])
vim.keymap.set('n', '<Leader>st', [[G?--<CR>jVGd :r ~/.mutt/short-signature-tango<CR>]])
vim.keymap.set('n', '<Leader>ss', [[G?--<CR>jVGd :r ~/.mutt/short-signature<CR>]])
vim.keymap.set('n', '<Leader>sl', [[G?--<CR>jVGd :r ~/.mutt/signature<CR>]])
-- }}}2
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
        or vim.bo.filetype == 'lazy'
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
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0
        and mark[1] <= lcount
        and vim.bo.filetype ~= 'commit'
        or vim.bo.filetype ~= 'rebase'
      then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
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
-- }}}1 --------------------- AUTOCMDS -----------------------------------------
-- {{{1 --------------------- PLUGINS ------------------------------------------
vim.keymap.set('n', '<Leader>l', require('lazy').home, { desc = 'Lazy' })
vim.keymap.set('n', '<Leader>ll', require('lazy').log, { desc = 'Lazy: log' })
vim.keymap.set('n', '<Leader>lp', require('lazy').profile, { desc = 'Lazy: profile' })
vim.keymap.set('n', '<Leader>ls', require('lazy').sync, { desc = 'Lazy: sync' })

local opts = {
  defaults = {
    lazy = true
  },
  ui = {
    border = My_Borders,
    icons = {
      cmd = ' ',
      config = ' ',
      event = ' ',
      ft = ' ',
      import = ' ',
      init = ' ',
      keys = ' ',
      plugin = ' ',
      runtime = ' ',
      source = ' ',
      start = ' ',
      task = ' ',
    }
  },
  diff = {
    cmd = 'git'
  },
  checker = {
    enabled = true
  }
}

require('lazy').setup('plugins', opts)
-- }}}1 --------------------- PLUGINS ------------------------------------------
-- vim: foldmethod=marker foldlevel=0
