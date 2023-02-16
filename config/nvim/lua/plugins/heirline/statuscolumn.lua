return {
  static = {
    get_signs = function()
      -- local buf = vim.api.nvim_get_current_buf()
      local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
      return vim.tbl_map(function(sign)
        return vim.fn.sign_getdefined(sign.name)[1]
      end, vim.fn.sign_getplaced(buf, { group = '*', lnum = vim.v.lnum })[1].signs)
    end,
    resolve = function(self, name)
      for pat, cb in pairs(self.handlers) do
        if name:match(pat) then
          return cb
        end
      end
    end,
    handlers = {
      ['GitSigns.*'] = function(args)
        require('gitsigns').preview_hunk()
      end,
      ['Diagnostic.*'] = function(args)
        vim.diagnostic.open_float() -- { pos = args.mousepos.line - 1, relative = "mouse" })
      end,
    },
  },
  {
    provider = '%s',

    on_click = {
      callback = function(self)
        local mousepos = vim.fn.getmousepos()
        vim.api.nvim_win_set_cursor(0, { mousepos.line, mousepos.column })
        local sign_at_cursor = vim.fn.screenstring(mousepos.screenrow, mousepos.screencol)
        if sign_at_cursor ~= '' then
          local args = {
            mousepos = mousepos,
          }
          local signs = vim.fn.sign_getdefined()
          for _, sign in ipairs(signs) do
            local glyph = sign.text:gsub(' ', '')
            if sign_at_cursor == glyph then
              vim.defer_fn(function()
                self:resolve(sign.name)(args)
              end, 10)
              return
            end
          end
        end
      end,
      name = 'heirline_signcol_callback',
      update = true,
    },
  },
  {
    provider = function()
      if vim.v.virtnum ~= 0 then return '' end
      local lnum = vim.v.lnum
      local icon = ' '
      if vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) then
        if vim.fn.foldclosed(lnum) == -1 then
          icon = '  '
        else
          icon = '  '
        end
      end
      return icon
    end,
    on_click = {
      callback = function(self)
        local mousepos = vim.fn.getmousepos()
        local lnum = mousepos.line
        if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then return end
        vim.cmd.execute("'" .. lnum .. 'fold' .. (vim.fn.foldclosed(lnum) == -1 and 'close' or 'open') .. "'")
      end,
      name = 'heirline_fold_click'
    }
  },
  {
    provider = "%=%2{v:virtnum ? '' : &nu ? (&rnu && v:relnum ? v:relnum : v:lnum . ' ') . ' ' : ''}"
  }
}
