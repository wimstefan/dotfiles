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
  'yaml',
  'zsh'
}
require('nvim-treesitter').install(ts_parsers)
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter.setup', {}),
  callback = function(args)
    local bufnr = args.buf
    local filetype = args.match
    local language = vim.treesitter.language.get_lang(filetype) or filetype
    if not vim.treesitter.language.add(language) then
      return
    end
    if not pcall(vim.treesitter.start, bufnr, language) then
      return
    end
    vim.bo[bufnr].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
    vim.bo[bufnr].syntax = 'on'
  end
})
vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').asciidoc = {
      install_info = {
        branch = 'master',
        location = 'tree-sitter-asciidoc',
        queries = 'queries/asciidoc/',
        requires = { 'asciidoc_inline' },
        url = 'https://github.com/cathaysia/tree-sitter-asciidoc'
      }
    }
    require('nvim-treesitter.parsers').asciidoc_inline = {
      install_info = {
        branch = 'master',
        location = 'tree-sitter-asciidoc_inline',
        queries = 'queries/asciidoc_inline',
        url = 'https://github.com/cathaysia/tree-sitter-asciidoc'
      }
    }
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

