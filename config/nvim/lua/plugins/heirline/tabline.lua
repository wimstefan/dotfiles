local utils = require('heirline.utils')
local format = require('plugins.heirline').format
local get_hl = utils.get_highlight

local TablineFileName = {
  provider = function(self)
    local filename = self.filename
    filename = filename == '' and '[No Name]' or vim.fn.fnamemodify(filename, ':t')
    return filename
  end,
  hl = function(self)
    return { bold = self.is_active }
  end
}

local TablineFileFlags = {
  {
    condition = function(self)
      return vim.api.nvim_buf_get_option(self.bufnr, 'modified')
    end,
    provider = ' ●',
    hl = { fg = 'red' }
  },
  {
    condition = function(self)
      return not vim.api.nvim_buf_get_option(self.bufnr, 'modifiable')
        or vim.api.nvim_buf_get_option(self.bufnr, 'readonly')
    end,
    provider = function(self)
      if vim.api.nvim_buf_get_option(self.bufnr, 'buftype') == 'toggleterm' then
        return '  '
      else
        return ' x'
      end
    end,
    hl = { fg = 'orange' }
  }
}

local TablineFileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
  end,
  hl = function(self)
    if self.is_active then
      return { bold = true }
    else
      return { fg = 'gray', bold = false }
    end
  end,
  on_click = {
    callback = function(_, minwid, _, button)
      if (button == 'm') then
        vim.api.nvim_buf_delete(minwid, { force = false })
      else
        vim.api.nvim_win_set_buf(0, minwid)
      end
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = 'heirline_tabline_buffer_callback'
  },
  TablineFileName,
  TablineFileFlags
}

local TablineBufferBlock = {
  condition = function(self)
    return self.is_visible
  end,
  utils.surround({ format.seps.half_bracket.left .. ' ', ' ' .. format.seps.half_bracket.right }, '', TablineFileNameBlock)
}

local BufferLine = utils.make_buflist(
  TablineBufferBlock,
  { provider = '   ', hl = { fg = 'gray' } },
  { provider = '   ', hl = { fg = 'gray' } }
)

local Tabpage = {
  provider = function(self)
    return '%' .. self.tabnr .. 'T ' .. self.tabpage .. ' %T'
  end,
  hl = function(self)
    if not self.is_active then
      return 'TabLine'
    else
      return 'TabLineSel'
    end
  end,
}

local TabpageClose = {
  provider = '%999X  %X',
  hl = 'TabLine'
}

local TabPages = {
  condition = function()
    return #vim.api.nvim_list_tabpages() >= 2
  end,
  { provider = '%=' },
  utils.make_tablist(Tabpage),
  TabpageClose
}

local TabLineOffset = {
  condition = function(self)
    local win = vim.api.nvim_tabpage_list_wins(0)[1]
    local bufnr = vim.api.nvim_win_get_buf(win)
    self.winid = win
  end,
  provider = function(self)
    local title = self.title
    local width = vim.api.nvim_win_get_width(self.winid)
    local pad = math.ceil((width - #title) / 2)
    return string.rep(' ', pad) .. title .. string.rep(' ', pad)
  end,
  hl = function(self)
    if vim.api.nvim_get_current_win() == self.winid then
      return 'TablineSel'
    else
      return 'Tabline'
    end
  end
}

return { TabLineOffset, BufferLine, TabPages }
