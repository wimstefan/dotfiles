--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
-- Adapted theme - inspired by the Adapta GTK theme                 ---
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

theme      = {}

-- Theme settings {{{
theme.wallpaper            = wallpaper_dir .. "/default.jpg"
theme.border_width         = "3"
theme.menu_height          = "14"
theme.menu_width           = "144"

theme.useless_gap          = "8"

theme.tooltip_align        = "bottom"
theme.tooltip_border_width = "0"
--}}}

-- Theme fonts {{{
theme.font                 = "Khand SemiBold 10"
theme.serif_font           = "Input Serif Compressed Bold 9"
theme.mono_font            = "Operator Mono Medium 9"
theme.taglist_font         = "Operator Mono Medium 10"
theme.tasklist_font        = "Kanit SemiBold 8"
theme.icon_font            = "Webhostinghub-Glyphs 8"
theme.hotkeys_font         = "Input Mono Compressed Bold 9"
theme.hotkeys_description_font = "Input Mono Compressed 9"
--}}}

-- Theme colours {{{
theme.foreground           = '#eceff1'
theme.background           = '#09212d'
theme.cursor               = '#1c222e'

theme.black1               = '#363636'
theme.black2               = '#121212'
theme.grey1                = '#696969'
theme.grey2                = '#4f4f4f'
theme.red1                 = '#e05a72'
theme.red2                 = '#9c4252'
theme.green1               = '#59b387'
theme.green2               = '#387054'
theme.green3               = '#3e515a'
theme.green4               = '#2a373e'
theme.yellow1              = '#ffffaf'
theme.yellow2              = '#cccc8c'
theme.orange1              = '#e6a15c'
theme.orange2              = '#805f3f'
theme.blue1                = '#5f87af'
theme.blue2                = '#527496'
theme.blue3                = '#335980'
theme.magenta1             = '#aa7fff'
theme.magenta2             = '#7759B3'
theme.cyan1                = '#5fafaf'
theme.cyan2                = '#5f8787'
theme.white1               = '#ffffff'
theme.white2               = '#cccccc'
theme.white3               = '#808080'

theme.fg_normal            = theme.foreground
theme.bg_normal            = theme.green4
theme.fg_focus             = theme.red1
theme.bg_focus             = theme.green4
theme.fg_em                = theme.grey1
theme.bg_em                = theme.grey2
theme.fg_urgent            = theme.white1
theme.bg_urgent            = theme.red1
theme.border_normal        = theme.green4
theme.border_focus         = theme.green3
theme.border_marked        = theme.green1
theme.taglist_fg_empty     = theme.cyan2
theme.taglist_bg_empty     = theme.green3
theme.taglist_fg_focus     = theme.green2
theme.taglist_bg_focus     = theme.white1
theme.taglist_fg_occupied  = theme.white2
theme.taglist_bg_occupied  = theme.green3
theme.taglist_fg_urgent    = theme.white1
theme.taglist_bg_urgent    = theme.red1
theme.gradient_1           = theme.red1
theme.gradient_2           = theme.blue3
theme.gradient_3           = theme.blue2
theme.tooltip_border_color = theme.grey2

theme.hotkeys_modifiers_fg = theme.blue1
--}}}

-- Theme icons {{{
theme.tasklist_disable_icon = false

theme.awesome_icon          = "/usr/share/awesome/icons/awesome16.png"
theme.menu_submenu_icon     = "/usr/share/awesome/themes/default/submenu.png"

theme.layout_fairh          = "/usr/share/awesome/themes/default/layouts/fairhw.png"
theme.layout_fairv          = "/usr/share/awesome/themes/default/layouts/fairvw.png"
theme.layout_floating       = "/usr/share/awesome/themes/default/layouts/floatingw.png"
theme.layout_magnifier      = "/usr/share/awesome/themes/default/layouts/magnifierw.png"
theme.layout_max            = "/usr/share/awesome/themes/default/layouts/maxw.png"
theme.layout_fullscreen     = "/usr/share/awesome/themes/default/layouts/fullscreenw.png"
theme.layout_tilebottom     = "/usr/share/awesome/themes/default/layouts/tilebottomw.png"
theme.layout_tileleft       = "/usr/share/awesome/themes/default/layouts/tileleftw.png"
theme.layout_tile           = "/usr/share/awesome/themes/default/layouts/tilew.png"
theme.layout_tiletop        = "/usr/share/awesome/themes/default/layouts/tiletopw.png"
theme.layout_spiral         = "/usr/share/awesome/themes/default/layouts/spiralw.png"
theme.layout_dwindle        = "/usr/share/awesome/themes/default/layouts/dwindlew.png"
theme.layout_cornernw       = "/usr/share/awesome/themes/default/layouts/cornernww.png"
theme.layout_cornerne       = "/usr/share/awesome/themes/default/layouts/cornernew.png"
theme.layout_cornersw       = "/usr/share/awesome/themes/default/layouts/cornersww.png"
theme.layout_cornerse       = "/usr/share/awesome/themes/default/layouts/cornersew.png"

theme.titlebar_close_button_normal              = "/usr/share/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = "/usr/share/awesome/themes/default/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal           = "/usr/share/awesome/themes/default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = "/usr/share/awesome/themes/default/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive     = "/usr/share/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = "/usr/share/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = "/usr/share/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = "/usr/share/awesome/themes/default/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive    = "/usr/share/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = "/usr/share/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = "/usr/share/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = "/usr/share/awesome/themes/default/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive  = "/usr/share/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = "/usr/share/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = "/usr/share/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = "/usr/share/awesome/themes/default/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "/usr/share/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = "/usr/share/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = "/usr/share/awesome/themes/default/titlebar/maximized_focus_active.png"

--}}}

-- Collision settings {{{
theme.collision_resize_width = "34"
theme.collision_resize_bg = theme.blue2
theme.collision_focus_bg = theme.blue2
theme.collision_focus_bg_center = theme.yellow1
-- }}}
return theme
--  vim: fdm=marker fdl=0
