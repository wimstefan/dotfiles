return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      width = math.floor(vim.o.columns * 0.44),
      sections = {
        { section = 'header', padding = 2 },
        { section = 'keys', padding = 2 },
        { section = 'recent_files', icon = ' ', title = 'Recent Files', indent = 3, padding = 2 },
        { section = 'projects', icon = ' ', title = 'Projects', indent = 3, padding = 2 },
        {
          section = 'terminal',
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          icon = ' ',
          title = 'Git Status',
          height = 8,
          padding = 2,
          indent = 0,
          cmd = 'git --no-pager diff --stat --stat-graph-width=30 -B -M -C'
        },
        { section = 'startup' }
      }
    },
    indent = {
      enabled = true,
      chunk = {
        enabled = true,
        char = {
          corner_top = '╭',
          corner_bottom = '╰',
          arrow = '▶',
          horizontal = '▶'
          -- arrow = '─',
          -- horizontal = '─'
        }
      },
      indent = { enabled = false },
      scope = { enabled = true }
    },
    input = { enabled = true },
    notifier = {
      enabled = true,
      style = 'fancy',
      top_down = false
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = {
      enabled = true,
      folds = {
        open = true,
        git_hl = true
      }
    },
    words = { enabled = true },
    styles = {
      notification_history = {
        height = 0.8,
        width = 0.8
      },
      terminal = {
        position = 'float',
        border = require('config.ui').borders
      }
    },
    win = { border = require('config.ui').borders }
  },
  keys = {
    { ',sd', function() Snacks.dashboard() end, desc = 'Snacks: dashboard' },
    { ',sr', function() Snacks.rename.rename_file() end, desc = 'Snacks: rename file' },
    { ',ss', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
    { ',sS', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },
    { '<Leader>N', function() Snacks.notifier.show_history() end, desc = 'Snacks: notifications' },
    { '<Leader>L', function() Snacks.lazygit() end, desc = 'Lazygit' },
    { '<Leader>gf', function() Snacks.lazygit.log_file() end, desc = 'Lazygit Current File History' },
    { '<Leader>gl', function() Snacks.lazygit.log() end, desc = 'Lazygit Log (cwd)' },
    { '<C-\\>', mode = { 'n', 't' }, function() Snacks.terminal.toggle() end, desc = 'Terminal' },
    { ']]', mode = { 'n', 't' }, function() Snacks.words.jump(vim.v.count1) end, desc = 'Snacks: next reference' },
    { '[[', mode = { 'n', 't' }, function() Snacks.words.jump(-vim.v.count1) end, desc = 'Snacks: prev reference' }
  },
  init = function()
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
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'background' }):map('yob')
        Snacks.toggle.option('hlsearch', { name = 'search highlighting' }):map('yoh')
        Snacks.toggle.option('spell', { name = 'spelling' }):map('yos')
        Snacks.toggle.option('wrap', { name = 'wrap' }):map('yow')
        Snacks.toggle.option('number', { name = 'absolute number' }):map('yol')
        Snacks.toggle.option('relativenumber', { name = 'relative number' }):map('yor')
        Snacks.toggle.dim({ name = 'dimming' }):map('yod')
        Snacks.toggle.zen({ name = 'zen' }):map('yoz')
        Snacks.toggle.zoom({ name = 'zoom' }):map('yoZ')
        Snacks.toggle.indent({ name = 'indent' }):map(',ti')
        Snacks.toggle.scroll({ name = 'scroll' }):map(',ts')
      end
    })
  end
}
