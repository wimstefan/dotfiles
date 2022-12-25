return {
  {
    'junegunn/fzf',
    build = './install --all --xdg'
  },
  {
    'ibhagwan/fzf-lua',
    init = function()
      vim.keymap.set('n', '<Leader>F', require('fzf-lua').builtin, { desc = 'Fzf: builtin' })
      vim.keymap.set('n', '<Leader>c', require('fzf-lua').colorschemes, { desc = 'Fzf: colorschemes' })
      vim.keymap.set('n', '<Leader>f', require('fzf-lua').files, { desc = 'Fzf: files' })
      vim.keymap.set('n', '<Leader>o', require('fzf-lua').oldfiles, { desc = 'Fzf: oldfiles' })
      vim.keymap.set('n', '<Leader>fg', require('fzf-lua').lgrep_curbuf, { desc = 'Fzf: grep current file' })
      vim.keymap.set('n', '<Leader>fG', require('fzf-lua').live_grep_native, { desc = 'Fzf: grep all files' })
      vim.keymap.set('n', '<Leader>h', require('fzf-lua').help_tags, { desc = 'Fzf: help' })
      vim.keymap.set('n', '<Leader>k', require('fzf-lua').man_pages, { desc = 'Fzf: man' })
      vim.keymap.set('n', '<Leader>fgb', require('fzf-lua').git_bcommits, { desc = 'Fzf: git buffer commits' })
      vim.keymap.set('n', '<Leader>fgc', require('fzf-lua').git_commits, { desc = 'Fzf: git commits' })
      vim.keymap.set('n', '<Leader>fgf', require('fzf-lua').git_files, { desc = 'Fzf: git files' })
      vim.keymap.set('n', '<Leader>fgs', require('fzf-lua').git_status, { desc = 'Fzf: git status' })
      vim.keymap.set('n', '<Leader>fc', require('fzf-lua').command_history, { desc = 'Fzf: command history' })
      vim.keymap.set('n', '<Leader>fk', require('fzf-lua').keymaps, { desc = 'Fzf: keymaps' })
      vim.keymap.set('n', '<Leader>fm', require('fzf-lua').marks, { desc = 'Fzf: marks' })
      vim.keymap.set('n', '<Leader>fq', require('fzf-lua').quickfix, { desc = 'Fzf: quickfix' })
      vim.keymap.set('n', '<Leader>fr', require('fzf-lua').registers, { desc = 'Fzf: registers' })
      vim.keymap.set('n', '<Leader>fs', require('fzf-lua').spell_suggest, { desc = 'Fzf: spell suggest' })
      vim.keymap.set('n', '<Leader>ft', require('fzf-lua').filetypes, { desc = 'Fzf: filetypes' })
      vim.keymap.set('n', '<Leader>fw', require('fzf-lua').grep_cword, { desc = 'Fzf: grep string' })
    end,
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
          prompt = 'Files❯ ',
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
        spell_suggest = {
          winopts = {
            relative = 'cursor',
            width = 0.2,
            row = 1.01
          }
        }
      })
    end
  }
}
