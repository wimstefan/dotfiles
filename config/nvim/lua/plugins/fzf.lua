return {
  {
    'junegunn/fzf',
    build = './install --all --xdg'
  },
  {
    'ibhagwan/fzf-lua',
    keys = {
      { '<Leader>F', function() require('fzf-lua').builtin() end, desc = 'Fzf: builtin' },
      { '<Leader>b', function() require('fzf-lua').buffers() end, desc = 'Fzf: buffers' },
      { '<Leader>c', function() require('fzf-lua').colorschemes() end, desc = 'Fzf: colorschemes' },
      { '<Leader>f', function() require('fzf-lua').files() end, desc = 'Fzf: files' },
      { '<Leader>o', function() require('fzf-lua').oldfiles() end, desc = 'Fzf: oldfiles' },
      { '<Leader>h', function() require('fzf-lua').help_tags() end, desc = 'Fzf: help' },
      { '<Leader>k', function() require('fzf-lua').man_pages() end, desc = 'Fzf: man' },
      { '<Leader>t', function() require('fzf-lua').tabs() end, desc = 'Fzf: tabs' },
      { '<Leader>?', function() require('fzf-lua').lgrep_curbuf() end, desc = 'Fzf: grep current file' },
      { '<Leader>/', function() require('fzf-lua').live_grep_native() end, desc = 'Fzf: grep all files' },
      { '<Leader>fgb', function() require('fzf-lua').git_bcommits() end, desc = 'Fzf: git buffer commits' },
      { '<Leader>fgc', function() require('fzf-lua').git_commits() end, desc = 'Fzf: git commits' },
      { '<Leader>fgf', function() require('fzf-lua').git_files() end, desc = 'Fzf: git files' },
      { '<Leader>fgs', function() require('fzf-lua').git_status() end, desc = 'Fzf: git status' },
      { '<Leader>fc', function() require('fzf-lua').command_history() end, desc = 'Fzf: command history' },
      { '<Leader>fh', function() require('fzf-lua').highlights() end, desc = 'Fzf: highlights' },
      { '<Leader>fk', function() require('fzf-lua').keymaps() end, desc = 'Fzf: keymaps' },
      { '<Leader>fm', function() require('fzf-lua').marks() end, desc = 'Fzf: marks' },
      { '<Leader>fq', function() require('fzf-lua').quickfix() end, desc = 'Fzf: quickfix' },
      { '<Leader>fr', function() require('fzf-lua').registers() end, desc = 'Fzf: registers' },
      { '<Leader>fs', function() require('fzf-lua').spell_suggest() end, desc = 'Fzf: spell suggest' },
      { '<Leader>ft', function() require('fzf-lua').filetypes() end, desc = 'Fzf: filetypes' },
      { '<Leader>fw', function() require('fzf-lua').grep_cword() end, desc = 'Fzf: grep string' }
    },
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
