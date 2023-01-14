-- define leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

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
    scope = 'line',
    source = 'always'
  },
  virtual_text = {
    source = 'always'
  }
})

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
vim.keymap.set('n', ',dt', function() toggle_diagnostics() end,  { desc = 'Diagnostic: toggle' })
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
