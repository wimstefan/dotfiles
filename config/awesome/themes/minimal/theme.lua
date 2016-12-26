--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
--  Awesome Minimal theme - based on Powerarrow theme by Rom Ockee   --
--  vim: fdm=marker fdl=0
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

green  = "#b6e354"
cyan   = "#7f4de6"
red    = "#b64d60"
lred   = "#e05a72"
dred   = "#8f3949"
blue   = "#729fcf"
dblue1 = "#2a373e"
dblue2 = "#3e515a"
dblue3 = "#455a64"
dblue4 = "#4f6069"
black  = "#000000"
lgrey  = "#eeeeee"
dgrey  = "#060606"
white  = "#ffffff"

theme = {}

-- Theme settings {{{
theme.wallpaper                 = wallpaper_dir .. "/default.jpg"
theme.border_width              = "3"
theme.menu_width                = "144"
--}}}

-- Theme fonts {{{
theme.font                                  = "Khand 11"
theme.taglist_font                          = "Operator Mono Book Bold 10"
theme.mono_font                             = "Operator Mono Book 11"
--}}}

-- Theme colours {{{
theme.fg_normal                             = lgrey
theme.bg_normal                             = dblue1
theme.fg_focus                              = lred
theme.bg_focus                              = dblue1
theme.fg_em                                 = lgrey
theme.bg_em                                 = "#5C5C5C"
theme.fg_urgent                             = white
theme.bg_urgent                             = lred
theme.border_normal                         = dblue1
theme.border_focus                          = dblue2
theme.border_marked                         = dblue4
theme.fg_widget_1                           = lgrey
theme.bg_widget_1                           = theme.bg_normal
theme.fg_widget_2                           = lgrey
theme.bg_widget_2                           = "#777E76"
theme.fg_widget_3                           = lgrey
theme.bg_widget_3                           = "#4B696D"
theme.fg_widget_4                           = lgrey
theme.bg_widget_4                           = "#4B3B51"
theme.fg_widget_5                           = lgrey
theme.bg_widget_5                           = "#D0785D"
theme.fg_widget_6                           = lgrey
theme.bg_widget_6                           = "#92B0A0"
theme.fg_widget_7                           = "#777E76"
theme.bg_widget_7                           = "#C2C2A4"
theme.fg_widget_8                           = lgrey
theme.bg_widget_8                           = "#777E76"
theme.fg_keydoc_option                      = green
theme.fg_keydoc_value                       = blue
theme.fg_keydoc_value_important             = lgrey
theme.taglist_fg_empty                      = dgrey
theme.taglist_bg_empty                      = dblue2
theme.taglist_fg_focus                      = dgrey
theme.taglist_bg_focus                      = white
theme.taglist_fg_occupied                   = dgrey
theme.taglist_bg_occupied                   = dblue2
theme.taglist_fg_urgent                     = white
theme.taglist_bg_urgent                     = lred
theme.gradient_1                            = lred
theme.gradient_2                            = dblue4
theme.gradient_3                            = dblue3
--}}}

-- Theme icons {{{
theme.awesome_icon                              = theme_dir .. "icons/awesome-icon.png"
theme.taglist_squares_sel                       = theme_dir .. "icons/square_sel.png"
theme.taglist_squares_unsel                     = theme_dir .. "icons/square_unsel.png"
theme.layout_floating                           = theme_dir .. "icons/floating.png"
theme.layout_tile                               = theme_dir .. "icons/tile.png"
theme.layout_tileleft                           = theme_dir .. "icons/tileleft.png"
theme.layout_tilebottom                         = theme_dir .. "icons/tilebottom.png"
theme.layout_tiletop                            = theme_dir .. "icons/tiletop.png"
theme.arr1                                      = theme_dir .. "icons/arr1.png"
theme.arr2                                      = theme_dir .. "icons/arr2.png"
theme.arr3                                      = theme_dir .. "icons/arr3.png"
theme.arr4                                      = theme_dir .. "icons/arr4.png"
theme.arr5                                      = theme_dir .. "icons/arr5.png"
theme.arr6                                      = theme_dir .. "icons/arr6.png"
theme.arr7                                      = theme_dir .. "icons/arr7.png"
theme.arr8                                      = theme_dir .. "icons/arr8.png"
theme.arr9                                      = theme_dir .. "icons/arr9.png"
theme.arr0                                      = theme_dir .. "icons/arr0.png"
--}}}

theme.icon_theme = "Numix"

return theme
