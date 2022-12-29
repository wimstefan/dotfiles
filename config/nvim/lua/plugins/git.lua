return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
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
        diff_opts = {
          linematch = 60
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
          vim.keymap.set('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'",
            { expr = true, replace_keycodes = false },
            { desc = 'Gitsigns: next hunk' })
          vim.keymap.set('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'",
            { expr = true, replace_keycodes = false },
            { desc = 'Gitsigns: previous hunk' })
          vim.keymap.set('n', ',sp', gs.preview_hunk, { desc = 'Gitsigns: preview hunk' }, { buffer = bufnr })
          vim.keymap.set('n', ',sb', function() gs.blame_line { full = true } end, { desc = 'Gitsigns: blame line' },
            { buffer = bufnr })
          vim.keymap.set('n', ',sd', gs.diffthis, { desc = 'Gitsigns: diffthis' }, { buffer = bufnr })
          vim.keymap.set('n', ',sD', function() gs.diffthis('~') end, { desc = 'Gitsigns: diffthis ~' },
            { buffer = bufnr })
          vim.keymap.set('n', ',ss', gs.stage_hunk, { desc = 'Gitsigns: stage hunk' }, { buffer = bufnr })
          vim.keymap.set('n', ',su', gs.undo_stage_hunk, { desc = 'Gitsigns: undo stage hunk' }, { buffer = bufnr })
          vim.keymap.set('n', ',sx', gs.toggle_deleted, { desc = 'Gitsigns: toggle deleted' }, { buffer = bufnr })
        end,
        preview_config = {
          border = My_Borders,
        },
        _extmark_signs = true,
        _threaded_diff = true,
        _signs_staged_enable = true,
        word_diff = true,
      })
    end
  },
  {
    'sindrets/diffview.nvim',
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
      'DiffviewFileHistory'
    },
    keys = {
      {
        '<Leader>gd',
        vim.cmd.DiffviewOpen,
        desc = 'Git: diff'
      },
      {
        '<Leader>gl',
        vim.cmd.DiffviewFileHistory,
        desc = 'Git: log'
      }
    },
    config = function()
      require('diffview').setup()
    end
  }
}
