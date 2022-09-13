local wezterm = require('wezterm')
local act = wezterm.action
local hostname = wezterm.hostname()
local my_font = 'iosevka'
-- local selected_scheme = 'wilmersdorf' -- dark
-- local selected_scheme = 'iceberg-light' -- light
local selected_scheme = 'seoulbones_light'

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

-- Colour configuration
-- see https://github.com/wez/wezterm/issues/2376#issuecomment-1208816450
local scheme = wezterm.get_builtin_color_schemes()[selected_scheme]
local C_FG = scheme.foreground
local C_BG = scheme.background
---@diagnostic disable-next-line: unused-local
local C_BLACK = scheme.ansi[1]
---@diagnostic disable-next-line: unused-local
local C_RED = scheme.ansi[2]
---@diagnostic disable-next-line: unused-local
local C_GREEN = scheme.ansi[3]
---@diagnostic disable-next-line: unused-local
local C_YELLOW = scheme.ansi[4]
---@diagnostic disable-next-line: unused-local
local C_BLUE = scheme.ansi[5]
---@diagnostic disable-next-line: unused-local
local C_MAGENTA = scheme.ansi[6]
---@diagnostic disable-next-line: unused-local
local C_CYAN = scheme.ansi[7]
---@diagnostic disable-next-line: unused-local
local C_WHITE = scheme.ansi[8]
---@diagnostic disable-next-line: unused-local
local C_BRIGHT_BLACK = scheme.ansi[9]
---@diagnostic disable-next-line: unused-local
local C_BRIGHT_RED = scheme.ansi[10]
---@diagnostic disable-next-line: unused-local
local C_BRIGHT_GREEN = scheme.ansi[11]
---@diagnostic disable-next-line: unused-local
local C_BRIGHT_YELLOW = scheme.ansi[12]
---@diagnostic disable-next-line: unused-local
local C_BRIGHT_BLUE = scheme.ansi[13]
---@diagnostic disable-next-line: unused-local
local C_BRIGHT_MAGENTA = scheme.ansi[14]
---@diagnostic disable-next-line: unused-local
local C_BRIGHT_CYAN = scheme.ansi[15]
---@diagnostic disable-next-line: unused-local
local C_BRIGHT_WHITE = scheme.ansi[16]
local fg = wezterm.color.parse(scheme.foreground)
local bg = wezterm.color.parse(scheme.background)
---@diagnostic disable-next-line: unused-local
local h, s, l, a = fg:hsla()
if l > 0.5 then
  C_FG = fg:complement_ryb():lighten(0.4)
  C_BG = bg:darken(0.2)
else
  C_FG = fg:complement_ryb():darken(0.8)
  C_BG = bg:lighten(0.6)
end
scheme.foreground = C_FG
scheme.background = C_BG
scheme.tab_bar = {
  background = C_BG,
  active_tab = {
    bg_color = C_BG,
    fg_color = C_FG,
    intensity = 'Bold'
  },
  inactive_tab = {
    bg_color = C_BG,
    fg_color = C_FG,
    intensity = 'Half'
  },
  inactive_tab_hover = {
    bg_color = C_BG,
    fg_color = C_FG,
    intensity = 'Half'
  },
  new_tab = {
    bg_color = C_BG,
    fg_color = C_FG,
  },
  new_tab_hover = {
    bg_color = C_BG,
    fg_color = C_FG,
    italic = true
  }
}
scheme.scrollbar_thumb = C_BLUE
scheme.split = C_BLUE
scheme.compose_cursor = C_BRIGHT_GREEN
scheme.visual_bell = C_BRIGHT_RED

-- Font configuration
local function font_fallback(name)
  local names = { name, 'nonicons', 'JoyPixels', 'OpenMoji',
    { family = 'Iosevka Artesanal', weight = 'Book', scale = 1.1 } }
  return wezterm.font_with_fallback(names)
end

