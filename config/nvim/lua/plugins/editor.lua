return {
  {
    'junegunn/fzf',
    build = './install --all --xdg && make && make install'
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = {
      signs = {
        add = { text = '│', show_count = true },
        change = { text = '│', show_count = true },
        delete = { show_count = true },
        topdelete = { show_count = true },
        changedelete = { show_count = true }
      },
      count_chars = {
        [1] = '¹',
        [2] = '²',
        [3] = '³',
        [4] = '⁴',
        [5] = '⁵',
        [6] = '⁶',
        [7] = '⁷',
        [8] = '⁸',
        [9] = '⁹',
        ['+'] = '⁺'
      },
      diff_opts = {
        internal = true,
        linematch = 60
      },
      preview_config = {
        relative = 'cursor',
        row = 1,
        col = 2
      },
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')
        vim.keymap.set('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal({ ']c', bang = true })
            else
              gitsigns.nav_hunk('next')
            end
          end,
          { desc = 'Gitsigns: next hunk' })
        vim.keymap.set('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({ '[c', bang = true })
            else
              gitsigns.nav_hunk('prev')
            end
          end,
          { desc = 'Gitsigns: previous hunk' })
        vim.keymap.set('n', '<Leader>gp', gitsigns.preview_hunk_inline, { desc = 'Gitsigns: preview hunk' }, { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gb', function() gitsigns.blame_line { full = true } end, { desc = 'Gitsigns: blame line' },
          { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gd', gitsigns.diffthis, { desc = 'Gitsigns: diffthis' }, { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gD', function() gitsigns.diffthis('~') end, { desc = 'Gitsigns: diffthis ~' },
          { buffer = bufnr })
        vim.keymap.set({ 'n', 'v' }, '<Leader>gs', gitsigns.stage_hunk, { desc = 'Gitsigns: stage hunk' },
          { buffer = bufnr })
        vim.keymap.set({ 'n', 'v' }, '<Leader>gu', gitsigns.undo_stage_hunk, { desc = 'Gitsigns: undo stage hunk' }, { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gx', gitsigns.toggle_deleted, { desc = 'Gitsigns: toggle deleted' }, { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gr', gitsigns.reset_hunk, { desc = 'Gitsigns: reset hunk' }, { buffer = bufnr })
      end
    }
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '\\',
        mode = { 'n', 'o', 'x' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        '\\r',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Flash: Treesitter Search',
      },
      {
        '\\t',
        mode = { 'n', 'o', 'x' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash: Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Flash: Remote',
      },
      {
        '<C-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Flash: Toggle Search',
      }
    },
    opts = {
      jump = {
        autojump = true
      },
      label = {
        rainbow = {
          enabled = true
        }
      },
      modes = {
        char = {
          jump_labels = true
        },
        search = {
          enabled = true
        }
      },
      prompt = {
        enabled = true,
        prefix = { { '󰛕 ', 'FlashPromptIcon' } }
      }
    }
  },
  {
    'lewis6991/spaceless.nvim',
    event = 'VeryLazy',
    opts = {}
  },
  {
    'MagicDuck/grug-far.nvim',
    event = 'VeryLazy',
    keys = {
      { '<Leader>R', function() require('grug-far').grug_far() end, desc = 'Grug-Far' },
      { '<Leader>Rf', function() require('grug-far').grug_far({ prefills = { flags = vim.fn.expand('%') } }) end, desc = 'Grug-Far: current file' },
      { '<Leader>Rv', function() require('grug-far').with_visual_selection({ prefills = { flags = vim.fn.expand('%') } }) end, desc = 'Grug-Far: visual selection' },
      { '<Leader>Rw', function() require('grug-far').grug_far({ prefills = { search = vim.fn.expand('<cword>') } }) end, desc = 'Grug-Far: current word' },
    },
    opts = {}
  },
  {
    'will133/vim-dirdiff',
    cmd = 'DirDiff'
  },
  {
    'rktjmp/paperplanes.nvim',
    cmd = 'PP',
    opts = {
      register = '+',
      provider = 'dpaste.org',
      provider_options = {},
      notifier = vim.notify or print
    }
  },
  {
    'potamides/pantran.nvim',
    cmd = 'Pantran',
    config = function()
      local keylock = vim.env.HOME .. '/system/.deepl_key.gpg'
      if vim.fn.filereadable(keylock) then
        local unlocked = vim.fn.system({
          'gpg',
          '-q',
          '--no-verbose',
          '-d',
          '--batch',
          keylock
        })
        unlocked = unlocked:gsub('\n', '')
        vim.env.DEEPL_AUTH_KEY = unlocked
      else
        vim.notify('No DEEPL_AUTH_KEY available', vim.log.levels.WARN)
      end
      require('pantran').setup({
        default_engine = 'deepl'
      })
    end
  },
  {
    'zk-org/zk-nvim',
    keys = {
      '<Leader>zf',
      '<Leader>zl',
      '<Leader>zn',
      '<Leader>zr',
      '<Leader>zt'
    },
    dependencies = 'junegunn/fzf',
    config = function()
      local function make_edit_fn(defaults, picker_options)
        return function(options)
          options = vim.tbl_extend('force', defaults, options or {})
          require('zk').edit(options, picker_options)
        end
      end

      require('zk').setup({
        picker = 'snacks_picker'
      })

      require('zk.commands').add('ZkRecents', make_edit_fn({ createdAfter = '1 week ago' }, { title = 'Zk Recents' }))

      vim.keymap.set('n', '<Leader>zf', [[<Cmd>ZkNotes { match = { vim.fn.input('Search: ') } }<CR>]])
      vim.keymap.set('v', '<Leader>zf', [[:'<,'>ZkMatch<CR>]])
      vim.keymap.set('n', '<Leader>zn', [[<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>]])
      vim.keymap.set('n', '<Leader>zl', [[<Cmd>ZkNotes<CR>]])
      vim.keymap.set('n', '<Leader>zr', [[<Cmd>ZkRecents<CR>]])
      vim.keymap.set('n', '<Leader>zt', [[<Cmd>ZkTags<CR>]])
    end
  }
}
