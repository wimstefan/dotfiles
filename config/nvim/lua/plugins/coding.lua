vim.pack.add({
  { src = 'https://github.com/windwp/nvim-autopairs' }
})
require('nvim-autopairs').setup({
  fast_wrap = {}
})
vim.keymap.set({ 'n', 'v' }, ',ta', function() require('nvim-autopairs').toggle() end, { desc = 'Toggle autopairs' })

vim.pack.add({
  { src = 'https://github.com/nemanjamalesija/smart-paste.nvim' }
})
require('smart-paste').setup()