local function font_set(name)
  local font
  if string.match(name, 'custom') then
    font = font_fallback({ family = 'Rec Mono Custom' })
  elseif string.match(name, 'fantasque') then
    font = font_fallback({ family = 'Fantasque Sans Mono', weight = 'Regular' })
  elseif string.match(name, 'iosevka') then
    font = font_fallback({ family = 'Iosevka Artesanal', harfbuzz_features = { 'calt=1', 'ccmp=1', 'dlig=1', 'onum=1' } })
  elseif string.match(name, 'operator') then
    font = font_fallback({ family = 'Operator Mono', weight = 'Book' })
  elseif string.match(name, 'plex') then
    font = font_fallback({ family = 'IBM Plex Mono Text', harfbuzz_features = { 'zero' } })
  elseif string.match(name, 'recursive') then
    font = font_fallback({ family = 'Rec Mono Casual', weight = 'Regular' })
  end
  return font
end

local function font_rules(name)
  local rules = {}
  if string.match(name, 'custom') then
    rules = nil
  elseif string.match(name, 'fantasque') then
    rules = {
      {
        intensity = 'Bold',
        italic = false,
        font = font_fallback({ family = 'Fantasque Sans Mono', weight = 'Bold' })
      },
      {
        intensity = 'Normal',
        italic = true,
        font = font_fallback({ family = 'Fantasque Sans Mono', weight = 'Regular', style = 'Italic' })
      },
      {
        intensity = 'Bold',
        italic = true,
        font = font_fallback({ family = 'Fantasque Sans Mono', weight = 'Bold', style = 'Italic' })
      },
    }
  elseif string.match(name, 'iosevka') then
    rules = {
      {
        intensity = 'Bold',
        italic = false,
        font = font_fallback({ family = 'Iosevka Artesanal', weight = 'Bold',
          harfbuzz_features = { 'calt=1', 'ccmp=1', 'dlig=1', 'onum=1' } }),
      },
      {
        intensity = 'Normal',
        italic = true,
        font = font_fallback({ family = 'Iosevka Artesanal Book', style = 'Italic' })
      },
      {
        intensity = 'Bold',
        italic = true,
        font = font_fallback({ family = 'Iosevka Artesanal', weight = 'Bold', style = 'Italic' })
      },
    }
  elseif string.match(name, 'operator') then
    rules = {
      {
        intensity = 'Bold',
        italic = false,
        font = font_fallback({ family = 'Operator Mono', weight = 'Medium' })
      },
      {
        intensity = 'Normal',
        italic = true,
        font = font_fallback({ family = 'Operator Mono', weight = 'Book', style = 'Italic' })
      },
      {
        intensity = 'Bold',
        italic = true,
        font = font_fallback({ family = 'Operator Mono', weight = 'Medium', style = 'Italic' })
      },
    }
  elseif string.match(name, 'plex') then
    rules = {
      {
        intensity = 'Bold',
        italic = false,
        font = font_fallback({ family = 'IBM Plex Mono SmBld', harfbuzz_features = { 'zero' } })
      },
      {
        intensity = 'Normal',
        italic = true,
        font = font_fallback({ family = 'IBM Plex Mono Text', style = 'Italic', harfbuzz_features = { 'zero' } })
      },
      {
        intensity = 'Bold',
        italic = true,
        font = font_fallback({ family = 'IBM Plex Mono SmBld', style = 'Italic', harfbuzz_features = { 'zero' } })
      },
    }
  elseif string.match(name, 'recursive') then
    rules = {
      {
        intensity = 'Bold',
        italic = false,
        font = font_fallback({ family = 'Rec Mono Casual', weight = 'Bold' })
      },
      {
        intensity = 'Normal',
        italic = true,
        font = font_fallback({ family = 'Rec Mono Casual', weight = 'Regular', style = 'Italic' })
      },
      {
        intensity = 'Bold',
        italic = true,
        font = font_fallback({ family = 'Rec Mono Casual', weight = 'Bold', style = 'Italic' })
      },
    }
  end
  return rules
