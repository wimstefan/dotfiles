--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
--  Awesome Minimal theme - based on Powerarrow theme by Rom Ockee   --
--  vim: fdm=marker fdl=0
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

foreground = '#eceff1'
background = '#09212d'
cursor     = '#1c222e'

black1     = '#363636'
black2     = '#121212'
grey1      = '#696969'
grey2      = '#4f4f4f'
red1       = '#e05a72'
red2       = '#9c4252'
green1     = '#59b387'
green2     = '#387054'
green3     = '#3e515a'
green4     = '#2a373e'
yellow1    = '#ffffaf'
yellow2    = '#cccc8c'
orange1    = '#e6a15c'
orange2    = '#805f3f'
blue1      = '#5f87af'
blue2      = '#527496'
blue3      = '#335980'
magenta1   = '#aa7fff'
magenta2   = '#7759B3'
cyan1      = '#5fafaf'
cyan2      = '#5f8787'
white1     = '#ffffff'
white2     = '#cccccc'
white3     = '#808080'

theme = {}

-- Theme settings {{{
theme.wallpaper                 = wallpaper_dir .. "/default.jpg"
theme.border_width              = "3"
theme.menu_width                = "144"
--}}}

-- Theme fonts {{{
theme.font                                  = "Khand Bold 10"
theme.taglist_font                          = "Operator Mono Book Bold 10"
theme.mono_font                             = "Operator Mono Book 11"
--}}}

-- Theme colours {{{
theme.fg_normal                             = foreground
theme.bg_normal                             = green4
theme.fg_focus                              = red1
theme.bg_focus                              = green4
theme.fg_em                                 = grey1
theme.bg_em                                 = "#5C5C5C"
theme.fg_urgent                             = white1
theme.bg_urgent                             = red1
theme.border_normal                         = green4
theme.border_focus                          = green3
theme.border_marked                         = green1
theme.fg_widget_1                           = grey1
theme.bg_widget_1                           = theme.bg_normal
theme.fg_widget_2                           = grey1
theme.bg_widget_2                           = "#777E76"
theme.fg_widget_3                           = grey1
theme.bg_widget_3                           = "#4B696D"
theme.fg_widget_4                           = grey1
theme.bg_widget_4                           = "#4B3B51"
theme.fg_widget_5                           = grey1
theme.bg_widget_5                           = "#D0785D"
theme.fg_widget_6                           = grey1
theme.bg_widget_6                           = "#92B0A0"
theme.fg_widget_7                           = "#777E76"
theme.bg_widget_7                           = "#C2C2A4"
theme.fg_widget_8                           = grey1
theme.bg_widget_8                           = "#777E76"
theme.fg_keydoc_option                      = green1
theme.fg_keydoc_value                       = blue1
theme.fg_keydoc_value_important             = grey1
theme.taglist_fg_empty                      = cyan2
theme.taglist_bg_empty                      = green3
theme.taglist_fg_focus                      = green2
theme.taglist_bg_focus                      = white1
theme.taglist_fg_occupied                   = white2
theme.taglist_bg_occupied                   = green3
theme.taglist_fg_urgent                     = white1
theme.taglist_bg_urgent                     = red1
theme.gradient_1                            = red1
theme.gradient_2                            = blue3
theme.gradient_3                            = blue2
--}}}

-- Theme icons {{{
theme.awesome_icon                              = theme_dir .. "icons/awesome-icon.png"
-- theme.taglist_squares_sel                       = theme_dir .. "icons/square_sel.png"
-- theme.taglist_squares_unsel                     = theme_dir .. "icons/square_unsel.png"
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

theme.icon_theme = "Victory Icon Theme"

return theme
