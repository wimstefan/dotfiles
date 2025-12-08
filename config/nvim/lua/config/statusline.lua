-- https://github.com/shivambegin/Neovim/blob/main/lua/config/statusline.lua
local statusline_augroup = vim.api.nvim_create_augroup('native_statusline', { clear = true })

-- LSP clients attached to buffer
local function lsp_clients()
  local current_buf = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.get_clients({ bufnr = current_buf })
  if next(clients) == nil then
    return ''
  end

  local c = {}
  for _, client in pairs(clients) do
    table.insert(c, client.name)
  end
  return '%#NoiceLspProgressClient# 󰌘 ' .. table.concat(c, '|') .. ' %*'
end

--- @return string
local function tab_info()
  local fname = vim.fn.expand('%:t')
  if fname == '' then
    return ''
  end
  return '%#WildMenu# ' .. fname .. ' %*'
end

--- @return string
local function filename()
  local fname = vim.fn.expand('%:~')
  if fname == '' then
    return ''
  end
  return '%#Bold# ' .. fname .. ' %*'
end

--- @return string
local function filestatus()
  if vim.bo.modified == true then
    return '%#Error# ● %*'
  end
  if vim.bo.readonly == true then
    return '%#Error#   %*'
  end
  return ''
end

--- @param type string
--- @return integer
local function get_git_diff(type)
  local gsd = vim.b.gitsigns_status_dict
  if gsd and gsd[type] then
    return gsd[type]
  end

  return 0
end

vim.api.nvim_set_hl(0, 'ModeNormal', { reverse = true })
vim.api.nvim_set_hl(0, 'ModeVisual', { fg = '#ff5ef1', bg = '#000000', reverse = true })
vim.api.nvim_set_hl(0, 'ModeSelect', { fg = '#f1ff5e', bg = '#000000', reverse = true })
vim.api.nvim_set_hl(0, 'ModeInsert', { fg = '#5eff6c', bg = '#000000', reverse = true })
vim.api.nvim_set_hl(0, 'ModeReplace', { fg = '#ff6e5e', bg = '#000000', reverse = true })
vim.api.nvim_set_hl(0, 'ModeCommand', { fg = '#5ea1ff', bg = '#000000', reverse = true })
vim.api.nvim_set_hl(0, 'ModePrompt', { fg = '#5ef1ff', bg = '#000000', reverse = true })
vim.api.nvim_set_hl(0, 'ModeTerminal', { fg = '#808080', bg = '#ffffff', reverse = true })

local modes = {
  ['n'] = '%#ModeNormal# NORMAL %*',
  ['no'] = '%#ModeNormal# NORMAL %*',
  ['v'] = '%#ModeVisual# VISUAL %*',
  ['V'] = '%#ModeVisual# VISUAL LINE %*',
  [''] = '%#ModeVisual# VISUAL BLOCK %*',
  ['s'] = '%#ModeSelect# SELECT %*',
  ['S'] = '%#ModeSelect# SELECT LINE %*',
  [''] = '%#ModeSelect# SELECT BLOCK %*',
  ['i'] = '%#ModeInsert# INSERT %*',
  ['ic'] = '%#ModeInsert# INSERT %*',
  ['R'] = '%#ModeReplace# REPLACE %*',
  ['Rv'] = '%#ModeReplace# VISUAL REPLACE %*',
  ['c'] = '%#ModeCommand# COMMAND %*',
  ['cv'] = '%#ModePrompt# VIM EX %*',
  ['ce'] = 'EX',
  ['r'] = '%#ModePrompt# PROMPT %*',
  ['rm'] = 'MOAR',
  ['r?'] = 'CONFIRM',
  ['!'] = '%#ModeCommand# SHELL %*',
  ['t'] = '%#ModeTerminal# TERMINAL %*',
}
--- @return string
local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(' %s ', modes[current_mode]):upper()
end

