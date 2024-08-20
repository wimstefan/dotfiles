function Dump(...)
  vim.print(...)
end

function MDump(...)
  local msg = vim.inspect(...)
  vim.notify('```lua\n' .. msg .. '\n```', vim.log.levels.INFO, {
    title = '[DEBUG]',
    on_open = function(win)
      vim.wo[win].conceallevel = 3
      local buf = vim.api.nvim_win_get_buf(win)
      vim.bo[buf].filetype = 'markdown'
      vim.wo[win].spell = false
    end,
  })
end

function Debug(note)
  vim.notify(note, vim.log.levels.DEBUG, { title = '[DEBUG]' })
end

-- {{{2 apply visual tweaks
function Prettify()
  -- colorscheme
  if vim.fn.filereadable(vim.fn.expand(vim.fn.getenv('HOME') .. '/.config/colours/nvim_theme.lua')) == 1 then
    vim.cmd.luafile(vim.fn.getenv('HOME') .. '/.config/colours/nvim_theme.lua')
  else
    vim.cmd.colorscheme('default')
  end
  -- highlights
  local function get_hex(name, attr)
    local bit = require('bit')
    local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
    if not ok then return 'NONE' end
    hl.foreground = hl.foreground and '#' .. bit.tohex(hl.foreground, 6)
    hl.background = hl.background and '#' .. bit.tohex(hl.background, 6)
    attr = ({ bg = 'background', fg = 'foreground' })[attr] or attr
    return hl[attr] or 'NONE'
  end
  local cs = vim.g.colors_name
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'LineNr', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'LineNrAbove', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'LineNrBelow', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'Folded', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'CursorColumn', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FoldColumn', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'ColorColumn', { link = 'Visual' })
  vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = 'orange', bold = true, italic = true })
  if cs == 'default' or cs == 'lunaperche' or cs == 'habamax' then
    print(cs)
    vim.api.nvim_set_hl(0, 'Conceal', { ctermfg = 255, fg = 255, ctermbg = 244, bg = 244 })
    vim.api.nvim_set_hl(0, 'StatusLine', { blend = 20 })
    vim.api.nvim_set_hl(0, 'StatusLineNC', { blend = 20 })
  elseif string.match(cs, '^tokyonight') then
    print(cs)
    local dimmed_bg = get_hex('StatusLine', 'bg')
    vim.api.nvim_set_hl(0, 'helpCommand', { fg = get_hex('helpCommand', 'fg'), bg = dimmed_bg, italic = true })
    vim.api.nvim_set_hl(0, '@text.literal.markdown_inline',
      { fg = get_hex('@text.literal.markdown_inline', 'fg'), bg = dimmed_bg, italic = true })
    vim.api.nvim_set_hl(0, 'Search', { link = 'DiagnosticVirtualTextInfo' })
    vim.api.nvim_set_hl(0, 'IncSearch', { link = 'DiagnosticVirtualTextWarn' })
    vim.api.nvim_set_hl(0, 'Visual', { bg = dimmed_bg, bold = true })
  elseif cs == 'vim' then
    print(cs)
    vim.opt.termguicolors = false
    vim.api.nvim_set_hl(0, 'CursorColumn', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'FoldColumn', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { ctermfg = 11, ctermbg = 'none' })
    vim.api.nvim_set_hl(0, 'LineNr', { ctermfg = 8, ctermbg = 'none' })
    vim.api.nvim_set_hl(0, 'Conceal', { ctermfg = 255, fg = 255, ctermbg = 244, bg = 244 })
    vim.api.nvim_set_hl(0, 'Error', { ctermfg = 1, fg = 1, underline = true })
    vim.api.nvim_set_hl(0, 'ErrorMsg', { ctermfg = 0, fg = 0, ctermbg = 'Red', bg = 'Red' })
    vim.api.nvim_set_hl(0, 'Pmenu', { fg = 'none' })
    vim.api.nvim_set_hl(0, 'Search', { ctermfg = 0, fg = 0, ctermbg = 11, bg = 11 })
    vim.api.nvim_set_hl(0, 'SpellBad', { ctermfg = 1, fg = 1, underdouble = true })
    vim.api.nvim_set_hl(0, 'SpellCap', { ctermfg = 12, fg = 12, underdouble = true })
    vim.api.nvim_set_hl(0, 'SpellRare', { ctermfg = 13, fg = 13, underdouble = true })
    vim.api.nvim_set_hl(0, 'SpellLocal', { ctermfg = 14, fg = 14, underdouble = true })
    vim.api.nvim_set_hl(0, 'StatusLine', { bold = true })
    -- vim.api.nvim_set_hl(0, 'StatusLineNC', { reverse = true })
    vim.api.nvim_set_hl(0, 'WildMenu', { ctermfg = 0, ctermbg = 11 })
    if vim.opt.background:get() == 'light' then
      vim.api.nvim_set_hl(0, 'Visual', { ctermfg = 'none', fg = 'none', ctermbg = 253, bg = 253, bold = true })
    else
      vim.api.nvim_set_hl(0, 'Visual', { ctermfg = 'none', fg = 'none', ctermbg = 237, bg = 237, bold = true })
    end
  end

  vim.notify('Applying visual tweaks', vim.log.levels.INFO, { title = '[UI]' })
end

-- }}}2

