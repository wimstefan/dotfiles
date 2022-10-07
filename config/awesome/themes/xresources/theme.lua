---------------------------------------------
-- Awesome theme which follows xrdb config --
--         by Yauhen Kirylau               --
---------------------------------------------

local gears         = require("gears")
local theme_assets  = require("beautiful.theme_assets")
local xresources    = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi           = xresources.apply_dpi
local xrdb          = xresources.get_current_theme()
local gdebug        = gears.debug
local gfs           = gears.filesystem
local recolor       = gears.color.recolor_image
local shape         = gears.shape
local icon_dir      = gfs.get_configuration_dir() .. "/icons/"
local themes_dir    = gfs.get_themes_dir()
local hostname      = io.lines("/proc/sys/kernel/hostname")()

local theme = dofile(themes_dir .. "default/theme.lua")

-- Fonts {{{
theme.font_name = "monospace "
theme.font      = theme.font_name .. "Book 10"
if hostname == "tj" then
  -- theme.taglist_font       = theme.font_name .. "Book 10"
  theme.taglist_font_focus = "Montserrat Bold 10"
  theme.tasklist_font      = theme.font_name .. "SemiBold 9"
  theme.widget_font        = theme.font_name .. "ExtraBold 10"
  theme.clock_font         = theme.font_name .. "ExtraBold 11.5"
  theme.notification_font  = theme.font_name .. "Book 9"
  theme.titlebar_font      = theme.font_name .. "Book 8.5"
else
  -- theme.taglist_font       = theme.font_name .. "Book 11"
  theme.taglist_font_focus = "Montserrat Bold 11"
  theme.tasklist_font      = theme.font_name .. "SemiBold 9.5"
  theme.widget_font        = theme.font_name .. "ExtraBold 11"
  theme.clock_font         = theme.font_name .. "ExtraBold 12"
  theme.notification_font  = theme.font_name .. "Book 10"
  theme.titlebar_font      = theme.font_name .. "Book 9"
end
-- }}}

-- Colors {{{
theme.foreground  = xrdb.foreground
theme.background  = xrdb.background
theme.black       = xrdb.color0
theme.black_alt   = xrdb.color8
theme.red         = xrdb.color1
theme.red_alt     = xrdb.color9
theme.green       = xrdb.color2
theme.green_alt   = xrdb.color10
theme.yellow      = xrdb.color3
theme.yellow_alt  = xrdb.color11
theme.blue        = xrdb.color4
theme.blue_alt    = xrdb.color12
theme.magenta     = xrdb.color5
theme.magenta_alt = xrdb.color13
theme.cyan        = xrdb.color6
theme.cyan_alt    = xrdb.color14
theme.white       = xrdb.color7
theme.white_alt   = xrdb.color15
theme.real_white  = "#ffffff"

theme.bg_normal   = theme.background
theme.bg_focus    = theme.blue
theme.bg_urgent   = theme.red
theme.bg_minimize = theme.black_alt
theme.bg_systray  = theme.bg_normal
theme.bg_transparent = theme.background .. "00"

theme.fg_normal   = theme.foreground
theme.fg_focus    = theme.bg_normal
theme.fg_urgent   = theme.real_white
theme.fg_minimize = theme.bg_normal

-- Try to determine if we are running light or dark colorscheme:
local bg_numberic_value = 0;
for s in theme.bg_normal:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
  bg_numberic_value = bg_numberic_value + tonumber("0x" .. s);
end
local is_dark_bg = (bg_numberic_value < 383)

if is_dark_bg then
  theme.tint_fg = theme.foreground .. "88"
  theme.tint_bg = theme.background .. "22"
  theme.tint_active = theme.green_alt .. "EE"
  theme.tint_marked = theme.yellow_alt .. "66"
  theme.tint_symbol = theme.green_alt
else
  theme.tint_fg = theme.foreground .. "88"
  theme.tint_bg = theme.background .. "22"
  theme.tint_active = theme.blue_alt .. "FF"
  theme.tint_marked = theme.yellow_alt .. "AA"
  theme.tint_symbol = theme.cyan_alt
end
-- }}}

-- Shaping {{{
-- Matrix rotation per direction
-- top    = math.pi     , -- 180
-- bottom = 0           , -- 0
-- left   = math.pi/2   , -- 90
-- right  = 3*math.pi/2 , -- 270
theme.app_shape = function(cr, width, height)
  shape.rounded_rect(cr, width, height, dpi(14))
end
theme.hotkeys_shape = function(cr, width, height)
  shape.partially_rounded_rect(cr, width, height, true, false, true, false, dpi(14))
end
theme.notification_shape = function(cr, width, height)
  shape.infobubble(cr, width, height, dpi(6), dpi(7), width - dpi(30))
  -- local transform = shape.transform(shape.infobubble):rotate(math.pi/2)
  -- transform(cr, height, width, dpi(6), dpi(7), height - dpi(30))
end
theme.tooltip_shape = shape.infobubble
-- }}}

