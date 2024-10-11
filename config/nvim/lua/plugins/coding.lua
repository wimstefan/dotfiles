return {
  -- {{{2 nvim-autopairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {
      fast_wrap = {}
    }
  },
  -- }}}2
  -- {{{2 nvim-surround
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    opts = {}
  },
  -- }}}2
  -- {{{2 multicursor.nvim
  {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    event = 'VeryLazy',
    config = function()
      local mc = require('multicursor-nvim')
      mc.setup()

      vim.keymap.set({ 'n', 'v' }, '<Leader>mk', function() mc.lineAddCursor(-1) end, { desc = 'Cursors: add cursor above the main cursor' })
      vim.keymap.set({ 'n', 'v' }, '<Leader>mj', function() mc.lineAddCursor(1) end, { desc = 'Cursors: add cursor below the main cursor' })
      vim.keymap.set({ 'n', 'v' }, '<Leader>mn', function() mc.matchAddCursor(1) end, { desc = 'Cursors: add a new cursor by matching the current word/selection' })
      vim.keymap.set({ 'n', 'v' }, '<Leader>ms', function() mc.matchSkipCursor(1) end, { desc = 'Cursors: skip adding a new cursor by matching the current word/selection' })
      vim.keymap.set({ 'n', 'v' }, '<Leader>mN', function() mc.matchAddCursor(-1) end, { desc = 'Cursors: add a new cursor by matching the current word/selection' })
      vim.keymap.set({ 'n', 'v' }, '<Leader>mS', function() mc.matchSkipCursor(-1) end, { desc = 'Cursors: skip adding a new cursor by matching the current word/selection' })

      vim.keymap.set({ 'n', 'v' }, '<C-n>', function() mc.addCursor('*') end, { desc = 'Cursors: add a cursor and jump to the next word under cursor' })
      vim.keymap.set({ 'n', 'v' }, '<C-s>', function() mc.skipCursor('*') end, { desc = 'Cursors: jump to the next word under cursor but do not add a cursor' })

      vim.keymap.set({ 'n', 'v' }, '<Leader>ma', mc.alignCursors, { desc = 'Cursors: align' })

      vim.keymap.set('v', 'M', mc.matchCursors, { desc = 'Cursors: match new cursors within visual selection by regex' })
      vim.keymap.set('v', 'I', mc.insertVisual, { desc = 'Cursors: append for each line of visual selections' })
      vim.keymap.set('v', 'A', mc.appendVisual, { desc = 'Cursors: insert for each line of visual selections' })
      vim.keymap.set('v', 'S', mc.splitCursors, { desc = 'Cursors: split visual selection by regex' })

      vim.keymap.set('n', '<Esc>', function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
        end
      end, { desc = 'Cursors: clear/enable cursors' })

      vim.api.nvim_set_hl(0, 'MultiCursorCursor', { link = 'Cursor' })
      vim.api.nvim_set_hl(0, 'MultiCursorVisual', { link = 'Visual' })
      vim.api.nvim_set_hl(0, 'MultiCursorDisabledCursor', { link = 'Visual' })
      vim.api.nvim_set_hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
    end
  },
  -- }}}2
  -- {{{2 text-case.nvim
  {
    'johmsalas/text-case.nvim',
    event = 'VeryLazy',
    opts = {}
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
  -- {{{2 vim-simple-align
  {
    'kg8m/vim-simple-align',
    cmd = 'SimpleAlign'
  }
  -- }}}2
}
-- vim: foldmethod=marker foldlevel=1
