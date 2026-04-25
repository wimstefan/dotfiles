vim.pack.add({
  { src = 'https://github.com/junegunn/fzf' }
})

vim.pack.add({
  { src = 'https://github.com/lewis6991/gitsigns.nvim' }
})
require('gitsigns').setup({
  signs = {
    add = { show_count = true },
    change = { show_count = true },
    delete = { show_count = true },
    topdelete = { show_count = true },
    changedelete = { show_count = true }
  },
  numhl = true,
  linehl = true,
  word_diff = true,
  diff_opts = {
    internal = true,
    linematch = 60
  },
  gh = true,
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
    vim.keymap.set('n', '<Leader>gb', function() gitsigns.blame_line { full = true } end, { desc = 'Gitsigns: blame line' }, { buffer = bufnr })
    vim.keymap.set('n', '<Leader>gB', function() gitsigns.blame { full = true } end, { desc = 'Gitsigns: blame' }, { buffer = bufnr })
    vim.keymap.set('n', '<Leader>gd', gitsigns.diffthis, { desc = 'Gitsigns: diffthis' }, { buffer = bufnr })
    vim.keymap.set({ 'n', 'v' }, '<Leader>gr', gitsigns.reset_hunk, { desc = 'Gitsigns: reset hunk' }, { buffer = bufnr })
    vim.keymap.set({ 'n', 'v' }, '<Leader>gs', gitsigns.stage_hunk, { desc = 'Gitsigns: stage hunk' }, { buffer = bufnr })
    vim.keymap.set({ 'n', 'v' }, '<Leader>gu', gitsigns.undo_stage_hunk, { desc = 'Gitsigns: undo stage hunk' }, { buffer = bufnr })
    vim.keymap.set('n', '<Leader>gh', gitsigns.toggle_linehl, { desc = 'Gitsigns: toggle line highlight' }, { buffer = bufnr })
    vim.keymap.set('n', '<Leader>gw', gitsigns.toggle_word_diff, { desc = 'Gitsigns: toggle word diff' }, { buffer = bufnr })
    vim.keymap.set('n', '<Leader>gx', gitsigns.toggle_deleted, { desc = 'Gitsigns: toggle deleted' }, { buffer = bufnr })
  end
})

vim.pack.add({
  { src = 'https://github.com/yorickpeterse/nvim-jump' }
})
vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('jump').start() end, { desc = 'Jump' })

vim.pack.add({
  { src = 'https://github.com/lewis6991/spaceless.nvim' }
})

vim.pack.add({
  { src = 'https://github.com/MagicDuck/grug-far.nvim' }
})
require('grug-far').setup()
vim.keymap.set('n', '<Leader>R', function() require('grug-far').open() end, { desc = 'Grug-Far' })
vim.keymap.set('n', '<Leader>Rf',
  function() require('grug-far').open({ prefills = { flags = vim.fn.expand('%') } }) end,
  { desc = 'Grug-Far: current file' })
vim.keymap.set('n', '<Leader>Rv',
  function() require('grug-far').with_visual_selection({ prefills = { flags = vim.fn.expand('%') } }) end,
  { desc = 'Grug-Far: visual selection' })
vim.keymap.set('n', '<Leader>Rw',
  function() require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } }) end,
  { desc = 'Grug-Far: current word' })

vim.pack.add({
  { src = 'https://github.com/rktjmp/paperplanes.nvim' }
})
require('paperplanes').setup({
  register = '+',
  provider = 'dpaste.org',
  provider_options = {},
  notifier = vim.notify or print
})

vim.pack.add({
  { src = 'https://github.com/potamides/pantran.nvim' }
})
require('pantran').setup({
  function()
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
  end,
  default_engine = vim.env.DEEPL_AUTH_KEY and 'deepl' or 'google'
})

vim.pack.add({
  { src = 'https://github.com/zk-org/zk-nvim' }
})
require('zk').setup({
  picker = 'snacks_picker',
  function()
    local function make_edit_fn(defaults, picker_options)
      return function(options)
        options = vim.tbl_extend('force', defaults, options or {})
        require('zk').edit(options, picker_options)
      end
    end
    require('zk.commands').add('ZkRecents', make_edit_fn({ createdAfter = '1 week ago' }, { title = 'Zk Recents' }))
  end
})
vim.keymap.set('n', '<Leader>zf', [[<Cmd>ZkNotes { match = { vim.fn.input('Search: ') } }<CR>]])
vim.keymap.set('v', '<Leader>zf', [[:'<,'>ZkMatch<CR>]])
vim.keymap.set('n', '<Leader>zn', [[<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>]])
vim.keymap.set('n', '<Leader>zl', [[<Cmd>ZkNotes<CR>]])
vim.keymap.set('n', '<Leader>zr', [[<Cmd>ZkRecents<CR>]])
vim.keymap.set('n', '<Leader>zt', [[<Cmd>ZkTags<CR>]])
