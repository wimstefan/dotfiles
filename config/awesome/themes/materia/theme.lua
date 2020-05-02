--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
--  Materia theme - inspired by the Materia (formerly Flat-Plat) GTK theme  ---
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

local theme_assets         = require("beautiful.theme_assets")
local dpi                  = require("beautiful.xresources").apply_dpi

local gears                = require("gears")
local themes_path          = gears.filesystem.get_themes_dir()

theme                      = {}

-- Theme settings {{{
theme.wallpaper            = wallpaper_dir .. "/default.jpg"
theme.border_width         = dpi(2)
theme.menu_height          = dpi(18)
theme.menu_width           = dpi(144)

theme.useless_gap          = dpi(8)

theme.tooltip_align        = "bottom"
theme.tooltip_border_width = dpi(0)

app_shape = function(cr, width, height)
  gears.shape.rounded_rect(cr, width, height, 16)
end
local hotkeys_shape = function(cr, width, height)
  gears.shape.partially_rounded_rect(cr, width, height, true, false, true, false, 24)
end
theme.hotkeys_shape        = hotkeys_shape
theme.hotkeys_group_margin = 44
--}}}

-- Theme fonts {{{
theme.font                 = "Iosevka Artesanal Tailed Semibold 11"
theme.mono_font            = "Iosevka Artesanal Tailed Bold 11"
theme.taglist_font         = "Iosevka Artesanal Tailed HvEx 11.5"
theme.tasklist_font        = "Iosevka Artesanal Tailed Book 10"
theme.clock_font           = "Iosevka Artesanal Tailed XBdEx 11"

theme.icon_font            = "Webhostinghub-Glyphs 8"
theme.hotkeys_font         = "Iosevka Artesanal Tailed Bold 11"
theme.hotkeys_description_font = "Iosevka Artesanal Tailed Book 11"
--}}}

-- Theme colours {{{
theme.foreground           = '#09212d'
theme.background           = '#eceff1'
theme.cursor               = '#1c222e'

theme.black1               = '#363636'
theme.black2               = '#121212'
theme.grey1                = '#bdbdbd'
theme.grey2                = '#616161'
theme.red1                 = '#e57373'
theme.red2                 = '#b71c1c'
theme.green1               = '#009688'
theme.green2               = '#00695c'
theme.yellow1              = '#fff59d'
theme.yellow2              = '#fdd835'
theme.orange1              = '#ff9900'
theme.orange2              = '#d84315'
theme.blue1                = '#b3e5fc'
theme.blue2                = '#01579b'
theme.magenta1             = '#d1c4e9'
theme.magenta2             = '#9575cd'
theme.cyan1                = '#80deea'
theme.cyan2                = '#0097a7'
theme.white1               = '#ffffff'
theme.white2               = '#dedede'

theme.fg_normal            = theme.foreground
theme.bg_normal            = theme.background
theme.fg_focus             = theme.red1
theme.bg_focus             = theme.background
theme.fg_em                = theme.grey1
theme.bg_em                = theme.grey2
theme.fg_urgent            = theme.white1
theme.bg_urgent            = theme.red1
theme.border_normal        = theme.background
theme.border_focus         = theme.grey1
theme.border_marked        = theme.grey2
theme.cal_fg               = theme.background
theme.cal_bg               = theme.blue2
theme.clock_fg             = theme.background
theme.clock_bg             = theme.blue2
theme.hotkeys_fg           = theme.foreground
theme.hotkeys_bg           = theme.background
theme.hotkeys_modifiers_fg = theme.blue2
theme.taglist_fg_empty     = theme.white1
theme.taglist_bg_empty     = theme.white2
theme.taglist_fg_focus     = theme.white1
theme.taglist_bg_focus     = theme.blue2
theme.taglist_fg_occupied  = theme.blue2
theme.taglist_bg_occupied  = theme.white2
theme.taglist_fg_urgent    = theme.white1
theme.taglist_bg_urgent    = theme.red2
theme.tasklist_fg_focus    = theme.red2
theme.tasklist_bg_urgent   = theme.red2
theme.titlebar_fg_focus    = theme.red2
theme.titlebar_fg_normal   = theme.red1
theme.gradient_1           = theme.red1
theme.gradient_2           = theme.blue1
theme.gradient_3           = theme.blue2
theme.tooltip_border_color = theme.grey2
theme.panel_fg             = theme.grey1

theme                      = theme_assets.recolor_layout(theme, theme.panel_fg)
theme                      = theme_assets.recolor_titlebar_normal(theme, theme.titlebar_fg_normal)
theme                      = theme_assets.recolor_titlebar_focus(theme, theme.titlebar_fg_focus)

--}}}

