local M = {
  'rebelot/heirline.nvim',
  event = 'VeryLazy',
  opts = {}
}

local buftypes = {
  'help',
  'nofile',
  'prompt',
  'quickfix',
  'terminal'
}
local filetypes = {
  '^toggleterm$'
}
local force_inactive_filetypes = {
  '^$',
  '^lazy$',
  '^netrw$',
  '^toggleterm$',
  '^undotree$'
}
local align = { provider = '%=' }
local spacer = { provider = ' ' }

M.format = {
  seps = {
    double_quote = {
      left = '«',
      right = '»'
    },
    bracket = {
      left = '[',
      right = ']'
    },
    half_bracket = {
      left = '⸢',
      right = '⸥'
    },
    double_angle = {
      left = '⟪',
      right = '⟫'
    },
    single_angle = {
      left = '❰',
      right = '❱'
    }
  },
}

function M.load()
  local heirline = require('heirline')
  local conditions = require('heirline.conditions')
  local utils = require('heirline.utils')
  local get_hl = utils.get_highlight

  local statusline = require('plugins.heirline.statusline')
  local statuscolumn = require('plugins.heirline.statuscolumn')
  local tabline = require('plugins.heirline.tabline')

  local function default_colors()
    return {
      fg_statusline = get_hl('StatusLine').fg,
      bg_statusline = get_hl('StatusLine').bg or 'None',
      gray = get_hl('NonText').fg,
      red = get_hl('ErrorMsg').fg,
      green = get_hl('String').fg,
      blue = get_hl('Type').fg,
      orange = get_hl('Constant').fg,
      yellow = get_hl('DiagnosticWarn').fg,
      purple = get_hl('Statement').fg,
      cyan = get_hl('PreProc').fg,
      diag_warn = get_hl('DiagnosticWarn').fg,
      diag_error = get_hl('DiagnosticError').fg,
      diag_hint = get_hl('DiagnosticHint').fg,
      diag_info = get_hl('DiagnosticInfo').fg,
      git_del = get_hl('DiagnosticError').fg,
      git_add = get_hl('DiagnosticInfo').fg,
      git_change = get_hl('DiagnosticHint').fg,
    }
  end
  local function plugin_colors()
    return {
      git_del = get_hl('DiffRemoved').fg,
      git_add = get_hl('DiffAdded').fg,
      git_change = get_hl('DiffChanged').fg,
    }
  end
  heirline.load_colors(default_colors())
  vim.api.nvim_create_augroup('Heirline', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
      local plugin_support, extra_colors = pcall(plugin_colors)
      utils.on_colorscheme(vim.tbl_extend('force', default_colors(), plugin_support and extra_colors or {}))
    end,
    group = 'Heirline',
  })

  heirline.setup({
    statusline = {
      static = {
        buftypes = buftypes,
        filetypes = filetypes,
        force_inactive_filetypes = force_inactive_filetypes,
        mode_colors = {
          n = 'green',
          i = 'red',
          v = 'purple',
          V = 'purple',
          ['\22'] = 'purple',
          c = 'orange',
          s = 'cyan',
          S = 'cyan',
          ['\19'] = 'cyan',
          R = 'orange',
          r = 'orange',
          ['!'] = 'red',
          t = 'green',
        },
        mode_color = function(self)
          local mode = conditions.is_active() and vim.fn.mode() or 'n'
          return self.mode_colors[mode]
        end
      },
      condition = function(self)
        return not conditions.buffer_matches({
          filetype = self.force_inactive_filetypes,
        })
      end,
      statusline.Root,
      statusline.Ruler,
      spacer,
      statusline.ViMode,
      spacer,
      statusline.WorkDir,
      spacer,
      statusline.FileNameBlock,
      spacer,
      statusline.SearchResults,
      align,
      statusline.Sessions,
      spacer,
      statusline.LSPActive,
      spacer,
      statusline.Git,
      spacer,
      statusline.Diagnostics,
      spacer,
      statusline.FileTypeBlock
    },
    statuscolumn = {
      static = {
        buftypes = buftypes,
        filetypes = filetypes,
        force_inactive_filetypes = force_inactive_filetypes
      },
      condition = function(self)
        return not conditions.buffer_matches({
          buftype = self.buftypes,
          filetype = self.force_inactive_filetypes,
        })
      end,
      statuscolumn
    },
    tabline = tabline
  })
end

vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])

function M.config() M.load() end
return M
