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
