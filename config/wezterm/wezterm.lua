local wez = require('wezterm')
local act = wez.action
local gpus = wez.gui.enumerate_gpus()
local hostname = wez.hostname()
local config = {}
if wez.config_builder then
  config = wez.config_builder()
end

local appearance
local bg_file = io.open(wez.home_dir .. '/.config/colours/background', 'r')
if bg_file then
  appearance = bg_file:read('*a')
  bg_file:close()
else
  appearance = 'dark'
end

local my_font
if hostname == 'tj' then
  my_font = 'monaspace'
else
  my_font = 'monaspace'
end

local function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

wez.on('format-tab-title', function(tab)
  local tab_prefix = tab.tab_index == 0 and '  ' or ' '
  local tab_index = tab.tab_index
  local pane = tab.active_pane
  -- local tab_title = tab_index .. ' ' .. tab.active_pane.title
  local tab_title = tab_index .. ' ' .. basename(pane.foreground_process_name)
  if tab.is_active then
    return {
      { Text = tab_prefix },
      { Text = pane.is_zoomed and '⸢' .. tab_title .. '  ' .. '⸥' or '⸢' .. tab_title .. '⸥' }
    }
  end
  return {
    { Text = tab_prefix },
    { Text = pane.is_zoomed and tab_title .. '  ' or tab_title }
  }
end)

wez.on('update-right-status', function(window, pane)
  local title = pane:get_title()
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
    { Text = '• ' .. title .. ' •' .. ' ' },
    { Foreground = { AnsiColor = 'Blue' } },
    { Text = keytable or '' },
    { Foreground = { AnsiColor = 'Yellow' } },
    { Text = bat },
    { Foreground = 'Default' },
    { Text = date },
  }))
end)

-- {{{1 Colour configuration
-- see https://github.com/wez/wezterm/issues/2376#issuecomment-1208816450
local scheme_pool = {
  catppuccin_frappe = 'catppuccin_frappe',
  catppuccin_latte = 'catppuccin_latte',
  catppuccin_macchiato = 'catppuccin_macchiato',
  catppuccin_mocha = 'catppuccin_mocha',
  atelier_cave_base16 = 'Atelier Cave (base16)',
  atelier_cave_light_base16 = 'Atelier Cave Light (base16)',
  galaxy_dark = 'galaxy_dark',
  galaxy_light = 'galaxy_light',
  cyberdream = 'cyberdream',
  cyberdream_light = 'cyberdream-light',
  github_dark = 'Github Dark',
  github_light = 'Github (base16)',
  seoulbones_dark = 'seoulbones_dark',
  seoulbones_light = 'seoulbones_light',
  base16_tokyo_city_terminal_dark = 'base16-tokyo-city-terminal-dark',
  base16_tokyo_city_terminal_light = 'base16-tokyo-city-terminal-light',
  tokyonight_moon = 'tokyonight_moon',
  tokyonight_night = 'tokyonight_night',
  tokyonight_storm = 'tokyonight_storm',
  tokyonight_day = 'tokyonight_day',
  my_rose_pine = 'my_rose_pine',
  my_rose_pine_moon = 'my_rose_pine_moon',
  my_rose_pine_dawn = 'my_rose_pine_dawn'
}
local selected_scheme = scheme_pool.cyberdream
local colour_dir = os.getenv('XDG_CONFIG_HOME') .. '/wezterm/colours/'
local opacity
local scheme
if string.match(selected_scheme, '^base16') then
  scheme = wez.color.load_base16_scheme(colour_dir .. selected_scheme .. '.yaml')
elseif string.match(selected_scheme, '^catppuccin_') or string.match(selected_scheme, '^tokyonight_') or string.match(selected_scheme, '^galaxy_') then
  scheme = wez.color.load_scheme(colour_dir .. selected_scheme .. '.toml')
elseif string.match(selected_scheme, '^cyberdream') then
  scheme = require('colours/' .. selected_scheme)
elseif string.match(selected_scheme, 'my_rose_pine$') then
  scheme = require('colours/rose_pine').colors()
elseif string.match(selected_scheme, 'my_rose_pine_moon$') then
  scheme = require('colours/rose_pine_moon').colors()
elseif string.match(selected_scheme, 'my_rose_pine_dawn$') then
  scheme = require('colours/rose_pine_dawn').colors()
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
    C_BG = bg:darken(0.4)
  end
  scheme.selection_bg = 'rgba(88% 88% 88% 30%)'
  opacity = 0
else
  C_FG = fg:darken(0.8)
  scheme.selection_bg = 'rgba(44% 44% 44% 40%)'
  opacity = 0
end
scheme.foreground = C_FG
scheme.background = C_BG
scheme.selection_fg = 'none'
scheme.tab_bar = {
  background = C_BG,
  active_tab = {
    bg_color = 'none',
    fg_color = C_FG,
    intensity = 'Bold'
  },
  inactive_tab = {
    bg_color = 'none',
    fg_color = C_FG,
    intensity = 'Half'
  },
  inactive_tab_hover = {
    bg_color = 'none',
    fg_color = C_FG,
    intensity = 'Half'
  },
  new_tab = {
    bg_color = 'none',
    fg_color = C_FG,
  },
  new_tab_hover = {
    bg_color = 'none',
    fg_color = C_FG,
    italic = true
  }
}
scheme.scrollbar_thumb = C_BLUE
scheme.split = C_BLUE
scheme.compose_cursor = C_BRIGHT_GREEN
scheme.visual_bell = C_BRIGHT_RED
config.color_schemes = {
  [selected_scheme] = scheme
}
config.color_scheme = selected_scheme
config.pane_select_fg_color = C_FG
config.pane_select_bg_color = C_BG
config.force_reverse_video_cursor = true
config.front_end = 'WebGpu'
config.webgpu_preferred_adapter = gpus[1]
-- 1}}}

