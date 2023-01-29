vim.keymap.set('', 'cd', [[<Cmd>cd %:h | pwd<CR>]])
vim.keymap.set('n', '<C-l>', [[<Cmd>set nohlsearch|diffupdate|highlight clear ColorColumn|normal! <C-l><CR>]])
vim.keymap.set('n', '<Leader>g', [[:grep<Space>]])
vim.keymap.set('n', '<Leader>i', [[<Cmd>Inspect!<CR>]])
vim.keymap.set('n', '<Leader>K', function() ShowMan() end, { desc = 'Search man pages for current word' })
vim.keymap.set('n', '<Leader>m', [[<Cmd>messages<cr>]])
vim.keymap.set('n', '<Leader>p', function() Prettify() end, { desc = 'Apply visual tweaks' })
vim.keymap.set('n', '<F9>', function() ToggleFoldColumn() end, { desc = 'Toggle foldcolumn' })
vim.keymap.set('n', '<F10>', function() ToggleDetails() end, { desc = 'Toggle decorations' })
-- {{{2 lazy.nvim
vim.keymap.set('n', '<Leader>l', require('lazy').home, { desc = 'Lazy' })
vim.keymap.set('n', '<Leader>ll', [[:Lazy load<Space>]], { desc = 'Lazy: load' })
vim.keymap.set('n', '<Leader>lp', require('lazy').profile, { desc = 'Lazy: profile' })
vim.keymap.set('n', '<Leader>ls', require('lazy').sync, { desc = 'Lazy: sync' })
-- }}}2
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
-- vim: foldmethod=marker foldlevel=1
