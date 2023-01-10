local wez = require('wezterm')
local act = wez.action
local mux = wez.mux
local gpus = wez.gui.enumerate_gpus()
local hostname = wez.hostname()
local my_font
if hostname == 'tj' then
  my_font = 'iosevka'
else
  my_font = 'iosevka'
end
-- local selected_scheme = 'wilmersdorf'
-- local selected_scheme = 'terafox'
-- local selected_scheme = 'nightfox'
-- local selected_scheme = 'Atelier Cave (base16)'
-- local selected_scheme = 'Atelier Cave Light (base16)'
-- local selected_scheme = 'Atelier Lakeside Light (base16)'
-- local selected_scheme = 'seoulbones_dark'
-- local selected_scheme = 'seoulbones_light'
-- local selected_scheme = 'base16-tokyo-city-terminal-light'
-- local selected_scheme = 'base16-tokyo-city-terminal-dark'
local selected_scheme = 'Atelier Cave Light (base16)'

local function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

-- {{{1 Colour configuration
-- see https://github.com/wez/wezterm/issues/2376#issuecomment-1208816450
local scheme
if string.match(selected_scheme, '^base16') then
  scheme = wez.color.load_base16_scheme(os.getenv('XDG_CONFIG_HOME') .. '/wezterm/colors/' .. selected_scheme .. '.yaml')
else
  scheme = wez.get_builtin_color_schemes()[selected_scheme]
end
local C_FG = scheme.foreground
local C_BG = scheme.background
local C_BLACK = scheme.ansi[1]
local C_RED = scheme.ansi[2]
local C_GREEN = scheme.ansi[3]
local C_YELLOW = scheme.ansi[4]
local C_BLUE = scheme.ansi[5]
local C_MAGENTA = scheme.ansi[6]
local C_CYAN = scheme.ansi[7]
local C_WHITE = scheme.ansi[8]
local C_BRIGHT_BLACK = scheme.ansi[9]
local C_BRIGHT_RED = scheme.ansi[10]
local C_BRIGHT_GREEN = scheme.ansi[11]
local C_BRIGHT_YELLOW = scheme.ansi[12]
local C_BRIGHT_BLUE = scheme.ansi[13]
local C_BRIGHT_MAGENTA = scheme.ansi[14]
local C_BRIGHT_CYAN = scheme.ansi[15]
local C_BRIGHT_WHITE = scheme.ansi[16]
local fg = wez.color.parse(scheme.foreground)
local bg = wez.color.parse(scheme.background)
local h, s, l, a = fg:hsla()
if l > 0.5 then
  if selected_scheme == 'seoulbones_dark' then
    C_BG = bg:darken(0.6)
  end
  C_FG = fg:lighten(1.0)
  scheme.selection_bg = 'rgba(88% 88% 88% 30%)'
else
  C_FG = fg:darken(1.0)
  C_BG = bg:darken(0.1)
  scheme.selection_bg = 'rgba(70% 70% 70% 40%)'
end
scheme.foreground = C_FG
scheme.background = C_BG
scheme.selection_fg = 'none'
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
-- 1}}}

