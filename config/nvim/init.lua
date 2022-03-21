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
vim.opt.laststatus = 3
vim.opt.fillchars:append({
  horiz = '─',
  horizup = '┴',
  horizdown = '┬',
  vert = '│',
  vertleft = '┤',
  vertright = '├',
  verthoriz = '┼',
  foldclose = '▾',
  foldopen = '▴',
  foldsep = '🮍',
  msgsep = '═'
})
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
vim.opt.spelloptions = 'camel'
vim.opt.nrformats:append({
  'alpha'
})
if vim.fn.executable('ugrep') == 1 then
  vim.opt.grepprg = 'ugrep -RIjnkz --hidden --ignore-files --exclude-dir=".git"'
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
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 0
vim.g.netrw_alto = 0

-- Visual configuration options
-- symbols --
My_Symbols = {
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
My_Borders = 'rounded'

-- diagnostic handling
local diagnostic_signs = { ' ', ' ', '𥉉', ' ' }
local diagnostic_severity_fullnames = { 'Error', 'Warning', 'Information', 'Hint' }
local diagnostic_severity_shortnames = { 'Error', 'Warn', 'Info', 'Hint' }
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
    border = My_Borders,
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

-- }}}1 --------------------- OPTIONS ------------------------------------------
-- {{{1 --------------------- MAPPINGS -----------------------------------------
vim.keymap.set('', 'cd', '<Cmd>cd %:h | pwd<CR>')
vim.keymap.set('n', '<Leader>g', ':grep<Space>')
vim.keymap.set('n', '<Leader>l', '<Cmd>nohlsearch | hi clear ColorColumn<CR>')
vim.keymap.set('n', 'M', '<Cmd>lua ShowMan()<CR>')
vim.keymap.set('n', '<F10>', '<Cmd>lua ToggleDetails()<CR>')
vim.keymap.set('n', '<F11>', '<Cmd>lua Identify_Highlight_Group()<CR>')
-- {{{2 navigation
vim.keymap.set('n', 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
vim.keymap.set('n', 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
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
-- {{{2 quickfix
vim.keymap.set('n', '<C-c>', [[<Cmd>lua ToggleQF('q')<CR>]])
vim.keymap.set('n', '<A-c>', [[<Cmd>lua ToggleQF('l')<CR>]])
vim.keymap.set('n', '[\\', [[<Cmd>colder<CR>]])
vim.keymap.set('n', ']\\', [[<Cmd>cnewer<CR>]])
-- }}}
--{{{2 signatures
vim.keymap.set('n', '<Leader>sa', [[1G:s#\(Stefan Wimmer\) <.*>#\1 <stefan@tangoartisan.com>#<CR>G?--<CR>jVGd :r ~/.mutt/short-signature-artisan<CR>/^To:<CR>]])
vim.keymap.set('n', '<Leader>sg', [[1G:s#\(Stefan Wimmer\) <.*>#\1 <wimstefan@gmail.com>#<CR>G?--<CR>jVGd :r ~/.mutt/short-signature-gmail<CR>/^To:<CR>]])
vim.keymap.set('n', '<Leader>st', [[G?--<CR>jVGd :r ~/.mutt/short-signature-tango<CR>]])
vim.keymap.set('n', '<Leader>ss', [[G?--<CR>jVGd :r ~/.mutt/short-signature<CR>]])
vim.keymap.set('n', '<Leader>sl', [[G?--<CR>jVGd :r ~/.mutt/signature<CR>]])
-- }}}
-- }}}1 --------------------- MAPPINGS -----------------------------------------
-- {{{1 --------------------- AUTOCMDS -----------------------------------------
vim.cmd([[
augroup General
  autocmd!
  autocmd BufRead * if expand('%') =~ 'tangoartisan' | setfiletype html | endif
  autocmd BufNewFile,BufRead *.htp,*.htt set filetype=xhtml
  autocmd BufNewFile,BufRead *.xmp set filetype=xml
  autocmd BufNewFile,BufRead *.rasi set filetype=config
  autocmd BufWritePost *.sh,*.pl,*.py silent !chmod +x %
  autocmd BufNewFile,BufRead *.m3u set encoding=utf-8 fileencoding=utf-8 ff=unix
  autocmd BufWritePost X{resources,defaults} silent !xrdb %
  autocmd BufNewFile,BufRead *cddb* set encoding=utf-8 fileencoding=utf-8 ff=unix
  autocmd FileType txt,markdown,asciidoc*,rst if &filetype !~ 'man\|help' | setlocal spell | endif
  autocmd FileType help,man,startuptime,qf,lspinfo,null-ls-info,checkhealth nnoremap <buffer><silent>q :bdelete<CR>
  autocmd BufWinEnter * if &previewwindow | setlocal nofoldenable | endif
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | execute "normal! g`\"" | endif
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup='WildMenu', timeout=4444}
augroup END
augroup Commentstrings
  autocmd!
  autocmd FileType pfmain,toml set commentstring=#\%s
  autocmd FileType vifm set commentstring=\"\ %s
  autocmd FileType xdefaults set commentstring=!\%s
  autocmd FileType json syntax match Comment +\/\/.\+$+
augroup END
augroup Help
  autocmd!
  autocmd BufWinEnter * if &filetype =~ 'help' | wincmd L | vertical resize 84 | endif
  autocmd BufWinEnter * if &filetype =~ 'man' | wincmd L | wincmd = | endif
  autocmd FileType man,help,*doc setlocal nonumber norelativenumber nospell nolist nocursorcolumn
augroup END
augroup Colors
  autocmd!
  autocmd ColorScheme * highlight clear ColorColumn
  autocmd ColorScheme,VimEnter,WinEnter,BufEnter * call v:lua.NotifyColors()
augroup END
]])
vim.cmd(string.format([[
augroup Packer
  autocmd!
  autocmd FileType packer set previewheight=30
  autocmd FileType git set nolist nonumber norelativenumber
  autocmd BufWritePost init.lua if expand('%s') =~ '%s' || expand('%s') =~ '%s' && expand('%s') !~ 'fugitive\|scp' | source <afile> | call v:lua.require('packer').sync() | endif
augroup end
]], '%:p', vim.fn.stdpath('config'), '%:p', vim.fn.getenv('HOME') .. '/.dotfiles/', '%'))
-- }}}1 --------------------- AUTOCMDS -----------------------------------------
-- {{{1 --------------------- FUNCTIONS ----------------------------------------
function Dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

function Identify_Highlight_Group()
	local highlight_name = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(vim.fn.line('.'), vim.fn.col('.'), 1)), 'name')
  if highlight_name == ''
    then
      vim.notify('Highlight group not found', vim.log.levels.WARN, { title = '[UI]' })
    else
      vim.cmd(string.format([[highlight %s]], highlight_name))
    end
end

function NotifyColors()
  vim.cmd([[
    highlight link NotifyERRORBorder DiagnosticVirtualTextError
    highlight link NotifyWARNBorder DiagnosticVirtualTextWarn
    highlight link NotifyINFOBorder DiagnosticVirtualTextInfo
    highlight link NotifyDEBUGBorder PmenuSel
    highlight link NotifyTRACEBorder DiagnosticVirtualTextHint
    highlight link NotifyERRORIcon DiagnosticSignError
    highlight link NotifyWARNIcon DiagnosticSignWarn
    highlight link NotifyINFOIcon DiagnosticSignInfo
    highlight link NotifyDEBUGIcon ModeMsg
    highlight link NotifyTRACEIcon DiagnosticSignHint
    highlight link NotifyERRORTitle DiagnosticError
    highlight link NotifyWARNTitle DiagnosticWarn
    highlight link NotifyINFOTitle DiagnosticInfo
    highlight link NotifyDEBUGTitle ModeMsg
    highlight link NotifyTRACETitle DiagnosticHint
    highlight link NotifyERRORBody Normal
    highlight link NotifyWARNBody Normal
    highlight link NotifyINFOBody Normal
    highlight link NotifyDEBUGBody Normal
    highlight link NotifyTRACEBody Normal
  ]])
end

-- {{{2 toggle detailed information for easier paste
function ToggleDetails()
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
    vim.notify('Details disabled', vim.log.levels.INFO, { title = '[UI]' })
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
    vim.notify('Details enabled', vim.log.levels.INFO, { title = '[UI]' })
  end
end
-- }}}
-- {{{2 quickfix/location toggle made by iBaghwan
function TableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function FindQF(type)
  local wininfo = vim.fn.getwininfo()
  local win_tbl = {}
  for _, win in pairs(wininfo) do
    local found = false
    if type == 'l' and win['loclist'] == 1 then
      found = true
    end
    if type == 'q' and win['quickfix'] == 1 and win['loclist'] == 0 then
      found = true
    end
    if found then
      table.insert(win_tbl, { winid = win['winid'], bufnr = win['bufnr'] })
    end
  end
  return win_tbl
end

function OpenQF()
  local qf_name = 'quickfix'
  local qf_empty = function() return vim.tbl_isempty(vim.fn.getqflist()) end
  if not qf_empty() then
    vim.cmd([[copen]])
    vim.cmd([[wincmd J]])
  else
    print(string.format("%s is empty.", qf_name))
  end
end

function OpenLoclistAll()
  local wininfo = vim.fn.getwininfo()
  local qf_name = 'loclist'
  local qf_empty = function(winnr) return vim.tbl_isempty(vim.fn.getloclist(winnr)) end
  for _, win in pairs(wininfo) do
    if win['quickfix'] == 0 then
      if not qf_empty(win['winnr']) then
        vim.api.nvim_set_current_win(win['winid'])
        vim.cmd([[lopen]])
      else
        print(string.format("%s is empty.", qf_name))
      end
    end
  end
end

function ToggleQF(type)
  local windows = FindQF(type)
  if TableLength(windows) > 0 then
    for _, win in pairs(windows) do
      vim.api.nvim_win_hide(win.winid)
    end
  else
    if type == 'l' then
      OpenLoclistAll()
    else
      OpenQF()
    end
  end
end
-- }}}
-- {{{2 show manpage of current word
function ShowMan()
  local cword = vim.fn.expand('<cword>')
  vim.cmd([[Man ]] .. cword)
end
-- }}}
-- }}}1 --------------------- FUNCTIONS ----------------------------------------
-- {{{1 --------------------- PLUGINS ------------------------------------------
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/shadmansaleh/packer.nvim', install_path })
end

local packer = require('packer')
local use = packer.use
packer.startup(function()
  packer.init({
    compile_path = vim.fn.stdpath('config') .. '/lua/packer_compiled.lua',
    display = {
      open_cmd = '84vnew [packer]',
      working_sym = '北 ',
      error_sym = '✗  ',
      done_sym = '✓  ',
      removed_sym = '  ',
      moved_sym = '-> ',
      prompt_border = My_Borders
    }
  })
  -- {{{2 packer.nvim
  use({
    'shadmansaleh/packer.nvim',
    config = function()
      vim.keymap.set('n', ',pc', '<Cmd>PackerClean<CR>')
      vim.keymap.set('n', ',pi', '<Cmd>PackerInstall<CR>')
      vim.keymap.set('n', ',pq', '<Cmd>PackerStatus<CR>')
      vim.keymap.set('n', ',ps', '<Cmd>PackerSync<CR>')
      vim.keymap.set('n', ',pu', '<Cmd>PackerUpdate<CR>')
    end
  })
  -- }}}
  -- {{{2 impatient.nvim
  use('lewis6991/impatient.nvim')
  -- }}}
  -- {{{2 FixCursorHold.nvim
  use('antoinemadec/FixCursorHold.nvim')
  -- }}}
  -- {{{2 startuptime
  use('dstein64/vim-startuptime')
  -- }}}
  -- {{{2 Treesitter
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      'windwp/nvim-ts-autotag',
      'JoosepAlviste/nvim-ts-context-commentstring',
      {
        'nvim-treesitter/playground',
        config = function()
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
          additional_vim_regex_highlighting = true
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
          navigation = { enable = true },
          smart_rename = { enable = true },
        },
        textobjects = {
          lookahead = true,
          lsp_interop = {
            enable = true,
            border = My_Borders,
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
      local parsers = require('nvim-treesitter.parsers')
      function Ensure_Treesitter_Language_Installed()
        local lang = parsers.get_buf_lang()
        if parsers.get_parser_configs()[lang] and not parsers.has_parser(lang) then
          vim.schedule_wrap(function()
            vim.cmd([[TSInstall ]] .. lang)
          end)()
        end
      end

      vim.cmd([[autocmd FileType * lua Ensure_Treesitter_Language_Installed()]])
    end
  })
  -- }}}
  -- {{{2 Telescope
  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make'
      }
    },
    config = function()
      vim.keymap.set('n', '<Leader>T', [[<Cmd>Telescope<CR>]])
      vim.keymap.set('n', '<Leader>b', [[<Cmd>Telescope buffers<CR>]])
      vim.keymap.set('n', '<Leader>c', [[<Cmd>Telescope colorscheme<CR>]])
      vim.keymap.set('n', '<Leader>f', [[<Cmd>Telescope find_files<CR>]])
      vim.keymap.set('n', '<Leader>o', [[<Cmd>Telescope oldfiles<CR>]])
      vim.keymap.set('n', '<Leader>Tg', [[<Cmd>Telescope live_grep grep_open_files=true<CR>]])
      vim.keymap.set('n', '<Leader>TG', [[<Cmd>Telescope live_grep<CR>]])
      vim.keymap.set('n', '<Leader>h', [[<Cmd>Telescope help_tags<CR>]])
      vim.keymap.set('n', '<Leader>M', [[<Cmd>Telescope man_pages<CR>]])
      vim.keymap.set('n', '<Leader>m', [[<Cmd>Telescope marks<CR>]])
      vim.keymap.set('n', '<Leader>r', [[<Cmd>Telescope registers<CR>]])
      vim.keymap.set('n', '<Leader>Tgb', [[<Cmd>Telescope git_bcommits<CR>]])
      vim.keymap.set('n', '<Leader>Tgc', [[<Cmd>Telescope git_commits<CR>]])
      vim.keymap.set('n', '<Leader>Tgf', [[<Cmd>Telescope git_files<CR>]])
      vim.keymap.set('n', '<Leader>Tgs', [[<Cmd>Telescope git_status<CR>]])
      vim.keymap.set('n', '<Leader>Tc', [[<Cmd>Telescope command_history<CR>]])
      vim.keymap.set('n', '<Leader>Tf', [[<Cmd>Telescope filetypes<CR>]])
      vim.keymap.set('n', '<Leader>Tm', [[<Cmd>Telescope keymaps<CR>]])
      vim.keymap.set('n', '<Leader>Tq', [[<Cmd>Telescope quickfix<CR>]])
      vim.keymap.set('n', '<Leader>Ts', [[<Cmd>Telescope spell_suggest<CR>]])
      vim.keymap.set('n', '<Leader>Tw', [[<Cmd>Telescope grep_string<CR>]])
      vim.keymap.set('n', '<Leader>Tz', [[<Cmd>Telescope current_buffer_fuzzy_find<CR>]])
      require('telescope').setup({
        defaults = {
          prompt_prefix = '∷ ',
          selection_caret = '» ',
          dynamic_preview_title = true,
          wrap_results = true,
          file_ignore_patterns = { '^.git/', 'db', 'gif', 'jpeg', 'jpg', 'ods', 'odt', 'pdf', 'png', 'svg', 'xcf', 'xls' },
          layout_strategy = 'bottom_pane',
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position = 'top',
            center = {
              mirror = true
            },
            horizontal = {
              anchor = 'NE',
              height = 0.99,
              width = 0.66,
              preview_width = 0.55
            },
            vertical = {
              anchor = 'NE',
              width = 0.50,
              height = 0.99,
              preview_cutoff = 4,
              preview_height = 0.66,
              mirror = true
            },
          },
          mappings = {
            i = {
              ['<C-h>'] = 'which_key',
              ['<C-w>'] = require('telescope.actions.layout').toggle_preview,
              ['<C-q>'] = require('telescope.actions').smart_send_to_qflist + require('telescope.actions').open_qflist,
              ['<M-q>'] = require('telescope.actions').smart_add_to_qflist + require('telescope.actions').open_qflist,
            },
            n = {
              ['<C-h>'] = 'which_key',
              ['<C-w>'] = require('telescope.actions.layout').toggle_preview,
              ['<C-q>'] = require('telescope.actions').smart_send_to_qflist + require('telescope.actions').open_qflist,
              ['<M-q>'] = require('telescope.actions').smart_add_to_qflist + require('telescope.actions').open_qflist,
            },
          },
          preview = {
            msg_bg_fillchar = '░',
          },
          vimgrep_arguments = {
            'ugrep',
            '-RIjnkz',
            '--color=never',
            '--hidden',
            '--ignore-files',
            '--exclude-dir=".git"'
          }
        },
        pickers = {
          builtin = {
            layout_strategy = 'vertical',
            previewer = false
          },
          colorscheme = {
            theme = 'dropdown',
            enable_preview = true
          },
          diagnostics = {
            layout_strategy = 'vertical'
          },
          find_files = {
            find_command = { 'fd', '--exclude', '.git/' },
            follow = true,
            hidden = true,
            no_ignore = false
          },
          filetypes = {
            theme = 'dropdown'
          },
          git_branches = {
            layout_strategy = 'vertical'
          },
          lsp_code_actions = {
            theme = 'cursor'
          },
          lsp_declarations = {
            layout_strategy = 'vertical'
          },
          lsp_definitions = {
            layout_strategy = 'vertical'
          },
          lsp_implementations = {
            layout_strategy = 'vertical'
          },
          oldfiles = {
            layout_strategy = 'vertical',
            previewer = false
          },
          spell_suggest = {
            theme = 'cursor',
            layout_config = {
              height = 14
            }
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
  })
  -- }}}
  -- {{{2 nvim-cmp
  use({
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
    'ray-x/cmp-treesitter',
    'f3fora/cmp-spell',
  },
  config = function()
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end

    local cmp = require('cmp')
    local luasnip = require('luasnip')
    luasnip.filetype_extend('all', { '_' })
    require('luasnip.loaders.from_snipmate').lazy_load()

    cmp.setup({
      completion = {
        border = My_Borders,
        scrollbar = '🮑'
      },
      documentation = {
        border = My_Borders
      },
      experimental = {
        ghost_text = true,
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          vim_item.menu = ({
            buffer = '[Buffer]',
            nvim_lsp = '[LSP]',
            nvim_lua = '[API]',
            path = '[Filesystem]',
            luasnip = '[Snippet]',
            treesitter = '[TS]',
            spell = '[Spell]',
          })[entry.source.name]
          vim_item.kind = My_Symbols[vim_item.kind]
          return vim_item
        end
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end
      },
      mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.mapping.confirm({ select = false }),
        ['<C-e>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ['<C-l>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            return cmp.complete_common_string()
          end
          fallback()
        end, { 'i', 'c' }),
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
      sources = cmp.config.sources({
        { name = 'nvim_lua' },
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'luasnip' },
        { name = 'buffer',
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end
          }
        },
        { name = 'treesitter' },
        { name = 'spell' },
      })
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
  })
  -- }}}
  -- {{{2 LSP
  use({
    'neovim/nvim-lspconfig',
    requires = {
      'ii14/lsp-command',
      'folke/lua-dev.nvim',
      'jose-elias-alvarez/null-ls.nvim',
      {
        'kosayoda/nvim-lightbulb',
        config = function()
          vim.fn.sign_define('LightBulbSign', { text = ' ', texthl = 'WarningMsg', linehl = '', numhl = '' })
          vim.cmd([[autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]])
          require('nvim-lightbulb').update_lightbulb()
        end
      },
      {
        'stevearc/aerial.nvim',
        config = function()
          require('aerial').setup({
            backends = { 'treesitter', 'lsp', 'markdown' },
            placement_editor_edge = true,
            symbols = My_Symbols,
            on_attach = function(bufnr)
              vim.keymap.set('n', '<Leader>a', '<Cmd>AerialToggle!<CR>', { buffer = bufnr })
              vim.keymap.set('n', '{', '<Cmd>AerialPrev<CR>', { buffer = bufnr })
              vim.keymap.set('n', '}', '<Cmd>AerialNext<CR>', { buffer = bufnr })
              vim.keymap.set('n', '{{', '<Cmd>AerialPrevUp<CR>', { buffer = bufnr })
              vim.keymap.set('n', '}}', '<Cmd>AerialNextUp<CR>', { buffer = bufnr })
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

      -- LSP handlers
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = My_Borders })
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = My_Borders })

      -- LSP functions
      local on_attach = function(client, bufnr)
        lsp_aerial.on_attach(client, bufnr)
        local lsp_messages = {}
        local lsp_msg_sep = ' ∷ '
        lsp_messages = lsp_msg_sep .. 'LSP attached' .. lsp_msg_sep
        -- options
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        -- keybindings
        vim.keymap.set('n', ',lR', [[<Cmd>Telescope lsp_definitions<CR>]], { buffer = bufnr })
        vim.keymap.set('n', ',lr', [[<Cmd>Telescope lsp_references<CR>]], { buffer = bufnr })
        vim.keymap.set('n', ',ly', [[<Cmd>Telescope lsp_document_symbols<CR>]], { buffer = bufnr })
        vim.keymap.set('n', ',lY', [[<Cmd>Telescope lsp_workspace_symbols<CR>]], { buffer = bufnr })
        vim.keymap.set('n', ',ld', [[<Cmd>Telescope diagnostics bufnr=0<CR>]], { buffer = bufnr })
        vim.keymap.set('n', ',lD', [[<Cmd>Telescope diagnostics<CR>]], { buffer = bufnr })
        vim.keymap.set('n', ',le', [[<Cmd>lua vim.diagnostic.open_float({ scope = 'line' })<CR>]], { buffer = bufnr })
        vim.keymap.set('n', '[d', [[<Cmd>lua vim.diagnostic.goto_prev({ float = false })<CR>]], { buffer = bufnr })
        vim.keymap.set('n', ']d', [[<Cmd>lua vim.diagnostic.goto_next({ float = false })<CR>]], { buffer = bufnr })
        vim.keymap.set('n', ',lrn', [[<Cmd>lua vim.lsp.buf.rename()<CR>]], { buffer = bufnr })
        vim.keymap.set('n', ',lh', [[<Cmd>lua vim.lsp.buf.hover()<CR>]], { buffer = bufnr })
        vim.keymap.set('n', ',lw', [[<Cmd>lua Dump(vim.lsp.buf.list_workspace_folders())<CR>]], { buffer = bufnr })
        if client.supports_method('textDocument/codeAction') then
          vim.keymap.set('n', ',lca', [[<Cmd>Telescope lsp_code_actions<CR>]], { buffer = bufnr })
        else
          lsp_messages = lsp_messages .. 'no codeAction' .. lsp_msg_sep
        end
        if client.resolved_capabilities.declaration then
          vim.keymap.set('n', ',lc', [[<Cmd>lua vim.lsp.buf.declaration()<CR>]], { buffer = bufnr })
        else
          vim.keymap.set('n', ',lc', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no declaration' .. lsp_msg_sep
        end
        if client.resolved_capabilities.document_formatting then
          vim.keymap.set('n', ',lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>', { buffer = bufnr, silent = true })
        else
          lsp_messages = lsp_messages .. 'no format' .. lsp_msg_sep
        end
        if client.resolved_capabilities.document_range_formatting then
          vim.keymap.set('v', ',lf', '<Cmd>lua vim.lsp.buf.range_formatting()<CR>', { buffer = bufnr, silent = true })
        else
          lsp_messages = lsp_messages .. 'no rangeFormat' .. lsp_msg_sep
        end
        if client.resolved_capabilities.implementation then
          vim.keymap.set('n', ',li', [[<Cmd>Telescope lsp_implementations<CR>]], { buffer = bufnr })
        else
          vim.keymap.set('n', ',li', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no implementation' .. lsp_msg_sep
        end
        if client.resolved_capabilities.signature_help then
          vim.keymap.set('i', '<C-s>', [[<Cmd>lua vim.lsp.buf.signature_help({ border = My_Borders })<CR>]], { buffer = bufnr })
          vim.keymap.set('n', ',ls', [[<Cmd>lua vim.lsp.buf.signature_help({ border = My_Borders })<CR>]], { buffer = bufnr })
        else
          vim.keymap.set('n', ',ls', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no signatureHelp' .. lsp_msg_sep
        end
        if client.resolved_capabilities.type_definition then
          vim.keymap.set('n', ',ltd', [[<Cmd>Telescope lsp_type_definitions<CR>]], { buffer = bufnr })
        else
          vim.keymap.set('n', ',ltd', [[<Nop>]], { buffer = bufnr })
          lsp_messages = lsp_messages .. 'no typeDefinition' .. lsp_msg_sep
        end

        -- autocmds
        if client.supports_method('textDocument/codeLens') then
          vim.keymap.set('n', ',ll', [[<Cmd>lua vim.lsp.buf.codelens.run({ border = My_Borders })<CR>]], { buffer = bufnr })
          vim.cmd([[autocmd BufEnter,CursorHold,InsertLeave * lua vim.lsp.codelens.refresh()]])
        else
          lsp_messages = lsp_messages .. 'no codeLens' .. lsp_msg_sep
        end

        -- messages
        vim.notify(lsp_messages, vim.log.levels.INFO, { title = '[LSP]' })
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits',
        }
      }
      capabilities.experimental = {}
      capabilities.experimental.hoverActions = true
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

      -- null-ls
      require('null-ls').setup({
        debug = false,
        sources = {
          require('null-ls').builtins.diagnostics.zsh,
          require('null-ls').builtins.diagnostics.trail_space,
          require('null-ls').builtins.formatting.trim_whitespace,
          require('null-ls').builtins.formatting.prettier.with({
            extra_args = { '--single-quote' }
          }),
        },
        on_attach = on_attach,
        capabilities = capabilities
      })

      -- lua
      local sumneko_binary = vim.fn.stdpath('data') .. '/lspconfig/lua-language-server/bin/lua-language-server'
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
          cmd = { sumneko_binary, '--preview' },
          on_attach = on_attach,
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
                path = runtime_path
              },
              diagnostics = {
                enable = true,
                globals = { 'vim' },
                neededFileStatus = {
                  codestyle_check = 'Any'
                }
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = 'space',
                  indent_size = 2,
                  continuation_indent_size = 2,
                  quote_style = 'single',
                  call_arg_parentheses = 'keep',
                  local_assign_continuation_align_to_first_expression = true,
                  align_call_args = true,
                  align_function_define_params = true,
                  align_table_field_to_first_field = true,
                  keep_one_space_between_table_and_bracket = true,
                  keep_one_space_between_namedef_and_attribute = false,
                  continuous_assign_statement_align_to_equal_sign = true,
                  continuous_assign_table_field_align_to_equal_sign = true,
                  if_condition_no_continuation_indent = true,
                  if_condition_align_with_each_other = true,
                }
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                preloadFileSize = 500
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
  })
  -- }}}
  -- {{{2 which-key.nvim
  use({
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
          border = My_Borders
        },
      })
    end
  })
  -- }}}
  -- {{{2 vim-fugitive
  use({
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<Leader>gc', '<Cmd>Git commit -v %<CR>')
      vim.keymap.set('n', '<Leader>gd', '<Cmd>Gdiffsplit<CR>')
      vim.keymap.set('n', '<Leader>gl', '<Cmd>0Gclog!<CR>')
      vim.keymap.set('n', '<Leader>gp', '<Cmd>Git push<CR>')
      vim.keymap.set('n', '<Leader>gs', '<Cmd>Git<CR>')
    end
  })
  -- }}}
  -- {{{2 vim-obsession
  use({
    'tpope/vim-obsession',
    config = function()
      vim.keymap.set('n', ',to', '<Cmd>Obsession<CR>')
    end
  })
  -- }}}
  -- {{{2 vim-repeat
  use('tpope/vim-repeat')
  -- }}}
  -- {{{2 vim-surround
  use('tpope/vim-surround')
  -- }}}
  -- {{{2 vim-unimpaired
  use('tpope/vim-unimpaired')
  -- }}}
  -- {{{2 lightspeed.nvim
  use({
    'ggandor/lightspeed.nvim',
    config = function()
      vim.keymap.set('n', 's', '<Plug>Lightspeed_omni_s')
      vim.keymap.set('n', 'S', '<Plug>Lightspeed_omni_gs')
    end
  })
  -- }}}
  -- {{{2 spellsitter.nvim
  use({
    'lewis6991/spellsitter.nvim',
    config = function()
      require('spellsitter').setup()
    end
  })
  -- }}}
  -- {{{2 Comment.nvim
  use({
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
  })
  -- }}}
  -- {{{2 nvim-bqf
  use({
    'kevinhwang91/nvim-bqf',
    config = function()
      vim.api.nvim_command([[packadd cfilter]])
      require('bqf').setup({
        auto_enable = true,
        auto_resize_height = true
      })
    end
  })
  -- }}}
  -- {{{2 nvim-hlslens
  use({
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup()
      vim.opt.shortmess:append('S')
      vim.keymap.set('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]])
      vim.keymap.set('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]])
      vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]])
      vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]])
      vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]])
      vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]])
    end
  })
  -- }}}
  -- {{{2 zk-nvim
  use({
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

      vim.keymap.set('n', '<Leader>zf', [[<Cmd>ZkNotes { match = vim.fn.input('Search: ') }<CR>]])
      vim.keymap.set('v', '<Leader>zf', [[:'<,'>ZkMatch<CR>]])
      vim.keymap.set('n', '<Leader>zn', [[<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>]])
      vim.keymap.set('n', '<Leader>zl', [[<Cmd>ZkNotes<CR>]])
      vim.keymap.set('n', '<Leader>zr', [[<Cmd>ZkRecents<CR>]])
      vim.keymap.set('n', '<Leader>zt', [[<Cmd>ZkTags<CR>]])
    end
  })
  -- }}}
  -- {{{2 vim-simple-align
  use('kg8m/vim-simple-align')
  -- }}}
  -- {{{2 fm-nvim
  use({
    'is0n/fm-nvim',
    config = function()
      vim.keymap.set('n', '<Leader>z', '<Cmd>Fzf<CR>', {})
      vim.keymap.set('n', '<Leader>x', '<Cmd>Vifm<CR>', {})
      require('fm-nvim').setup({
        border = My_Borders,
        border_hl = 'Normal'
      })
    end
  })
  -- }}}
  -- {{{2 toggleterm.nvim
  use({
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
        direction = 'float',
        float_opts = {
          border = My_Borders
        }
      })
      vim.keymap.set('n', '<Leader>tf', [[<Cmd>ToggleTerm direction=float<CR>]])
      vim.keymap.set('n', '<Leader>th', [[<Cmd>ToggleTerm direction=horizontal<CR>]])
      vim.keymap.set('n', '<Leader>tv', [[<Cmd>ToggleTerm direction=vertical<CR>]])
    end
  })
  -- }}}
  -- {{{2 vim-oscyank
  use({
    'ojroques/vim-oscyank',
    config = function()
      vim.cmd([[autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif]])
    end
  })
  -- }}}
  -- {{{2 nvim-spectre
  use({
    'windwp/nvim-spectre',
    config = function()
      require('spectre').setup({
        find_engine = {
          ['rg'] = {
            cmd = 'ugrep',
            args = {
              '-RIjnkz',
              '--color=never',
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
      vim.keymap.set('n', '<Leader>S', [[<Cmd>lua require('spectre').open()<CR>]])
    end
  })
  -- }}}
  -- {{{2 undotree
  use({
    'mbbill/undotree',
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_ShortIndicators = 1
      vim.keymap.set('n', ',tu', '<Cmd>UndotreeToggle<CR>', {})
    end
  })
  -- }}}
  -- {{{2 vim-dirdiff
  use('will133/vim-dirdiff')
  -- }}}
  -- {{{2 paperplanes.nvim
  use({
  'rktjmp/paperplanes.nvim',
  config = function()
    require('paperplanes').setup({
      register = 'p',
      provider = 'paste.rs'
    })
  end
  })
  -- }}}
  -- {{{2 vim-renamer
  use('qpkorr/vim-renamer')
  -- }}}
  -- {{{2 vim-gnupg
  use('jamessan/vim-gnupg')
  -- }}}
  -- {{{2 vim-log-highlighting
  use({
    'MTDL9/vim-log-highlighting',
    ft = 'log'
  })
  -- }}}
  -- {{{2 unicode.vim
  use({
    'chrisbra/unicode.vim',
    config = function()
      vim.keymap.set('n', '<Leader>ut', '<Cmd>UnicodeTable<CR>')
      vim.keymap.set('n', 'ga', '<Cmd>UnicodeName<CR>')
    end
  })
  -- }}}
  -- {{{2 Visuals
  -- {{{3 nvim-colorizer.lua
  use({
    'DarwinSenior/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup(
        { '*' },
        {
          RGB = true,
          RRGGBB = true,
          RRGGBBAA = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          names = false,
          mode = 'background',
        }
      )
    end
  })
  -- }}}
  -- {{{3 nvim-web-devicons
  use({
    'wimstefan/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup({
        padding = true
      })
    end
  })
  -- }}}
  -- {{{3 lush.nvim
  use('rktjmp/lush.nvim')
  -- }}}
  -- {{{3 artesanal
  use({
    'wimstefan/vim-artesanal',
    config = function()
      vim.g.artesanal_dimmed = false
      vim.g.artesanal_transparent = true
    end
  })
  -- }}}
  -- {{{3 nightfox.nvim
  use({
    'EdenEast/nightfox.nvim',
    config = function()
      require('nightfox').setup({
        options = {
          transparent = true,
          dim_inactive = true,
          terminal_colors = true,
          styles = {
            comments = 'italic',
            functions = 'italic',
            keywords = 'bold',
            strings = 'NONE',
            variables = 'NONE',
          },
          inverse = {
            match_paren = true,
            visual = false,
            search = true,
          }
        },
        groups = {
          Folded = { bg = "NONE" }
        }
      })
    end
  })
  -- }}}
  -- {{{3 zenbones.nvim
  use({
    'mcchrish/zenbones.nvim',
    config = function()
      local flavours = { 'zenbones', 'zenwritten', 'neobones', 'nordbones', 'seoulbones', 'tokyobones' }
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
  })
  -- }}}
  -- {{{3 onedark.nvim
  use({
    'navarasu/onedark.nvim',
    config = function()
      require('onedark').setup({
        transparent = true,
        code_style = {
          comments = 'italic',
          keywords = 'none',
          functions = 'bold',
          strings = 'none',
          variables = 'none'
        },
        diagnostics = {
          background = false
        },
        toggle_style_key = ',tos',
        toggle_style_list = { 'cool', 'deep', 'light' },
      })
    end
  })
  -- }}}
  -- {{{3 lualine.nvim
  use({
    'nvim-lualine/lualine.nvim',
    config = function()
      if vim.fn.filereadable(vim.fn.expand('$HOME/.config/colours/nvim_theme.lua')) == 1 then
        vim.api.nvim_command [[luafile $HOME/.config/colours/nvim_theme.lua]]
      else
        vim.api.nvim_command [[colorscheme desert]]
      end
      local check_width = function()
        return vim.fn.winwidth(0) > 100
      end
      local check_width_wide = function()
        return vim.fn.winwidth(0) > 140
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
      local lsp_status = function()
        local msg = ''
        msg = '[LSP]'
        for _, client in ipairs(vim.lsp.get_active_clients()) do
          msg = msg .. '‹' .. client.name .. '›'
          for _, progress in pairs(client.messages.progress) do
            if not progress.done then
              msg = progress.title
              if progress.message then
                msg = msg .. ' ' .. progress.message
              end
              if progress.percentage then
                msg = string.format('%s%2d%s', '⸢', progress.percentage, '%%⸥')
              end
              return msg
            end
          end
        end
        return msg
      end
      local diff_source = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
        end
      end
      local window = function()
        return vim.api.nvim_win_get_number(0)
      end
      local minimal_extension = {
        sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = { 'location', 'progress' },
          lualine_z = { 'filetype' },
        },
        filetypes = { 'help', 'packer', 'qf' }
      }

      require('lualine').setup({
        options = {
          icons_enabled = true,
          globalstatus = true,
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'location', 'progress' },
          lualine_c = {
            {
              'filename',
              file_status = false
            },
            {
              get_readonly,
              padding = 0,
              color = { fg = 'grey' },
            },
            {
              get_modified,
              padding = 0,
              color = { fg = 'red' },
            },
            {
              get_spell,
              padding = 1,
              color = { fg = 'brown' },
            },
            {
              get_session,
              padding = 1,
              color = { fg = 'yellow' },
            },
          },
          lualine_x = {
            {
              'aerial',
              cond = check_width_wide
            },
            {
              lsp_status,
              cond = check_width
            },
            {
              'diagnostics',
              always_visible = false,
              sources = { 'nvim_diagnostic' },
              symbols = {
                error = vim.fn.sign_getdefined('DiagnosticSignError')[1].text .. ' ',
                warn = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text .. ' ',
                info = vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text .. ' ',
                hint = vim.fn.sign_getdefined('DiagnosticSignHint')[1].text .. ' '
              }
            },
          },
          lualine_y = {
            {
              'diff',
              source = diff_source,
              diff_color = { added = 'GitSignsAdd', modified = 'GitSignsChange', removed = 'GitSignsDelete' },
              symbols = { added = '  ', modified = '  ', removed = '  ' },
            },
            {
              'branch',
              icon = '⭠'
            }
          },
          lualine_z = { 'filetype' },
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = { 'location' },
          lualine_z = { 'filetype' },
        },
        tabline = {
          lualine_a = { window },
          lualine_c = { 'buffers' },
          lualine_b = { get_path },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {
            {
              'tabs',
              mode = 2
            }
          }
        },
        extensions = { 'aerial', 'fugitive', minimal_extension, 'toggleterm' },
      })
    end
  })
  -- }}}
  -- {{{3 gitsigns.nvim
  use({
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
        numhl = true,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          vim.keymap.set('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
          vim.keymap.set('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })
          vim.keymap.set('n', ',sp', gs.preview_hunk, { buffer = bufnr })
          vim.keymap.set('n', ',sb', function() gs.blame_line { full = true } end, { buffer = bufnr })
          vim.keymap.set('n', ',sd', gs.diffthis, { buffer = bufnr })
          vim.keymap.set('n', ',sD', function() gs.diffthis('~') end, { buffer = bufnr })
          vim.keymap.set('n', ',ss', gs.stage_hunk, { buffer = bufnr })
          vim.keymap.set('n', ',su', gs.undo_stage_hunk, { buffer = bufnr })
          vim.keymap.set('n', ',sx', gs.toggle_deleted, { buffer = bufnr })
        end,
        preview_config = {
          border = My_Borders,
        }
      })
    end
  })
  -- }}}
  -- {{{3 indent-blankline.nvim
  use({
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
  })
  -- }}}
  -- {{{3 virt-column.nvim
  use({
    'lukas-reineke/virt-column.nvim',
    config = function()
      vim.opt.colorcolumn = '80'
      require('virt-column').setup({
        char = '🮍',
      })
    end
  })
  -- }}}
  -- {{{3 nvim-notify
  use({
    'rcarriga/nvim-notify',
    config = function()
      local highlights = require('notify.config.highlights')
      function highlights.setup()
        NotifyColors()
      end

      require('notify').setup({
        stages = 'static',
        timeout = 2000,
        background_colour = function()
          local group_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('Normal')), 'bg#')
          if group_bg == '' or group_bg == 'none' then
            group_bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID('Float')), 'bg#')
            if group_bg == '' or group_bg == 'none' then
              return '#000000'
            end
          end
          return group_bg
        end,
        icons = {
          ERROR = ' ',
          WARN = ' ',
          INFO = ' ',
          DEBUG = ' ',
          TRACE = '變 '
        }
      })
      vim.notify = require('notify')
      vim.keymap.set('n', '<Leader>Tn', [[<Cmd>lua require('telescope').extensions.notify.notify()<CR>]])
    end
  })
  -- }}}
  -- {{{3 dressing.nvim
  use({
    'stevearc/dressing.nvim',
    config = function()
      require('dressing').setup({
        input = {
          winblend = 0,
          winhighlight = 'Normal:ModeMsg,FloatBorder:TelescopeBorder'
        },
        select = {
          winblend = 0
        },
      })
    end
  })
  -- }}}
  -- }}}
end)
require('packer_compiled')
-- }}}1 --------------------- PLUGINS ------------------------------------------
-- vim: foldmethod=marker foldlevel=1
