return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    bigfile = { enabled = true },
    dashboard = {
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
    explorer = {
      replace_netrw = true
    },
    image = { enabled = true },
    indent = {
      chunk = {
        enabled = true,
        char = {
          corner_top = '╭',
          corner_bottom = '╰',
          arrow = '▶',
          horizontal = '▶'
        }
      },
      indent = { enabled = false },
      scope = { enabled = true }
    },
    input = { enabled = true },
    notifier = {
      style = 'fancy',
      top_down = true
    },
    picker = {
      layout = 'ivy',
      matcher = {
        frecency = true
      },
      formatters = {
        file = { filename_first = true }
      },
      previewers = {
        diff = {
          builtin = false,
          cmd = { 'bat' }
        }
      }
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = {
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
    { '<Leader>S', function() Snacks.picker() end, desc = 'Snacks: picker' },
    { '<Leader>e', function() Snacks.explorer() end, desc = 'Snacks: explorer' },
    { '<Leader>b', function() Snacks.picker.buffers() end, desc = 'Snacks: buffers' },
    { '<Leader>c', function() Snacks.picker.colorschemes() end, desc = 'Snacks: colorschemes' },
    { '<Leader>f', function() Snacks.picker.smart() end, desc = 'Snacks: files, buffers & recent files' },
    { '<Leader>o', function() Snacks.picker.recent() end, desc = 'Snacks: recent' },
    { '<Leader>h', function() Snacks.picker.help() end, desc = 'Snacks: help' },
    { '<Leader>k', function() Snacks.picker.man() end, desc = 'Snacks: man' },
    { '<Leader>r', function() Snacks.picker.resume() end, desc = 'Snacks: resume' },
    { '<Leader>?', function() Snacks.picker.grep_buffers() end, desc = 'Snacks: grep open buffers' },
    { '<Leader>/', function() Snacks.picker.grep() end, desc = 'Snacks: grep current directory recursively' },
    { '<Leader>sc', function() Snacks.picker.command_history() end, desc = 'Snacks: command history' },
    { '<Leader>sgb', function() Snacks.picker.git_log_file() end, desc = 'Snacks: git log current buffer' },
    { '<Leader>sgl', function() Snacks.picker.git_log() end, desc = 'Snacks: git log' },
    { '<Leader>sgd', function() Snacks.picker.git_diff() end, desc = 'Snacks: git diff' },
    { '<Leader>sgf', function() Snacks.picker.git_files() end, desc = 'Snacks: git files' },
    { '<Leader>sgg', function() Snacks.picker.git_grep() end, desc = 'Snacks: git grep' },
    { '<Leader>sgs', function() Snacks.picker.git_status() end, desc = 'Snacks: git status' },
    { '<Leader>sh', function() Snacks.picker.highlights() end, desc = 'Snacks: highlights' },
    { '<Leader>si', function() Snacks.picker.icons() end, desc = 'Snacks: icons' },
    { '<Leader>sj', function() Snacks.picker.jumps() end, desc = 'Snacks: jumps' },
    { '<Leader>sk', function() Snacks.picker.keymaps() end, desc = 'Snacks: keymaps' },
    { '<Leader>sm', function() Snacks.picker.marks() end, desc = 'Snacks: marks' },
    { '<Leader>sq', function() Snacks.picker.qflist() end, desc = 'Snacks: quickfix list' },
    { '<Leader>sr', function() Snacks.picker.registers() end, desc = 'Snacks: registers' },
    { '<Leader>sR', function() Snacks.rename.rename_file() end, desc = 'Snacks: rename file' },
    { '<Leader>ss', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
    { '<Leader>sS', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },
    { '<Leader>su', function() Snacks.picker.undo() end, desc = 'Snacks: undo' },
    { '<Leader>sw', function() Snacks.picker.grep_word() end, desc = 'Snacks: grep word' },
    { '<Leader>N', function() Snacks.notifier.show_history() end, desc = 'Snacks: notifications' },
    { '<Leader>L', function() Snacks.lazygit() end, desc = 'Lazygit' },
    { '<Leader>Lf', function() Snacks.lazygit.log_file() end, desc = 'Lazygit Current File History' },
    { '<Leader>Ll', function() Snacks.lazygit.log() end, desc = 'Lazygit Log (cwd)' },
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
