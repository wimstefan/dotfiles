--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
--                       Materia theme - light version                      ---
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

local beautiful     =  require('beautiful')
local dpi           =  beautiful.xresources.apply_dpi
local theme_assets  =  beautiful.theme_assets

local gears         =  require('gears')
local recolor       =  gears.color.recolor_image

theme               =  {}

-- Theme settings {{{
theme.wallpaper       =  wallpaper_dir .. 'default.jpg'
theme.border_width    =  dpi(4)
theme.useless_gap     =  dpi(8)
theme.wibar_position  =  'top'
theme.wibar_height    =  dpi(18)
--}}}

-- Theme shapes {{{
app_shape = function(cr, width, height)
  gears.shape.rounded_rect(cr, width, height, dpi(16))
end
theme.hotkeys_shape = function(cr, width, height)
  gears.shape.partially_rounded_rect(cr, width, height, true, false, true, false, dpi(44))
end
theme.notification_shape = function(cr, width, height)
  gears.shape.partially_rounded_rect(cr, width, height, true, false, true, false, dpi(24))
end
theme.tooltip_shape = gears.shape.infobubble
--}}}

-- Theme fonts {{{
theme.font                     = 'Iosevka Artesanal Tailed Semibold 10'
theme.mono_font                = 'Iosevka Artesanal Tailed Bold 10'
theme.taglist_font             = 'Iosevka Artesanal Tailed HvEx 10.5'
theme.tasklist_font            = 'Iosevka Artesanal Tailed 9'
theme.clock_font               = 'Iosevka Artesanal Tailed XBdEx 10'
theme.icon_font                = 'Webhostinghub-Glyphs 8'
--}}}

-- Theme colours {{{
theme.foreground           =  '#09212d'
theme.background           =  '#eceff1'
theme.cursor               =  '#1c222e'

theme.black1               =  '#363636'
theme.black2               =  '#121212'
theme.grey1                =  '#bdbdbd'
theme.grey2                =  '#616161'
theme.red1                 =  '#e57373'
theme.red2                 =  '#b71c1c'
theme.green1               =  '#009688'
theme.green2               =  '#00695c'
theme.yellow1              =  '#fff59d'
theme.yellow2              =  '#fdd835'
theme.orange1              =  '#ff9900'
theme.orange2              =  '#d84315'
theme.blue1                =  '#99bbd7'
theme.blue2                =  '#01579b'
theme.magenta1             =  '#d1c4e9'
theme.magenta2             =  '#9575cd'
theme.cyan1                =  '#80deea'
theme.cyan2                =  '#0097a7'
theme.white1               =  '#ffffff'
theme.white2               =  '#dedede'

theme.fg_normal            =  theme.foreground
theme.bg_normal            =  theme.background
theme.fg_focus             =  theme.red1
theme.bg_focus             =  theme.background
theme.fg_em                =  theme.grey1
theme.bg_em                =  theme.grey2
theme.fg_urgent            =  theme.white1
theme.bg_urgent            =  theme.red1
theme.border_color         =  theme.white2
theme.border_normal        =  theme.white2
theme.border_focus         =  theme.white1
theme.border_marked        =  theme.grey2
theme.cal_fg               =  theme.background
theme.cal_bg               =  theme.blue2
theme.clock_fg             =  theme.background
theme.clock_bg             =  theme.blue2
theme.taglist_fg_empty     =  theme.white1
theme.taglist_bg_empty     =  theme.white2
theme.taglist_fg_focus     =  theme.white1
theme.taglist_bg_focus     =  theme.blue2
theme.taglist_fg_occupied  =  theme.blue2
theme.taglist_bg_occupied  =  theme.white2
theme.taglist_fg_urgent    =  theme.white1
theme.taglist_bg_urgent    =  theme.red2
theme.tasklist_fg_focus    =  theme.red2
theme.tasklist_bg_urgent   =  theme.red2
theme.titlebar_fg_focus    =  theme.red2
theme.titlebar_fg_normal   =  theme.red1
theme.gradient_1           =  theme.red1
theme.gradient_2           =  theme.blue1
theme.gradient_3           =  theme.blue2
theme.decoration_tint      =  theme.blue2
theme.symbol_tint          =  theme.green1

--}}}

-- Menu settings {{{
theme.menu_height        =  dpi(18)
theme.menu_width         =  dpi(144)
theme.menu_border_color  =  theme.decoration_tint
theme.menu_border_width  =  dpi(1)
theme.menu_submenu_icon  =  icon_dir .. 'multicolor-icons/submenu.png'
theme.menu_submenu_icon  =  recolor(theme.menu_submenu_icon, theme.decoration_tint)
--}}}

-- Notification settings {{{
theme.notification_border_color  =  theme.symbol_tint
theme.notification_border_width  =  theme.border_width * 2.8
theme.notification_fg            =  theme.symbol_tint
theme.notification_padding       =  dpi(8)
theme.notification_spacing       =  dpi(4)
-- }}}

