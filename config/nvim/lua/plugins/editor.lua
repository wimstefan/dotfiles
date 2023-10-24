return {
  -- {{{2 fzf
  {
    'junegunn/fzf',
    build = './install --all --xdg'
  },
  {
    'ibhagwan/fzf-lua',
    keys = {
      { '<Leader>F', function() require('fzf-lua').builtin() end, desc = 'Fzf: builtin' },
      { '<Leader>b', function() require('fzf-lua').buffers() end, desc = 'Fzf: buffers' },
      { '<Leader>c', function() require('fzf-lua').colorschemes() end, desc = 'Fzf: colorschemes' },
      { '<Leader>f', function() require('fzf-lua').files() end, desc = 'Fzf: files' },
      { '<Leader>o', function() require('fzf-lua').oldfiles() end, desc = 'Fzf: oldfiles' },
      { '<Leader>h', function() require('fzf-lua').help_tags() end, desc = 'Fzf: help' },
      { '<Leader>k', function() require('fzf-lua').man_pages() end, desc = 'Fzf: man' },
      { '<Leader>t', function() require('fzf-lua').tabs() end, desc = 'Fzf: tabs' },
      { '<Leader>?', function() require('fzf-lua').lgrep_curbuf() end, desc = 'Fzf: grep current file' },
      { '<Leader>/', function() require('fzf-lua').live_grep_native() end, desc = 'Fzf: grep all files' },
      { '<Leader>fgb', function() require('fzf-lua').git_bcommits() end, desc = 'Fzf: git buffer commits' },
      { '<Leader>fgc', function() require('fzf-lua').git_commits() end, desc = 'Fzf: git commits' },
      { '<Leader>fgf', function() require('fzf-lua').git_files() end, desc = 'Fzf: git files' },
      { '<Leader>fgs', function() require('fzf-lua').git_status() end, desc = 'Fzf: git status' },
      { '<Leader>fc', function() require('fzf-lua').command_history() end, desc = 'Fzf: command history' },
      { '<Leader>fh', function() require('fzf-lua').highlights() end, desc = 'Fzf: highlights' },
      { '<Leader>fk', function() require('fzf-lua').keymaps() end, desc = 'Fzf: keymaps' },
      { '<Leader>fm', function() require('fzf-lua').marks() end, desc = 'Fzf: marks' },
      { '<Leader>fq', function() require('fzf-lua').quickfix() end, desc = 'Fzf: quickfix' },
      { '<Leader>fr', function() require('fzf-lua').registers() end, desc = 'Fzf: registers' },
      { '<Leader>fs', function() require('fzf-lua').spell_suggest() end, desc = 'Fzf: spell suggest' },
      { '<Leader>ft', function() require('fzf-lua').filetypes() end, desc = 'Fzf: filetypes' },
      { '<Leader>fw', function() require('fzf-lua').grep_cword() end, desc = 'Fzf: grep string' }
    },
    config = function()
      local fzf_lua = require('fzf-lua')

      local bottom_row = {
        height = 0.4,
        width = 1,
        row = 1,
        col = 0,
        preview = {
          layout = 'horizontal',
          horizontal = 'right:55%',
        }
      }
      local right_popup = {
        height = 0.97,
        width = 0.2,
        row = 0.3,
        col = 1
      }
      local right_column = {
        height = 1,
        width = 0.45,
        row = 0,
        col = 1,
        preview = {
          layout = 'vertical',
          vertical = 'down:65%'
        }
      }

      fzf_lua.setup({
        global_resume = true,
        winopts = bottom_row,
        builtin = {
          winopts = right_column
        },
        colorschemes = {
          winopts = right_popup
        },
        diagnostics = {
          winopts = right_column
        },
        files = {
          prompt = 'Files❯ ',
        },
        filetypes = {
          winopts = {
            relative = 'cursor',
            width = 0.14,
            row = 1.01
          }
        },
        git = {
          branches = {
            winopts = right_column
          },
          bcommits = {
            winopts = right_column
          },
          commits = {
            winopts = right_column
          },
          status = {
            winopts = right_column
          },
        },
        grep = {
          cmd = 'ugrep -RIjnkzs --hidden --ignore-files --exclude-dir=".git"',
          winopts = right_column
        },
        highlights = {
          winopts = right_column
        },
        spell_suggest = {
          winopts = {
            relative = 'cursor',
            width = 0.2,
            row = 1.01
          }
        }
      })
    end
  },
  -- }}}2
  -- {{{2 gitsigns.nvim
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
        border = require('config.ui').borders,
        relative = 'cursor',
        row = 1,
        col = 2
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        vim.keymap.set('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'",
          { expr = true, replace_keycodes = false },
          { desc = 'Gitsigns: next hunk' })
        vim.keymap.set('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'",
          { expr = true, replace_keycodes = false },
          { desc = 'Gitsigns: previous hunk' })
        vim.keymap.set('n', '<Leader>gp', gs.preview_hunk_inline, { desc = 'Gitsigns: preview hunk' }, { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gb', function() gs.blame_line { full = true } end, { desc = 'Gitsigns: blame line' },
          { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gd', gs.diffthis, { desc = 'Gitsigns: diffthis' }, { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gD', function() gs.diffthis('~') end, { desc = 'Gitsigns: diffthis ~' },
          { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gs', gs.stage_hunk, { desc = 'Gitsigns: stage hunk' }, { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gu', gs.undo_stage_hunk, { desc = 'Gitsigns: undo stage hunk' }, { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gx', gs.toggle_deleted, { desc = 'Gitsigns: toggle deleted' }, { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gr', gs.reset_hunk, { desc = 'Gitsigns: reset hunk' }, { buffer = bufnr })
      end
    }
  },
  -- }}}2
  -- {{{2 flash.nvim
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      search = {
        mode = 'fuzzy',
        incremental = true
      },
      jump = {
        autojump = true
      }
    }
  },
  -- }}}2
  -- {{{2 spaceless.nvim
  {
    'lewis6991/spaceless.nvim',
    event = 'VeryLazy',
    opts = {}
  },
  -- }}}2
  -- {{{2 vim-renamer
  {
    'qpkorr/vim-renamer',
    cmd = 'Renamer'
  },
  -- }}}2
  -- {{{2 vim-dirdiff
  {
    'will133/vim-dirdiff',
    cmd = 'DirDiff'
  },
  -- }}}2
  -- {{{2 paperplanes.nvim
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
  -- }}}2
  -- {{{2 pantran.nvim
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
  -- }}}2
  -- {{{2 zk-nvim
  {
    'mickael-menu/zk-nvim',
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
        picker = 'fzf'
      })

      require('zk.commands').add('ZkRecents', make_edit_fn({ createdAfter = '1 week ago' }, { title = 'Zk Recents' }))

      vim.keymap.set('n', '<Leader>zf', [[<Cmd>ZkNotes { match = { vim.fn.input('Search: ') } }<CR>]])
      vim.keymap.set('v', '<Leader>zf', [[:'<,'>ZkMatch<CR>]])
      vim.keymap.set('n', '<Leader>zn', [[<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>]])
      vim.keymap.set('n', '<Leader>zl', [[<Cmd>ZkNotes<CR>]])
      vim.keymap.set('n', '<Leader>zr', [[<Cmd>ZkRecents<CR>]])
      vim.keymap.set('n', '<Leader>zt', [[<Cmd>ZkTags<CR>]])
    end
  },
  -- }}}2
  -- {{{2 muren.nvim
  {
    'AckslD/muren.nvim',
    keys = {
      { '<Leader>R', vim.cmd.MurenToggle, desc = 'Muren' },
      { '<Leader>Rf', vim.cmd.MurenFresh, desc = 'Muren: fresh' },
      { '<Leader>Ru', vim.cmd.MurenUnique, desc = 'Muren: unique' }
    },
    config = true
  }
  -- }}}
}
-- vim: foldmethod=marker foldlevel=1
