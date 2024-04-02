local indent = 2

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.numberwidth = 3
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
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

vim.opt.shortmess = 'ltToOCFI'
vim.opt.laststatus = 3
vim.opt.fillchars:append({
  stl = ' ',
  stlnc = ' ',
  wbr = ' ',
  diff = ' ',
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
vim.opt.mousemodel = 'extend'

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
vim.opt.completeopt = {
  'menuone',
  'noinsert',
  'popup'
}
vim.opt.diffopt:append({
  'vertical',
  'indent-heuristic',
  'linematch:60',
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
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.backup = false
vim.opt.backupcopy = 'auto'
vim.opt.writebackup = true
vim.opt.undofile = true
vim.opt.modelineexpr = true

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
