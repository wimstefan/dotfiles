return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = {
      signs = {
        add = { show_count = true },
        change = { show_count = true },
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
        vim.keymap.set('n', '<Leader>gp', gs.preview_hunk, { desc = 'Gitsigns: preview hunk' }, { buffer = bufnr })
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
  }
}