-- Settings {{{
if hostname == "tj" then
  theme.spacing = dpi(6)
else
  theme.spacing = dpi(6)
end
theme.useless_gap  = dpi(4)
theme.border_width = dpi(2)

theme.wibar_position = 'top'
theme.wibar_height   = dpi(26)

theme.border_color_normal = theme.tint_bg
theme.border_color_active = theme.tint_active
theme.border_color_marked = theme.tint_marked

theme.taglist_spacing = theme.spacing
theme.taglist_squares_sel = nil
theme.taglist_squares_unsel = nil
theme.taglist_fg_occupied = theme.blue_alt
theme.taglist_fg_focus = theme.blue_alt
theme.taglist_bg_focus = theme.bg_normal
theme.taglist_fg_empty = theme.tint_fg
theme.taglist_bg_empty = theme.bg_normal
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_fg_urgent = theme.red_alt
theme.taglist_bg_urgent = theme.bg_normal

theme.tag_preview_widget_border_radius = dpi(0)
theme.tag_preview_client_border_radius = dpi(10)
theme.tag_preview_client_opacity = 0.8
theme.tag_preview_client_bg = theme.background
theme.tag_preview_client_border_color = theme.tint_symbol
theme.tag_preview_client_border_width = theme.border_width * 0.8
theme.tag_preview_widget_bg = theme.foreground .. "00"
theme.tag_preview_widget_border_color = theme.tint_symbol
theme.tag_preview_widget_border_width = 0
theme.tag_preview_widget_margin = theme.spacing * 4

theme.task_preview_widget_border_radius = dpi(0)
theme.task_preview_widget_bg = theme.foreground .. "00"
theme.task_preview_widget_border_color = theme.tint_symbol
theme.task_preview_widget_border_width = 0
theme.task_preview_widget_margin = theme.spacing * 4

theme.tasklist_disable_icon    = false
theme.tasklist_plain_task_name = true
theme.tasklist_spacing         = theme.spacing
theme.tasklist_fg_focus        = theme.tint_active
theme.tasklist_bg_focus        = theme.bg_normal
theme.tasklist_fg_normal       = theme.tint_fg
theme.tasklist_bg_normal       = theme.bg_normal
theme.tasklist_fg_urgent       = theme.red_alt
theme.tasklist_bg_urgent       = theme.bg_normal
if is_dark_bg then
  theme.tasklist_fg_minimized = theme.black_alt
else
  theme.tasklist_fg_minimized = theme.white_alt
end
theme.tasklist_bg_minimized = theme.bg_normal

theme.hotkeys_fg               = theme.foreground
theme.hotkeys_bg               = theme.background
theme.hotkeys_modifiers_fg     = theme.blue_alt
theme.hotkeys_border_color     = theme.tint_marked
theme.hotkeys_border_width     = theme.border_width * 1.4
theme.hotkeys_group_margin     = dpi(24)
theme.hotkeys_font             = theme.font_name .. "Bold 9.5"
theme.hotkeys_description_font = theme.font_name .. "Book 9.5"

theme.notification_border_width = theme.border_width * 0.8

theme.tooltip_border_color = theme.tint_symbol
theme.tooltip_border_width = theme.border_width * 0.6
theme.tooltip_fg           = theme.fg_normal
theme.tooltip_bg           = theme.bg_normal
theme.tooltip_font         = theme.font_name .. "Book 10"

theme.menu_height       = dpi(24)
theme.menu_width        = dpi(140)
theme.menu_submenu_icon = icon_dir .. "multicolor-icons/submenu.png"
theme.menu_submenu_icon = recolor(theme.menu_submenu_icon, theme.red_alt)
-- }}}

