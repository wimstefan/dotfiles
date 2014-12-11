--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
--  Awesome Minimal theme - based on Powerarrow theme by Rom Ockee   --
--  vim: fdm=marker fdl=0
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

green = "#B6E354"
cyan  = "#7F4DE6"
red   = "#E04613"
blue  = "#729FCF"
black = "#000000"
lgrey = "#EEEEEE"
dgrey = "#494949"
white = "#FFFFFF"

theme = {}

-- Theme settings {{{
theme.wallpaper                 = config_dir .. "/themes/wallpaper.png"
theme.border_width              = "4"
--}}}

-- Theme fonts {{{
theme.font                                  = "Terminal Dosis Bold 10"
theme.mono_font                             = "Envy Code R Bold 10"
--}}}

-- Theme colours {{{
theme.fg_normal                             = lgrey
theme.fg_focus                              = blue
theme.fg_em                                 = lgrey
theme.fg_urgent                             = white
theme.bg_normal                             = dgrey
theme.bg_focus                              = dgrey
theme.bg_em                                 = "#5C5C5C"
theme.bg_urgent                             = red
theme.border_normal                         = black
theme.border_focus                          = dgrey
theme.border_marked                         = "#CC9393"
theme.fg_widget_1                           = lgrey
theme.fg_widget_2                           = lgrey
theme.fg_widget_3                           = lgrey
theme.fg_widget_4                           = lgrey
theme.fg_widget_5                           = lgrey
theme.fg_widget_6                           = lgrey
theme.fg_widget_7                           = "#777E76"
theme.fg_widget_8                           = lgrey
theme.bg_widget_1                           = theme.bg_normal
theme.bg_widget_2                           = "#777E76"
theme.bg_widget_3                           = "#4B696D"
theme.bg_widget_4                           = "#4B3B51"
theme.bg_widget_5                           = "#D0785D"
theme.bg_widget_6                           = "#92B0A0"
theme.bg_widget_7                           = "#C2C2A4"
theme.bg_widget_8                           = "#777E76"
theme.fg_keydoc_option                      = green
theme.fg_keydoc_value                       = blue
theme.fg_keydoc_value_important             = lgrey
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

return theme


