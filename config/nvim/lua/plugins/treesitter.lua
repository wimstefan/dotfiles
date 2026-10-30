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
  'query',
  'regex',
  'rst',
  'scss',
  'toml',
  'vim',
  'vimdoc',
  'xml',
  'xresources',
  'yaml',
  'zsh'
}
require('nvim-treesitter').install(ts_parsers)
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter.setup', {}),
  callback = function(ev)
    local bufnr = ev.buf
    local filetype = ev.match
    local language = vim.treesitter.language.get_lang(filetype) or filetype
    if language and vim.treesitter.language.add(language) then
      vim.treesitter.start(bufnr, language)
      vim.wo[0][0].foldmethod = 'expr'
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.bo[bufnr].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
      vim.bo[bufnr].syntax = 'on'
    end
  end
})

vim.pack.add({
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    version = 'main'
  }
})

vim.pack.add({
  {
    src = 'https://github.com/celeste3z/celeste_comment.nvim',
    name = 'celeste_comment'
  }
})
require('celeste_comment').setup({
  mappings = {
    line_invert = 'gci'
  }
})