-- Appearance {{{
-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme, theme.magenta_alt)

-- Recolor titlebar icons:
local function darker(color_value, darker_n)
  local result = "#"
  for s in color_value:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
    local bg_numeric_value = tonumber("0x" .. s) - darker_n
    if bg_numeric_value < 0 then bg_numeric_value = 0 end
    if bg_numeric_value > 255 then bg_numeric_value = 255 end
    result = result .. string.format("%2.2x", bg_numeric_value)
  end
  return result
end

theme = theme_assets.recolor_titlebar(
  theme, theme.fg_normal, "normal"
)
theme = theme_assets.recolor_titlebar(
  theme, darker(theme.fg_normal, -60), "normal", "hover"
)
theme = theme_assets.recolor_titlebar(
  theme, xrdb.color1, "normal", "press"
)
theme = theme_assets.recolor_titlebar(
  theme, theme.fg_focus, "focus"
)
theme = theme_assets.recolor_titlebar(
  theme, darker(theme.fg_focus, -60), "focus", "hover"
)
theme = theme_assets.recolor_titlebar(
  theme, xrdb.color1, "focus", "press"
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = 'HighContrast'

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
  theme.menu_height, theme.red_alt, theme.fg_focus
)

-- Generate symbols:
theme.symbol_forward                = icon_dir .. 'font-awesome/forward.svg'
theme.symbol_forward                = recolor(theme.symbol_forward, theme.tint_symbol)
theme.symbol_backward               = icon_dir .. 'font-awesome/backward.svg'
theme.symbol_backward               = recolor(theme.symbol_backward, theme.tint_symbol)
theme.symbol_microchip              = icon_dir .. 'font-awesome/microchip.svg'
theme.symbol_microchip              = recolor(theme.symbol_microchip, theme.tint_symbol)
theme.symbol_pause                  = icon_dir .. 'font-awesome/pause.svg'
theme.symbol_pause                  = recolor(theme.symbol_pause, theme.tint_symbol)
theme.symbol_play                   = icon_dir .. 'font-awesome/play.svg'
theme.symbol_play                   = recolor(theme.symbol_play, theme.tint_symbol)
theme.symbol_stop                   = icon_dir .. 'font-awesome/stop.svg'
theme.symbol_stop                   = recolor(theme.symbol_stop, theme.tint_symbol)
theme.symbol_volume_down            = icon_dir .. 'font-awesome/volume-down.svg'
theme.symbol_volume_down            = recolor(theme.symbol_volume_down, theme.tint_symbol)
theme.symbol_volume_mute            = icon_dir .. 'font-awesome/volume-mute.svg'
theme.symbol_volume_mute            = recolor(theme.symbol_volume_mute, theme.tint_symbol)
theme.symbol_volume_off             = icon_dir .. 'font-awesome/volume-off.svg'
theme.symbol_volume_off             = recolor(theme.symbol_volume_off, theme.tint_symbol)
theme.symbol_volume_up              = icon_dir .. 'font-awesome/volume-up.svg'
theme.symbol_volume_up              = recolor(theme.symbol_volume_up, theme.tint_symbol)
theme.symbol_memory                 = icon_dir .. 'font-awesome/memory.svg'
theme.symbol_memory                 = recolor(theme.symbol_memory, theme.tint_symbol)
theme.symbol_thermometer            = icon_dir .. 'font-awesome/thermometer-empty.svg'
theme.symbol_thermometer            = recolor(theme.symbol_thermometer, theme.tint_symbol)
theme.symbol_battery_empty          = icon_dir .. 'font-awesome/battery-empty.svg'
theme.symbol_battery_empty          = recolor(theme.symbol_battery_empty, theme.tint_symbol)
theme.symbol_battery_full           = icon_dir .. 'font-awesome/battery-full.svg'
theme.symbol_battery_full           = recolor(theme.symbol_battery_full, theme.tint_symbol)
theme.symbol_battery_half           = icon_dir .. 'font-awesome/battery-half.svg'
theme.symbol_battery_half           = recolor(theme.symbol_battery_half, theme.tint_symbol)
theme.symbol_battery_quarter        = icon_dir .. 'font-awesome/battery-quarter.svg'
theme.symbol_battery_quarter        = recolor(theme.symbol_battery_quarter, theme.tint_symbol)
theme.symbol_battery_three_quarters = icon_dir .. 'font-awesome/battery-three-quarters.svg'
theme.symbol_battery_three_quarters = recolor(theme.symbol_battery_three_quarters, theme.tint_symbol)
theme.symbol_plug                   = icon_dir .. 'font-awesome/plug.svg'
theme.symbol_plug                   = recolor(theme.symbol_plug, theme.tint_symbol)
theme.symbol_power_off              = icon_dir .. 'font-awesome/power-off.svg'
theme.symbol_power_off              = recolor(theme.symbol_power_off, theme.tint_symbol)

-- Generate wallpaper:
local wallpaper_bg = theme.bg_normal
local wallpaper_fg = theme.foreground .. "88"
local wallpaper_alt_fg = theme.tint_active .. "44"

local rsvg = pcall(function() return require("lgi").Rsvg end)

if rsvg then
  local handle = require("lgi").Rsvg.Handle.new_from_file(
    -- themes_dir .. "xresources/wallpaper.svg"
     "/home/swimmer/system/wallpapers/gecko.svg"
  )

  if handle then
    handle:set_stylesheet([[
      .normal {
        fill: ]] .. wallpaper_fg .. [[;
      }
      .background {
        fill: ]] .. wallpaper_bg .. [[;
        stroke: ]] .. wallpaper_bg .. [[;
      }
      .logo {
        fill: ]] .. wallpaper_alt_fg .. [[;
      }
    ]])
    theme.wallpaper = handle
  end
else
  gdebug.print_warning("Could not load the wallpaper: librsvg is not installed.")
end

if not theme.wallpaper then
  theme.wallpaper = themes_dir .. "xresources/wallpaper.svg"
end

theme.wallpaper_bg = wallpaper_bg

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
  rnotification.append_rule {
    rule       = { urgency = 'critical' },
    properties = { bg = theme.red_alt, fg = theme.real_white }
  }
end)
-- }}}

return theme

-- vim: filetype=lua fdm=marker
