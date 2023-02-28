return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'RRethy/nvim-treesitter-textsubjects',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      'windwp/nvim-ts-autotag',
      'JoosepAlviste/nvim-ts-context-commentstring'
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        auto_install = true,
        autotag = {
          enable = true
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false
        },
        highlight = {
          enable = true
        },
        incremental_selection = {
          enable = false
        },
        indent = {
          enable = false
        },
        refactor = {
          highlight_current_scope = {
            enable = false
          },
          highlight_definitions = {
            enable = true
          },
          navigation = {
            enable = true
          },
          smart_rename = {
            enable = true
          }
        },
        textobjects = {
          lookahead = true,
          lsp_interop = {
            enable = true,
            floating_preview_opts = {
              border = require('config.ui').borders
            },
            peek_definition_code = {
              ['df'] = '@function.outer',
              ['dF'] = '@class.outer'
            }
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['aa'] = '@attribute.outer',
              ['ia'] = '@attribute.inner',
              ['ab'] = '@block.outer',
              ['ib'] = '@block.inner',
              ['at'] = '@call.outer',
              ['it'] = '@call.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['a/'] = '@comment.outer',
              ['i/'] = '@comment.inner',
              ['ai'] = '@conditional.outer',
              ['ii'] = '@conditional.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
              ['ap'] = '@parameter.outer',
              ['ip'] = '@parameter.inner',
              ['is'] = '@scopename.inner',
              ['as'] = '@statement.outer'
            },
            include_surrounding_whitespace = true
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ['gna'] = '@attribute.outer',
              ['gnia'] = '@attribute.inner',
              ['gnb'] = '@block.outer',
              ['gnib'] = '@block.inner',
              ['gnt'] = '@call.outer',
              ['gnit'] = '@call.inner',
              ['gnc'] = '@class.outer',
              ['gnic'] = '@class.inner',
              ['gn/'] = '@comment.outer',
              ['gnf'] = '@function.outer',
              ['gnif'] = '@function.inner',
              ['gnl'] = '@loop.outer',
              ['gnil'] = '@loop.inner',
              ['gnp'] = '@parameter.outer',
              ['gnip'] = '@parameter.inner',
              ['gnis'] = '@scopename.inner'
            },
            goto_next_end = {
              ['gnA'] = '@attribute.outer',
              ['gniA'] = '@attribute.inner',
              ['gnB'] = '@block.outer',
              ['gniB'] = '@block.inner',
              ['gnT'] = '@call.outer',
              ['gniT'] = '@call.inner',
              ['gnC'] = '@class.outer',
              ['gniC'] = '@class.inner',
              ['gnF'] = '@function.outer',
              ['gniF'] = '@function.inner',
              ['gnL'] = '@loop.outer',
              ['gniL'] = '@loop.inner',
              ['gnP'] = '@parameter.outer',
              ['gniP'] = '@parameter.inner',
              ['gniS'] = '@scopename.inner'
            },
            goto_previous_start = {
              ['gpa'] = '@attribute.outer',
              ['gpia'] = '@attribute.inner',
              ['gpb'] = '@block.outer',
              ['gpib'] = '@block.inner',
              ['gpt'] = '@call.outer',
              ['gpit'] = '@call.inner',
              ['gpc'] = '@class.outer',
              ['gpic'] = '@class.inner',
              ['gp/'] = '@comment.outer',
              ['gpf'] = '@function.outer',
              ['gpif'] = '@function.inner',
              ['gpl'] = '@loop.outer',
              ['gpil'] = '@loop.inner',
              ['gpp'] = '@parameter.outer',
              ['gpip'] = '@parameter.inner',
              ['gpis'] = '@scopename.inner'
            },
            goto_previous_end = {
              ['gpA'] = '@attribute.outer',
              ['gpiA'] = '@attribute.inner',
              ['gpB'] = '@block.outer',
              ['gpiB'] = '@block.inner',
              ['gpT'] = '@call.outer',
              ['gpiT'] = '@call.inner',
              ['gpC'] = '@class.outer',
              ['gpiC'] = '@class.inner',
              ['gpF'] = '@function.outer',
              ['gpiF'] = '@function.inner',
              ['gpL'] = '@loop.outer',
              ['gpiL'] = '@loop.inner',
              ['gpP'] = '@parameter.outer',
              ['gpiP'] = '@parameter.inner',
              ['gpiS'] = '@scopename.inner'
            }
          }
        },
        textsubjects = {
          enable = true,
          prev_selection = ',',
          keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = 'textsubjects-container-inner',
          }
        }
      })
    end
  }
}
-- vim: foldmethod=marker foldlevel=1
