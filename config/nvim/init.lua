--------------------- MY PERSONAL NEOVIM CONFIGURATION -------------------------
-- {{{1 --------------------- First things first. ------------------------------
require('impatient')
-- }}}
-- {{{1 --------------------- OPTIONS ------------------------------------------
-- define leader keys
vim.g.mapleader = ' '

local indent = 2

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showtabline = 2
vim.opt.linebreak = true
vim.opt.showbreak = '  » '
vim.opt.conceallevel = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.list = true
vim.opt.listchars = {
  tab = '› ',
  trail = '·',
  eol = '«',
  extends = '>',
  precedes = '<'
}
vim.opt.fillchars = {
  vert = '▌',
  foldclose = '▾',
  foldopen = '▴',
  foldsep = '🮍',
  msgsep = '🮑'
}
vim.opt.mouse = 'a'

vim.opt.shiftwidth = indent
vim.opt.shiftround = true
vim.opt.softtabstop = indent
vim.opt.tabstop = indent
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.gdefault = true
vim.opt.inccommand = 'split'
vim.opt.selection = 'exclusive'
vim.opt.pastetoggle = '<F3>'
vim.opt.diffopt:append({
  'vertical',
  'indent-heuristic',
  'algorithm:histogram'
})
vim.opt.spellfile = vim.fn.stdpath('config') .. '/spell/myspell.utf-8.add'
vim.opt.spelllang = {
  'en',
  'de',
  'es',
  'nl'
}
vim.opt.nrformats:append({
  'alpha'
})
if vim.fn.executable('ugrep') == 1 then
  vim.opt.grepprg = 'ugrep -RIjnkz --hidden --ignore-files'
  vim.opt.grepformat = '%f:%l:%c:%m,%f+%l+%c+%m,%-G%f\\|%l\\|%c\\|%m'
elseif vim.fn.executable('git') == 1 then
  vim.opt.grepprg = 'git'
elseif vim.fn.executable('ack') == 1 then
  vim.opt.grepprg = 'ack --nogroup --column --smart-case --nocolor --follow $*'
end
vim.opt.keywordprg = ':help'

vim.opt.timeoutlen = 500
vim.opt.updatetime = 100
vim.opt.autowrite = true
vim.opt.backup = false
vim.opt.backupcopy = 'auto'
vim.opt.writebackup = true
vim.opt.undofile = true
vim.opt.modelineexpr = true

vim.opt.foldlevel = 99
local fm_opts = vim.opt.foldmethod:get()
if fm_opts == '' or fm_opts == 'manual' then
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
else
  vim.opt.foldmethod = fm_opts
end

vim.g.netrw_winsize = 20
vim.g.netrw_banner =  0
vim.g.netrw_liststyle =  3
vim.g.netrw_preview =  0
vim.g.netrw_alto =  0

-- Visual configuration options
-- symbols --
_G.my_symbols = {
  Array = '謹',
  Boolean = '凌',
  Class = ' ',
  Color = ' ',
  Constant = ' ',
  Constructor = ' ',
  EnumMember = ' ',
  Enum = ' ',
  Event = ' ',
  Field = ' ',
  File = ' ',
  Folder = ' ',
  Function = ' ',
  Interface = ' ',
  Keyword = ' ',
  Namespace = ' ',
  Method = ' ',
  Module = ' ',
  Number = '濫',
  Object = '謹',
  Operator = ' ',
  Package = ' ',
  Property = ' ',
  Reference = ' ',
  Snippet = ' ',
  Struct = ' ',
  Text = ' ',
  TypeParameter = ' ',
  Unit = ' ',
  Value = ' ',
  Variable = ' ',
}
-- borders --
_G.my_borders = 'rounded'

-- }}}1 --------------------- OPTIONS ------------------------------------------
-- {{{1 --------------------- MAPPINGS -----------------------------------------
vim.keymap.set('',  'cd', '<Cmd>cd %:h | pwd<CR>')
vim.keymap.set('n', '<Leader>g', ':grep<Space>')
vim.keymap.set('n', '<Leader>l', '<Cmd>nohlsearch | hi clear ColorColumn<CR>')
-- {{{2 navigation
vim.keymap.set('n', 'k', [[v:count == 0 ? 'gk' : 'k']], {expr = true})
vim.keymap.set('n', 'j', [[v:count == 0 ? 'gj' : 'j']], {expr = true})
-- }}}
-- {{{2 editing
vim.keymap.set('n', '<Leader>ev', '<Cmd>edit $MYVIMRC<CR>')
vim.keymap.set('n', '<Leader>sv', '<Cmd>luafile $MYVIMRC<CR>')
vim.keymap.set('n', '<Leader>w', '<Cmd>w!<CR>')
vim.keymap.set('n', '<Leader>wa', '<Cmd>wa!<CR>')
vim.keymap.set('n', '<Leader>q', '<Cmd>q!<CR>')
vim.keymap.set('n', '<Leader>qa', '<Cmd>qa!<CR>')
vim.keymap.set('n', '<Leader>wqa', '<Cmd>wqa!<CR>')
vim.keymap.set('n', ',ul', '<Cmd>undolist<CR>')
-- }}}
-- {{{2 buffers
vim.keymap.set('n', '<Tab>', '<Cmd>bnext<CR>')
vim.keymap.set('n', '<S-Tab>', '<Cmd>bprev<CR>')
vim.keymap.set('n', '<Leader><Leader>', '<C-^>')
vim.keymap.set('n', '<Leader>bd', '<Cmd>bdelete<CR>')
-- }}}
-- {{{2 tabs
vim.keymap.set('n', '<Leader>td', '<Cmd>tabclose<CR>')
-- }}}
-- {{{2 terminals
vim.keymap.set('t', '<Esc>', [[<C-\><C-N>]])
vim.keymap.set('t', '<A-h>', [[<C-\><C-N><C-w>h]])
vim.keymap.set('t', '<A-j>', [[<C-\><C-N><C-w>j]])
vim.keymap.set('t', '<A-k>', [[<C-\><C-N><C-w>k]])
vim.keymap.set('t', '<A-l>', [[<C-\><C-N><C-w>l]])
-- }}}
--{{{2 signatures
vim.keymap.set('n', '<Leader>sa', [[1G:s#\(Stefan Wimmer\) <.*>#\1 <stefan@tangoartisan.com>#<CR>G?--<CR>jVGd :r ~/.mutt/short-signature-artisan<CR>/^To:<CR>]])
vim.keymap.set('n', '<Leader>sg', [[1G:s#\(Stefan Wimmer\) <.*>#\1 <wimstefan@gmail.com>#<CR>G?--<CR>jVGd :r ~/.mutt/short-signature-gmail<CR>/^To:<CR>]])
vim.keymap.set('n', '<Leader>st', [[G?--<CR>jVGd :r ~/.mutt/short-signature-tango<CR>]])
vim.keymap.set('n', '<Leader>ss', [[G?--<CR>jVGd :r ~/.mutt/short-signature<CR>]])
vim.keymap.set('n', '<Leader>sl', [[G?--<CR>jVGd :r ~/.mutt/signature<CR>]])
-- }}}
-- {{{2 show manpage of current word
ShowMan = function()
  local cword = vim.fn.expand('<cword>')
  vim.cmd('Man ' .. cword)
end
vim.keymap.set('n', 'M', '<Cmd>lua ShowMan()<CR>')
-- }}}
-- {{{2 toggle to disable detailed information for easier paste
ToggleDetails = function()
  local mouse_opts = vim.opt.mouse:get()
  if mouse_opts.a then
    vim.opt.mouse = 'v'
    vim.opt.cursorcolumn = false
    vim.opt.cursorline = false
    vim.opt.signcolumn = 'no'
    vim.opt.foldenable = false
    vim.opt.list = false
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.colorcolumn = ''
    vim.notify('Details disabled', vim.log.levels.INFO, {title = '[UI]'})
  else
    vim.opt.mouse = 'a'
    vim.opt.cursorcolumn = true
    vim.opt.cursorline = true
    vim.opt.signcolumn = 'yes'
    vim.opt.foldenable = true
    vim.opt.list = true
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.colorcolumn = '80'
    vim.notify('Details enabled', vim.log.levels.INFO, {title = '[UI]'})
  end
end
vim.keymap.set('n', '<F10>', '<Cmd>lua ToggleDetails()<CR>')
-- }}}
-- }}}1 --------------------- MAPPINGS -----------------------------------------
-- {{{1 --------------------- AUTOCMDS -----------------------------------------
vim.api.nvim_exec([[
augroup General
  autocmd!
  " mail specific configuration
  autocmd BufRead * if expand('%') =~ '/tmp/mutt*' | setfiletype mail | endif
  " tridactyl editing
  autocmd BufRead * if expand('%') =~ 'tangoartisan' | setfiletype html | endif
  " Syntax for tmux
  autocmd BufNewFile,BufRead *tmux*conf* set filetype=tmux
  " Syntax for htp files
  autocmd BufNewFile,BufRead {*.htp,*.htt} set filetype=xhtml
  " Syntax for xmp files
  autocmd BufNewFile,BufRead {*.xmp} set filetype=xml
  " Syntax for Xorg log files
  autocmd BufNewFile,BufRead *Xorg*log* set filetype=msmessages
  " Automatically chmod +x Shell and Perl scripts
  autocmd BufWritePost {*.sh,*.pl,*.py} silent !chmod +x %
  " Change fileformat on playlist files (created by moc)
  autocmd BufNewFile,BufRead *.m3u set encoding=utf-8 fileencoding=utf-8 ff=unix
  " run xrdb whenever Xdefaults or Xresources are updated
  autocmd BufWritePost X{resources,defaults} silent !xrdb %
  " Encoding for cddb files
  autocmd BufNewFile,BufRead *cddb* set encoding=utf-8 fileencoding=utf-8 ff=unix
  " Enable spelling for text files
  autocmd FileType {txt,markdown,asciidoc*,rst} if &filetype !~ 'man\|help' | setlocal spell | endif
  " Some buffers can be closed with 'q'
  autocmd FileType help,man,startuptime,qf,lspinfo,checkhealth nnoremap <buffer><silent>q :bdelete<CR>
  " Disable folding in previews
  autocmd BufWinEnter * if &previewwindow | setlocal nofoldenable | endif
  " Remember last cursor position
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | execute "normal! g`\"" | endif
  " Enable yank highlighting
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup='WildMenu', timeout=4444}
  " Clean ColorColumn
  autocmd ColorScheme * highlight clear ColorColumn
augroup END
augroup Commentstrings
  autocmd!
  autocmd FileType pfmain set commentstring=#\%s
  autocmd FileType toml set commentstring=#\%s
  autocmd FileType vifm set commentstring=\"\ %s
  autocmd FileType xdefaults set commentstring=!\%s
  autocmd BufNewFile,BufRead *.ptl set filetype=julia commentstring=#\ %s
  autocmd FileType json syntax match Comment +\/\/.\+$+
augroup END
augroup Help
  autocmd!
  autocmd BufWinEnter * if &filetype =~ 'help' | wincmd L | vertical resize 84 | endif
  autocmd BufWinEnter * if &filetype =~ 'man' | wincmd L | wincmd = | endif
  autocmd FileType {man,help,*doc} setlocal nonumber norelativenumber nospell nolist nocursorcolumn
augroup END
augroup Packer
  autocmd!
  autocmd FileType packer set previewheight=30
  autocmd FileType git set nolist nonumber norelativenumber
  autocmd BufWritePost init.lua if expand('%') !~ 'fugitive\|scp' | source <afile> | call v:lua.require('packer').sync() | endif
augroup end
]], false)
-- }}}1 --------------------- AUTOCMDS -----------------------------------------
-- {{{1 --------------------- FUNCTIONS ----------------------------------------
function _G.inspect(...)
  vim.notify(vim.inspect(...))
end
-- }}}1 --------------------- FUNCTIONS ----------------------------------------
-- {{{1 --------------------- PLUGINS ------------------------------------------
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local packer = require('packer')
local use = packer.use
packer.startup(function()
  packer.init({
    compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua',
    display = {
      open_cmd = '84vnew [packer]',
      working_sym = '北',
      error_sym = '✘',
      done_sym = '✔',
      removed_sym = '-',
      moved_sym = '➜',
      prompt_border = my_borders
    }
  })
-- {{{2 packer.nvim
  use {
    'wbthomason/packer.nvim',
    config = function()
      vim.keymap.set('n', ',pc', '<Cmd>PackerClean<CR>')
      vim.keymap.set('n', ',pi', '<Cmd>PackerInstall<CR>')
      vim.keymap.set('n', ',pq', '<Cmd>PackerStatus<CR>')
      vim.keymap.set('n', ',ps', '<Cmd>PackerSync<CR>')
      vim.keymap.set('n', ',pu', '<Cmd>PackerUpdate<CR>')
    end
  }
-- }}}
-- {{{2 impatient.nvim
  use {'lewis6991/impatient.nvim'}
-- }}}
-- {{{2 filetype.nvim
  use {'nathom/filetype.nvim'}
-- }}}
-- {{{2 FixCursorHold.nvim
  use {'antoinemadec/FixCursorHold.nvim'}
-- }}}
-- {{{2 startuptime
  use {'dstein64/vim-startuptime'}
-- }}}
-- {{{2 Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      'windwp/nvim-ts-autotag',
      'JoosepAlviste/nvim-ts-context-commentstring',
      {
        'nvim-treesitter/playground',
        config = function ()
          vim.keymap.set('n', '<F12>', [[<Cmd>TSHighlightCapturesUnderCursor<CR>]])
          vim.keymap.set('n', ',tsp', [[<Cmd>TSPlaygroundToggle<CR>]])
        end
      }
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        autotag = {
          enable = true
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false
        },
        highlight = {
          enable = true,
          use_languagetree = true
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
          },
        },
        indent = {
          enable = false
        },
        playground = {
          enable = true
        },
        refactor = {
          highlight_current_scope = { enable = false },
          highlight_definitions = { enable = true },
          navigation = {
            enable = true,
            keymaps = {
              goto_definition = 'gnd',
              list_definitions = 'gnD',
              list_definitions_toc = 'gO',
              goto_next_usage = '<a-*>',
              goto_previous_usage = '<a-#>',
            },
          },
          smart_rename = {
            enable = true,
            keymaps = {
              smart_rename = 'grr',
            },
          },
        },
        textobjects = {
          lookahead = true,
          lsp_interop = {
            enable = true,
            border = my_borders,
            peek_definition_code = {
              ['df'] = '@function.outer',
              ['dF'] = '@class.outer',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['[S'] = '@parameter.inner',
            },
            swap_previous = {
              [']S'] = '@parameter.inner',
            },
          },
        },
      })
      local parsers = require'nvim-treesitter.parsers'
      function _G.ensure_treesitter_language_installed()
        local lang = parsers.get_buf_lang()
        if parsers.get_parser_configs()[lang] and not parsers.has_parser(lang) then
          vim.schedule_wrap(function()
          vim.cmd('TSInstall '..lang)
          end)()
        end
      end
      vim.cmd [[autocmd FileType * lua ensure_treesitter_language_installed()]]
    end
  }
-- }}}
-- {{{2 Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make'
      }
    },
    config = function()
      vim.keymap.set('n', '<Leader>T', [[<Cmd>lua require('telescope.builtin').builtin(require('telescope.themes').get_dropdown({previewer = false}))<CR>]])
      vim.keymap.set('n', '<Leader>b', [[<Cmd>lua require('telescope.builtin').buffers()<CR>]])
      vim.keymap.set('n', '<Leader>c', [[<Cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<CR>]])
      vim.keymap.set('n', '<Leader>f', [[<Cmd>lua require('telescope.builtin').find_files({follow = true})<CR>]])
      vim.keymap.set('n', '<Leader>Tg', [[<Cmd>lua require('telescope.builtin').live_grep({grep_open_files=true})<CR>]])
      vim.keymap.set('n', '<Leader>TG', [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]])
      vim.keymap.set('n', '<Leader>h', [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]])
      vim.keymap.set('n', '<Leader>M', [[<Cmd>lua require('telescope.builtin').man_pages()<CR>]])
      vim.keymap.set('n', '<Leader>m', [[<Cmd>lua require('telescope.builtin').marks()<CR>]])
      vim.keymap.set('n', '<Leader>r', [[<Cmd>lua require('telescope.builtin').registers()<CR>]])
      vim.keymap.set('n', '<Leader>Tgb', [[<Cmd>lua require('telescope.builtin').git_bcommits()<CR>]])
      vim.keymap.set('n', '<Leader>Tgc', [[<Cmd>lua require('telescope.builtin').git_commits()<CR>]])
      vim.keymap.set('n', '<Leader>Tgf', [[<Cmd>lua require('telescope.builtin').git_files()<CR>]])
      vim.keymap.set('n', '<Leader>Tgs', [[<Cmd>lua require('telescope.builtin').git_status()<CR>]])
      vim.keymap.set('n', '<Leader>Tc', [[<Cmd>lua require('telescope.builtin').command_history()<CR>]])
      vim.keymap.set('n', '<Leader>Tf', [[<Cmd>lua require('telescope.builtin').filetypes(require('telescope.themes').get_dropdown({}))<CR>]])
      vim.keymap.set('n', '<Leader>Tm', [[<Cmd>lua require('telescope.builtin').keymaps()<CR>]])
      vim.keymap.set('n', '<Leader>To', [[<Cmd>lua require('telescope.builtin').oldfiles(require('telescope.themes').get_dropdown({previewer = false}))<CR>]])
      vim.keymap.set('n', '<Leader>Ts', [[<Cmd>lua require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor({}))<CR>]])
      vim.keymap.set('n', '<Leader>Tw', [[<Cmd>lua require('telescope.builtin').grep_string()<CR>]])
      vim.keymap.set('n', '<Leader>Tz', [[<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]])
      require('telescope').setup({
        defaults = {
          prompt_prefix = ' » ',
          dynamic_preview_title = true,
          file_ignore_patterns = {'db', 'gif', 'jpeg', 'jpg', 'ods', 'odt', 'pdf', 'png', 'svg', 'xcf', 'xls'},
          layout_config = {
            horizontal = {
              preview_width = 0.6
            }
          },
          layout_strategy = 'flex',
          mappings = {
            i = {
              ['<C-q>'] = require('telescope.actions').smart_send_to_qflist + require('telescope.actions').open_qflist,
              ['<M-q>'] = require('telescope.actions').smart_add_to_qflist + require('telescope.actions').open_qflist,
            },
            n = {
              ['<C-q>'] = require('telescope.actions').smart_send_to_qflist + require('telescope.actions').open_qflist,
              ['<M-q>'] = require('telescope.actions').smart_add_to_qflist + require('telescope.actions').open_qflist,
            },
          },
          preview = {
            msg_bg_fillchar = " ",
          },
          vimgrep_arguments = {
            'ugrep',
            '-RIjnkz',
            '--color=never',
            '--hidden',
            '--ignore-files'
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case'
          }
        }
      })
      require('telescope').load_extension('fzf')
    end
  }
-- }}}
-- {{{2 nvim-cmp
use {
  'hrsh7th/nvim-cmp',
  requires = {
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    {
      'saadparwaiz1/cmp_luasnip',
      requires = {
        'L3MON4D3/LuaSnip',
        'honza/vim-snippets'
      }
    },
    'f3fora/cmp-spell',
    'ray-x/cmp-treesitter',
    'dmitmel/cmp-digraphs'
  },
  config = function()
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end

    local cmp = require('cmp')
    local luasnip = require('luasnip')
    luasnip.filetype_extend('all', {'_'})
    require('luasnip.loaders.from_snipmate').lazy_load()

    cmp.setup({
      completion = {
        border = my_borders,
        scrollbar = '🮑'
      },
      documentation = {
        border = my_borders
      },
      experimental = {
        ghost_text = true,
        native_menu = false
      },
      formatting = {
        format = function(entry, vim_item)
          vim_item.menu = ({
            buffer = '[Buffer]',
            nvim_lsp = '[LSP]',
            nvim_lua = '[API]',
            path = '[Filesystem]',
            luasnip = '[Snippet]',
            spell = '[Spelling]',
            treesitter = '[TS]',
            digraphs = '[DG]',
          })[entry.source.name]
          vim_item.kind = my_symbols[vim_item.kind] .. ' ' .. vim_item.kind
          return vim_item
        end
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end
      },
      mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' })
      },
      sources = cmp.config.sources(
        {
          {name = 'nvim_lua'},
          {name = 'nvim_lsp'},
          {name = 'path'},
          {name = 'treesitter'},
          {name = 'luasnip'},
          {name = 'buffer',
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            }
          },
          {name = 'spell'},
          {name = 'digraphs'}
        }
      )
    })
    cmp.setup.cmdline(':', {
      sources = {
        { name = 'cmdline' }
      }
    })
    cmp.setup.cmdline('/', {
      sources = {
        { name = 'buffer' }
      }
    })
  end,
}
-- }}}
-- {{{2 LSP
  use {
    'neovim/nvim-lspconfig',
    requires = {
      {
        'kosayoda/nvim-lightbulb',
        config = function()
          vim.fn.sign_define('LightBulbSign', {text = ' ', texthl = 'WarningMsg', linehl='', numhl=''})
          vim.cmd [[autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]]
          require('nvim-lightbulb').update_lightbulb()
        end
      },
      'nvim-lua/lsp-status.nvim',
      'folke/lua-dev.nvim',
      'ii14/lsp-command',
      {
        'stevearc/aerial.nvim',
        config = function()
          require('aerial').setup({
            on_attach = function(bufnr)
              vim.keymap.set('n', '<Leader>a', '<Cmd>AerialToggle!<CR>', {buffer = bufnr})
              vim.keymap.set('n', '{', '<Cmd>AerialPrev<CR>', {buffer = bufnr})
              vim.keymap.set('n', '}', '<Cmd>AerialNext<CR>', {buffer = bufnr})
              vim.keymap.set('n', '{{', '<Cmd>AerialPrevUp<CR>', {buffer = bufnr})
              vim.keymap.set('n', '}}', '<Cmd>AerialNextUp<CR>', {buffer = bufnr})
            end
          })
          require('telescope').load_extension('aerial')
        end
      },
    },
    config = function()
      local lsp_aerial = require('aerial')
      local lsp_cmp = require('cmp_nvim_lsp')
      local lsp_config = require('lspconfig')
      local lsp_status = require('lsp-status')

      -- diagnostic handling
      local diagnostic_signs = {' ', ' ', '𥉉', ' '}
      local diagnostic_severity_fullnames = {'Error', 'Warning', 'Information', 'Hint'}
      local diagnostic_severity_shortnames = {'Error', 'Warn', 'Info', 'Hint'}
      for index, icon in ipairs(diagnostic_signs) do
        local fullname = diagnostic_severity_fullnames[index]
        local shortname = diagnostic_severity_shortnames[index]

        vim.fn.sign_define('DiagnosticSign' .. shortname, {
          text = icon,
          texthl = 'Diagnostic' .. shortname,
          linehl = '',
          numhl = '',
        })

        vim.fn.sign_define('LspDiagnosticsSign' .. fullname, {
          text = icon,
          texthl = 'LspDiagnosticsSign' .. fullname,
          linehl = '',
          numhl = '',
        })
      end
      vim.diagnostic.config({
        float = {
          border = my_borders,
          header = '',
          focusable = false,
          scope = 'cursor',
          source = 'always'
        },
        virtual_text = {
          focusable = false,
          prefix = '❰',
          source = 'always'
        }
      })

      -- lsp-status config
      lsp_status.config({
        current_function = false,
        diagnostics = false,
        indicator_errors = ' ' .. vim.trim(vim.fn.sign_getdefined('DiagnosticSignError')[1].text),
        indicator_warnings = ' ' .. vim.trim(vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text),
        indicator_info = ' ' .. vim.trim(vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text),
        indicator_hint = ' ' .. vim.trim(vim.fn.sign_getdefined('DiagnosticSignHint')[1].text),
        indicator_ok = '',
        select_symbol = function(cursor_pos, symbol)
          if symbol.valueRange then
            local value_range = {
              ['start'] = {
                character = 0,
                line = vim.fn.byte2line(symbol.valueRange[1])
              },
              ['end'] = {
                character = 0,
                line = vim.fn.byte2line(symbol.valueRange[2])
              }
            }
            return lsp_status.util.in_range(cursor_pos, value_range)
          end
        end,
        status_symbol = '',
      })
      lsp_status.register_progress()

      -- LSP handlers
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = my_borders
      })
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = my_borders
      })

      -- LSP functions
      local on_attach = function(client,bufnr)
        lsp_aerial.on_attach(client, bufnr)
        lsp_status.on_attach(client)
        local lsp_messages = {}
        local lsp_msg_sep = ' ∷ '
        lsp_messages = lsp_msg_sep .. 'LSP attached' .. lsp_msg_sep
        -- options
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        -- keybindings
        vim.keymap.set('n', ',lR', [[<Cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], {buffer = bufnr})
        vim.keymap.set('n', ',lr', [[<Cmd>lua require('telescope.builtin').lsp_references()<CR>]], {buffer = bufnr})
        vim.keymap.set('n', ',ly', [[<Cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], {buffer = bufnr})
        vim.keymap.set('n', ',lY', [[<Cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>]], {buffer = bufnr})
        vim.keymap.set('n', ',ld', [[<Cmd>lua require('telescope.builtin').diagnostics({bufnr = 0})<CR>]], {buffer = bufnr})
        vim.keymap.set('n', ',lD', [[<Cmd>lua require('telescope.builtin').diagnostics()<CR>]], {buffer = bufnr})
        vim.keymap.set('n', ',le', [[<Cmd>lua vim.diagnostic.open_float({scope = 'line', border = my_borders})<CR>]], {buffer = bufnr})
        vim.keymap.set('n', '[d', [[<Cmd>lua vim.diagnostic.goto_prev({float = false})<CR>]], {buffer = bufnr})
        vim.keymap.set('n', ']d', [[<Cmd>lua vim.diagnostic.goto_next({float = false})<CR>]], {buffer = bufnr})
        vim.keymap.set('n', ',lrn', [[<Cmd>lua vim.lsp.buf.rename()<CR>]], {buffer = bufnr})
        vim.keymap.set('n', ',lh', [[<Cmd>lua vim.lsp.buf.hover()<CR>]], {buffer = bufnr})
        if client.supports_method('textDocument/codeAction') then
          vim.keymap.set('n', ',lca', [[<Cmd>lua require('telescope.builtin').lsp_code_actions(require('telescope.themes').get_cursor({}))<CR>]], {buffer = bufnr})
        else
          lsp_messages = lsp_messages .. 'no codeAction' .. lsp_msg_sep
        end
        if client.resolved_capabilities.declaration then
          vim.keymap.set('n', ',lc', [[<Cmd>lua require('telescope.builtin').lsp_declarations(require('telescope.themes').get_cursor({}))<CR>]], {buffer = bufnr})
        else
          vim.keymap.set('n', ',lc', [[<Nop>]], {buffer = bufnr})
          lsp_messages = lsp_messages .. 'no declaration' .. lsp_msg_sep
        end
        if client.resolved_capabilities.document_formatting then
          vim.keymap.set('n', ',lf', ':lua vim.lsp.buf.formatting()<CR>', {buffer = bufnr})
        else
          lsp_messages = lsp_messages .. 'no format' .. lsp_msg_sep
        end
        if client.resolved_capabilities.document_range_formatting then
          vim.keymap.set('v', ',lf', ':lua vim.lsp.buf.range_formatting()<CR>', {buffer = bufnr})
        else
          lsp_messages = lsp_messages .. 'no rangeFormat' .. lsp_msg_sep
        end
        if client.resolved_capabilities.implementation then
          vim.keymap.set('n', ',li', [[<Cmd>lua require('telescope.builtin').lsp_implementations(require('telescope.themes').get_cursor({}))<CR>]], {buffer = bufnr})
        else
          vim.keymap.set('n', ',li', [[<Nop>]], {buffer = bufnr})
          lsp_messages = lsp_messages .. 'no implementation' .. lsp_msg_sep
        end
        if client.resolved_capabilities.signature_help then
          vim.keymap.set('i', '<C-s>', [[<Cmd>lua vim.lsp.buf.signature_help({border = my_borders})<CR>]], {buffer = bufnr})
          vim.keymap.set('n', ',ls', [[<Cmd>lua vim.lsp.buf.signature_help({border = my_borders})<CR>]], {buffer = bufnr})
        else
          vim.keymap.set('n', ',ls', [[<Nop>]], {buffer = bufnr})
          lsp_messages = lsp_messages .. 'no signatureHelp' .. lsp_msg_sep
        end
        if client.resolved_capabilities.type_definition then
          vim.keymap.set('n', ',ltd', [[<Cmd>lua require('telescope.builtin').lsp_type_definitions(require('telescope.themes').get_cursor({}))<CR>]], {buffer = bufnr})
        else
          vim.keymap.set('n', ',ltd', [[<Nop>]], {buffer = bufnr})
          lsp_messages = lsp_messages .. 'no typeDefinition' .. lsp_msg_sep
        end

        -- autocmds
        if client.supports_method('textDocument/codeLens') then
          vim.keymap.set('n', ',ll', [[<Cmd>lua vim.lsp.buf.codelens.run({border = my_borders})<CR>]], {buffer = bufnr})
          vim.cmd [[autocmd BufEnter,CursorHold,InsertLeave * lua vim.lsp.codelens.refresh()]]
        else
          lsp_messages = lsp_messages .. 'no codeLens' .. lsp_msg_sep
        end

        -- messages
        vim.notify(lsp_messages, vim.log.levels.INFO, {title = '[LSP]'})
      end

      local capabilities = lsp_cmp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

      -- LSP servers
      local servers = {
        bashls = {
          filetypes = {
            'sh',
            'bash',
            'zsh'
          }
        },
        cssls = {},
        html = {
          filetypes = {
            'html',
            'html-eex',
            'liquid'
          }
        },
        jsonls = {},
        vimls = {},
      }
      for name, opts in pairs(servers) do
        if type(opts) == 'function' then
          opts()
        else
          local client = lsp_config[name]
          client.setup(vim.tbl_extend('force', {
            on_attach = on_attach,
            capabilities = capabilities,
          }, opts))
        end
      end

      local sumneko_binary = vim.fn.stdpath('data')..'/lspconfig/lua-language-server/bin/lua-language-server'
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, 'lua/?.lua')
      table.insert(runtime_path, 'lua/?/init.lua')
      local lua_dev = require('lua-dev').setup({
        library = {
          vimruntime = true,
          types = true,
          plugins = true
        },
        lspconfig = {
          capabilities = capabilities,
          cmd = {sumneko_binary},
          on_attach = on_attach,
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
                path = runtime_path
              },
              diagnostics = {
                enable = true,
                globals = {
                  'vim',
                  'awesome',
                  'client',
                  'clientbuttons',
                  'clientkeys',
                  'screen',
                  'tag',
                  'widget'
                },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                preloadFileSize = 400
              },
              telemetry = {
                enable = false
              },
            },
          }
        }
      })
      lsp_config.sumneko_lua.setup(lua_dev)

    end
  }
