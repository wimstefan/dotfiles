local conditions = require('heirline.conditions')
local utils = require('heirline.utils')
local get_hl = utils.get_highlight
local format = require('plugins.heirline').format

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
      return vim.bo[self.bufnr].modified
    end,
    provider = ' ●',
    hl = { fg = 'red' }
  },
  {
    condition = function(self)
      return not vim.bo[self.bufnr].modifiable or vim.bo[self.bufnr].readonly
    end,
    provider = function(self)
      if vim.bo[self.bufnr].buftype == 'toggleterm' then
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
        vim.schedule(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
        end)
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
  utils.surround({ format.seps.half_bracket.left .. ' ', ' ' .. format.seps.half_bracket.right }, '', TablineFileNameBlock)
}

local BufferLine = {
  utils.make_buflist(
    TablineBufferBlock,
    { provider = '   ', hl = { fg = 'gray' } },
    { provider = '   ', hl = { fg = 'gray' } }
  )
}

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
  provider = '%999X x%X',
  hl = { fg = 'red', bold = true }
}

local TabPages = {
  condition = function()
    return #vim.api.nvim_list_tabpages() >= 2
  end,
  { provider = '%=' },
  utils.make_tablist(Tabpage),
  TabpageClose
}

return { BufferLine, TabPages }
