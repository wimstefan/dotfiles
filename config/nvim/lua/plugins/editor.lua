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
      { '<Leader>b', function() require('fzf-lua').buffers({ formatter = 'path.filename_first' }) end, desc = 'Fzf: buffers' },
      { '<Leader>c', function() require('fzf-lua').colorschemes() end, desc = 'Fzf: colorschemes' },
      { '<Leader>f', function() require('fzf-lua').files({ formatter = 'path.filename_first' }) end, desc = 'Fzf: files' },
      { '<Leader>o', function() require('fzf-lua').oldfiles({ formatter = 'path.filename_first' }) end, desc = 'Fzf: oldfiles' },
      { '<Leader>h', function() require('fzf-lua').help_tags() end, desc = 'Fzf: help' },
      { '<Leader>k', function() require('fzf-lua').man_pages() end, desc = 'Fzf: man' },
      { '<Leader>t', function() require('fzf-lua').tabs({ formatter = 'path.filename_first' }) end, desc = 'Fzf: tabs' },
      { '<Leader>?', function() require('fzf-lua').lgrep_curbuf() end, desc = 'Fzf: grep current file' },
      { '<Leader>/', function() require('fzf-lua').live_grep_native({ formatter = 'path.filename_first' }) end, desc = 'Fzf: grep all files' },
      { '<Leader>fgb', function() require('fzf-lua').git_bcommits() end, desc = 'Fzf: git buffer commits' },
      { '<Leader>fgc', function() require('fzf-lua').git_commits() end, desc = 'Fzf: git commits' },
      { '<Leader>fgf', function() require('fzf-lua').git_files({ formatter = 'path.filename_first' }) end, desc = 'Fzf: git files' },
      { '<Leader>fgl', function() require('fzf-lua').git_blame() end, desc = 'Fzf: git blame' },
      { '<Leader>fgs', function() require('fzf-lua').git_status() end, desc = 'Fzf: git status' },
      { '<Leader>fc', function() require('fzf-lua').command_history() end, desc = 'Fzf: command history' },
      { '<Leader>fh', function() require('fzf-lua').highlights() end, desc = 'Fzf: highlights' },
      { '<Leader>fj', function() require('fzf-lua').jumps() end, desc = 'Fzf: marks' },
      { '<Leader>fk', function() require('fzf-lua').keymaps() end, desc = 'Fzf: keymaps' },
      { '<Leader>fm', function() require('fzf-lua').marks() end, desc = 'Fzf: marks' },
      { '<Leader>fq', function() require('fzf-lua').quickfix() end, desc = 'Fzf: quickfix' },
      { '<Leader>fr', function() require('fzf-lua').registers() end, desc = 'Fzf: registers' },
      { '<Leader>fs', function() require('fzf-lua').spell_suggest() end, desc = 'Fzf: spell suggest' },
      { '<Leader>ft', function() require('fzf-lua').filetypes() end, desc = 'Fzf: filetypes' },
      { '<Leader>fw', function() require('fzf-lua').grep_cword({ formatter = 'path.filename_first' }) end, desc = 'Fzf: grep string' }
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
          prompt = 'Files❯ '
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
        lsp = {
          symbols = {
            winopts = right_column
          }
        },
        spell_suggest = {
          winopts = {
            relative = 'cursor',
            width = 0.2,
            row = 1.01
          }
        }
      })

      fzf_lua.register_ui_select(function(_, items)
        local min_h, max_h = 0.15, 0.70
        local h = (#items + 4) / vim.o.lines
        if h < min_h then
          h = min_h
        elseif h > max_h then
          h = max_h
        end
        return { winopts = { height = h, width = 0.60, row = 0.40 } }
      end)

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
        vim.keymap.set('n', '<Leader>gs', gitsigns.stage_hunk, { desc = 'Gitsigns: stage hunk' }, { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gu', gitsigns.undo_stage_hunk, { desc = 'Gitsigns: undo stage hunk' }, { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gx', gitsigns.toggle_deleted, { desc = 'Gitsigns: toggle deleted' }, { buffer = bufnr })
        vim.keymap.set('n', '<Leader>gr', gitsigns.reset_hunk, { desc = 'Gitsigns: reset hunk' }, { buffer = bufnr })
      end
    }
  },
  -- }}}2
  -- {{{2 neogit
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'ibhagwan/fzf-lua'
    },
    event = 'VeryLazy',
    keys = {
      { '<Leader>gn', vim.cmd.Neogit, desc = 'Neogit' }
    },
    opts = {
      graph_style = 'unicode'
    }
  },
  -- }}}2
  -- {{{2 flash.nvim
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
  -- }}}2
  -- {{{2 spaceless.nvim
  {
    'lewis6991/spaceless.nvim',
    event = 'VeryLazy',
    opts = {}
  },
  -- }}}2
  -- {{{2 grug-far.nvim
  {
    'MagicDuck/grug-far.nvim',
    event = 'VeryLazy',
    keys = {
      { '<Leader>R', function() require('grug-far').grug_far() end, desc = 'Grug-Far' },
      { '<Leader>Rf', function() require('grug-far').grug_far({ prefills = { flags = vim.fn.expand('%') } }) end, desc = 'Grug-Far: current file' },
      { '<Leader>Rv', function() require('grug-far').with_visual_selection({ prefills = { flags = vim.fn.expand('%') } }) end, desc = 'Grug-Far: visual selection' },
      { '<Leader>Rw', function() require('grug-far').grug_far({ prefills = { search = vim.fn.expand('<cword>') } }) end, desc = 'Grug-Far: current file' },
    },
    opts = {}
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
        picker = 'fzf_lua'
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
  -- }}}2
}
-- vim: foldmethod=marker foldlevel=1