-- {{{2 toggle detailed information for easier paste
function ToggleDetails()
  local mouse_opts = vim.api.nvim_get_option_value('mouse', {})
  if mouse_opts == 'a' then
    vim.opt.mouse = 'v'
    vim.opt.cursorcolumn = false
    vim.opt.cursorline = false
    vim.opt.signcolumn = 'no'
    vim.opt.foldenable = false
    vim.opt.list = false
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.colorcolumn = ''
    vim.notify('Details disabled', vim.log.levels.INFO, { title = '[UI]' })
  else
    vim.opt.mouse = 'a'
    vim.opt.cursorcolumn = true
    vim.opt.cursorline = true
    vim.opt.signcolumn = 'number'
    vim.opt.foldenable = true
    vim.opt.list = true
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.colorcolumn = limited
    vim.notify('Details enabled', vim.log.levels.INFO, { title = '[UI]' })
  end
end

-- }}}2

-- {{{2 quickfix/location toggle made by ibhagwan
function FindQF(type)
  local wininfo = vim.fn.getwininfo()
  local win_tbl = {}
  for _, win in pairs(wininfo) do
    local found = false
    if type == 'l' and win['loclist'] == 1 then
      found = true
    end
    if type == 'q' and win['quickfix'] == 1 and win['loclist'] == 0 then
      found = true
    end
    if found then
      table.insert(win_tbl, { winid = win['winid'], bufnr = win['bufnr'] })
    end
  end
  return win_tbl
end

function OpenQF()
  local qf_name = 'quickfix'
  local qf_empty = function() return vim.tbl_isempty(vim.fn.getqflist()) end
  if not qf_empty() then
    vim.cmd.copen()
    vim.cmd.wincmd('J')
  else
    print(string.format('%s is empty.', qf_name))
  end
end

function OpenLoclistAll()
  local wininfo = vim.fn.getwininfo()
  local qf_name = 'loclist'
  local qf_empty = function(winnr) return vim.tbl_isempty(vim.fn.getloclist(winnr)) end
  for _, win in pairs(wininfo) do
    if win['quickfix'] == 0 then
      if not qf_empty(win['winnr']) then
        vim.api.nvim_set_current_win(win['winid'])
        vim.cmd.lopen()
      else
        print(string.format('%s is empty.', qf_name))
      end
    end
  end
end

function ToggleQF(type)
  local windows = FindQF(type)
  if #windows > 0 then
    for _, win in ipairs(windows) do
      vim.api.nvim_win_hide(win.winid)
    end
  else
    if type == 'l' then
      OpenLoclistAll()
    else
      OpenQF()
    end
  end
end

-- }}}2

-- {{{2 show manpage of current word
function ShowMan()
  local cword = vim.fn.expand('<cword>')
  vim.cmd.Man(cword)
end

-- }}}2

-- {{{2 toggle hlsearch
function ToggleHlSearch()
  local current_hls = vim.api.nvim_get_option_value('hlsearch', {})
  if current_hls == false then
    vim.opt.hlsearch = true
    vim.notify('Search highlighting enabled', vim.log.levels.INFO, { title = '[UI]' })
  else
    vim.opt.hlsearch = false
    vim.notify('Search highlighting disabled', vim.log.levels.INFO, { title = '[UI]' })
  end
end

-- }}}2

-- vim: foldmethod=marker foldlevel=1
