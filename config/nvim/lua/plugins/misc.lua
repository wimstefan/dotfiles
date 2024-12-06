return {
  'nvim-lua/plenary.nvim',
  {
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
            cmd = 'hub --no-pager diff --stat -B -M -C'
          },
          { section = 'startup' }
        }
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = {
        enabled = true,
        folds = {
          open = true,
          git_hl = true
        }
      },
      words = { enabled = true },
      styles = {
        terminal = {
          position = 'float',
          border = require('config.ui').borders
        },
      },
      win = { border = require('config.ui').borders }
    },
    keys = {
      { ',sd', function() Snacks.dashboard() end, desc = 'Snacks: dashboard' },
      { ',sr', function() Snacks.rename.rename_file() end, desc = 'Snacks: rename file' },
      { ',ss', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
      { ',sS', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },
      { '<Leader>L', function() Snacks.lazygit() end, desc = 'Lazygit' },
      { '<Leader>gf', function() Snacks.lazygit.log_file() end, desc = 'Lazygit Current File History' },
      { '<Leader>gl', function() Snacks.lazygit.log() end, desc = 'Lazygit Log (cwd)' },
      { '<C-\\>', mode = { 'n', 't' }, function() Snacks.terminal.toggle() end, desc = 'Terminal' },
      { ']]', mode = { 'n', 't' }, function() Snacks.words.jump(vim.v.count1) end, desc = 'Snacks: next reference' },
      { '[[', mode = { 'n', 't' }, function() Snacks.words.jump(-vim.v.count1) end, desc = 'Snacks: prev reference' }
    },
    init = function()
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
          Snacks.toggle.option('relativenumber', { name = 'relative number' }):map('yor')
          Snacks.toggle.line_number({ name = 'line number' }):map('yol')
        end
      })
    end
  },
  {
    'gennaro-tedesco/nvim-possession',
    keys = {
      { '<leader>pd', function() require('nvim-possession').delete() end, desc = 'Projects: delete' },
      { '<leader>pl', function() require('nvim-possession').list() end, desc = 'Projects: list' },
      { '<leader>pn', function() require('nvim-possession').new() end, desc = 'Projects: new' },
      { '<leader>pu', function() require('nvim-possession').update() end, desc = 'Projects: update' }
    },
    opts = {
      sessions = {
        sessions_icon = '󱜤  '
      },
      autoswitch = {
        enable = true
      }
    }
  },
  {
    'tpope/vim-repeat',
    keys = '.'
  },
  {
    'kevinhwang91/nvim-bqf',
    dependencies = 'junegunn/fzf',
    event = 'BufReadPost',
    opts = {
      auto_enable = true,
      auto_resize_height = true
    }
  },
  {
    'mikavilpas/yazi.nvim',
    event = 'VeryLazy',
    keys = {
      { '<Leader>y', '<Cmd>Yazi<CR>', desc = 'Open yazi at the current file' },
      { '<Leader>yw', '<Cmd>Yazi cwd<CR>', desc = "Open the file manager in nvim's working directory" },
      { ',ty', '<Cmd>Yazi toggle<CR>', desc = 'Resume the last yazi session' }
    },
    opts = {}
  },
  {
    'jamessan/vim-gnupg',
    lazy = false
  },
  {
    'MTDL9/vim-log-highlighting',
    ft = 'log'
  },
  {
    'chrisbra/unicode.vim',
    cmd = {
      'UnicodeName',
      'UnicodeTable'
    },
    keys = {
      { '<Leader>ut', vim.cmd.UnicodeTable, desc = 'Open unicode table' },
      { 'gu', vim.cmd.UnicodeName, desc = 'Lookup Unicode character' }
    }
  }
}