-- {{{1 Font configuration
-- {{{2 font_fallback
local function font_fallback(name)
  local names = { name, 'nonicons', 'Noto Color Emoji', 'Iosevka Artesanal' }
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
  elseif string.match(name, 'hasklig') then
    font = font_fallback({ family = 'Hasklig', harfbuzz_features = { 'onum' } })
  elseif string.match(name, 'iosevka') then
    font = font_fallback({ family = 'IosevkaArtesanal Nerd Font', harfbuzz_features = { 'calt', 'ccmp', 'dlig', 'onum' } })
    -- font = font_fallback({ family = 'Iosevka Artesanal', harfbuzz_features = { 'calt', 'ccmp', 'dlig', 'onum' } })
  elseif string.match(name, 'jet') then
    font = font_fallback({ family = 'JetBrains Mono', harfbuzz_features = { 'cv06', 'cv07', 'cv11', 'ss20', 'zero' } })
  elseif string.match(name, 'monolisa') then
    font = font_fallback({ family = 'MonoLisa', harfbuzz_features = { 'case', 'liga', 'dlig', 'onum' } })
  elseif string.match(name, 'monaspace') then
    font = font_fallback({ family = 'Monaspace Argon', weight = 'Light', harfbuzz_features = { 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'liga' } })
  elseif string.match(name, 'operator') then
    font = font_fallback({ family = 'Liga Operator Mono', weight = 'Light', harfbuzz_features = { 'ss05' } })
  elseif string.match(name, 'plex') then
    font = font_fallback({ family = 'IBM Plex Mono Text', harfbuzz_features = { 'zero' } })
  elseif string.match(name, 'pt') then
    font = font_fallback({ family = 'PT Mono', weight = 'Regular' })
  elseif string.match(name, 'recursive') then
    font = font_fallback({ family = 'Rec Mono Custom', weight = 'Regular' })
  elseif string.match(name, 'triple') then
    if string.match(appearance, 'light') then
      font = font_fallback({ family = 'Triplicate T4', weight = 'Regular', harfbuzz_features = { 'onum' } })
    else
      font = font_fallback({ family = 'Triplicate T3', weight = 'Regular', harfbuzz_features = { 'onum' } })
    end
  end
  return font
end

-- 2}}}
-- {{{2 font_rules
local function font_rules(name)
  local rules = {}
  if string.match(name, 'custom')
    or string.match(name, 'fantasque')
    or string.match(name, 'monolisa')
    or string.match(name, 'recursive')
    or string.match(name, 'triple')
  then
    rules = nil
  elseif string.match(name, 'iosevka') then
    rules = {
      {
        intensity = 'Normal',
        italic = true,
        font = font_fallback({ family = 'Iosevka Artesanal', weight = 'Book', style = 'Italic' })
        -- font = font_fallback({ family = 'IBM Plex Mono Text', style = 'Italic', harfbuzz_features = { 'zero' } })
        -- font = font_fallback({
        --   family = 'Liga Operator Mono',
        --   weight = 'Book',
        --   style = 'Italic',
        --   harfbuzz_features = { 'ss05' }
        -- })
      },
      {
        intensity = 'Bold',
        italic = true,
        font = font_fallback({ family = 'Iosevka Artesanal', weight = 'Bold', style = 'Italic' })
        -- font = font_fallback({ family = 'IBM Plex Mono SmBld', style = 'Italic', harfbuzz_features = { 'zero' } })
        -- font = font_fallback({
        --   family = 'Liga Operator Mono',
        --   weight = 'Regular',
        --   style = 'Italic',
        --   harfbuzz_features = { 'ss05' }
        -- })
      },
    }
  elseif string.match(name, 'monaspace') then
    rules = {
      {
        intensity = 'Normal',
        italic = true,
        font = font_fallback({
          family = 'Monaspace Radon',
          weight = 'Light',
          harfbuzz_features = { 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'liga' }
        })
      },
      {
        intensity = 'Bold',
        italic = true,
        font = font_fallback({
          family = 'Monaspace Radon',
          weight = 'Medium',
          harfbuzz_features = { 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'liga' }
        })
      },
      {
        intensity = 'Bold',
        italic = false,
        font = font_fallback({
          family = 'Monaspace Argon',
          weight = 'Medium',
          harfbuzz_features = { 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'liga' }
        })
      }
    }
  elseif string.match(name, 'operator') then
    rules = {
      {
        intensity = 'Bold',
        italic = false,
        font = font_fallback({
          family = 'Liga Operator Mono',
          weight = 'Book',
          harfbuzz_features = { 'ss05' }
        })
      },
      {
        intensity = 'Normal',
        italic = true,
        font = font_fallback({
          family = 'Liga Operator Mono',
          weight = 'Light',
          style = 'Italic',
          harfbuzz_features = { 'ss05' }
        })
      },
      {
        intensity = 'Bold',
        italic = true,
        font = font_fallback({
          family = 'Liga Operator Mono',
          weight = 'Book',
          style = 'Italic',
          harfbuzz_features = { 'ss05' }
        })
      },
    }
  elseif string.match(name, 'plex') then
    rules = {
      {
        intensity = 'Bold',
        italic = false,
        font = font_fallback({ family = 'IBM Plex Mono SmBld', harfbuzz_features = { 'onum', 'zero' } })
      },
      {
        intensity = 'Normal',
        italic = true,
        font = font_fallback({ family = 'IBM Plex Mono Text', style = 'Italic', harfbuzz_features = { 'onum', 'zero' } })
      },
      {
        intensity = 'Bold',
        italic = true,
        font = font_fallback({ family = 'IBM Plex Mono SmBld', style = 'Italic', harfbuzz_features = { 'onum', 'zero' } })
      },
    }
  elseif string.match(name, 'pt') then
    rules = {
      {
        intensity = 'Normal',
        italic = true,
        -- font = font_fallback({ family = 'IBM Plex Mono Text', style = 'Italic', harfbuzz_features = { 'onum', 'zero' } })
        font = font_fallback({ family = 'Codelia Ligatures Medium', style = 'Italic' })
      },
      {
        intensity = 'Bold',
        italic = true,
        -- font = font_fallback({ family = 'IBM Plex Mono SmBld', style = 'Italic', harfbuzz_features = { 'onum', 'zero' } })
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
  if hostname == 'swimmer' or hostname == 'komala' then
    if string.match(name, 'custom') then
      size = 10.0
    elseif string.match(name, 'fantasque') then
      size = 11.4
    elseif string.match(name, 'hasklig') then
      size = 10.5
    elseif string.match(name, 'iosevka') then
      size = 10.0
    elseif string.match(name, 'jet') then
      size = 10.0
    elseif string.match(name, 'operator') then
      size = 10.7
    elseif string.match(name, 'monaspace') then
      size = 9.5
    elseif string.match(name, 'monolisa') then
      size = 10.0
    elseif string.match(name, 'plex') then
      size = 10.0
    elseif string.match(name, 'pt') then
      size = 10.0
    elseif string.match(name, 'recursive') then
      size = 9.9
    elseif string.match(name, 'triple') then
      size = 10.5
    end
  elseif hostname == 'tj' then
    if string.match(name, 'custom') then
      size = 9.0
    elseif string.match(name, 'fantasque') then
      size = 11.4
    elseif string.match(name, 'hasklig') then
      size = 9.5
    elseif string.match(name, 'iosevka') then
      size = 10.0
    elseif string.match(name, 'jet') then
      size = 9.5
    elseif string.match(name, 'monaspace') then
      size = 9.5
    elseif string.match(name, 'monolisa') then
      size = 9.0
    elseif string.match(name, 'operator') then
      size = 9.8
    elseif string.match(name, 'plex') then
      size = 10.4
    elseif string.match(name, 'pt') then
      size = 9.5
    elseif string.match(name, 'recursive') then
      size = 9.2
    elseif string.match(name, 'triple') then
      size = 10.0
    end
  end
  return size
end

-- 2}}}
-- {{{2 freetype
local function ft_target(type)
  local ft_type
  if string.match(type, 'load') then
    if my_font == 'operator' then
      if string.match(appearance, 'light') then
        ft_type = 'Light'
      else
        ft_type = 'Normal'
      end
    else
      ft_type = 'Normal'
    end
  elseif string.match(type, 'render') then
    if my_font == 'operator' then
      if string.match(appearance, 'light') then
        ft_type = 'HorizontalLcd'
      else
        ft_type = 'Normal'
      end
    else
      ft_type = 'Normal'
    end
  end
  return ft_type
end
-- 2}}}
-- {{{2 set_geometry
local function set_geometry(x)
  local value = 0
  if x == 'cols' then
    value = 160
  elseif x == 'rows' then
    if hostname == 'swimmer' then
      if (my_font == 'monaspace') then
        value = 66
      elseif (my_font == 'pt') then
        value = 63
      elseif (my_font == 'fantasque' or my_font == 'iosevka' or my_font == 'monolisa' or my_font == 'recursive' or my_font == 'triple') then
        value = 61
      elseif (my_font == 'custom' or my_font == 'jet' or my_font == 'operator' or my_font == 'plex') then
        value = 56
      elseif (my_font == 'hasklig') then
        value = 53
      end
    elseif hostname == 'komala' then
      if (my_font == 'monaspace') then
        value = 67
      elseif (my_font == 'pt') then
        value = 64
      elseif (my_font == 'fantasque' or my_font == 'hasklig' or my_font == 'iosevka' or my_font == 'monolisa' or my_font == 'recursive' or my_font == 'triple') then
        value = 61
      elseif (my_font == 'custom' or my_font == 'jet' or my_font == 'operator') then
        value = 56
      elseif (my_font == 'plex') then
        value = 53
      end
    elseif hostname == 'tj' then
      if (my_font == 'pt' or my_font == 'recursive') then
        value = 51
      elseif (my_font == 'hasklig' or my_font == 'iosevka' or my_font == 'monaspace' or my_font == 'monolisa' or my_font == 'operator' or my_font == 'plex' or my_font == 'triple') then
        value = 50
      elseif (my_font == 'fantasque' or my_font == 'jet') then
        value = 44
      elseif (my_font == 'custom') then
        value = 41
      end
    end
  end
  return value
end

-- 2}}}
config.font = font_set(my_font)
config.font_rules = font_rules(my_font)
config.font_size = font_size(my_font)
config.char_select_font_size = font_size(my_font) - 1
config.command_palette_font_size = font_size(my_font) - 1
config.freetype_load_target = ft_target('load')
config.freetype_render_target = ft_target('render')
config.warn_about_missing_glyphs = false
config.underline_thickness = '220%'
config.unicode_version = 15
config.window_frame = {
  font = wez.font({ family = 'PayPal Sans Big' }),
  font_size = font_size(my_font) - 2
}
-- 1}}}

-- {{{1 Tab bar configuration
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 44
config.show_tab_index_in_tab_bar = true
-- }}}1

-- Behaviour
config.term = 'wezterm'
config.check_for_updates = false
config.adjust_window_size_when_changing_font_size = false
config.window_background_opacity = opacity
config.initial_cols = set_geometry('cols')
config.initial_rows = set_geometry('rows')
config.enable_kitty_graphics = true
config.selection_word_boundary = ' \t\n{}"\'`,;@│*'
config.clean_exit_codes = { 127, 130, 255 }
-- Panes
config.pane_focus_follows_mouse = true
config.swallow_mouse_click_on_pane_focus = true
config.swallow_mouse_click_on_window_focus = true
config.inactive_pane_hsb = {
  saturation = 1.0,
  brightness = 1.0
}
-- Hyperlinks
config.hyperlink_rules = {
  {
    regex = '\\b\\w+://(?:[\\w.-]+)\\.[a-z0-9]{2,15}\\S*\\b',
    format = '$0',
  }
}
-- Key bindings
config.disable_default_key_bindings = true
config.use_ime = false
config.debug_key_events = false
config.leader = { key = 'q', mods = 'CTRL' }
config.keys = {
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
  { key = 'f', mods = 'LEADER', action = act.Search { CaseSensitiveString = '' } },
  { key = 'x', mods = 'LEADER', action = act.ActivateCopyMode },
  {
    key = 'e',
    mods = 'LEADER',
    action = act.QuickSelectArgs {
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
  { key = 'w', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = 'w', mods = 'LEADER|SHIFT', action = act.CloseCurrentTab { confirm = true } },
  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
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
  { key = 'LeftArrow', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Left', 4 } },
  { key = 'RightArrow', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Right', 4 } },
  { key = 'UpArrow', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Up', 4 } },
  { key = 'DownArrow', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Down', 4 } },
}

return config
-- vim: foldmethod=marker foldlevel=0