-- }}}
-- {{{2 which-key.nvim
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup({
        plugins = {
          spelling = {
            enabled = true,
            suggestions = 40
          }
        },
        window = {
          border = my_borders
        },
      })
    end
  }
-- }}}
-- {{{2 vim-abolish
  use {
    'tpope/vim-abolish',
    config = function()
      vim.g.abolish_save_file = vim.fn.stdpath('config') .. '/after/plugin/abolish.vim'
    end
  }
-- }}}
-- {{{2 vim-fugitive
  use {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<Leader>gc', '<Cmd>Git commit -v %<CR>')
      vim.keymap.set('n', '<Leader>gd', '<Cmd>Gdiffsplit<CR>')
      vim.keymap.set('n', '<Leader>gl', '<Cmd>0Gclog!<CR>')
      vim.keymap.set('n', '<Leader>gp', '<Cmd>Git push<CR>')
      vim.keymap.set('n', '<Leader>gs', '<Cmd>Git<CR>')
    end
  }
-- }}}
-- {{{2 vim-obsession
  use {
    'tpope/vim-obsession',
    config = function()
      vim.keymap.set('n', ',to', '<Cmd>Obsession<CR>')
    end
  }
-- }}}
-- {{{2 vim-repeat
  use {'tpope/vim-repeat'}
-- }}}
-- {{{2 vim-surround
  use {'tpope/vim-surround'}
-- }}}
-- {{{2 vim-unimpaired
  use {'tpope/vim-unimpaired'}
-- }}}
-- {{{2 Comment.nvim
  use {
    'numToStr/Comment.nvim',
    config = function()
      vim.keymap.set('x', 'gci', ':g/./lua require\'Comment.api\'.toggle_current_linewise()<CR><cmd>nohls<CR>')
      require('Comment').setup({
        pre_hook = function(ctx)
          local U = require 'Comment.utils'
          local location = nil
          if ctx.ctype == U.ctype.block then
            location = require('ts_context_commentstring.utils').get_cursor_location()
          elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require('ts_context_commentstring.utils').get_visual_start_location()
          end
          return require('ts_context_commentstring.internal').calculate_commentstring {
            key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
            location = location,
          }
        end
      })
    end
  }
-- }}}
-- {{{2 vim-qf
  use {
    'romainl/vim-qf',
    config = function()
      vim.g.qf_mapping_ack_style = true
      vim.keymap.set('n', '<C-q>', '<Plug>(qf_qf_switch)', {})
      vim.keymap.set('n', '<C-c>', '<Plug>(qf_qf_toggle)', {})
      vim.keymap.set('n', '<Home>', '<Plug>(qf_qf_previous)', {})
      vim.keymap.set('n', '<End>', '<Plug>(qf_qf_next)', {})
      vim.keymap.set('n', '<A-c>', '<Plug>(qf_loc_toggle)', {})
      vim.keymap.set('n', '<C-Home>', '<Plug>(qf_loc_previous)', {})
      vim.keymap.set('n', '<C-End>', '<Plug>(qf_loc_next)', {})
    end
  }
-- }}}
-- {{{2 nvim-bqf
  use {
    'kevinhwang91/nvim-bqf',
    config = function()
      require('bqf').setup({
        auto_enable = true
      })
    end
  }
-- }}}
-- {{{2 zk-nvim
  use {
    'mickael-menu/zk-nvim',
    config = function()
      local zk = require('zk')
      local commands = require('zk.commands')
      local function make_edit_fn(defaults, picker_options)
        return function(options)
          options = vim.tbl_extend('force', defaults, options or {})
          zk.edit(options, picker_options)
        end
      end

      require('telescope').load_extension('zk')
      zk.setup({
        picker = 'telescope'
      })

      commands.add('ZkRecents', make_edit_fn({ createdAfter = '1 week ago' }, { title = 'Zk Recents' }))

      vim.keymap.set('n', '<Leader>zf', [[<Cmd>ZkNotes {match = vim.fn.input('Search: ')}<CR>]])
      vim.keymap.set('v', '<Leader>zf', [[:'<,'>ZkMatch<CR>]])
      vim.keymap.set('n', '<Leader>zn', [[<Cmd>ZkNew {title = vim.fn.input('Title: ')}<CR>]])
      vim.keymap.set('n', '<Leader>zl', [[<Cmd>ZkNotes<CR>]])
      vim.keymap.set('n', '<Leader>zr', [[<Cmd>ZkRecents<CR>]])
      vim.keymap.set('n', '<Leader>zt', [[<Cmd>ZkTags<CR>]])
    end
  }
-- }}}
-- {{{2 vim-simple-align
  use {'kg8m/vim-simple-align'}
-- }}}
-- {{{2 fm-nvim
  use {
    'is0n/fm-nvim',
    config = function()
      vim.keymap.set('n', '<Leader>z', '<Cmd>Fzf<CR>', {})
      vim.keymap.set('n', '<Leader>x', '<Cmd>Vifm<CR>', {})
      require('fm-nvim').setup({
        border = my_borders,
        border_hl = 'Normal'
      })
    end
  }
-- }}}
-- {{{2 toggleterm.nvim
  use {
    'akinsho/toggleterm.nvim',
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
        direction = 'vertical',
        float_opts = {
          border = my_borders
        }
      })
      vim.keymap.set('n', '<Leader>tf', [[<Cmd>ToggleTerm direction=float<CR>]])
      vim.keymap.set('n', '<Leader>th', [[<Cmd>ToggleTerm direction=horizontal<CR>]])
      vim.keymap.set('n', '<Leader>tv', [[<Cmd>ToggleTerm direction=vertical<CR>]])
    end
  }
-- }}}
-- {{{2 nvim-spectre
  use {
    'windwp/nvim-spectre',
    config = function()
      require('spectre').setup()
      vim.keymap.set('n', '<Leader>S', [[<Cmd>lua require('spectre').open()<CR>]])
    end
  }
-- }}}
-- {{{2 undotree
  use {
    'mbbill/undotree',
    config = function()
      vim.g.undotree_WindowLayout= 2
      vim.g.undotree_SetFocusWhenToggle= 1
      vim.g.undotree_ShortIndicators= 1
      vim.keymap.set('n', ',tu', '<Cmd>UndotreeToggle<CR>', {})
    end
  }
-- }}}
-- {{{2 vim-dirdiff
  use {'will133/vim-dirdiff'}
-- }}}
-- {{{2 paperplanes.nvim
use {
  'rktjmp/paperplanes.nvim',
  config = function()
    require('paperplanes').setup({
      register = 'p',
      provider = 'paste.rs'
    })
  end
}
-- }}}
-- {{{2 vim-renamer
  use {'qpkorr/vim-renamer'}
-- }}}
-- {{{2 vim-gnupg
  use {'jamessan/vim-gnupg'}
-- }}}
-- {{{2 vim-log-highlighting
  use {
    'MTDL9/vim-log-highlighting',
    ft = 'log'
  }
-- }}}
-- {{{2 unicode.vim
  use {
    'chrisbra/unicode.vim',
    config = function()
      vim.keymap.set('n', '<Leader>ut', '<Cmd>UnicodeTable<CR>')
      vim.keymap.set('n', 'ga', '<Cmd>UnicodeName<CR>')
    end
  }
-- }}}
-- {{{2 Visuals
-- {{{3 nvim-colorizer.lua
  use {
    'DarwinSenior/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
        '*';
        css = {
          css = true;
          css_fn = true;
        };
        html = {
          names = false;
        }
      })
    end
  }
-- }}}
-- {{{3 nvim-web-devicons
  use {'kyazdani42/nvim-web-devicons'}
-- }}}
-- {{{3 lush.nvim
  use { 'rktjmp/lush.nvim'}
-- }}}
-- {{{3 artesanal
  use {
    'wimstefan/vim-artesanal',
    config = function()
      vim.g.artesanal_dimmed = false
      vim.g.artesanal_transparent = true
    end
  }
-- }}}
-- {{{3 nightfox.nvim
  use {
    'EdenEast/nightfox.nvim',
    config = function()
      require('nightfox').setup({
        transparent = true,
        alt_nc = true,
        terminal_colors = true,
        styles = {
          comments = "italic",
          functions = "italic",
          keywords = "bold",
          strings = "NONE",
          variables = "NONE",
        },
        inverse = {
          match_paren = true,
          visual = false,
          search = true,
        }
      })
    end
  }
-- }}}
-- {{{3 zenbones.nvim
  use {
    'mcchrish/zenbones.nvim',
    config = function()
      local flavours = {'zenbones', 'zenwritten', 'neobones', 'nordbones', 'seoulbones', 'tokyobones'}
      for _, flavour in ipairs(flavours) do
        vim.g[flavour] = {
          solid_float_border = true,
          lightness = 'bright',
          darkness = 'warm',
          darken_comments = 30,
          lighten_comments = 30,
          transparent_background = true
        }
      end
    end
  }
-- }}}
-- {{{3 lualine.nvim
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      if vim.fn.filereadable(vim.fn.expand('$HOME/.config/colours/nvim_theme.lua')) == 1 then
        vim.api.nvim_command[[luafile $HOME/.config/colours/nvim_theme.lua]]
      else
        vim.api.nvim_command[[colorscheme desert]]
      end
      local get_modified = function()
        return '%m' or ''
      end
      local get_readonly = function()
        if not vim.bo.readonly then
          return ''
        end
        return '[RO]'
      end
      local get_session = function()
        if not vim.g.loaded_obsession then
          return ''
        end
        return '%{ObsessionStatus("\\\\o/", "_o_")}'
      end
      local get_spell = function()
        if not vim.wo.spell then
          return ''
        end
        return '[SP]'
      end
      local get_path = function()
        return '[' .. vim.fn.expand('%:p:h') .. ']'
      end
      local diff_source = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed}
        end
      end
      local function window()
        return vim.api.nvim_win_get_number(0)
      end
      local minimal_extension = {
        sections = {
          lualine_a = {'filename'},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {'location', 'progress'},
          lualine_z = {'filetype'},
        },
        filetypes = {'help', 'packer', 'qf'}
      }

      require('lualine').setup({
        options = {
          icons_enabled = true,
          section_separators = '',
          component_separators = '',
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'location', 'progress'},
          lualine_c = {
            {
              'filename',
              file_status = false
            },
            {
              get_readonly,
              padding = 0,
              color = {fg = 'grey'},
            },
            {
              get_modified,
              padding = 0,
              color = {fg = 'red'},
            },
            {
              get_spell,
              padding = 1,
              color = {fg = 'brown'},
            },
            {
              get_session,
              padding = 1,
              color = {fg = 'yellow'},
            },
          },
          lualine_x = {
            'aerial',
            function() return require('lsp-status').status() end,
            {
              'diagnostics',
              always_visible = false,
              sources = {'nvim_diagnostic'},
              symbols = {
                error = vim.trim(vim.fn.sign_getdefined('DiagnosticSignError')[1].text) .. ' ',
                warn = vim.trim(vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text) .. ' ',
                info = vim.trim(vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text) .. ' ',
                hint = vim.trim(vim.fn.sign_getdefined('DiagnosticSignHint')[1].text) .. ' '
              }
            },
          },
          lualine_y = {
            {
              'diff',
              source = diff_source,
              diff_color = {added = 'GitSignsAdd', modified = 'GitSignsChange', removed = 'GitSignsDelete'},
              symbols = {added = '  ', modified = '  ', removed = '  '},
            },
            {
              'branch',
              icon = ''
            }
          },
          lualine_z = {'filetype'},
        },
        inactive_sections = {
          lualine_a = {'filename'},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {'location'},
          lualine_z = {'filetype'},
        },
        tabline = {
          lualine_a = {window},
          lualine_c = {'buffers'},
          lualine_b = {get_path},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            {
              'tabs',
              mode = 2
            }
          }
        },
        extensions = {'fugitive', minimal_extension, 'toggleterm'},
      })
    end
  }
