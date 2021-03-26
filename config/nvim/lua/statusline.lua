--------------------------------------------------------------------------------
-- Many thanks to Elianiva who got me going with:                             --
-- https://elianiva.me/post/neovim-lua-statusline                             --
--------------------------------------------------------------------------------
local vim = vim

-- helper for defining highlight groups
local set_hl = function(group, options)
  local bg     = options.bg == nil and '' or 'guibg=' .. options.bg
  local fg     = options.fg == nil and '' or 'guifg=' .. options.fg
  local gui    = options.gui == nil and '' or 'gui=' .. options.gui
  local link   = options.link or false
  local target = options.target
  if not link then
    vim.cmd(string.format('autocmd VimEnter,ColorScheme * hi %s %s %s %s', group, bg, fg, gui))
  else
    vim.cmd(string.format('autocmd VimEnter, ColorScheme * hi! link', group, target))
  end
end
local highlights = {
  { 'Active',       { fg = 'fg', gui = 'bold' }},
  { 'Separator',    { fg = 'fg' }},
  { 'Filetype',     { gui = 'reverse' }},
  { 'Git',          { fg = 'fg' }},
  { 'LineCol',      { fg = 'fg' }},
  { 'Mode',         { fg = 'fg', gui = 'reverse' }},
  { 'ModeCommand',  { fg = '#ff6167', bg = '#f7f7f7', gui = 'reverse' }},
  { 'ModeInsert',   { fg = '#59b387', bg = '#f7f7f7', gui = 'reverse' }},
  { 'ModeReplace',  { fg = '#5f87af', bg = '#f7f7f7', gui = 'reverse' }},
  { 'ModeSelect',   { fg = '#ffff8d', bg = '#2e3440', gui = 'reverse' }},
  { 'ModeTerminal', { fg = '#b39bbd', bg = '#f7f7f7', gui = 'reverse' }},
  { 'ModeVisual',   { fg = '#ffcc66', bg = '#2e3440', gui = 'reverse' }},
  { 'Modified',     { fg = '#ff6167', gui = 'bold' }},
}
for _, highlight in ipairs(highlights) do
  set_hl(highlight[1], highlight[2])
end

local M = {}

-- possible values are 'bar' | 'blank'
local active_sep = 'blank'

-- change them if you want to different separator
M.separators = {
  bar     = { '┃', '┃' },
  blank   = { '', '' },
}

-- highlight groups
M.colors = {
  active       = '%#Active#',
  inactive     = '%#StatusLineNC#',
  separator    = '%#Separator#',
  filetype     = '%#Filetype#',
  git          = '%#Git#',
  line_col     = '%#LineCol#',
  mode         = '%#Mode#',
  modified     = '%#Modified#',
}

M.trunc_width = setmetatable({
  git_status = 90,
  filename   = 140,
}, {
  __index = function()
    return 80
  end,
})

M.is_truncated = function(_, width)
  local current_width = vim.api.nvim_win_get_width(0)
  return current_width < width
end

M.modes = setmetatable({
  ['n']  = { 'N', '%#Mode#' },
  ['no'] = { 'N·P', '%#Mode#' },
  ['v']  = { 'V', '%#ModeVisual#' },
  ['V']  = { 'V·L', '%#ModeVisual#' },
  [''] = { 'V·B', '%#ModeVisual#' },
  ['s']  = { 'S', '%#ModeSelect#' },
  ['S']  = { 'S·L', '%#ModeSelect#' },
  [''] = { 'S·B', '%#ModeSelect#' },
  ['i']  = { 'I', '%#ModeInsert#' },
  ['ic'] = { 'I', '%#ModeInsert#' },
  ['R']  = { 'R', '%#ModeReplace#' },
  ['Rv'] = { 'V·R', '%#ModeReplace#' },
  ['c']  = { 'C', '%#ModeCommand#' },
  ['cv'] = { 'V·E', '%#ModeVisual#' },
  ['ce'] = { 'E', '%#Mode#' },
  ['r']  = { 'P', '%#Mode#' },
  ['rm'] = { 'M', '%#Mode#' },
  ['r?'] = { 'C', '%#ModeCommand#' },
  ['!']  = { 'S', '%#ModeSelect#' },
  ['t']  = { 'T', '%#ModeTerminal#' },
}, {
  __index = function()
    return 'U' -- handle edge cases
  end,
})

