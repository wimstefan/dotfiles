local M = {}
-- icons
M.icons = {
  diagnostics = {
    ' ',
    ' ',
    ' ',
    ' ',
    '󰄭 '
  },
  git = {
    -- added = '󰐖 ', modified = '󰅗  ', removed = '󰍵  ', renamed = '󰛂 '
    -- added = '󰜄  ', modified = '󰅘  ', removed = '󰛲  ', renamed = '󰜶 '
    added = '󰐙 ',
    modified = '󰅚  ',
    removed = '󰍷  ',
    renamed = '󰳠 ',
    untracked = ' ',
    ignored   = ' ',
    unstaged  = ' ',
    staged    = ' ',
    conflict  = ' '
  },
  kinds = {
    Array = ' ', -- ' ', -- '謹',
    Boolean = ' ', -- ' ', --'ﬧ ',
    Class = ' ', -- ' ', -- ' ',
    Color = ' ', -- ' ', -- ' ',
    Constant = ' ', -- ' ',
    Constructor = ' ', -- ' ', -- ' ', -- ' ',
    Enum = ' ', -- ' ', -- '練 ',
    EnumMember = ' ', -- ' ', -- ' ',
    Event = ' ', -- ' ', -- ' ',
    Field = ' ', -- ' ', -- ' ',
    File = ' ', -- ' ', -- ' ',
    Folder = ' ', -- ' ',
    Function = '󰊕 ', -- ' ',
    Interface = ' ', -- ' ', -- '﨡', -- ' ',
    Keyword = ' ', -- ' ', -- ' ', -- ' ',
    Method = ' ', -- ' ',
    Module = ' ', -- ' ',
    Namespace = ' ', -- ' ',
    Number = ' ', -- ' ', -- '濫',
    Object = ' ', -- '謹',
    Operator = ' ', -- '璉 ',
    Package = ' ', -- ' ', -- '  ',
    Property = ' ', -- ' ', -- ' ',
    Reference = ' ', -- '  ', -- ' ' -- ' ',
    Snippet = ' ', -- ' ', -- ' ', !!!
    String = ' ', -- ' ', -- ' ',
    Struct = ' ', -- ' ',  --'פּ ', -- ' ',
    Text = ' ', -- '  ', -- ' ',
    TypeParameter = ' ', -- ' ', -- ' ', -- ' ',
    Unit = ' ', -- '塞 ', -- 'ﰩ '  --' ',
    Value = ' ', -- ' ',
    Variable = ' ', -- ' ', -- ' ',
  }
}

-- borders --
-- M.borders = { '╤', '═', '╤', '│', '╧', '═', '╧', '│' }
-- M.borders = { '╓', '─', '╖', '║', '╜', '─', '╙', '║' }
-- M.borders = { '┯', '━', '┯', '│', '┷', '━', '┷', '│' }
-- M.borders = { '·', '─', '·', '│', '·', '─', '·', '│' }
-- M.borders = { '╏', '🮂', '╏', '╏', '╏', '▂', '╏', '╏' }
-- M.borders = { '┎', '─', '┒', '┃', '┚', '─', '┖', '┃' }
-- M.borders = { '┬', '─', '┬', '│', '┴', '─', '┴', '│' }
M.borders = 'rounded'

return M
