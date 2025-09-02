local aucmd = vim.api.nvim_create_autocmd
local function augroup(name, fnc)
  fnc(vim.api.nvim_create_augroup(name, { clear = true }))
end

augroup('Pack', function(g)
  aucmd('PackChanged', {
    group = g,
    callback = function(args)
      local spec = args.data.spec
      if spec and spec.name == 'fzf' and args.data.kind == 'update' or args.data.kind == 'install' then
        local cwd_path = vim.fn.stdpath('data') .. '/site/pack/core/opt/fzf'
        vim.notify('Installing/updating fzf in' .. cwd_path, vim.log.levels.INFO)
        vim.schedule(function()
          vim.system({ './install', '--all', '--xdg' }, { cwd = cwd_path, text = true })
          vim.system({ 'make' }, { cwd = cwd_path, text = true })
          vim.system({ 'make', 'install' }, { cwd = cwd_path, text = true })
        end)
      end
      if spec and spec.name == 'nvim-treesitter' and args.data.kind == 'update' then
        vim.schedule(function()
          require('nvim-treesitter').update()
        end)
      end
    end
  })
end)

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
    pattern = {
      'markdown'
    },
    desc = 'Format markdown',
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.softtabstop = 2
      vim.opt_local.shiftwidth = 2
    end
  })
  aucmd('FileType', {
    group = g,
    pattern = 'checkhealth',
    desc = 'Format checkhealth output',
    callback = function()
      vim.opt_local.foldlevel = 99
      vim.opt_local.foldlevelstart = 99
      vim.opt_local.list = false
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.colorcolumn = ''
    end
  })
  aucmd('FileType', {
    group = g,
    pattern = {
      'help',
      'man',
      'snacks_dashboard'
    },
    desc = 'Disable folding',
    callback = function()
      vim.opt_local.foldlevel = 99
      vim.opt_local.foldlevelstart = 99
    end
  })
  local unpack = unpack or table.unpack
  local ignore_filetype = { 'gitcommit', 'gitrebase' }
  local ignore_buftype = { 'quickfix', 'nofile', 'help' }
  aucmd('BufReadPost', {
    group = g,
    desc = 'Jump back to previous cursor position',
    callback = function()
      if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
        return
      end
      if vim.tbl_contains(ignore_buftype, vim.bo.buftype) then
        return
      end
      local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
      if row > 0 and row <= vim.api.nvim_buf_line_count(0) then
        vim.api.nvim_win_set_cursor(0, { row, col })
        if vim.api.nvim_eval 'foldclosed(\'.\')' ~= -1 then
          vim.api.nvim_input 'zv'
        end
      end
    end
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

augroup('UI', function(g)
  aucmd({ 'ColorScheme', 'UiEnter' }, {
    group = g,
    desc = 'Apply visual tweaks',
    callback = function()
      Prettify()
    end
  })
  aucmd('TextYankPost', {
    group = g,
    desc = 'Highlight yanked text',
    callback = function()
      vim.hl.on_yank({
        higroup = { '@text.strong', '@text.emphasis' },
        timeout = 1000
      })
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
      'nvim-pack',
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
