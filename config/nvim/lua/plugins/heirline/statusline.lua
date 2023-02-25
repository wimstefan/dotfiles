local M = {}

local utils = require('heirline.utils')
local conditions = require('heirline.conditions')
local format = require('plugins.heirline').format

-- {{{2 Mode
M.ViMode = {
  init = function(self)
    self.mode = vim.fn.mode(1)
    if not self.once then
      vim.api.nvim_create_autocmd('ModeChanged', {
        pattern = '*:*o',
        command = 'redrawstatus'
      })
      self.once = true
    end
  end,
  static = {
    mode_names = {
      n = 'NORMAL',
      no = 'NORMAL',
      nov = 'NORMAL',
      noV = 'NORMAL',
      ['no\22'] = 'NORMAL',
      niI = 'NORMAL',
      niR = 'NORMAL',
      niV = 'NORMAL',
      nt = 'NORMAL',
      v = 'VISUAL',
      vs = 'VISUAL',
      V = 'VISUAL',
      Vs = 'VISUAL',
      ['\22'] = 'VISUAL',
      ['\22s'] = 'VISUAL',
      s = 'SELECT',
      S = 'SELECT',
      ['\19'] = 'SELECT',
      i = 'INSERT',
      ic = 'INSERT',
      ix = 'INSERT',
      R = 'REPLACE',
      Rc = 'REPLACE',
      Rx = 'REPLACE',
      Rv = 'REPLACE',
      Rvc = 'REPLACE',
      Rvx = 'REPLACE',
      c = 'COMMAND',
      cv = 'Ex',
      r = '...',
      rm = 'M',
      ['r?'] = '?',
      ['!'] = '!',
      t = 'TERM',
    }
  },
  provider = function(self)
    return ' ' .. '%2(' .. self.mode_names[self.mode] .. '%)' .. ' '
  end,
  hl = function(self)
    local color = self:mode_color()
    return { fg = color, bold = true, reverse = true }
  end
}
-- }}}2
-- {{{2 File area
M.Ruler = {
  init = function(self)
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color_by_filetype(vim.bo.filetype)
  end,
  hl = function(self)
    return { fg = self.icon_color, standout = true, italic = false, bold = true, reverse = true }
  end,
  provider = format.seps.half_bracket.left .. '%7(%l/%3L%):%2c %P' .. format.seps.half_bracket.right
}

M.WorkDir = {
  init = function(self)
    local cwd = vim.fn.getcwd(0)
    self.cwd = vim.fn.fnamemodify(cwd, ':~')
  end,
  hl = { fg = 'blue', bg = 'bg_statusline', bold = true },
  on_click = {
    callback = function()
      vim.cmd('Vifm')
      vim.defer_fn(function() vim.cmd('startinsert') end, 300)
    end,
    name = 'heirline_explore',
  },
  flexible = 1,
  {
    provider = function(self)
      local trail = self.cwd:sub(-1) == '/' and '' or '/'
      return self.cwd .. trail
    end
  },
  {
    provider = function(self)
      local cwd = vim.fn.pathshorten(self.cwd)
      local trail = self.cwd:sub(-1) == '/' and '' or '/'
      return cwd .. trail
    end
  },
  {
    provider = ''
  }
}

local FileBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  condition = function(self)
    return not conditions.buffer_matches({
      filetype = self.filetypes,
    })
  end
}
local FileName = {
  init = function(self)
    self.lfilename = vim.fn.fnamemodify(self.filename, ':.')
    if self.lfilename == '' then self.lfilename = '[No Name]' end
  end,
  hl = { fg = 'blue', bg = 'bg_statusline' },
  flexible = 1,
  {
    provider = function(self)
      return '⋗ ' .. self.lfilename
    end
  },
  {
    provider = function(self)
      return '⋗ ' .. vim.fn.pathshorten(self.lfilename)
    end,
  },
  {
    provider = ''
  }
}
local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = '[+] ',
    hl = { fg = 'red', bg = 'bg_statusline', bold = true }
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = '[RO] ',
    hl = { fg = 'orange', bg = 'bg_statusline' }
  },
  {
    condition = function()
      return vim.wo.spell
    end,
    provider = '[SP] ',
    hl = { fg = 'yellow', bg = 'bg_statusline' }
  }
}
local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      return { fg = 'red', bg = 'bg_statusline', bold = true, force = true }
    end
  end
}
M.FileNameBlock = utils.insert(FileBlock,
  utils.insert(FileNameModifer, FileName),
  { provider = ' ' },
  FileFlags,
  { provider = '%<' }
)

local FileTypeBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  hl = function(self)
    return { bold = true, reverse = true }
  end
}
local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension)
  end,
  provider = function(self)
    return self.icon and (format.seps.half_bracket.left .. self.icon .. '  ') or format.seps.half_bracket.left
  end,
  hl = function(self)
      return { fg = self.icon_color, reverse = true }
  end,
  on_click = {
    callback = function()
      require('fzf-lua').filetypes()
      vim.defer_fn(function() vim.cmd('startinsert') end, 300)
    end,
    name = 'heirline_filetype',
  }
}
local FileType = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension)
  end,
  provider = function(self)
      return vim.bo.filetype and string.lower(vim.bo.filetype) .. format.seps.half_bracket.right
  end,
  hl = function(self)
    return { fg = self.icon_color, reverse = true }
  end,
  on_click = {
    callback = function()
      require('fzf-lua').filetypes()
      vim.defer_fn(function() vim.cmd('startinsert') end, 300)
    end,
    name = 'heirline_filetype',
  },
}
M.FileTypeBlock = utils.insert(FileTypeBlock,
  FileIcon,
  FileType
)
-- }}}2
-- {{{2 Sessions
M.Sessions = {
  provider = function()
    local session = require('nvim-possession').status()
    if session == nil then return '' end
    return session
  end,
  hl = { fg = 'yellow', bg = 'bg_statusline' }
}
-- }}}2
-- {{{2 LSP
M.LSPActive = {
  condition = conditions.lsp_attached,
  update = { 'LspAttach', 'LspDetach' },
  provider = function()
    local names = {}
    for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      table.insert(names, server.name)
    end
    return format.seps.double_quote.right .. ' ' .. ' [' .. table.concat(names, '|') .. ']'
  end,
  hl = { fg = 'green', bg = 'bg_statusline', bold = true },
  on_click = {
    callback = function()
      vim.defer_fn(function()
        vim.cmd('LspInfo')
      end, 100)
    end,
    name = 'heirline_LSP',
  }
}
-- }}}2
-- {{{2 Git
M.Git = {
  condition = conditions.is_git_repo,
  { provider = format.seps.double_quote.right .. ' ', hl = { fg = 'orange', bg = 'bg_statusline', bold = true } },
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or
      self.status_dict.changed ~= 0
  end,
  hl = { fg = 'orange', bg = 'bg_statusline' },
  {
    provider = function(self)
      return ' ' .. self.status_dict.head
    end
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = '('
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ('+' .. count .. ' ')
    end,
    hl = { fg = 'git_add', bg = 'bg_statusline' },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ('-' .. count .. ' ')
    end,
    hl = { fg = 'git_del', bg = 'bg_statusline' },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ('~' .. count)
    end,
    hl = { fg = 'git_change', bg = 'bg_statusline' },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ')',
  },
  on_click = {
    callback = function()
      vim.cmd('Lazygit')
      vim.defer_fn(function() vim.cmd('startinsert') end, 300)
    end,
    name = 'heirline_git',
  }
}
-- }}}2
-- {{{2 Diagnostics
M.Diagnostics = {
  condition = conditions.has_diagnostics,
  { provider = format.seps.double_quote.right .. ' ', hl = { fg = 'yellow', bg = 'bg_statusline', bold = true } },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  update = { 'DiagnosticChanged', 'BufEnter' },
  {
    provider = function(self)
      return self.errors > 0 and (require('config.ui').icons.diagnostics[1] .. ' ' .. self.errors .. ' ')
    end,
    hl = { fg = 'diag_error', bg = 'bg_statusline' }
  },
  {
    provider = function(self)
      return self.warnings > 0 and (require('config.ui').icons.diagnostics[2] .. ' ' .. self.warnings .. ' ')
    end,
    hl = { fg = 'diag_warn', bg = 'bg_statusline' }
  },
  {
    provider = function(self)
      return self.info > 0 and (require('config.ui').icons.diagnostics[3] .. ' ' .. self.info .. ' ')
    end,
    hl = { fg = 'diag_info', bg = 'bg_statusline' }
  },
  {
    provider = function(self)
      return self.hints > 0 and (require('config.ui').icons.diagnostics[4] .. ' ' .. self.hints)
    end,
    hl = { fg = 'diag_hint', bg = 'bg_statusline' }
  },
  on_click = {
    callback = function()
      vim.diagnostic.setqflist()
    end,
    name = 'heirline_diagnostics',
  }
}
-- }}}2
-- {{{2 Special cases
M.Root = {
  condition = function()
    local user = vim.env.USER
    return user == 'root'
  end,
  { provider = ' ＃ ', hl = { fg = 'red', reverse = true } },
  { provider = ' ', hl = { bg = bg_statusline } }
}
M.SearchResults = {
  condition = function(self)
    local lines = vim.api.nvim_buf_line_count(0)
    if lines > 50000 then return end
    local query = vim.fn.getreg('/')
    if query == '' then return end
    if query:find('@') then return end
    local search_count = vim.fn.searchcount({ recompute = 1, maxcount = -1 })
    local active = false
    if vim.v.hlsearch and vim.v.hlsearch == 1 and search_count.total > 0 then
      active = true
    end
    if not active then return end
    query = query:gsub([[^\V]], '')
    query = query:gsub([[\<]], ''):gsub([[\>]], '')
    self.query = query
    self.count = search_count
    return true
  end,
  init = function()
    vim.opt.shortmess:append('S')
  end,
  {
    provider = function(self)
      return table.concat({
        ' ', self.query, ' ', self.count.current, '/', self.count.total, ' '
      })
    end,
    hl = { fg = 'green', reverse = true }
  }
}
-- }}}2

return M

-- vim: foldmethod=marker foldlevel=1
