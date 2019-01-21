--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
--  Materia theme - inspired by the Materia (formerly Flat-Plat) GTK theme  ---
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

local theme_assets         = require("beautiful.theme_assets")
local xresources           = require("beautiful.xresources")
local dpi                  = xresources.apply_dpi

local gears                = require("gears")
local themes_path          = gears.filesystem.get_themes_dir()

theme                      = {}

-- Theme settings {{{
theme.wallpaper            = wallpaper_dir .. "/default.jpg"
theme.border_width         = dpi(3)
theme.menu_height          = dpi(14)
theme.menu_width           = dpi(144)

theme.useless_gap          = dpi(5)

theme.tooltip_align        = "bottom"
theme.tooltip_border_width = dpi(0)

local hotkeys_shape = function(cr, width, height)
  gears.shape.partially_rounded_rect(cr, width, height, true, false, true, false, 24)
end
theme.hotkeys_shape        = hotkeys_shape
theme.hotkeys_group_margin = 44
--}}}

-- Theme fonts {{{
theme.font                 = "Rosario SemiBold 9"
theme.serif_font           = "Manuale Bold 9"
theme.mono_font            = "Operator Mono Medium 9"
theme.taglist_font         = "Operator Mono Medium 10"
theme.tasklist_font        = "Rosario SemiBold 8"
theme.icon_font            = "Webhostinghub-Glyphs 8"
theme.hotkeys_font         = "Manuale Bold 9"
theme.hotkeys_description_font = "Faustina 9"
--}}}

-- Theme colours {{{
theme.foreground           = '#fbfbfb'
theme.background           = '#2e3440'
theme.cursor               = '#1c222e'

theme.black1               = '#575c66'
theme.black2               = '#121419'
theme.grey1                = '#bdbdbd'
theme.grey2                = '#616161'
theme.red1                 = '#e84256'
theme.red2                 = '#dc1b33'
theme.green1               = '#00bf8a'
theme.green2               = '#008c65'
theme.yellow1              = '#fff176'
theme.yellow2              = '#ffeb3b'
theme.orange1              = '#ffa567'
theme.orange2              = '#ff8734'
theme.blue1                = '#9fc0df'
theme.blue2                = '#8cb3d9'
theme.blue3                = '#6699cc'
theme.magenta1             = '#fa75e2'
theme.magenta2             = '#f844d8'
theme.cyan1                = '#99eaea'
theme.cyan2                = '#00bbcc'
theme.white1               = '#ffffff'
theme.white2               = '#eaeaeb'

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
theme.cal_bg               = theme.blue1
theme.clock_fg             = theme.background
theme.clock_bg             = theme.blue1
theme.hotkeys_fg           = theme.foreground
theme.hotkeys_bg           = theme.background
theme.hotkeys_modifiers_fg = theme.blue2
theme.taglist_fg_empty     = theme.grey2
theme.taglist_bg_empty     = theme.background
theme.taglist_fg_focus     = theme.background
theme.taglist_bg_focus     = theme.blue2
theme.taglist_fg_occupied  = theme.blue2
theme.taglist_bg_occupied  = theme.background
theme.taglist_fg_urgent    = theme.white1
theme.taglist_bg_urgent    = theme.red2
theme.tasklist_fg_focus    = theme.red2
theme.tasklist_bg_urgent   = theme.red2
theme.titlebar_fg_focus    = theme.red2
theme.titlebar_fg_normal   = theme.red1
theme.gradient_1           = theme.red1
theme.gradient_2           = theme.blue2
theme.gradient_3           = theme.blue3
theme.tooltip_border_color = theme.grey2
theme.panel_fg             = theme.grey1

theme                      = theme_assets.recolor_layout(theme, theme.panel_fg)
theme                      = theme_assets.recolor_titlebar_normal(theme, theme.titlebar_fg_normal)
theme                      = theme_assets.recolor_titlebar_focus(theme, theme.titlebar_fg_focus)

--}}}

-- Theme icons {{{
theme.icon_theme            = home_dir .. "/.icons/Newaita-dark"
theme.tasklist_disable_icon = false

theme.awesome_icon          = theme_assets.awesome_icon( theme.menu_height, theme.bg_focus, theme.fg_focus )
theme.menu_submenu_icon     = "/usr/share/awesome/themes/default/submenu.png"

theme.layout_fairh          = theme_dir .. "/icons/layouts/fairh.png"
theme.layout_fairv          = theme_dir .. "/icons/layouts/fairv.png"
theme.layout_floating       = theme_dir .. "/icons/layouts/floating.png"
theme.layout_magnifier      = theme_dir .. "/icons/layouts/magnifier.png"
theme.layout_max            = theme_dir .. "/icons/layouts/max.png"
theme.layout_fullscreen     = theme_dir .. "/icons/layouts/fullscreen.png"
theme.layout_tilebottom     = theme_dir .. "/icons/layouts/tilebottom.png"
theme.layout_tileleft       = theme_dir .. "/icons/layouts/tileleft.png"
theme.layout_tile           = theme_dir .. "/icons/layouts/tile.png"
theme.layout_tiletop        = theme_dir .. "/icons/layouts/tiletop.png"
theme.layout_spiral         = theme_dir .. "/icons/layouts/spiral.png"
theme.layout_dwindle        = theme_dir .. "/icons/layouts/dwindle.png"
theme.layout_cornernw       = theme_dir .. "/icons/layouts/cornernw.png"
theme.layout_cornerne       = theme_dir .. "/icons/layouts/cornerne.png"
theme.layout_cornersw       = theme_dir .. "/icons/layouts/cornersw.png"
theme.layout_cornerse       = theme_dir .. "/icons/layouts/cornerse.png"

theme.titlebar_close_button_normal              = "/usr/share/awesome/themes/zenburn/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = "/usr/share/awesome/themes/zenburn/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal           = "/usr/share/awesome/themes/zenburn/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = "/usr/share/awesome/themes/zenburn/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive     = "/usr/share/awesome/themes/zenburn/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = "/usr/share/awesome/themes/zenburn/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = "/usr/share/awesome/themes/zenburn/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = "/usr/share/awesome/themes/zenburn/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive    = "/usr/share/awesome/themes/zenburn/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = "/usr/share/awesome/themes/zenburn/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = "/usr/share/awesome/themes/zenburn/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = "/usr/share/awesome/themes/zenburn/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive  = "/usr/share/awesome/themes/zenburn/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = "/usr/share/awesome/themes/zenburn/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = "/usr/share/awesome/themes/zenburn/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = "/usr/share/awesome/themes/zenburn/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/zenburn/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/zenburn/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = "/usr/share/awesome/themes/zenburn/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = "/usr/share/awesome/themes/zenburn/titlebar/maximized_focus_active.png"

--}}}

-- Collision settings {{{
theme.collision_resize_width = dpi(34)
theme.collision_resize_bg = theme.blue3
theme.collision_focus_bg = theme.blue3
theme.collision_focus_bg_center = theme.yellow1
-- }}}
return theme
--  vim: fdm=marker fdl=0
