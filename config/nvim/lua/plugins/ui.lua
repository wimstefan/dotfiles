-- Messaging
require('vim._core.ui2').enable({
  msg = {
    targets = 'msg'
  }
})

-- LSP progress
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value
    if not client or type(value) ~= 'table' then
      return
    end
    local p = progress[client.id]
    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ('[%3d%%] %s%s'):format(
            value.kind == 'end' and 100 or value.percentage or 100,
            value.title or '',
            value.message and (' **%s**'):format(value.message) or ''
          ),
          done = value.kind == 'end',
        }
        break
      end
    end
    local msg = {}
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)
    local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    vim.notify(table.concat(msg, '\n'), 'info', {
      id = 'lsp_progress',
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and ' '
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end
    })
  end
})

vim.pack.add({
  { src = 'https://github.com/serhez/teide.nvim' }
})
require('teide').setup({
  style = 'darker',
  transparent = true
})
vim.cmd.colorscheme('teide')

vim.pack.add({
  { src = 'https://github.com/folke/which-key.nvim' }
})
require('which-key').setup({
  preset = 'helix',
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 40
    }
  },
  win = {
    padding = { 2, 2, 2, 2 }
  }
})

vim.pack.add({
  {
    src = 'https://github.com/OXY2DEV/markview.nvim',
    data = {
      ft = 'markdown'
    }
  }
})
require('markview').setup({
  preview = {
    modes = { 'n', 'I' },
    hybrid_modes = { 'i' }
  },
  markdown = {
    list_items = {
      indent_size = 2,
      shift_width = 2,
      marker_minus = {
        add_padding = false,
        text = '',
        hl = 'MarkviewListItemMinus'
      },
      marker_plus = {
        add_padding = false,
        text = '',
        hl = 'MarkviewListItemPlus'
      },
      marker_star = {
        add_padding = true,
        text = '󰓒',
        hl = 'MarkviewListItemStar'
      }
    }
  }
})
vim.keymap.set('n', ',tm', function() require('markview').commands.toggle() end, { desc = 'Toggle Markview' })
vim.keymap.set('n', ',tms', function() require('markview').commands.splitToggle() end, { desc = 'Toggle Split Markview' })

vim.pack.add({
  { src = 'https://github.com/folke/twilight.nvim' }
})
require('twilight').setup()
vim.keymap.set('n', ',tt', function() require('twilight').toggle() end, { desc = 'Toggle Twilight' })

vim.pack.add({
  { src = 'https://github.com/folke/zen-mode.nvim' }
})
require('zen-mode').setup({
  window = {
    options = {
      signcolumn = 'no',
      number = false,
      relativenumber = false
    }
  },
  plugins = {
    twilight = {
      enabled = true
    },
    gitsigns = {
      enabled = false
    }
  }
})
vim.keymap.set('n', ',tz', function() require('zen-mode').toggle() end, { desc = 'Toggle Zen mode' })
