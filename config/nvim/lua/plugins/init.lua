return {
  -- {{{2 plenary.nvim
  'nvim-lua/plenary.nvim',
  -- }}}2
  -- {{{2 nvim-luapad
  {
    'rafcamlet/nvim-luapad',
    cmd = 'Luapad',
    dependencies = 'antoinemadec/FixCursorHold.nvim'
  },
  -- }}}2
  -- {{{2 Projects
  {
    'gennaro-tedesco/nvim-possession',
    keys = {
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
  -- }}}2
  -- {{{2 vim-repeat
  {
    'tpope/vim-repeat',
    keys = '.'
  },
  -- }}}2
  -- {{{2 vim-unimpaired
  {
    'tpope/vim-unimpaired',
    event = 'VeryLazy'
  },
  -- }}}2
  -- {{{2 leap.nvim
  {
    'ggandor/leap.nvim',
    event = 'VeryLazy',
    config = function()
      require('leap').add_default_mappings()
    end
  },
  -- }}}2
  -- {{{2 spaceless.nvim
  {
    'lewis6991/spaceless.nvim',
    event = 'VeryLazy',
    opts = {}
  },
  -- }}}2
  -- {{{2 hover.nvim
  {
    'lewis6991/hover.nvim',
    keys = {
      { 'H', function() require('hover').hover() end, desc = 'hover.nvim' },
      { 'gH', function() require('hover').hover_select() end, desc = 'hover.nvim (select)' }
    },
    config = function()
      require('hover').setup({
        init = function()
          require('hover.providers.lsp')
          require('hover.providers.man')
        end,
        preview_opts = {
          border = nil
        },
        title = true
      })
    end
  },
  -- }}}2
  -- {{{2 ultimate-autopair.nvim
  {
    'altermo/ultimate-autopair.nvim',
    event = 'VeryLazy',
    opts = {}
  },
  -- }}}2
  -- {{{2 nvim-surround
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    opts = {}
  },
  -- }}}2
  -- {{{2 Comment.nvim
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    keys = {
      { 'gci', [[:g/./lua require('Comment.api').toggle.linewise.current()<CR><Cmd>nohls<CR>]],
        mode = 'x', silent = true, desc = 'Invert comments' }
    },
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
      })
    end
  },
  -- }}}2
  -- {{{2 dial.nvim
  {
    'monaqa/dial.nvim',
    keys = {
      { '<C-a>', function() return require('dial.map').inc_normal() end, expr = true, desc = 'Increment' },
      { '<C-x>', function() return require('dial.map').dec_normal() end, expr = true, desc = 'Decrement' },
      { '<C-a>', function() return require('dial.map').inc_normal() end, mode = 'v', expr = true, desc = 'Increment visual selection' },
      { '<C-x>', function() return require('dial.map').dec_normal() end, mode = 'v', expr = true, desc = 'Decrement visual selection' }
    },
    config = function()
      local augend = require('dial.augend')
      require('dial.config').augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.bool,
          augend.semver.alias.semver
        }
      })
    end
  },
  -- }}}
  -- {{{2 text-case.nvim
  {
    'johmsalas/text-case.nvim',
    event = 'VeryLazy',
    opts = {}
  },
  -- }}}2
  -- {{{2 nvim-bqf
  {
    'kevinhwang91/nvim-bqf',
    dependencies = 'junegunn/fzf',
    event = 'BufReadPost',
    opts = {
      auto_enable = true,
      auto_resize_height = true
    }
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
  -- {{{2 vim-simple-align
  {
    'kg8m/vim-simple-align',
    cmd = 'SimpleAlign'
  },
  -- }}}2
  -- {{{2 fm-nvim
  {
    'is0n/fm-nvim',
    cmd = {
      'Fzf',
      'Lazygit',
      'Vifm'
    },
    keys = {
      { '<Leader>z', vim.cmd.Fzf, desc = 'Fzf' },
      { '<Leader>L', vim.cmd.Lazygit, desc = 'Lazygit' },
      { '<Leader>x', vim.cmd.Vifm, desc = 'Vifm' }
    },
    opts = {
      ui = {
        default = 'float',
        float = {
          border = require('config.ui').borders,
          float_hl = 'Normal',
          border_hl = 'FloatBorder'
        }
      }
    }
  },
  -- }}}2
  -- {{{2 toggleterm.nvim
  {
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    keys = {
      { '<C-\\>' },
      { '<Leader>Tf', [[<Cmd>ToggleTerm direction=float<CR>]], desc = 'ToggleTerm: floating' },
      { '<Leader>Th', [[<Cmd>ToggleTerm direction=horizontal<CR>]], desc = 'ToggleTerm: horizontal' },
      { '<Leader>Tv', [[<Cmd>ToggleTerm direction=vertical<CR>]], desc = 'ToggleTerm: vertical' }
    },
    opts = {
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
        border = require('config.ui').borders
      }
    }
  },
  -- }}}2
  -- {{{2 smartyank.nvim
  {
    'ibhagwan/smartyank.nvim',
    event = 'VeryLazy'
  },
  -- }}}2
  -- {{{2 nvim-spectre
  {
    'nvim-pack/nvim-spectre',
    keys = {
      { '<Leader>S', function() require('spectre').open() end, desc = 'Spectre' }
    },
    opts = {
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
    }
  },
  -- }}}2
  -- {{{2 undotree
  {
    'jiaoshijie/undotree',
    keys = {
      { ',tu', function() require('undotree').toggle() end, noremap = true, silent = true, desc = 'Undotree' }
    },
    opts = {
      window = {
        winblend = 0
      }
    }
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
  -- {{{2 vim-renamer
  {
    'qpkorr/vim-renamer',
    cmd = 'Renamer'
  },
  -- }}}2
  -- {{{2 vim-gnupg
  {
    'jamessan/vim-gnupg',
    lazy = false
  },
  -- }}}2
  -- {{{2 vim-log-highlighting
  {
    'MTDL9/vim-log-highlighting',
    ft = 'log'
  },
  -- }}}2
  -- {{{2 rasi.vim
  {
    'Fymyte/rasi.vim',
    ft = 'rasi',
    build = ':TSInstall rasi'
  },
  -- }}}2
  -- {{{2 unicode.vim
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
  },
  -- }}}2
}
-- vim: foldmethod=marker foldlevel=1
