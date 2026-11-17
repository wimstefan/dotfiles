vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.nvim' }
})

require('mini.ai').setup({
  mappings = {
    around_last = 'aL',
    inside_last = 'iL',
  }
})
require('mini.align').setup()
require('mini.clue').setup({
  clues = {
    require('mini.clue').gen_clues.builtin_completion(),
    require('mini.clue').gen_clues.g(),
    require('mini.clue').gen_clues.marks(),
    require('mini.clue').gen_clues.registers(),
    require('mini.clue').gen_clues.square_brackets(),
    require('mini.clue').gen_clues.windows({ submode_resize = true }),
    require('mini.clue').gen_clues.z()
  },
  triggers = {
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    { mode = { 'n', 'x' }, keys = '<LocalLeader>' },
    { mode = 'n', keys = '\\' },
    { mode = { 'n', 'x' }, keys = '[' },
    { mode = { 'n', 'x' }, keys = ']' },
    { mode = 'i', keys = '<C-x>' },
    { mode = { 'n', 'x' }, keys = 'g' },
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' },
    { mode = { 'n', 'x' }, keys = 's' },
    { mode = { 'n', 'x' }, keys = 'z' }
  },
  window = {
    delay = 100
  }
})
require('mini.files').setup({
  windows = {
    preview = true,
    width_preview = 75
  }
})
require('mini.icons').setup()
require('mini.icons').mock_nvim_web_devicons()
require('mini.icons').tweak_lsp_kind()
require('mini.indentscope').setup({
  draw = {
    delay = 1
  },
  symbol = '┊'
})
require('mini.jump').setup()
require('mini.jump2d').setup({
  view = {
    dim = true
  }
})
require('mini.notify').setup({
  content = {
    sort = function(notif_arr)
      table.sort(
        notif_arr,
        function(a, b) return a.ts_update > b.ts_update end
      )
      return notif_arr
    end
  },
  window = {
    max_width_share = 0.882
  }
})
require('mini.pick').setup({
  window = {
    prompt_prefix =  ' ' .. require('config.ui').icons.diagnostics[4] .. ' '
  }
})
require('mini.extra').setup()
require('mini.sessions').setup({
  directory = vim.fn.stdpath('state') .. '/sessions/',
  force = {
    delete = true
  }
})
require('mini.starter').setup({
  evaluate_single = true
})
require('mini.surround').setup()

vim.keymap.set('n', '<Leader>b', function() MiniPick.builtin.buffers() end, { desc = 'Mini: buffers' })
vim.keymap.set('n', '<Leader>c', function() MiniExtra.pickers.colorschemes() end, { desc = 'Mini: colorschemes' })
vim.keymap.set('n', '<Leader>e', function()
  local minifiles_toggle = function(...)
    if MiniFiles.close() == nil then MiniFiles.open(...) end
  end
  minifiles_toggle()
end, { desc = 'Mini: file explorer' })
vim.keymap.set('n', '<Leader>f', function() MiniPick.builtin.files() end, { desc = 'Mini: files' })
vim.keymap.set('n', '<Leader>o', function() MiniExtra.pickers.oldfiles() end, { desc = 'Mini: recent' })
vim.keymap.set('n', '<Leader>h', function() MiniPick.builtin.help() end, { desc = 'Mini: help' })
vim.keymap.set('n', '<Leader>k', function() MiniExtra.pickers.manpages() end, { desc = 'Mini: man' })
vim.keymap.set('n', '<Leader>r', function() MiniPick.builtin.resume() end, { desc = 'Mini: resume' })
vim.keymap.set('n', '<Leader>?', function() MiniExtra.pickers.buf_lines() end, { desc = 'Mini: grep open buffers' })
vim.keymap.set('n', '<Leader>/', function() MiniPick.builtin.grep_live() end, { desc = 'Mini: grep current directory recursively' })
vim.keymap.set('n', '<Leader>N', function() MiniNotify.show_history() end, { desc = 'Mini: notifications' })

vim.keymap.set('n', '<Leader>mc', function() MiniExtra.pickers.history({ scope = ':' }) end, { desc = 'Mini: command history' })
vim.keymap.set('n', '<Leader>ms', function() MiniExtra.pickers.history({ scope = '/' }) end, { desc = 'Mini: search history' })
vim.keymap.set('n', '<Leader>mgl', function() MiniExtra.pickers.git_commits({ path = vim.fn.expand('%:p') }) end, { desc = 'Mini: git log current buffer' })
vim.keymap.set('n', '<Leader>mgL', function() MiniExtra.pickers.git_commits() end, { desc = 'Mini: git log' })
vim.keymap.set('n', '<Leader>mgd', function() MiniExtra.pickers.git_hunks({ path = vim.fn.expand('%:p') }) end, { desc = 'Mini: git diff current buffer' })
vim.keymap.set('n', '<Leader>mgD', function() MiniExtra.pickers.git_hunks() end, { desc = 'Mini: git diff' })
vim.keymap.set('n', '<Leader>mh', function() MiniExtra.pickers.hl_groups() end, { desc = 'Mini: highlights' })
vim.keymap.set('n', '<Leader>mj', function() MiniExtra.pickers.list({ scope = 'jump' }) end, { desc = 'Mini: jump list' })
vim.keymap.set('n', '<Leader>mk', function() MiniExtra.pickers.keymaps() end, { desc = 'Mini: keymaps' })
vim.keymap.set('n', '<Leader>ml', function() MiniExtra.pickers.list({ scope = 'location' }) end, { desc = 'Mini: location list' })
vim.keymap.set('n', '<Leader>mm', function() MiniExtra.pickers.marks() end, { desc = 'Mini: marks' })
vim.keymap.set('n', '<Leader>mo', function() MiniExtra.pickers.options() end, { desc = 'Mini: options' })
vim.keymap.set('n', '<Leader>mq', function() MiniExtra.pickers.list({ scope = 'quickfix' }) end, { desc = 'Mini: quickfix list' })
vim.keymap.set('n', '<Leader>mr', function() MiniExtra.pickers.registers() end, { desc = 'Mini: registers' })
vim.keymap.set('n', '<Leader>mw', function()
  local cword = vim.fn.expand('<cword>')
  if cword == '' then return end
  MiniPick.builtin.grep({ pattern = cword })
end, { desc = 'Mini: grep word' })

vim.keymap.set('n', '<Leader>pd', function() require('mini.sessions').delete() end, { desc = 'Session: delete' })
vim.keymap.set('n', '<Leader>pr', function() require('mini.sessions').read() end, { desc = 'Session: read' })
vim.keymap.set('n', '<Leader>ps', function() require('mini.sessions').select() end, { desc = 'Session: select' })
vim.keymap.set('n', '<Leader>pw', function() require('mini.sessions').write() end, { desc = 'Session: write' })
