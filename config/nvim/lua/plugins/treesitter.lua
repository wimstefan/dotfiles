vim.pack.add({
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main'
  }
})
require('nvim-treesitter').setup()
local ts_parsers = {
  'bash',
  'cmake',
  'comment',
  'css',
  'diff',
  'git_config',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'gpg',
  'html',
  'json',
  'kdl',
  'lua',
  'luadoc',
  'make',
  'markdown',
  'markdown_inline',
  'muttrc',
  'query',
  'regex',
  'rst',
  'scss',
  'toml',
  'vim',
  'vimdoc',
  'yaml',
  'xml',
  'xresources',
  'yaml'
}
require('nvim-treesitter').install(ts_parsers)
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter.setup', {}),
  callback = function(args)
    local buf = args.buf
    local filetype = args.match
    local language = vim.treesitter.language.get_lang(filetype) or filetype
    if not vim.treesitter.language.add(language) then
      return
    end
    vim.treesitter.start(buf, language)
    vim.bo[buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
    vim.bo[buf].syntax = 'on'
  end
})

vim.pack.add({
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    version = 'main'
  }
})

vim.pack.add({
  { src = 'https://github.com/folke/ts-comments.nvim' }
})

vim.pack.add({
  { src = 'https://github.com/windwp/nvim-ts-autotag' }
})
require('nvim-ts-autotag').setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false
  }
})

vim.pack.add({
  { src = 'https://github.com/HiPhish/rainbow-delimiters.nvim' }
})
require('rainbow-delimiters.setup').setup({
  strategy = {
    [''] = require('rainbow-delimiters').strategy['global']
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks'
  }
})