-- {{{1 Font configuration
-- {{{2 font_fallback
local function font_fallback(name)
  local names = { name, 'nonicons', 'JoyPixels', 'Iosevka Artesanal' }
  return wez.font_with_fallback(names)
end
-- 2}}}
-- {{{2 font_set
local function font_set(name)
  local font
  if string.match(name, 'custom') then
    font = font_fallback({ family = 'Codelia Ligatures' })
  elseif string.match(name, 'fantasque') then
    font = font_fallback({ family = 'Fantasque Sans Mono', weight = 'Regular' })
  elseif string.match(name, 'iosevka') then
    font = font_fallback({ family = 'Iosevka Artesanal', harfbuzz_features = { 'calt=1', 'ccmp=1', 'dlig=1', 'onum=1' } })
  elseif string.match(name, 'mona') then
    font = font_fallback({ family = 'MonoLisa', weight = 'Book', harfbuzz_features = { 'case=1', 'liga=1', 'dlig=1', 'onum=1' } })
  elseif string.match(name, 'operator') then
    font = font_fallback({ family = 'Operator Mono', weight = 'Light' })
  elseif string.match(name, 'plex') then
    font = font_fallback({ family = 'IBM Plex Mono Text', harfbuzz_features = { 'zero' } })
  elseif string.match(name, 'pt') then
    font = font_fallback({ family = 'PT Mono', weight = 'Regular' })
  elseif string.match(name, 'recursive') then
    font = font_fallback({ family = 'Rec Mono Casual', weight = 'Regular' })
  end
  return font
end
-- 2}}}
-- {{{2 font_rules
local function font_rules(name)
  local rules = {}
  if string.match(name, 'custom')
      or string.match(name, 'fantasque')
      or string.match(name, 'mona')
      or string.match(name, 'recursive')
  then
    rules = nil
  elseif string.match(name, 'iosevka') then
    rules = {
      {
        intensity = 'Bold',
        italic = false,
        font = font_fallback({ family = 'Iosevka Artesanal', weight = 'Bold' }),
      },
      {
        intensity = 'Normal',
        italic = true,
        -- font = font_fallback({ family = 'Iosevka Artesanal', weight = 'Book', style = 'Italic' })
        -- font = font_fallback({ family = 'IBM Plex Mono Text', style = 'Italic', harfbuzz_features = { 'zero' } })
        font = font_fallback({ family = 'Operator Mono', weight = 'Book', style = 'Italic' })
      },
      {
        intensity = 'Bold',
        italic = true,
        -- font = font_fallback({ family = 'Iosevka Artesanal', weight = 'Bold', style = 'Italic' })
        -- font = font_fallback({ family = 'IBM Plex Mono SmBld', style = 'Italic', harfbuzz_features = { 'zero' } })
        font = font_fallback({ family = 'Operator Mono', weight = 'Medium', style = 'Italic' })
      },
    }
  elseif string.match(name, 'operator') then
    rules = {
      {
        intensity = 'Bold',
        italic = false,
        font = font_fallback({ family = 'Operator Mono', weight = 'Book' })
      },
      {
        intensity = 'Normal',
        italic = true,
        font = font_fallback({ family = 'Operator Mono', weight = 'Light', style = 'Italic' })
      },
      {
        intensity = 'Bold',
        italic = true,
        font = font_fallback({ family = 'Operator Mono', weight = 'Book', style = 'Italic' })
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
  elseif string.match(name, 'pt') then
    rules = {
      {
        intensity = 'Normal',
        italic = true,
        -- font = font_fallback({ family = 'IBM Plex Mono Text', style = 'Italic', harfbuzz_features = { 'zero' } })
        font = font_fallback({ family = 'Codelia Ligatures Medium', style = 'Italic' })
      },
      {
        intensity = 'Bold',
        italic = true,
        -- font = font_fallback({ family = 'IBM Plex Mono SmBld', style = 'Italic', harfbuzz_features = { 'zero' } })
        font = font_fallback({ family = 'Codelia Ligatures Bold', style = 'Italic' })
      },
    }
  end
  return rules
end
-- 2}}}
-- {{{2 font_size
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
      size = 10.5
    elseif string.match(name, 'mona') then
      size = 9.6
    elseif string.match(name, 'plex') then
      size = 10.6
    elseif string.match(name, 'pt') then
      size = 10.0
    elseif string.match(name, 'recursive') then
      size = 9.9
    end
  elseif hostname == 'komala' then
    if string.match(name, 'custom') then
      size = 10.0
    elseif string.match(name, 'fantasque') then
      size = 11.4
    elseif string.match(name, 'iosevka') then
      size = 11.0
    elseif string.match(name, 'operator') then
      size = 11.0
    elseif string.match(name, 'mona') then
      size = 9.5
    elseif string.match(name, 'plex') then
      size = 10.6
    elseif string.match(name, 'pt') then
      size = 10.0
    elseif string.match(name, 'recursive') then
      size = 9.9
    end
  elseif hostname == 'tj' then
    if string.match(name, 'custom') then
      size = 10.0
    elseif string.match(name, 'fantasque') then
      size = 11.4
    elseif string.match(name, 'iosevka') then
      size = 11.0
    elseif string.match(name, 'mona') then
      size = 9.0
    elseif string.match(name, 'operator') then
      size = 10.0
    elseif string.match(name, 'plex') then
      size = 10.4
    elseif string.match(name, 'pt') then
      size = 9.5
    elseif string.match(name, 'recursive') then
      size = 9.8
    end
  end
  return size
end
-- 2}}}
-- {{{2 set_geometry
local function set_geometry(x)
  local value = 0
  if x == 'cols' then
    value = 160
  elseif x == 'rows' then
    if hostname == 'swimmer' then
      if (my_font == 'iosevka' or my_font == 'pt') then
        value = 64
      elseif (my_font == 'custom' or my_font == 'operator') then
        value = 55
      elseif (my_font == 'recursive' or my_font == 'fantasque' or my_font == 'mona') then
        value = 62
      elseif (my_font == 'plex') then
        value = 53
      end
    elseif hostname == 'komala' then
      if (my_font == 'iosevka' or my_font == 'pt') then
        value = 64
      elseif (my_font == 'custom' or my_font == 'operator') then
        value = 55
      elseif (my_font == 'recursive' or my_font == 'fantasque' or my_font == 'mona') then
        value = 62
      elseif (my_font == 'plex') then
        value = 53
      end
    elseif hostname == 'tj' then
      if (my_font == 'iosevka' or my_font == 'mona') then
        value = 50
      elseif (my_font == 'recursive' or my_font == 'pt') then
        value = 51
      elseif (my_font == 'custom') then
        value = 41
      elseif (my_font == 'operator' or my_font == 'fantasque' or my_font == 'plex') then
        value = 42
      end
    end
  end
  return value
end
-- 2}}}
-- 1}}}

local function update_ssh_status(window, pane)
  local text = pane:get_domain_name()
  if text == 'local' then
    text = hostname
  end
  return text
end

wez.on('format-tab-title', function(tab)
  local tab_prefix = tab.tab_index == 0 and '  ' or ' '
  local tab_index = tab.tab_index
  local pane = tab.active_pane
  -- local tab_title = tab_index .. ' ' .. tab.active_pane.title
  local tab_title = tab_index .. ' ' .. basename(pane.foreground_process_name)
  if pane.domain_name and not pane.domain_name == 'local' then
    tab_title = pane.domain_name .. ':' .. tab_title
  end
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

wez.on('update-right-status', function(window, pane)
  local host = update_ssh_status(window, pane)
  local date = wez.strftime('[%H:%M] %a %b %d %Y  ')
  local bat = ''
  for _, b in ipairs(wez.battery_info()) do
    bat = string.format('[BAT] %.0f%% ', b.state_of_charge * 100)
  end
  local keytable = window:active_key_table()
  if keytable then
    keytable = 'TABLE: ' .. keytable
  end
  window:set_right_status(wez.format({
    { Attribute = { Intensity = 'Bold' } },
    { Foreground = { AnsiColor = 'Green' } },
    { Text = '• ' .. host .. ': ' .. hostname .. ' •' .. ' ' },
    { Foreground = { AnsiColor = 'Blue' } },
    { Text = keytable or '' },
    { Foreground = { AnsiColor = 'Yellow' } },
    { Text = bat },
    { Foreground = 'Default' },
    { Text = date },
  }))
end)

-- wez.on('gui-startup', function(cmd)
--     local tab, top_pane, window = mux.spawn_window(cmd or {})
--     local bottom_pane = top_pane:split { direction = 'Bottom' }
--     top_pane:split { direction = 'Right'}
--     bottom_pane:split { direction = 'Right'}
-- end)

return {
  color_schemes = {
    [selected_scheme] = scheme
  },
  color_scheme = selected_scheme,
  force_reverse_video_cursor = true,
  webgpu_preferred_adapter = gpus[1],
  front_end = 'WebGpu',

  -- Fonts
  font = font_set(my_font),
  font_rules = font_rules(my_font),
  font_size = font_size(my_font),
  char_select_font_size = font_size(my_font),
  warn_about_missing_glyphs = false,
  underline_position = '-1.4pt',
  underline_thickness = '200%',
  unicode_version = 15,

  -- Behaviour
  term = 'wezterm',
  check_for_updates = false,
  adjust_window_size_when_changing_font_size = false,
  window_background_opacity = 0.6,
  window_padding = {
    left = '3cell',
    right = '3cell',
    top = '1cell',
    bottom = '1cell',
  },
  initial_cols = set_geometry('cols'),
  initial_rows = set_geometry('rows'),
  enable_kitty_graphics = true,
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
    { key = 'c', mods = 'LEADER', action = act.ActivateCommandPalette },
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
        action = wez.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          wez.log_info('opening: ' .. url)
          wez.open_with(url)
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
-- vim: foldmethod=marker foldlevel=0