end

local function font_size(name)
  local size
  if hostname == 'swimmer' then
    if string.match(name, 'custom') then
      size = 10.0
    elseif string.match(name, 'fantasque') then
      size = 11.4
    elseif string.match(name, 'iosevka') then
      size = 11.0
    elseif string.match(name, 'operator') then
      size = 11.0
    elseif string.match(name, 'plex') then
      size = 10.6
    elseif string.match(name, 'recursive') then
      size = 9.9
    end
  elseif hostname == 'tj' then
    if string.match(name, 'custom') then
      size = 10.0
    elseif string.match(name, 'fantasque') then
      size = 11.0
    elseif string.match(name, 'iosevka') then
      size = 10.4
    elseif string.match(name, 'operator') then
      size = 11.0
    elseif string.match(name, 'plex') then
      size = 10.4
    elseif string.match(name, 'recursive') then
      size = 9.4
    end
  end
  return size
end

local function set_geometry(x)
  local value = 0
  if x == 'cols' then
    value = 160
  elseif x == 'rows' then
    if hostname == 'swimmer' then
      if my_font == 'recursive' then
        value = 62
      elseif my_font == 'iosevka' then
        value = 64
      end
    elseif hostname == 'tj' then
      if my_font == 'recursive' then
        value = 51
      elseif my_font == 'iosevka' then
        value = 50
      end
    end
  end
  return value
end

---@diagnostic disable-next-line: unused-local
local function update_ssh_status(window, pane)
  local text = pane:get_domain_name()
  if text == "local" then
    text = hostname
  end
  return text
end

wezterm.on('format-tab-title', function(tab)
  local tab_prefix = tab.tab_index == 0 and "  " or " "
  local tab_index = tab.tab_index
  local pane = tab.active_pane
  -- local tab_title = tab_index .. ' ' .. tab.active_pane.title
  local tab_title = tab_index .. ' ' .. basename(pane.foreground_process_name)
  if tab.is_active then
    return {
      { Text = tab_prefix },
      { Text = pane.is_zoomed and '⸢' .. tab_title .. '  ' .. '⸥' or '⸢' .. tab_title .. '⸥' }
    }
  end
  return {
    { Text = tab_prefix },
    { Text = pane.is_zoomed and tab_title .. '  ' or tab_title }
  }
end)

wezterm.on('update-right-status', function(window, pane)
  local host = update_ssh_status(window, pane)
  local host_name = wezterm.hostname()
  local date = wezterm.strftime('[%H:%M] %a %b %d %Y  ')
  local bat = ''
  for _, b in ipairs(wezterm.battery_info()) do
    bat = string.format('[BAT] %.0f%% ', b.state_of_charge * 100)
  end
  window:set_right_status(wezterm.format({
    { Attribute = { Intensity = 'Bold' } },
    { Foreground = { AnsiColor = 'Green' } },
    { Text = '• ' .. host .. ': ' .. host_name .. ' •' .. ' ' },
    { Foreground = { AnsiColor = 'Yellow' } },
    { Text = bat },
    { Foreground = 'Default' },
    { Text = date },
  }))
end)