-- }}}
-- {{{3 gitsigns.nvim
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup({
        signs = {
          add = {
            hl = 'GitSignsAdd',
            numhl = 'GitSignsAddNr',
            show_count = true
          },
          change = {
            hl = 'GitSignsChange',
            numhl = 'GitSignsChangeNr',
            show_count = true
          },
          delete = {
            hl = 'GitSignsDelete',
            numhl = 'GitSignsDeleteNr',
            show_count = true
          },
          topdelete = {
            hl = 'GitSignsDelete',
            numhl = 'GitSignsDeleteNr',
            show_count = true
          },
          changedelete = {
            hl = 'GitSignsChange',
            numhl = 'GitSignsChangeNr',
            show_count = true
          }
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
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text_pos = 'overlay'
        },
        numhl = true,
        keymaps = {
          noremap = true,
          ['n ]c'] = {expr = true, "&diff ? ']c' : '<Cmd>Gitsigns next_hunk<CR>'"},
          ['n [c'] = {expr = true, "&diff ? '[c' : '<Cmd>Gitsigns prev_hunk<CR>'"},
          ['n ,st'] = '<Cmd>Gitsigns toggle_signs<CR>',
          ['n ,sh'] = '<Cmd>Gitsigns toggle_linehl<CR>',
          ['n ,sp'] = '<Cmd>Gitsigns preview_hunk<CR>',
          ['n ,sb'] = '<Cmd>lua require"gitsigns".blame_line({full=true})<CR>',
        },
        preview_config = {
          border = my_borders,
        }
      })
    end
  }
-- }}}
-- {{{3 indent-blankline.nvim
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup({
        char = '▏',
        filetype_exclude = {
          'help',
          'man',
          'diagnosticpopup',
          'lspinfo',
          'packer',
          'TelescopePrompt',
          'TelescopeResults',
          '',
        },
        disable_with_nolist = true,
        use_treesitter = true,
        show_current_context = true,
        show_current_context_start = true,
        show_current_context_start_on_current_line = true,
        context_patterns = {
          'class',
          'function',
          'method',
          '^if',
          '^while',
          '^for',
          '^object',
          '^table',
          'block',
          'arguments',
          'element'
        },
      })
      vim.keymap.set('n', ',ti', '<Cmd>IndentBlanklineToggle<CR>')
    end
  }
-- }}}
-- {{{3 virt-column.nvim
  use {
    'lukas-reineke/virt-column.nvim',
    config = function()
      vim.opt.colorcolumn = '80'
      require('virt-column').setup({
        char = '🮍',
      })
    end
  }
-- }}}
-- {{{3 dressing.nvim
  use {'stevearc/dressing.nvim'}
-- }}}
-- }}}
end)
require('packer_compiled')
-- }}}1 --------------------- PLUGINS ------------------------------------------
-- vim: foldmethod=marker foldlevel=1