-- Theme icons {{{
theme.icon_theme            = home_dir .. "/.icons/oomox-ta-materia-light-blue"
theme.tasklist_disable_icon = false

theme.awesome_icon          = theme_assets.awesome_icon( theme.menu_height, theme.taglist_bg_focus, theme.taglist_fg_focus )
theme.menu_submenu_icon     = icon_dir .. "multicolor-icons/submenu.png"
theme.menu_submenu_icon     = recolor(theme.menu_submenu_icon, theme.blue2)

theme.layout_fairh          = icon_dir .. "multicolor-icons/fairh.png"
theme.layout_fairv          = icon_dir .. "multicolor-icons/fairv.png"
theme.layout_floating       = icon_dir .. "multicolor-icons/floating.png"
theme.layout_magnifier      = icon_dir .. "multicolor-icons/magnifier.png"
theme.layout_max            = icon_dir .. "multicolor-icons/max.png"
theme.layout_fullscreen     = icon_dir .. "multicolor-icons/fullscreen.png"
theme.layout_tilebottom     = icon_dir .. "multicolor-icons/tilebottom.png"
theme.layout_tileleft       = icon_dir .. "multicolor-icons/tileleft.png"
theme.layout_tile           = icon_dir .. "multicolor-icons/tile.png"
theme.layout_tiletop        = icon_dir .. "multicolor-icons/tiletop.png"
theme.layout_spiral         = icon_dir .. "multicolor-icons/spiral.png"
theme.layout_dwindle        = icon_dir .. "multicolor-icons/dwindle.png"
theme.layout_cornernw       = icon_dir .. "multicolor-icons/cornernw.png"
theme.layout_cornerne       = icon_dir .. "multicolor-icons/cornerne.png"
theme.layout_cornersw       = icon_dir .. "multicolor-icons/cornersw.png"
theme.layout_cornerse       = icon_dir .. "multicolor-icons/cornerse.png"

theme.titlebar_close_button_normal              = icon_dir .. "multicolor-icons/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = icon_dir .. "multicolor-icons/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal           = icon_dir .. "multicolor-icons/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = icon_dir .. "multicolor-icons/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive     = icon_dir .. "multicolor-icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = icon_dir .. "multicolor-icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = icon_dir .. "multicolor-icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = icon_dir .. "multicolor-icons/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive    = icon_dir .. "multicolor-icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = icon_dir .. "multicolor-icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = icon_dir .. "multicolor-icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = icon_dir .. "multicolor-icons/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive  = icon_dir .. "multicolor-icons/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = icon_dir .. "multicolor-icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = icon_dir .. "multicolor-icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = icon_dir .. "multicolor-icons/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = icon_dir .. "multicolor-icons/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = icon_dir .. "multicolor-icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = icon_dir .. "multicolor-icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = icon_dir .. "multicolor-icons/titlebar/maximized_focus_active.png"

--}}}

-- Collision settings {{{
theme.collision_resize_width = dpi(34)
theme.collision_resize_bg = theme.blue2
theme.collision_focus_bg = theme.blue2
theme.collision_focus_bg_center = theme.yellow1
-- }}}
return theme
--  vim: fdm=marker fdl=0
