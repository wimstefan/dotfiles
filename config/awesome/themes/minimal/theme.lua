    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
--{{  Awesome Powerarrow theme by Rom Ockee - based on Awesome Zenburn and Need_Aspirin themes }}---
    --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

green = "#7fb219"
cyan  = "#7f4de6"
red   = "#e04613"
lblue = "#6c9eab"
dblue = "#00ccff"
black = "#3f3f3f"
lgrey = "#d2d2d2"
dgrey = "#333333"
white = "#ffffff"

theme = {}

theme.wallpaper = config_dir .. "/themes/wallpaper.png"

theme.font                                  = "Alegreya Sans Bold 10"
theme.mono_font                             = "Envy Code R Bold 9"
theme.fg_normal                             = "#AAAAAA"
theme.fg_focus                              = "#F0DFAF"
theme.fg_em                                 = "#D6D6D6"
theme.fg_urgent                             = "white"
theme.bg_normal                             = "#222222"
theme.bg_focus                              = "#1E2320"
theme.bg_em                                 = "#5C5C5C"
theme.bg_urgent                             = red
theme.border_width                          = "0"
theme.border_normal                         = "#3F3F3F"
theme.border_focus                          = "#6F6F6F"
theme.border_marked                         = "#CC9393"
theme.titlebar_bg_focus                     = "#3F3F3F"
theme.titlebar_bg_normal                    = "#3F3F3F"
theme.fg_widget_1                           = "#EEEEEE"
theme.fg_widget_2                           = "#EEEEEE"
theme.fg_widget_3                           = "#EEEEEE"
theme.fg_widget_4                           = "#EEEEEE"
theme.fg_widget_5                           = "#EEEEEE"
theme.fg_widget_6                           = "#EEEEEE"
theme.fg_widget_7                           = "#777E76"
theme.fg_widget_8                           = "#EEEEEE"
theme.bg_widget_1                           = theme.bg_normal
theme.bg_widget_2                           = "#777E76"
theme.bg_widget_3                           = "#4B696D"
theme.bg_widget_4                           = "#4B3B51"
theme.bg_widget_5                           = "#D0785D"
theme.bg_widget_6                           = "#92B0A0"
theme.bg_widget_7                           = "#C2C2A4"
theme.bg_widget_8                           = "#777E76"
-- theme.taglist_bg_focus                      = black
theme.taglist_fg_focus                      = white
theme.tasklist_bg_focus                     = "#222222"
theme.tasklist_fg_focus                     = white
theme.textbox_widget_as_label_font_color    = white
theme.textbox_widget_margin_top             = 1
theme.text_font_color_1                     = green
theme.text_font_color_2                     = dblue
theme.text_font_color_3                     = white
theme.notify_font_color_1                   = green
theme.notify_font_color_2                   = dblue
theme.notify_font_color_3                   = black
theme.notify_font_color_4                   = white
theme.notify_font                           = "Cousine 9"
theme.notify_fg                             = theme.fg_normal
theme.notify_bg                             = theme.bg_normal
theme.notify_border                         = theme.border_focus
theme.awful_widget_bckgrd_color             = dgrey
theme.awful_widget_border_color             = dgrey
theme.awful_widget_color                    = dblue
theme.awful_widget_gradien_color_1          = orange
theme.awful_widget_gradien_color_2          = orange
theme.awful_widget_gradien_color_3          = orange
theme.awful_widget_height                   = 11
theme.awful_widget_margin_top               = 0

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
-- theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
-- theme.fg_widget        = "#AECF96"
-- theme.fg_center_widget = "#88A175"
-- theme.fg_end_widget    = "#FF5656"
-- theme.bg_widget        = "#494B4F"
-- theme.border_widget    = "#3F3F3F"
theme.fg_widget_clock                       = "#B6E354"
theme.fg_widget_value                       = "#729FCF"
theme.fg_widget_value_important             = theme.fg_em

theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]

-- theme.menu_bg_normal    = ""
-- theme.menu_bg_focus     = ""
-- theme.menu_fg_normal    = ""
-- theme.menu_fg_focus     = ""
-- theme.menu_border_color = ""
-- theme.menu_border_width = ""
theme.menu_height       = "16"
theme.menu_width        = "140"

--{{--- Theme icons ------------------------------------------------------------------------------------------

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

--{{----------------------------------------------------------------------------

return theme