return {
  color_schemes = {
    [selected_scheme] = scheme
  },
  color_scheme = selected_scheme,
  force_reverse_video_cursor = true,

  -- Fonts
  font = font_set(my_font),
  font_rules = font_rules(my_font),
  font_size = font_size(my_font),
  char_select_font_size = font_size(my_font),
  freetype_load_target = 'Light',
  allow_square_glyphs_to_overflow_width = 'WhenFollowedBySpace',
  custom_block_glyphs = true,
  warn_about_missing_glyphs = false,
  underline_position = '-1.4pt',
  underline_thickness = '1.4pt',

  -- Behaviour
  term = 'wezterm',
  check_for_updates = false,
  adjust_window_size_when_changing_font_size = false,
  window_background_opacity = 0.7,
  window_padding = {
    left = '3cell',
    right = '3cell',
    top = '1cell',
    bottom = '1cell',
  },
  initial_cols = set_geometry('cols'),
  initial_rows = set_geometry('rows'),
  enable_kitty_graphics = true,
  enable_kitty_keyboard = true,
  selection_word_boundary = ' \t\n{}"\'`,;@│*',
  clean_exit_codes = { 127, 130, 255 },

  -- Tabs
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  tab_max_width = 44,
  show_tab_index_in_tab_bar = true,

  -- Panes
  pane_focus_follows_mouse = true,
  swallow_mouse_click_on_pane_focus = true,
  swallow_mouse_click_on_window_focus = true,
  inactive_pane_hsb = {
    saturation = 0.7,
    brightness = 1.0,
  },

  -- Hyperlinks
  hyperlink_rules = {
    {
      regex = '\\b\\w+://(?:[\\w.-]+)\\.[a-z0-9]{2,15}\\S*\\b',
      format = '$0',
    },
  },

  -- Key bindings
  disable_default_key_bindings = true,
  use_ime = false,
  debug_key_events = false,
  leader = { key = 'q', mods = 'CTRL' },
  keys = {
    { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
    { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
    { key = '0', mods = 'CTRL', action = act.ResetFontSize },
    { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
    { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
    { key = 'Z', mods = 'CTRL|SHIFT', action = act.CharSelect },
    { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },
    { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },
    { key = 'd', mods = 'LEADER', action = act.ShowDebugOverlay },
    { key = 'l', mods = 'LEADER', action = act.ShowLauncher },
    { key = 'Space', mods = 'LEADER', action = act.QuickSelect },
    { key = 'f', mods = 'LEADER', action = act.Search{ CaseSensitiveString = '' } },
    { key = 'x', mods = 'LEADER', action = act.ActivateCopyMode },
    { key = 'e', mods = 'LEADER',
      action = act.QuickSelectArgs{
        label = 'open url',
        patterns = {
          'https?://\\S+'
        },
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          wezterm.log_info('opening: ' .. url)
          wezterm.open_with(url)
        end)
      }
    },
    { key = 't', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'w', mods = 'LEADER', action = act.CloseCurrentPane{ confirm = true } },
    { key = 'w', mods = 'LEADER|SHIFT', action = act.CloseCurrentTab{ confirm = true } },
    { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal{ domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'LEADER', action = act.SplitVertical{ domain = 'CurrentPaneDomain' } },
    { key = 'P', mods = 'LEADER', action = act.PaneSelect },
    { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
    { key = '0', mods = 'LEADER', action = act.ActivateTab(0) },
    { key = '1', mods = 'LEADER', action = act.ActivateTab(1) },
    { key = '2', mods = 'LEADER', action = act.ActivateTab(2) },
    { key = '3', mods = 'LEADER', action = act.ActivateTab(3) },
    { key = '4', mods = 'LEADER', action = act.ActivateTab(4) },
    { key = '5', mods = 'LEADER', action = act.ActivateTab(5) },
    { key = '6', mods = 'LEADER', action = act.ActivateTab(6) },
    { key = '7', mods = 'LEADER', action = act.ActivateTab(7) },
    { key = '8', mods = 'LEADER', action = act.ActivateTab(8) },
    { key = '9', mods = 'LEADER', action = act.ActivateTab(9) },
    { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
    { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
    { key = 'o', mods = 'LEADER', action = act.ActivateLastTab },
    { key = 'LeftArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
    { key = 'LeftArrow', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize{ 'Left', 4 } },
    { key = 'RightArrow', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize{ 'Right', 4 } },
    { key = 'UpArrow', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize{ 'Up', 4 } },
    { key = 'DownArrow', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize{ 'Down', 4 } },
  },
}