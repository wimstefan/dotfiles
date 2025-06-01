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
  local cs = vim.g.colors_name or 'default'
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'CursorColumn', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'ColorColumn', { link = 'Visual' })
  vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = 'orange', bold = true, italic = true })
  if cs == 'default' or cs == 'lunaperche' or cs == 'habamax' then
    vim.api.nvim_set_hl(0, 'StatusLine', { blend = 20 })
    vim.api.nvim_set_hl(0, 'StatusLineNC', { blend = 20 })
  elseif string.match(cs, '^tokyonight') then
    local dimmed_bg = get_hex('StatusLine', 'bg')
    vim.api.nvim_set_hl(0, 'helpCommand', { fg = get_hex('helpCommand', 'fg'), bg = dimmed_bg, italic = true })
    vim.api.nvim_set_hl(0, '@text.literal.markdown_inline',
      { fg = get_hex('@text.literal.markdown_inline', 'fg'), bg = dimmed_bg, italic = true })
    vim.api.nvim_set_hl(0, 'Search', { link = 'DiagnosticVirtualTextInfo' })
    vim.api.nvim_set_hl(0, 'IncSearch', { link = 'DiagnosticVirtualTextWarn' })
    vim.api.nvim_set_hl(0, 'Visual', { bg = dimmed_bg, bold = true })
  elseif cs == 'vim' then
    vim.api.nvim_set_hl(0, 'CursorColumn', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { ctermfg = 11, ctermbg = 'none' })
    vim.api.nvim_set_hl(0, 'LineNr', { ctermfg = 240 })
    vim.api.nvim_set_hl(0, 'LineNrAbove', { ctermfg = 240 })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { ctermfg = 240 })
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
-- {{{2 show manpage of current word
function ShowMan()
  local cword = vim.fn.expand('<cword>')
  vim.cmd.Man(cword)
end
-- }}}2
-- vim: foldmethod=marker foldlevel=1
