return {
  -- {{{2 plenary.nvim
  'nvim-lua/plenary.nvim',
  -- }}}
  -- {{{2 nvim-luapad
  {
    'rafcamlet/nvim-luapad',
    cmd = 'Luapad',
    dependencies = 'antoinemadec/FixCursorHold.nvim'
  },
  -- }}}
  -- {{{2 nvim-luaref
  'milisims/nvim-luaref',
  -- }}}
  -- {{{2 vim-obsession
  {
    'tpope/vim-obsession',
    keys = ',to',
    init = function()
      vim.keymap.set('n', ',to', vim.cmd.Obsession)
    end
  },
  -- }}}
  -- {{{2 vim-repeat
  'tpope/vim-repeat',
  -- }}}
  -- {{{2 vim-unimpaired
  {
    'tpope/vim-unimpaired',
    event = 'VeryLazy'
  },
  -- }}}
  -- {{{2 leap.nvim
  {
    'ggandor/leap.nvim',
    event = 'VeryLazy',
    config = function()
      require('leap').set_default_keymaps()
    end
  },
  -- }}}
  -- {{{2 spaceless.nvim
  {
    'lewis6991/spaceless.nvim',
    event = 'VeryLazy',
    config = function()
      require('spaceless').setup()
    end
  },
  -- }}}
  -- {{{2 hover.nvim
  {
    'lewis6991/hover.nvim',
    keys = {
      'H',
      'gH'
    },
    init = function()
      vim.keymap.set('n', 'H', require('hover').hover, { desc = 'hover.nvim' })
      vim.keymap.set('n', 'gH', require('hover').hover_select, { desc = 'hover.nvim (select)' })
    end,
    config = function()
      require('hover').setup {
        init = function()
          require('hover.providers.lsp')
          require('hover.providers.man')
        end,
        preview_opts = {
          border = nil
        },
        title = true
      }
    end
  },
  -- }}}
  -- {{{2 nvim-surround
  {
    'kylechui/nvim-surround',
    event = 'BufReadPost',
    config = function()
      require('nvim-surround').setup()
    end
  },
  -- }}}
  -- {{{2 Comment.nvim
  {
    'numToStr/Comment.nvim',
    event = 'BufReadPost',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring'
    },
    init = function()
      vim.keymap.set('x', 'gci', [[:g/./lua require('Comment.api').toggle.linewise.current()<CR><Cmd>nohls<CR>]],
        { silent = true },
        { desc = 'Invert comments' })
    end,
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
      })
    end
  },
  -- }}}
  -- {{{2 text-case.nvim
  {
    'johmsalas/text-case.nvim',
    event = 'BufReadPost',
    config = function()
      require('textcase').setup()
    end
  },
  -- }}}
  -- {{{2 buffer-manager.nvim
  {
    'j-morano/buffer_manager.nvim',
    keys = '<Leader>b',
    init = function()
      vim.keymap.set({ 't', 'n' }, '<Leader>b', require('buffer_manager.ui').toggle_quick_menu, { noremap = true })
    end
  },
  -- }}}
  -- {{{2 nvim-bqf
  {
    'kevinhwang91/nvim-bqf',
    event = 'BufReadPost',
    config = function()
      vim.api.nvim_command([[packadd cfilter]])
      require('bqf').setup({
        auto_enable = true,
        auto_resize_height = true
      })
    end
  },
  -- }}}
  -- {{{2 nvim-hlslens
  {
    'kevinhwang91/nvim-hlslens',
    event = 'VeryLazy',
    init = function()
      vim.keymap.set('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        { desc = 'Hlslens: n' })
      vim.keymap.set('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        { desc = 'Hlslens: N' })
      vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], { desc = 'Hlslens: *' })
      vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], { desc = 'Hlslens: #' })
      vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], { desc = 'Hlslens: g*' })
      vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], { desc = 'Hlslens: g#' })
    end,
    config = function()
      require('hlslens').setup()
      vim.opt.shortmess:append('S')
    end
  },
  -- }}}
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
  -- }}}
  -- {{{2 mkdnflow.nvim
  {
    'jakewvincent/mkdnflow.nvim',
    ft = 'markdown',
    config = function()
      require('mkdnflow').setup({
        mappings = {
          MkdnTableNextCell = { 'i', '<M-Tab>' },
          MkdnTablePrevCell = { 'i', '<M-S-Tab>' },
          MkdnTableNewRowBelow = { 'n', ',mir' },
          MkdnTableNewRowAbove = { 'n', ',miR' },
          MkdnTableNewColAfter = { 'n', ',mic' },
          MkdnTableNewColBefore = { 'n', ',miC' },
          MkdnFoldSection = { 'n', ',mf' },
          MkdnUnfoldSection = { 'n', ',mF' },
          MkdnUpdateNumbering = { 'n', ',mn' }
        }
      })
    end
  },
  -- }}}
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
  -- }}}
  -- {{{2 vim-simple-align
  {
    'kg8m/vim-simple-align',
    cmd = 'SimpleAlign'
  },
  -- }}}
  -- {{{2 fm-nvim
  {
    'is0n/fm-nvim',
    cmd = {
      'Fzf',
      'Lazygit',
      'ViFm'
    },
    init = function()
      vim.keymap.set('n', '<Leader>z', vim.cmd.Fzf, { desc = 'Fzf' })
      vim.keymap.set('n', '<Leader>L', vim.cmd.Lazygit, { desc = 'Lazygit' })
      vim.keymap.set('n', '<Leader>x', vim.cmd.Vifm, { desc = 'Vifm' })
    end,
    config = function()
      require('fm-nvim').setup({
        ui = {
          default = 'float',
          float = {
            border = My_Borders,
            float_hl = 'Normal',
            border_hl = 'FloatBorder'
          }
        }
      })
    end
  },
  -- }}}
  -- {{{2 toggleterm.nvim
  {
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    keys = '<C-\\>',
    init = function()
      vim.keymap.set('n', '<Leader>Tf', [[<Cmd>ToggleTerm direction=float<CR>]])
      vim.keymap.set('n', '<Leader>Th', [[<Cmd>ToggleTerm direction=horizontal<CR>]])
      vim.keymap.set('n', '<Leader>Tv', [[<Cmd>ToggleTerm direction=vertical<CR>]])
    end,
    config = function()
      require('toggleterm').setup({
        size = function(term)
          if term.direction == 'horizontal' then
            return vim.o.lines * 0.44
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.44
          end
        end,
        open_mapping = [[<C-\>]],
        shade_terminals = false,
        direction = 'float',
        float_opts = {
          border = My_Borders
        }
      })
    end
  },
  -- }}}
  -- {{{2 smartyank.nvim
  {
    'ibhagwan/smartyank.nvim',
    event = 'VeryLazy'
  },
  -- }}}
  -- {{{2 nvim-spectre
  {
    'windwp/nvim-spectre',
    cmd = 'Spectre',
    init = function()
      vim.keymap.set('n', '<Leader>S', require('spectre').open, { desc = 'Open spectre' })
    end,
    config = function()
      require('spectre').setup({
        find_engine = {
          ['rg'] = {
            cmd = 'ugrep',
            args = {
              '-RIjnkzs',
              '--ignore-files',
              '--exclude-dir=".git"'
            },
            options = {
              ['ignore-case'] = {
                value = '--ignore-case',
                icon = '[I]',
                desc = 'ignore case'
              },
              ['hidden'] = {
                value = '--hidden',
                desc = 'hidden file',
                icon = '[H]'
              },
            }
          }
        }
      })
    end
  },
  -- }}}
  -- {{{2 undotree
  {
    'jiaoshijie/undotree',
    keys = ',tu',
    init = function()
      vim.keymap.set('n', ',tu', require('undotree').toggle, { noremap = true, silent = true }, { desc = 'Undo tree' })
    end,
    config = function()
      require('undotree').setup({
        window = {
          winblend = 0,
        }
      })
    end
  },
  -- }}}
  -- {{{2 vim-dirdiff
  {
    'will133/vim-dirdiff',
    cmd = 'DirDiff'
  },
  -- }}}
  -- {{{2 paperplanes.nvim
  {
    'rktjmp/paperplanes.nvim',
    cmd = 'PP',
    config = function()
      require('paperplanes').setup({
        register = '+',
        provider = 'dpaste.org',
        provider_options = {},
        notifier = vim.notify or print
      })
    end
  },
  -- }}}
  -- {{{2 vim-renamer
  {
    'qpkorr/vim-renamer',
    cmd = 'Renamer'
  },
  -- }}}
  -- {{{2 vim-gnupg
  {
    'jamessan/vim-gnupg',
    lazy = false
  },
  -- }}}
  -- {{{2 vim-log-highlighting
  {
    'MTDL9/vim-log-highlighting',
    ft = 'log'
  },
  -- }}}
  -- {{{2 rasi.vim
  {
    'Fymyte/rasi.vim',
    ft = 'rasi',
    build = ':TSInstall rasi'
  },
  -- }}}
  -- {{{2 unicode.vim
  {
    'chrisbra/unicode.vim',
    cmd = {
      'UnicodeName',
      'UnicodeTable'
    },
    init = function()
      vim.keymap.set('n', '<Leader>ut', vim.cmd.UnicodeTable)
      vim.keymap.set('n', 'gu', vim.cmd.UnicodeName)
    end
  },
  -- }}}
  -- {{{2 vim-startuptime
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime'
  }
  -- }}}
}
-- vim: foldmethod=marker foldlevel=1