-- Tooltip settings {{{
theme.tooltip_align         =  'top'
theme.tooltip_border_color  =  theme.border_color
theme.tooltip_border_width  =  theme.border_width * 1.5
theme.tooltip_fg            =  theme.symbol_tint
theme.tooltip_font          = 'Iosevka Artesanal Tailed 10'
theme.tooltip_gaps          =  dpi(24)
-- }}}

-- Hotkeys settings {{{
theme.hotkeys_fg                =  theme.foreground
theme.hotkeys_bg                =  theme.background
theme.hotkeys_modifiers_fg      =  theme.blue2
theme.hotkeys_border_color      =  theme.border_focus
theme.hotkeys_border_width      =  theme.border_width * 2.8
theme.hotkeys_group_margin      =  dpi(24)
theme.hotkeys_font              =  'Iosevka Artesanal Tailed Bold 10'
theme.hotkeys_description_font  =  'Iosevka Artesanal Tailed 10'
-- }}}

-- Theme icons {{{
theme.awesome_icon           =  theme_assets.awesome_icon( theme.menu_height, theme.taglist_bg_focus, theme.taglist_fg_focus )
theme.icon_theme             =  home_dir .. '/.icons/oomox-ta-materia-light-blue'
theme.tasklist_disable_icon  =  false

theme.layout_fairh       =  icon_dir .. 'multicolor-icons/fairh.png'
theme.layout_fairv       =  icon_dir .. 'multicolor-icons/fairv.png'
theme.layout_floating    =  icon_dir .. 'multicolor-icons/floating.png'
theme.layout_magnifier   =  icon_dir .. 'multicolor-icons/magnifier.png'
theme.layout_max         =  icon_dir .. 'multicolor-icons/max.png'
theme.layout_fullscreen  =  icon_dir .. 'multicolor-icons/fullscreen.png'
theme.layout_tilebottom  =  icon_dir .. 'multicolor-icons/tilebottom.png'
theme.layout_tileleft    =  icon_dir .. 'multicolor-icons/tileleft.png'
theme.layout_tile        =  icon_dir .. 'multicolor-icons/tile.png'
theme.layout_tiletop     =  icon_dir .. 'multicolor-icons/tiletop.png'
theme.layout_spiral      =  icon_dir .. 'multicolor-icons/spiral.png'
theme.layout_dwindle     =  icon_dir .. 'multicolor-icons/dwindle.png'
theme.layout_cornernw    =  icon_dir .. 'multicolor-icons/cornernw.png'
theme.layout_cornerne    =  icon_dir .. 'multicolor-icons/cornerne.png'
theme.layout_cornersw    =  icon_dir .. 'multicolor-icons/cornersw.png'
theme.layout_cornerse    =  icon_dir .. 'multicolor-icons/cornerse.png'

theme.titlebar_close_button_normal               =  icon_dir .. 'multicolor-icons/titlebar/close_normal.png'
theme.titlebar_close_button_focus                =  icon_dir .. 'multicolor-icons/titlebar/close_focus.png'
theme.titlebar_minimize_button_normal            =  icon_dir .. 'multicolor-icons/titlebar/minimize_normal.png'
theme.titlebar_minimize_button_focus             =  icon_dir .. 'multicolor-icons/titlebar/minimize_focus.png'
theme.titlebar_ontop_button_normal_inactive      =  icon_dir .. 'multicolor-icons/titlebar/ontop_normal_inactive.png'
theme.titlebar_ontop_button_focus_inactive       =  icon_dir .. 'multicolor-icons/titlebar/ontop_focus_inactive.png'
theme.titlebar_ontop_button_normal_active        =  icon_dir .. 'multicolor-icons/titlebar/ontop_normal_active.png'
theme.titlebar_ontop_button_focus_active         =  icon_dir .. 'multicolor-icons/titlebar/ontop_focus_active.png'
theme.titlebar_sticky_button_normal_inactive     =  icon_dir .. 'multicolor-icons/titlebar/sticky_normal_inactive.png'
theme.titlebar_sticky_button_focus_inactive      =  icon_dir .. 'multicolor-icons/titlebar/sticky_focus_inactive.png'
theme.titlebar_sticky_button_normal_active       =  icon_dir .. 'multicolor-icons/titlebar/sticky_normal_active.png'
theme.titlebar_sticky_button_focus_active        =  icon_dir .. 'multicolor-icons/titlebar/sticky_focus_active.png'
theme.titlebar_floating_button_normal_inactive   =  icon_dir .. 'multicolor-icons/titlebar/floating_normal_inactive.png'
theme.titlebar_floating_button_focus_inactive    =  icon_dir .. 'multicolor-icons/titlebar/floating_focus_inactive.png'
theme.titlebar_floating_button_normal_active     =  icon_dir .. 'multicolor-icons/titlebar/floating_normal_active.png'
theme.titlebar_floating_button_focus_active      =  icon_dir .. 'multicolor-icons/titlebar/floating_focus_active.png'
theme.titlebar_maximized_button_normal_inactive  =  icon_dir .. 'multicolor-icons/titlebar/maximized_normal_inactive.png'
theme.titlebar_maximized_button_focus_inactive   =  icon_dir .. 'multicolor-icons/titlebar/maximized_focus_inactive.png'
theme.titlebar_maximized_button_normal_active    =  icon_dir .. 'multicolor-icons/titlebar/maximized_normal_active.png'
theme.titlebar_maximized_button_focus_active     =  icon_dir .. 'multicolor-icons/titlebar/maximized_focus_active.png'

theme.symbol_forward                 =  icon_dir .. 'font-awesome/forward.svg'
theme.symbol_forward                 =  recolor(theme.symbol_forward, theme.symbol_tint)
theme.symbol_backward                =  icon_dir .. 'font-awesome/backward.svg'
theme.symbol_backward                =  recolor(theme.symbol_backward, theme.symbol_tint)
theme.symbol_microchip               =  icon_dir .. 'font-awesome/microchip.svg'
theme.symbol_microchip               =  recolor(theme.symbol_microchip, theme.symbol_tint)
theme.symbol_pause                   =  icon_dir .. 'font-awesome/pause.svg'
theme.symbol_pause                   =  recolor(theme.symbol_pause, theme.symbol_tint)
theme.symbol_play                    =  icon_dir .. 'font-awesome/play.svg'
theme.symbol_play                    =  recolor(theme.symbol_play, theme.symbol_tint)
theme.symbol_stop                    =  icon_dir .. 'font-awesome/stop.svg'
theme.symbol_stop                    =  recolor(theme.symbol_stop, theme.symbol_tint)
theme.symbol_volume_down             =  icon_dir .. 'font-awesome/volume-down.svg'
theme.symbol_volume_down             =  recolor(theme.symbol_volume_down, theme.symbol_tint)
theme.symbol_volume_mute             =  icon_dir .. 'font-awesome/volume-mute.svg'
theme.symbol_volume_mute             =  recolor(theme.symbol_volume_mute, theme.symbol_tint)
theme.symbol_volume_off              =  icon_dir .. 'font-awesome/volume-off.svg'
theme.symbol_volume_off              =  recolor(theme.symbol_volume_off, theme.symbol_tint)
theme.symbol_volume_up               =  icon_dir .. 'font-awesome/volume-up.svg'
theme.symbol_volume_up               =  recolor(theme.symbol_volume_up, theme.symbol_tint)
theme.symbol_memory                  =  icon_dir .. 'font-awesome/memory.svg'
theme.symbol_memory                  =  recolor(theme.symbol_memory, theme.symbol_tint)
theme.symbol_thermometer             =  icon_dir .. 'font-awesome/thermometer-empty.svg'
theme.symbol_thermometer             =  recolor(theme.symbol_thermometer, theme.symbol_tint)
theme.symbol_battery_empty           =  icon_dir .. 'font-awesome/battery-empty.svg'
theme.symbol_battery_empty           =  recolor(theme.symbol_battery_empty, theme.symbol_tint)
theme.symbol_battery_full            =  icon_dir .. 'font-awesome/battery-full.svg'
theme.symbol_battery_full            =  recolor(theme.symbol_battery_full, theme.symbol_tint)
theme.symbol_battery_half            =  icon_dir .. 'font-awesome/battery-half.svg'
theme.symbol_battery_half            =  recolor(theme.symbol_battery_half, theme.symbol_tint)
theme.symbol_battery_quarter         =  icon_dir .. 'font-awesome/battery-quarter.svg'
theme.symbol_battery_quarter         =  recolor(theme.symbol_battery_quarter, theme.symbol_tint)
theme.symbol_battery_three_quarters  =  icon_dir .. 'font-awesome/battery-three-quarters.svg'
theme.symbol_battery_three_quarters  =  recolor(theme.symbol_battery_three_quarters, theme.symbol_tint)
theme.symbol_plug                    =  icon_dir .. 'font-awesome/plug.svg'
theme.symbol_plug                    =  recolor(theme.symbol_plug, theme.symbol_tint)
theme.symbol_power_off               =  icon_dir .. 'font-awesome/power-off.svg'
theme.symbol_power_off               =  recolor(theme.symbol_power_off, theme.symbol_tint)

--}}}

-- Collision settings {{{
theme.collision_resize_width     =  dpi(34)
theme.collision_resize_bg        =  theme.blue2
theme.collision_focus_bg         =  theme.blue2
theme.collision_focus_bg_center  =  theme.yellow1
-- }}}
return theme
--  vim: fdm=marker fdl=0
