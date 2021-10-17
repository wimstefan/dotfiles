--------------------- MY PERSONAL NEOVIM CONFIGURATION -------------------------
-- {{{1 --------------------- First things first. ------------------------------
require('impatient').enable_profile()
-- }}}
-- {{{1 --------------------- OPTIONS ------------------------------------------
-- define leader keys
vim.g.mapleader = ' '

local indent = 2

vim.opt.termguicolors = true
vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'auto'
vim.opt.relativenumber = true
vim.opt.showtabline = 2
vim.opt.linebreak = true
vim.opt.showbreak = '  » '
vim.opt.conceallevel = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.listchars = {
  tab = '› ',
  trail = '·',
  eol = '«',
  extends = '>',
  precedes = '<'
}
vim.opt.fillchars = {
  vert = '█',
  foldclose = '▾',
  foldopen = '▴',
  foldsep = '🮍',
  msgsep = '🮑'
}
vim.opt.mouse = 'a'
vim.opt.guifont = 'monospace:h11'

vim.opt.shiftwidth = indent
vim.opt.shiftround = true
vim.opt.softtabstop = indent
vim.opt.tabstop = indent
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.joinspaces = true
vim.opt.gdefault = true
vim.opt.inccommand = 'split'
vim.opt.selection = 'exclusive'
vim.opt.pastetoggle = '<F3>'
vim.opt.completeopt = {
  'menuone',
  'noinsert',
  'noselect'
}
vim.opt.diffopt:append {
  'vertical',
  'indent-heuristic',
  'algorithm:histogram'
}
vim.opt.spellfile = vim.fn.stdpath('config') .. '/spell/myspell.utf-8.add'
vim.opt.spelllang = {
  'en',
  'de',
  'es',
  'nl'
}
vim.opt.nrformats:append {
  'alpha'
}
if vim.fn.executable('ugrep') == 1 then
  vim.opt.grepprg = 'ugrep -RInk -j -u --tabs=1'
  vim.opt.grepformat = '%f:%l:%c:%m,%f+%l+%c+%m,%-G%f\\|%l\\|%c\\|%m'
elseif vim.fn.executable('git') == 1 then
  vim.opt.grepprg = 'git'
elseif vim.fn.executable('ack') == 1 then
  vim.opt.grepprg = 'ack --nogroup --column --smart-case --nocolor --follow $*'
end

vim.opt.lazyredraw = false
vim.opt.timeoutlen = 500
vim.opt.updatetime = 300
vim.opt.autowrite = true
vim.opt.backup = false
vim.opt.backupcopy = 'auto'
vim.opt.writebackup = true
vim.opt.swapfile = true
vim.opt.undofile = true
vim.opt.hidden = true
vim.opt.modelineexpr = true

vim.opt.foldcolumn = 'auto:8'
vim.opt.foldlevel = 99
local fm_opts = vim.opt.foldmethod:get()
if fm_opts == '' or fm_opts == 'manual' then
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
else
  vim.opt.foldmethod = vim.opt.foldmethod
end

vim.g.netrw_winsize = 20
vim.g.netrw_banner =  0
vim.g.netrw_liststyle =  3
vim.g.netrw_preview =  0
vim.g.netrw_alto =  0
-- disable unused built-in plugins
vim.g.loaded_2html_plugin = 1
vim.g.loaded_matchit      = 1
vim.g.loaded_matchparen   = 1
vim.g.loaded_spec         = 1
-- }}}1 --------------------- OPTIONS ------------------------------------------
-- {{{1 --------------------- MAPPINGS -----------------------------------------
vim.api.nvim_set_keymap('', 'cd', '<Cmd>cd %:h | pwd<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>g', ':grep ', {noremap = true, silent = false})
vim.api.nvim_set_keymap('n', '<Leader>l', ':set hlsearch!<CR>', {noremap = true, silent = true})
-- {{{2 editing
vim.api.nvim_set_keymap('n', '<Leader>ev', '<Cmd>edit $MYVIMRC<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>sv', '<Cmd>luafile $MYVIMRC<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>w', '<Cmd>w!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>wa', '<Cmd>wa!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>q', '<Cmd>q!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>qa', '<Cmd>qa!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>wqa', '<Cmd>wqa!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', ',ul', '<Cmd>undolist<CR>', {noremap = true, silent = true})
-- }}}
-- {{{2 buffers
vim.api.nvim_set_keymap('n', '<Tab>', '<Cmd>bnext<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<S-Tab>', '<Cmd>bprev<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader><Leader>', '<C-^>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>bd', '<Cmd>bdelete<CR>', {noremap = true, silent = true})
-- }}}
-- {{{2 tabs
vim.api.nvim_set_keymap('n', '<Leader>td', '<Cmd>tabclose<CR>', {noremap = true, silent = true})
-- }}}
-- {{{2 terminals
vim.api.nvim_set_keymap('n', '<Leader>t', [[<Cmd> split term://$SHELL<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>vt', [[<Cmd> vnew term://$SHELL<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-N>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<A-h>', [[<C-\><C-N><C-w>h]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<A-j>', [[<C-\><C-N><C-w>j]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<A-k>', [[<C-\><C-N><C-w>k]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<A-l>', [[<C-\><C-N><C-w>l]], {noremap = true, silent = true})
-- }}}
--{{{2 signatures
vim.api.nvim_set_keymap('n', '<Leader>sa', [[ 1G:s#\(Stefan Wimmer\) <.*>#\1 <stefan@tangoartisan.com>#<CR> G?--<CR> jVGd :r ~/.mutt/short-signature-artisan<CR> /^To:<CR> ]] , {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>sg', [[ 1G:s#\(Stefan Wimmer\) <.*>#\1 <wimstefan@gmail.com>#<CR> G?--<CR> jVGd :r ~/.mutt/short-signature-gmail<CR> /^To:<CR> ]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>st', [[ G?--<CR>jVGd :r ~/.mutt/short-signature-tango<CR> ]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>ss', [[ G?--<CR>jVGd :r ~/.mutt/short-signature<CR> ]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Leader>sl', [[ G?--<CR>jVGd :r ~/.mutt/signature<CR> ]], {noremap = true, silent = true})
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
    vim.opt.number = false
    vim.opt.relativenumber = false
    print('Details disabled')
  else
    vim.opt.mouse = 'a'
    vim.opt.cursorcolumn = true
    vim.opt.cursorline = true
    vim.opt.signcolumn = 'yes'
    vim.opt.foldenable = true
    vim.opt.number = true
    vim.opt.relativenumber = true
    print('Details enabled')
  end
end
vim.api.nvim_set_keymap('n', '<F10>', '<Cmd>lua ToggleDetails()<CR>', { noremap = true , silent = true})
-- }}}
-- }}}1 --------------------- MAPPINGS -----------------------------------------
-- {{{1 --------------------- AUTOCMDS -----------------------------------------
vim.api.nvim_exec([[
  augroup help
    autocmd!
    autocmd WinNew * let w:new = 1
    autocmd FileType help,man if exists('w:new') | unlet w:new | wincmd L | vertical resize 84 | endif
  augroup END
]], false)
vim.api.nvim_exec([[
  augroup Terminal
    autocmd!
    autocmd TermOpen * startinsert
    autocmd TermOpen * set nonumber norelativenumber nolist
  augroup END
  ]], false)
vim.api.nvim_exec([[
augroup RC
  autocmd!

  " Reload $MYVIMRC after changes
  autocmd BufWritePost init.lua source $MYVIMRC

  " Automatically chmod +x Shell and Perl scripts
  autocmd BufWritePost {*.sh,*.pl,*.py} silent !chmod +x %

  " Commentstrings
  autocmd FileType pfmain set commentstring=#\%s
  autocmd FileType toml set commentstring=#\%s
  autocmd FileType xdefaults set commentstring=!\%s

  " mail specific configuration
  autocmd BufRead /tmp/mutt* setlocal filetype=mail

  " Syntax for tmux
  autocmd BufNewFile,BufRead *tmux*conf* set filetype=tmux

  " Syntax for Iosevka files
  autocmd BufNewFile,BufRead *.ptl set filetype=julia commentstring=#\ %s

  " Syntax for htp files
  autocmd BufNewFile,BufRead {*.htp,*.htt} set filetype=xhtml

  " Syntax for xmp files
  autocmd BufNewFile,BufRead {*.xmp} set filetype=xml

  " Syntax for fvwm files
  autocmd BufNewFile,BufRead */.fvwm*/* set filetype=fvwm syntax=fvwm

  " Syntax for Xorg log files
  autocmd BufNewFile,BufRead *Xorg*log* set filetype=msmessages

  " Syntax for rofi themes
  autocmd BufNewFile,BufRead {*.rasi} set filetype=css

  " Change fileformat on playlist files (created by moc)
  autocmd BufNewFile,BufRead *.m3u set encoding=utf-8 fileencoding=utf-8 ff=unix

  " run xrdb whenever Xdefaults or Xresources are updated
  autocmd BufWritePost X{resources,defaults} silent !xrdb %

  " Encoding for cddb files
  autocmd BufNewFile,BufRead *cddb* set encoding=utf-8 fileencoding=utf-8 ff=unix

  " Enable spelling for text files
  " autocmd BuFNewFile,BufRead {*.txt,*.md,*.adoc,*.asciidoc,*.rst} if &filetype !~ 'man\|help\|*doc' | setlocal spell | endif
  autocmd FileType {text,markdown,asciidoc*,rst} if &filetype !~ 'man\|help' | setlocal spell | endif

  " Disable numbers & spell inside manpages
  autocmd FileType {man,help,*doc} setlocal nonumber norelativenumber nospell nolist nocursorcolumn

  " Enable hyphen in css/html completion and disable uppercase tag completion
  " autocmd FileType css,html setlocal iskeyword+=- noignorecase

  " Correct comment highlighting for json config
  autocmd FileType json syntax match Comment +\/\/.\+$+

  " Some buffers can be closed with 'q'
  autocmd FileType help,startuptime,qf,lspinfo nnoremap <buffer><silent> q :close<CR>
  autocmd FileType man nnoremap <buffer><silent> q :quit<CR>
  
  " Disable folding in previews
  autocmd BufWinEnter * if &previewwindow | setlocal nofoldenable | endif

  " Remember last cursor position
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | execute "normal! g`\"" | endif

  " Enable yank highlighting
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup='WildMenu', timeout=4444}

augroup END
]], false)
-- }}}1 --------------------- AUTOCMDS -----------------------------------------
-- {{{1 --------------------- FUNCTIONS ----------------------------------------
function _G.inspect(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end
  print(table.concat(objects, '\n'))
  return ...
end
-- }}}1 --------------------- FUNCTIONS ----------------------------------------
-- {{{1 --------------------- PLUGINS ------------------------------------------
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.api.nvim_command[[packadd packer.nvim]]
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd FileType packer set previewheight=36
    autocmd BufWritePost init.lua PackerCompile
    autocmd User PackerComplete source $MYVIMRC
  augroup end
]], false)

local packer = require('packer')
local use = packer.use
packer.startup(function()
  packer.init({
    display = {
      open_cmd = '84vnew [packer]',
      working_sym = '北',
      error_sym = '✘',
      done_sym = '✔',
      removed_sym = '-',
      moved_sym = '->',
    }
  })
-- {{{2 packer.nvim
  use {
    'wbthomason/packer.nvim',
    opt = true,
    setup = function()
      vim.api.nvim_set_keymap('n', ',pc', '<Cmd>PackerClean<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', ',pi', '<Cmd>PackerInstall<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', ',pq', '<Cmd>PackerStatus<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', ',ps', '<Cmd>PackerSync<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', ',pu', '<Cmd>PackerUpdate<CR>', {noremap = true, silent = true})
    end
  }
-- }}}
-- {{{2 impatient.nvim
  use {'lewis6991/impatient.nvim'}
-- }}}
-- {{{2 filetype.nvim
  use {'nathom/filetype.nvim'}
-- }}}
-- {{{2 startuptime
  use {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime'
  }
-- }}}
-- {{{2 Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufRead',
    run = ':TSUpdate',
    requires = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        event = 'InsertEnter',
        after = 'nvim-treesitter'
      },
      {
        'windwp/nvim-ts-autotag',
        event = 'InsertEnter',
        after = 'nvim-treesitter'
      },
      {
        'nvim-treesitter/playground',
        config = function ()
          vim.api.nvim_set_keymap('n', '<F12>', [[<Cmd>TSHighlightCapturesUnderCursor<CR>]], {noremap = true, silent = false})
          vim.api.nvim_set_keymap('n', ',tsp', [[<Cmd>TSPlaygroundToggle<CR>]], {noremap = true, silent = true})
        end,
        after = 'nvim-treesitter'
      }
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = 'maintained',
        autotag = {
          enable = true
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
        matchup = {
          enable = true
        },
        playground = {
          enable = true
        },
        textobjects = {
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
      }
    end
  }
-- }}}
-- {{{2 Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', '<Leader>T', [[<Cmd>lua require('telescope.builtin').builtin(require('telescope.themes').get_dropdown({previewer = false}))<CR>]], {noremap = true})
      vim.api.nvim_set_keymap('n', '<Leader>Tb', [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Tc', [[<Cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Tf', [[<Cmd>lua require('telescope.builtin').find_files({follow = true})<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Tg', [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Th', [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Tm', [[<Cmd>lua require('telescope.builtin').man_pages()<CR>]], {noremap = true, silent = true})
    end
  }
-- }}}
-- {{{2 fzf-lua
  use {
    'ibhagwan/fzf-lua',
    requires = 'vijaymarupudi/nvim-fzf',
    config = function()
      require('fzf-lua').setup {
        file_icon_padding = '',
        lsp = {
          async_or_timeout  = true,
          icons = {
            ['Error'] = {icon = ' ', color = 'red'},
            ['Warning'] = {icon = ' ', color = 'yellow'},
            ['Hint'] = {icon = ' ', color = 'magenta'},
            ['Information'] = {icon = ' ', color = 'blue'},
          },
        },
        previewers = {
          man = {
            cmd = 'man %s | col -bx'
          }
        },
      }
      vim.api.nvim_set_keymap('n', '<Leader>F', [[<Cmd>lua require('fzf-lua').builtin()<CR>]], {})
      vim.api.nvim_set_keymap('n', '<Leader>b', [[<Cmd>lua require('fzf-lua').buffers()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>c', [[<Cmd>lua require('fzf-lua').colorschemes()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>f', [[<Cmd>lua require('fzf-lua').files()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>h', [[<Cmd>lua require('fzf-lua').help_tags()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>M', [[<Cmd>lua require('fzf-lua').man_pages()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>m', [[<Cmd>lua require('fzf-lua').marks()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>r', [[<Cmd>lua require('fzf-lua').registers()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Fgb', [[<Cmd>lua require('fzf-lua').git_bcommits()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Fgc', [[<Cmd>lua require('fzf-lua').git_commits()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Fgf', [[<Cmd>lua require('fzf-lua').git_files()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Fgs', [[<Cmd>lua require('fzf-lua').git_status()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Fg', [[<Cmd>lua require('fzf-lua').live_grep()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Fm', [[<Cmd>lua require('fzf-lua').keymaps()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Fs', [[<Cmd>lua require('fzf-lua').spell_suggest()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>Fw', [[<Cmd>lua require('fzf-lua').grep_cword()<CR>]], {noremap = true, silent = true})
    end
  }
-- }}}
-- {{{2 nvim-cmp
use {
  'hrsh7th/nvim-cmp',
  requires = {
    {
      'hrsh7th/cmp-nvim-lua',
      after = 'nvim-cmp'
    },
    {
      'hrsh7th/cmp-nvim-lsp',
      after = 'nvim-cmp',
    },
    {
      'hrsh7th/cmp-vsnip',
      after = 'nvim-cmp',
      requires = {
        'hrsh7th/vim-vsnip',
        {
          'rafamadriz/friendly-snippets',
          after = 'cmp-vsnip'
        }
      }
    },
    {
      'f3fora/cmp-spell',
      after = 'nvim-cmp'
    },
    {
      'hrsh7th/cmp-buffer',
      after = 'nvim-cmp'
    },
    {
      'hrsh7th/cmp-calc',
      after = 'nvim-cmp'
    },
    {
      'hrsh7th/cmp-path',
      after = 'nvim-cmp'
    },
  },
  config = function()
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end
    local feedkey = function(key, mode)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end
    local cmp = require('cmp')
    cmp.setup {
      documentation = {
        border = 'rounded'
      },
      formatting = {
        format = function(entry, vim_item)
          vim_item.menu = ({
            buffer = '[Buffer]',
            calc = '[Calc]',
            vsnip = '[Snippet]',
            nvim_lsp = '[LSP]',
            nvim_lua = '[Lua]',
            path = '[Filesystem]',
            spell = '[Spelling]',
          })[entry.source.name]
          vim_item.kind = vim.lsp.protocol.CompletionItemKind[vim_item.kind] .. ' ' .. vim_item.kind
          return vim_item
        end
      },
      mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.fn['vsnip#available']() == 1 then
            feedkey('<Plug>(vsnip-expand-or-jump)', '')
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.fn['vsnip#jumpable'](-1) == 1 then
            feedkey('<Plug>(vsnip-jump-prev)', '')
          end
        end, { 'i', 's' }),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
      },
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end
      },
      sources = {
        {name = 'nvim_lua'},
        {name = 'nvim_lsp'},
        {name = 'buffer',
          opts = {
            get_bufnrs = function()
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end
          }
        },
        {name = 'vsnip'},
        {name = 'spell'},
        {name = 'path'},
        {name = 'calc'},
      }
    }
  end,
}
-- }}}
-- {{{2 LSP
  use {
    'neovim/nvim-lspconfig',
    after = 'cmp-nvim-lsp',
    requires = {
      {
        'kosayoda/nvim-lightbulb',
        config = function()
          vim.fn.sign_define('LightBulbSign', {text = ' ', texthl = 'WarningMsg', linehl='', numhl=''})
          vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
          require('nvim-lightbulb').update_lightbulb {
            sign = {enabled = false},
            float = {enabled = false},
            virtual_text = {enabled = true}
          }
        end
      },
      'nvim-lua/lsp-status.nvim',
      'folke/lua-dev.nvim',
      {
        'simrat39/symbols-outline.nvim',
        config = function()
          vim.api.nvim_set_keymap('n', ',ts', '<Cmd>SymbolsOutline<CR>', {noremap = true, silent = true})
        end
      }
    },
    config = function()
      local lsp_cmp = require('cmp_nvim_lsp')
      local lsp_config = require('lspconfig')
      local lsp_status = require('lsp-status')

      -- diagnostic handling
      local signs = {
        Error = ' ',
        Warn = ' ',
        Hint = ' ',
        Info = ' ',
      }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
      end
      vim.diagnostic.config {
        signs = true,
        underline = true,
        update_in_insert = true,
        virtual_text = {prefix = '❰'}
      }

      -- symbols for autocomplete
      vim.lsp.protocol.CompletionItemKind = {
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
        Function = ' ',
        Interface = ' ',
        Keyword = ' ',
        Method = ' ',
        Module = ' ',
        Operator = ' ',
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

      -- lsp-status config
      lsp_status.config {
        current_function = true,
        diagnostics = false,
        indicator_errors = ' ' .. vim.trim(vim.fn.sign_getdefined('DiagnosticSignError')[1].text) .. '  ',
        indicator_warnings = ' ' .. vim.trim(vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text) .. '  ',
        indicator_info = ' ' .. vim.trim(vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text) .. '  ',
        indicator_hint = ' ' .. vim.trim(vim.fn.sign_getdefined('DiagnosticSignHint')[1].text) .. '  ',
        indicator_ok = 'OK',
        status_symbol = '[LSP]',
      }
      lsp_status.register_progress()

      -- LSP handlers
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = 'rounded'
      })
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded'
      })

      -- LSP functions
      local on_attach = function(client,bufnr)
        local lsp_messages = {}
        local lsp_msg_sep = ' ∷ '
        lsp_messages = lsp_msg_sep .. 'LSP attached' .. lsp_msg_sep
        lsp_status.on_attach(client)
        -- options
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        -- keybindings
        function _G.show_documentation()
          if vim.fn.index({'help', 'lua', 'man', 'vim'}, vim.bo.filetype) >= 0 then
            vim.api.nvim_command('h ' .. vim.fn.expand('<cword>'))
          else
            vim.api.nvim_command('lua vim.lsp.buf.hover()')
          end
        end
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', [[<Cmd>lua show_documentation({border = 'rounded'})<CR>]], {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lR', [[<Cmd>lua require('fzf-lua').lsp_definitions()<CR>]], {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lr', [[<Cmd>lua require('fzf-lua').lsp_references()<CR>]], {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ly', [[<Cmd>lua require('fzf-lua').lsp_document_symbols()<CR>]], {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lY', [[<Cmd>lua require('fzf-lua').lsp_workspace_symbols()<CR>]], {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ld', [[<Cmd>lua require('fzf-lua').lsp_document_diagnostics()<CR>]], {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lD', [[<Cmd>lua require('fzf-lua').lsp_workspace_diagnostics()<CR>]], {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',le', [[<Cmd>lua vim.diagnostic.show_line_diagnostics({border = 'rounded'})<CR>]], {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', [[<Cmd>lua vim.diagnostic.goto_prev({enable_popup = false})<CR>]], {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', [[<Cmd>lua vim.diagnostic.goto_next({enable_popup = false})<CR>]], {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lrn', [[<Cmd>lua vim.lsp.buf.rename()<CR>]], {noremap = true, silent = true})
        if client.supports_method('textDocument/codeAction') then
          vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lca', [[<Cmd>lua require('fzf-lua').lsp_code_actions()<CR>]], {noremap = true, silent = true})
        else
          lsp_messages = lsp_messages .. 'no codeAction' .. lsp_msg_sep
        end
        if client.resolved_capabilities.declaration then
          vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lc', [[<Cmd>lua require('fzf-lua').lsp_declarations()<CR>]], {noremap = true, silent = true})
        else
          vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lc', [[<Nop>]], {})
          lsp_messages = lsp_messages .. 'no declaration' .. lsp_msg_sep
        end
        if client.resolved_capabilities.document_formatting then
          vim.api.nvim_buf_set_keymap(bufnr, 'n', ',lf', ':lua vim.lsp.buf.formatting()<CR>', {noremap = true, silent = true})
        else
          lsp_messages = lsp_messages .. 'no format' .. lsp_msg_sep
        end
        if client.resolved_capabilities.document_range_formatting then
          vim.api.nvim_buf_set_keymap(bufnr, 'v', ',lf', ':lua vim.lsp.buf.range_formatting()<CR>', {noremap = true, silent = true})
        else
          lsp_messages = lsp_messages .. 'no rangeFormat' .. lsp_msg_sep
        end
        if client.resolved_capabilities.implementation then
          vim.api.nvim_buf_set_keymap(bufnr, 'n', ',li', [[<Cmd>lua require('fzf-lua').lsp_implementations()<CR>]], {noremap = true, silent = true})
        else
          vim.api.nvim_buf_set_keymap(bufnr, 'n', ',li', [[<Nop>]], {})
          lsp_messages = lsp_messages .. 'no implementation' .. lsp_msg_sep
        end
        if client.resolved_capabilities.signature_help then
          vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-s>', [[<Cmd>lua vim.lsp.buf.signature_help({border = 'rounded'})<CR>]], {noremap = true, silent = true})
          vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ls', [[<Cmd>lua vim.lsp.buf.signature_help({border = 'rounded'})<CR>]], {noremap = true, silent = true})
        else
          vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ls', [[<Nop>]], {})
          lsp_messages = lsp_messages .. 'no signatureHelp' .. lsp_msg_sep
        end
        if client.resolved_capabilities.type_definition then
          vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ltd', [[<Cmd>lua require('fzf-lua').lsp_typedefs()<CR>]], {noremap = true, silent = true})
        else
          vim.api.nvim_buf_set_keymap(bufnr, 'n', ',ltd', [[<Nop>]], {})
          lsp_messages = lsp_messages .. 'no typeDefinition' .. lsp_msg_sep
        end
        print(lsp_messages)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = lsp_cmp.update_capabilities(capabilities)

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
            'liquid',
            'markdown',
          }
        },
        jsonls = {},
        vimls = {}
      }
      for server, config in pairs(servers) do
        lsp_config[server].setup(vim.tbl_deep_extend('force', {
          capabilities = capabilities,
          on_attach = on_attach,
          flags = {
            debounce_text_changes = 150,
          },
          init_options = config
        }, {}))
      end

      -- Lua LSP server & lua-dev configuration
      local sumneko_root_path = vim.fn.stdpath('data')..'/lspconfig/sumneko_lua'
      local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'
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
          cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
          flags = {
            debounce_text_changes = 150,
          },
          on_attach = on_attach,
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
                path = runtime_path,
              },
              diagnostics = {
                enable = true,
                globals = {
                  'vim'
                },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                preloadFileSize = 400,
              },
              telemetry = {
                enable = false,
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
      require('which-key').setup {
        window = { border = 'rounded' }
      }
    end
  }
-- }}}
-- {{{2 vim-abolish
  use {
    'tpope/vim-abolish',
    cmd = {'Abolish', 'S'},
    config = function()
      vim.g.abolish_save_file = vim.fn.stdpath('config') .. '/after/plugin/abolish.vim'
    end
  }
-- }}}
-- {{{2 vim-fugitive
  use {
    'tpope/vim-fugitive',
    cmd = {'G', 'Git'},
    keys = {'<Leader>gc', '<Leader>gd', '<Leader>gl', '<Leader>gp', '<Leader>gs'},
    config = function()
      vim.api.nvim_set_keymap('n', '<Leader>gc', '<Cmd>Git commit -v %<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>gd', '<Cmd>Gdiffsplit<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>gl', '<Cmd>0Gclog!<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>gp', '<Cmd>Git push<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>gs', '<Cmd>Git<CR>', {noremap = true, silent = true})
    end
  }
-- }}}
-- {{{2 vim-obsession
  use {
    'tpope/vim-obsession',
    cmd = 'Obsession',
    setup = function()
      vim.api.nvim_set_keymap('n', ',to', '<Cmd>Obsession<CR>', {noremap = true, silent = true})
    end
  }
-- }}}
-- {{{2 vim-repeat
  use {
    'tpope/vim-repeat',
    event = 'BufRead'
  }
-- }}}
-- {{{2 vim-unimpaired
  use {
    'tpope/vim-unimpaired',
    event = 'BufRead'
  }
-- }}}
-- {{{2 gitsigns.nvim
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    event = 'BufRead',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = {
            hl = 'GitSignsAdd',
            show_count = true,
            numhl = 'GitSignsAddNr'
          },
          change = {
            hl = 'GitSignsChange',
            numhl = 'GitSignsChangeNr'},
          delete = {
            hl = 'GitSignsDelete',
            show_count = true,
            numhl = 'GitSignsDeleteNr'
          },
          topdelete = {
            hl = 'GitSignsDelete',
            show_count = true,
            numhl = 'GitSignsDeleteNr'
          },
          changedelete = {
            hl = 'GitSignsChange',
            show_count = true,
            numhl = 'GitSignsChangeNr'
          }
        },
        count_chars = {
          [1] = '₁',
          [2] = '₂',
          [3] = '₃',
          [4] = '₄',
          [5] = '₅',
          [6] = '₆',
          [7] = '₇',
          [8] = '₈',
          [9] = '₉',
          ['+'] = '₊'
        },
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text_pos = 'right_align'
        },
        numhl = true,
        keymaps = {
          noremap = true,
          buffer = true,
          ['n ]c'] = { expr = true, "&diff ? ']c' : '<Cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
          ['n [c'] = { expr = true, "&diff ? '[c' : '<Cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},
          ['n ,st'] = '<Cmd>lua require"gitsigns".toggle_signs()<CR>',
          ['n ,sh'] = '<Cmd>lua require"gitsigns".toggle_linehl()<CR>',
          ['n ,sp'] = '<Cmd>lua require"gitsigns".preview_hunk()<CR>',
          ['n ,sb'] = '<Cmd>lua require"gitsigns".blame_line({true})<CR>',
        },
        preview_config = {
          border = 'rounded',
        }
      }
    end
  }
-- }}}
-- {{{2 vim-sandwich
  use {
    'machakann/vim-sandwich',
    after = 'nvim-treesitter',
    keys = 's'
  }
-- }}}
-- {{{2 Comment.nvim
  use {
    'numToStr/Comment.nvim',
    config = function()
      vim.api.nvim_set_keymap('x', 'gci', ':g/./lua require\'Comment\'.toggle()<CR><cmd>nohls<CR>', {noremap = true, silent = true})
      require('Comment').setup()
    end
  }
-- }}}
-- {{{2 vim-matchup
  use {
    'andymass/vim-matchup',
    event = 'VimEnter',
    after = 'nvim-treesitter',
    setup = function()
      vim.g.matchup_matchparen_deferred = true
      vim.g.matchup_matchparen_offscreen = {method = 'popup', fullwidth = true}
      vim.g.matchup_surround_enabled = true
    end
  }
-- }}}
-- {{{2 vim-qf
  use {
    'romainl/vim-qf',
    event = {'BufRead', 'QuickFixCmdPre', 'QuickFixCmdPost'},
    config = function()
      vim.g.qf_mapping_ack_style = true
      vim.g.qf_auto_open_quickfix = true
    end,
    setup = function()
      vim.api.nvim_set_keymap('n', '<C-q>', '<Plug>(qf_qf_switch)', {})
      vim.api.nvim_set_keymap('n', '<C-c>', '<Plug>(qf_qf_toggle)', {})
      vim.api.nvim_set_keymap('n', '<F6>', '<Plug>(qf_loc_toggle)', {})
      vim.api.nvim_set_keymap('n', '<Home>', '<Plug>(qf_qf_previous)', {})
      vim.api.nvim_set_keymap('n', '<End>', '<Plug>(qf_qf_next)', {})
      vim.api.nvim_set_keymap('n', '<C-Home>', '<Plug>(qf_loc_previous)', {})
      vim.api.nvim_set_keymap('n', '<C-End>', '<Plug>(qf_loc_next)', {})
    end
  }
-- }}}
-- {{{2 vim-qlist
  use {
    'romainl/vim-qlist',
    event = {'BufRead', 'QuickFixCmdPre', 'QuickFixCmdPost'}
  }
-- }}}
-- {{{2 nvim-bqf
  use {
    'kevinhwang91/nvim-bqf',
    event = {'QuickFixCmdPre', 'QuickFixCmdPost'},
    after = 'vim-qf',
    config = function()
      require('bqf').setup {
        auto_enable = true
      }
    end
  }
-- }}}
-- {{{2 nvim-hlslens
  use {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup()
      vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('norm! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('norm! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], {noremap = true, silent = true})
    end
  }
-- }}}
-- {{{2 vim-simple-align
  use {
    'kg8m/vim-simple-align',
    cmd = 'SimpleAlign'
  }
-- }}}
-- {{{2 rnvimr
  use {
    'kevinhwang91/rnvimr',
    cmd = {'RnvimrToggle', 'RnvimrResize'},
    setup = function()
      vim.api.nvim_set_keymap('n', '<Leader>x', '<Cmd>RnvimrToggle<CR>', {})
    end,
    config = function()
      vim.g.rnvimr_enable_ex = 1
      vim.g.rnvimr_enable_picker = 1
    end
  }
-- }}}
-- {{{2 nvim-spectre
  use {
    'windwp/nvim-spectre',
    config = function()
      require('spectre').setup()
    end,
    setup = function()
      vim.api.nvim_set_keymap('n', '<Leader>S', [[<Cmd>lua require('spectre').open()<CR>]], {noremap = true, silent = true})
    end
  }
-- }}}
-- {{{2 undotree
  use {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    setup = function()
      vim.g.undotree_WindowLayout= 2
      vim.g.undotree_SetFocusWhenToggle= 1
      vim.g.undotree_ShortIndicators= 1
      vim.api.nvim_set_keymap('n', ',tu', '<Cmd>UndotreeToggle<CR>', {})
    end
  }
-- }}}
-- {{{2 vim-dirdiff
  use {
    'will133/vim-dirdiff',
    cmd = 'DirDiff'
  }
-- }}}
-- {{{2 paperplanes.nvim
use {
  'rktjmp/paperplanes.nvim',
  config = function()
    require('paperplanes').setup({
      register = 'p',
      provider = '0x0.st'
    })
  end
}
-- }}}
-- {{{2 vim-renamer
  use {
    'qpkorr/vim-renamer',
    cmd = {'Ren', 'Renamer'}
  }
-- }}}
-- {{{2 vim-gnupg
  use {'jamessan/vim-gnupg'}
-- }}}
-- {{{2 vim-asciidoctor
  use {
    'habamax/vim-asciidoctor',
    ft = {'asciidoc', 'asciidoctor'},
    setup = function()
      vim.g.asciidoctor_folding = 1
      vim.g.asciidoctor_foldnested = 0
      vim.g.asciidoctor_foldtitle_as_h1 = 1
    end
  }
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
      vim.g.Unicode_data_directory = vim.fn.stdpath('data') .. '/site/pack/packer/opt/unicode.vim/autoload/unicode/'
    end,
    setup = function()
      vim.api.nvim_set_keymap('n', '<Leader>ut', '<Cmd>UnicodeTable<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', 'ga', '<Cmd>UnicodeName<CR>', {noremap = true, silent = true})
    end
  }
-- }}}
-- {{{2 Visuals
-- {{{3 nvim-colorizer.lua
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup {
        '*';
        css = {
          css = true;
          css_fn = true;
        };
        html = {
          names = false;
        }
      }
    end
  }
-- }}}
-- {{{3 nvim-web-devicons
  use {'kyazdani42/nvim-web-devicons'}
-- }}}
-- {{{3 lush.nvim
  use {'rktjmp/lush.nvim'}
-- }}}
-- {{{3 artesanal
  use {
    'wimstefan/vim-artesanal',
    setup = function()
      vim.g.artesanal_dimmed = false
      vim.g.artesanal_transparent = true
    end
  }
-- }}}
-- {{{3 material.nvim
  use {
    'marko-cerovac/material.nvim',
    config = function()
      require('material').setup({
        contrast = false,
        borders = true,
        italics = {
          comments = true,
          keywords = true,
          functions = false,
          variables = false
        },
        contrast_windows = {},
        text_contrast = {
          lighter = true,
          darker = false
        },
        disable = {
          background = true,
          term_colors = false,
          eob_lines = true
        },
        custom_highlights = {}
      })
      vim.api.nvim_set_keymap('n', '<Leader>cmm', [[<Cmd>lua require('material.functions').toggle_style()<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>cml', [[<Cmd>lua require('material.functions').change_style('lighter')<CR>]], {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<Leader>cmd', [[<Cmd>lua require('material.functions').change_style('oceanic')<CR>]], {noremap = true, silent = true})
    end
  }
-- }}}
-- {{{3 nordbuddy
  use {
    'maaslalani/nordbuddy',
    setup = function()
      vim.g.nord_underline_option = 'undercurl'
      vim.g.nord_italic = true
      vim.g.nord_italic_comments = true
      vim.g.nord_minimal_mode = true
    end
  }
-- }}}
-- {{{3 zenbones.nvim
  use {
    'mcchrish/zenbones.nvim',
    setup = function()
      vim.g.zenbones_lightness = 'bright'
      vim.g.zenflesh_darkness = 'warm'
    end
  }
-- }}}
-- {{{3 github-nvim-theme
  use {
    'projekt0n/github-nvim-theme',
    after = 'lualine.nvim'
  }
-- }}}
-- {{{3 lualine.nvim
  use {
    'shadmansaleh/lualine.nvim',
    event = {'BufEnter', 'ColorScheme', 'WinEnter'},
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
        return '%F'
      end
      local diff_source = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed}
        end
      end
      local minimal_extension = {
        sections = {
          lualine_a = {get_path},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {'location', 'progress'},
          lualine_z = {'filetype'},
        },
        filetypes = {'help', 'packer', 'qf'}
      }

      require('lualine').setup {
        options = {
          icons_enabled = true,
          section_separators = '',
          component_separators = '',
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'location', 'progress'},
          lualine_c = {
            {get_path},
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
            function() return require('lsp-status').status() end,
            {
              'diagnostics',
              sources = {'nvim_lsp'},
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
            'branch'
          },
          lualine_z = {'filetype'},
        },
        inactive_sections = {
          lualine_a = {get_path},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {'location'},
          lualine_z = {'filetype'},
        },
        extensions = {'fugitive', minimal_extension, 'nvim-tree'},
      }
    end
  }
-- }}}
-- }}}
end)
-- }}}1 --------------------- PLUGINS ------------------------------------------
-- vim: foldmethod=marker foldlevel=0