--- @return string
local function lsp_active()
  if not rawget(vim, 'lsp') then
    return ''
  end

  local current_buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = current_buf })

  if #clients > 0 then
    return ' %#NoiceLspProgressTitle#  LSP%*'
  end

  return ''
end

--- @return string
local function git_diff_added()
  local added = get_git_diff('added')
  if added > 0 then
    return string.format('%%#GitSignsAdd#%s%s%%*', require('config.ui').icons.git.added, added)
  end

  return ''
end

--- @return string
local function git_diff_changed()
  local changed = get_git_diff('changed')
  if changed > 0 then
    return string.format('%%#GitSignsChange#%s%s%%*', require('config.ui').icons.git.modified, changed)
  end

  return ''
end

--- @return string
local function git_diff_removed()
  local removed = get_git_diff('removed')
  if removed > 0 then
    return string.format('%%#GitSignsDelete#%s%s%%*', require('config.ui').icons.git.removed, removed)
  end

  return ''
end

--- @return string
local function git_branch_icon()
  return ''
end

--- @return string
local function git_branch()
  local branch = vim.b.gitsigns_head

  if branch == '' or branch == nil then
    return ''
  end

  return string.format('%s', branch)
end

--- @return string
local function full_git()
  local full = ''
  local space = ' '

  local branch = git_branch()
  if branch ~= '' then
    local icon = git_branch_icon()
    full = full .. space .. icon .. space .. branch .. space
  end

  local added = git_diff_added()
  if added ~= '' then
    full = full .. added .. space
  end

  local changed = git_diff_changed()
  if changed ~= '' then
    full = full .. changed .. space
  end

  local removed = git_diff_removed()
  if removed ~= '' then
    full = full .. removed .. space
  end

  return full
end

--- @return string
local function line_info()
  local lines = vim.fn.line('$')
  local cur_pos = vim.api.nvim_win_get_cursor(0)[2]
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  if lines > 1 then
    return string.format('   %s:%s of %s ', cur_pos, cur_line, lines)
  else
    return ''
  end
end

--- @param hlgroup string
local function formatted_filetype(hlgroup)
  local filetype = vim.bo.filetype or vim.fn.expand('%:e', false)
  return string.format('%%#%s# %s %%*', hlgroup, filetype)
end

local function filetype()
  if vim.bo.filetype ~= '' then
    return string.format('[%s]', vim.bo.filetype):lower()
  else
    return ''
  end
end

StatusLine = {}

StatusLine.inactive = function()
  return table.concat({
    formatted_filetype('ModeMsg'),
  })
end

local redeable_filetypes = {
  ['qf'] = true,
  ['help'] = true,
  ['tsplayground'] = true,
}

StatusLine.active = function()
  local mode_str = vim.api.nvim_get_mode().mode
  if mode_str == 't' or mode_str == 'nt' then
    return table.concat({
      mode(),
      '%=',
      '%=',
      line_info()
    })
  end

  if redeable_filetypes[vim.bo.filetype] or vim.o.modifiable == false then
    return table.concat({
      formatted_filetype('ModeMsg'),
      '%=',
      '%=',
      line_info()
    })
  end

  local statusline = {
    '▊',
    mode(),
    line_info(),
    filename(),
    filestatus(),
    full_git(),
    '%=',
    '%=',
    '%S ',
    vim.diagnostic.status(),
    lsp_active(),
    lsp_clients(),
    filetype(),
    ' ▊',
  }

  return table.concat(statusline)
end

vim.opt.statusline = '%!v:lua.StatusLine.active()'

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter', 'FileType' }, {
  group = statusline_augroup,
  pattern = {
    'fzf',
    'lspinfo',
    'lazy',
    'netrw',
    'noice',
    'qf',
  },
  callback = function()
    vim.opt_local.statusline = '%!v:lua.StatusLine.inactive()'
  end,
})

TabLine = function()
  return table.concat({
    tab_info(),
    filestatus()
  })
end
vim.opt.tabline = '%!v:lua.TabLine()'
