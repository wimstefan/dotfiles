---------------------------
-- My awesome theme --
---------------------------
local default_icons = "/usr/share/awesome/themes/default"

theme = {}

theme.wallpaper = wallpaper_dir .. "/default.jpg"
theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"
--theme.font          = "Archivo Narrow Bold 10"
theme.font          = "Terminal Dosis Bold 10"
theme.mono_font     = "Cousine 9"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444448"
theme.bg_tooltip    = theme.fg_em
theme.bg_em         = "#5c5c5c"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"
theme.fg_tooltip    = "#1a1a1a"
theme.fg_em         = "#d6d6d6"

theme.border_width  = 1
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"
theme.border_urgent = "#ffffff"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = default_icons .. "/taglist/squarefw.png"
theme.taglist_squares_unsel = default_icons .. "/taglist/squarew.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
--theme.menu_submenu_icon = default_icons .. "/submenu.png"
theme.menu_submenu_icon = icon_path .. "/dots.png"
theme.menu_height = 18
theme.menu_width  = 160

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"
theme.fg_widget_clock = "#b6e354"
theme.fg_widget_value = "#729fcf"
theme.fg_widget_value_important = theme.fg_em

-- Define the image to load
theme.titlebar_close_button_normal = default_icons .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = default_icons .. "/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = default_icons .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = default_icons .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = default_icons .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = default_icons .. "/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = default_icons .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = default_icons .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = default_icons .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = default_icons .. "/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = default_icons .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = default_icons .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = default_icons .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = default_icons .. "/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = default_icons .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = default_icons .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = default_icons .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = default_icons .. "/titlebar/maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh = default_icons .. "/layouts/fairhw.png"
theme.layout_fairv = default_icons .. "/layouts/fairvw.png"
theme.layout_floating  = default_icons .. "/layouts/floatingw.png"
theme.layout_magnifier = default_icons .. "/layouts/magnifierw.png"
theme.layout_max = default_icons .. "/layouts/maxw.png"
theme.layout_fullscreen = default_icons .. "/layouts/fullscreenw.png"
theme.layout_tilebottom = default_icons .. "/layouts/tilebottomw.png"
theme.layout_tileleft   = default_icons .. "/layouts/tileleftw.png"
theme.layout_tile = default_icons .. "/layouts/tilew.png"
theme.layout_tiletop = default_icons .. "/layouts/tiletopw.png"
theme.layout_spiral  = default_icons .. "/layouts/spiralw.png"
theme.layout_dwindle = default_icons .. "/layouts/dwindlew.png"
theme.layout_treesome  = default_icons .. "/layouts/spiralw.png"


theme.blingbling = {
    htop_font = "Cousin 9",
    htop_title_color = "#ff0000",
    htop_user_color = "#e4e4e4",
    htop_root_color = "#ee2c2c"
}

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Clarity"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
