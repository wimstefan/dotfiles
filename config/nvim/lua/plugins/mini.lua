vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.ai' }
})
require('mini.ai').setup()

vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.align' }
})
require('mini.align').setup()

vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.completion' }
})
require('mini.completion').setup({
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = false
  }
})
vim.keymap.set('i', '<Tab>', [[pumvisible() ? '<C-n>' : '<Tab>']], { desc = 'Completion: next', expr = true })
vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? '<C-p>' : '<S-Tab>']], { desc = 'Completion: prev', expr = true })

vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.icons' }
})
require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()

vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.surround' }
})
require('mini.surround').setup()

vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.sessions' }
})
require('mini.sessions').setup({
  directory = vim.fn.stdpath('state') .. '/sessions/',
  force = {
    delete = true
  }
})
vim.keymap.set('n', '<Leader>pd', function() require('mini.sessions').delete() end, { desc = 'Session: delete' })
vim.keymap.set('n', '<Leader>pr', function() require('mini.sessions').read() end, { desc = 'Session: read' })
vim.keymap.set('n', '<Leader>ps', function() require('mini.sessions').select() end, { desc = 'Session: select' })
vim.keymap.set('n', '<Leader>pw', function() require('mini.sessions').write() end, { desc = 'Session: write' })