M.get_current_mode = function(self)
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(' %s %s ', self.modes[current_mode][2], self.modes[current_mode][1])
end

M.get_git_status = function(self)
  -- use fallback because it doesn't set this variable on the initial `BufEnter`
  local signs = vim.b.gitsigns_status_dict
    or { head = '', added = 0, changed = 0, removed = 0 }
  local is_head_empty = signs.head ~= ''

  if self:is_truncated(self.trunc_width.git_status) then
    return is_head_empty and string.format('  %s ', signs.head or '') or ''
  end

  return is_head_empty and string.format(
    ' ┃ +%s ~%s -%s |  %s ',
    signs.added,
    signs.changed,
    signs.removed,
    signs.head
  ) or ''
end

M.get_lsp_status = function(self)
  local lsp_status = require('lsp-status').status()
  if self:is_truncated(self.trunc_width.lsp_status) then
    return ''
  end
  return lsp_status
end

M.get_filename = function(self)
  if self:is_truncated(self.trunc_width.filename) then
    return ' %<%f '
  end
  return ' %<%F '
end

M.get_modified = function()
  return ' %M ' or ''
end

M.get_readonly = function()
  return '%r' or ''
end

M.get_filetype = function()
  local filetype = vim.bo.filetype

  if filetype == '' then
    return ' No FT '
  end
  return string.format(' %s ', filetype):lower()
end

M.get_line_col = function()
  local function pad(c, m)
    local padch = '·'
    return string.rep(padch, string.len(tostring(m)) - string.len(tostring(c)))
  end

  local function get_line()
    local nbline = vim.fn.line('$')
    local line = vim.fn.line('.')
    return string.format('%s%d/%d', pad(line, nbline), line, nbline)
  end

  local function get_column()
    local nbcol = vim.fn.col('$') - 1
    local col = vim.fn.col('.')
    return string.format('%s%d/%s%d', pad(col, 100), col, pad(nbcol, 100), nbcol)
  end

  local function get_percent()
    local nb_lines = vim.fn.line('$')
    local line = vim.fn.line('.')
    local percent = math.floor(line * 100 / nb_lines)
    return string.format('%s%d%%%%', pad(percent, 100), percent)
  end

  return table.concat({' ', get_line(), get_column(), get_percent(), ' '}, ' ')
end

M.set_active = function(self)
  local colors = self.colors

  -- local mode = colors.mode .. self:get_current_mode()
  local mode = self:get_current_mode()
  local separator = colors.separator .. self.separators[active_sep][1]
  local git = colors.git .. self:get_git_status()
  local lsp = colors.git .. self:get_lsp_status()
  local readonly = colors.inactive .. self:get_readonly()
  local filename = colors.active .. self:get_filename()
  local modified = colors.modified .. self:get_modified()
  local filetype = colors.filetype .. self:get_filetype()
  local line_col = colors.line_col .. self:get_line_col()

  return table.concat({
    colors.active,
    mode,
    separator,
    line_col,
    separator,
    '%=',
    readonly,
    filename,
    modified,
    '%=',
    separator,
    lsp,
    separator,
    git,
    separator,
    filetype,
  })
end

M.set_inactive = function(self)
  return self.colors.inactive .. '%= %F %='
end

M.set_explorer = function(self)
  local title = self.colors.mode .. ' N·T '
  local title_alt = self.colors.mode_alt .. self.separators[active_sep][2]

  return table.concat({ self.colors.active, title, title_alt })
end

Statusline = setmetatable(M, {
  __call = function(statusline, mode)
    if mode == 'active' then
      return statusline:set_active()
    end
    if mode == 'inactive' then
      return statusline:set_inactive()
    end
    if mode == 'explorer' then
      return statusline:set_explorer()
    end
  end,
})

-- set statusline
-- TODO: replace this once we can define autocmd using lua
vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline('active')
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline('inactive')
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline('explorer')

  augroup END
]], false)
