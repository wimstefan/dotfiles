-- my awesome config
-- vim: fdm=marker fdl=0 tw=200

print("Reading rc.lua: "..os.date())

-- Standard awesome library
local gears       = require("gears")
local awful       = require("awful")
awful.rules       = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox       = require("wibox")
local menubar     = require("menubar")
-- Vicious library
vicious           = require("vicious")
vicious.contrib   = require("vicious.contrib")
-- Theme handling library
local beautiful   = require("beautiful")
-- Notification library
local naughty     = require("naughty")

-- Basic configuration {{{1
hostname          = io.lines("/proc/sys/kernel/hostname")()
if hostname == 'tj' then
  TYPE    = "laptop"
  BAT     = "BAT0"
  SYSTEMP = "coretemp.0/hwmon/hwmon1"
elseif hostname == 'mimi' then
  TYPE    = "laptop"
  BAT     = "BAT1"
  SYSTEMP = "coretemp.0/hwmon/hwmon1"
elseif hostname == 'asuca' then
  TYPE    = "laptop"
elseif hostname == 'swimmer' or hostname == 'komala' then
  TYPE    = "desktop"
  SYSTEMP = "coretemp.0/hwmon/hwmon0"
end

home_dir          = os.getenv("HOME")
config_dir        = awful.util.getdir("config")
theme_dir         = config_dir.."/themes/minimal/"
wallpaper_dir     = home_dir.."/system/wallpapers/"
icon_path         = config_dir.."/icons/"

terminal          = "termite"
if terminal == 'pangoterm' or terminal == 'termite' then
  TITLE = " --title="
  NAME  = " --name="
  GEO   = " --geometry="
else
  TITLE = " -title "
  NAME  = " -name "
  GEO   = " -geometry "
end
browser           = os.getenv("BROWSER") or "firefox-bin"
editor            = os.getenv("EDITOR") or "gvim"
musicplr1         = terminal..TITLE.."'Music'"..GEO.."130x34-320+16 -e ncmpcpp"
musicplr2         = terminal..TITLE.."'Music'"..GEO.."130x34-320+16 -e mocp"
mixer             = terminal..TITLE.."'Music'"..GEO.."130x34-320+16 -e alsamixer"
iptraf            = terminal..TITLE.."'IP traffic monitor'"..GEO.."160x44-20+34 -e 'sudo iptraf-ng -i all'"
mytop             = terminal..TITLE.."'Htop'"..GEO.."160x44-20+34 -e htop"
editor_cmd        = "gvim"
modkey            = "Mod4"
altkey            = "Mod1"

timeout_tooltip   = 1

beautiful.init(theme_dir.."theme.lua")
if beautiful.wallpaper then
  gears.wallpaper.maximized(beautiful.wallpaper, 1, true)
end

local layouts =
{
    -- awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.magnifier,
    awful.layout.suit.max,                --1
    awful.layout.suit.floating,           --2
    awful.layout.suit.fair               --3
}

tags = awful.tag({ "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒" }, 1, layouts[1])
--}}}

-- Error handling {{{1
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- Functions {{{1
-- Load additional LUA files from rc/lib {{{2
function loadrc(name, mod)
   local success
   local result

   -- Which file? In rc/ or in lib/?
   local path = config_dir.."/".. (mod and "lib" or "rc").. "/"..name..".lua"

   -- If the module is already loaded, don't load it again
   if mod and package.loaded[mod] then return package.loaded[mod] end

   -- Execute the RC/module file
   success, result = pcall(function() return dofile(path) end)
   if not success then
      naughty.notify({ title = "Error while loading an RC file",
           text = "When loading `"..name.. "`, got the following error:\n"..result,
           preset = naughty.config.presets.critical
         })
      return print("E: error loading RC file '"..name.."': "..result)
   end

   -- Is it a module?
   if mod then
      return package.loaded[mod]
   end

   return result
end
-- }}}
 
-- Table utils {{{2
function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end
-- }}}

-- Conky HUD {{{2
function get_conky()
    local clients = client.get()
    local conky = nil
    local i = 1
    while clients[i]
    do
        if clients[i].class == "Conky"
        then
            conky = clients[i]
        end
        i = i + 1
    end
    return conky
end
function raise_conky()
    local conky = get_conky()
    if conky
    then
        conky.ontop = true
    end
end
function lower_conky()
    local conky = get_conky()
    if conky
    then
        conky.ontop = false
    end
end
function toggle_conky()
    local conky = get_conky()
    if conky
    then
        if conky.ontop
        then
            conky.ontop = false
        else
            conky.ontop = true
        end
    end
end
-- }}}

-- Awesome restart {{{2
function save_tag()
  local screen = mouse.screen
  local curtag = awful.tag.getidx(awful.tag.selected(screen))
  local f = io.open( config_dir.."/tag.id", 'w+')
  f:write(curtag)
  f:close()
end

function restore_tag()
  local f = io.open( config_dir.."/tag.id", 'r')
  local lasttag = f:read("*all")
  f:close()
  awful.tag.viewidx(lasttag)
  awful.tag.viewprev()
end
-- }}}

-- Wallpaper changer {{{2
local wallmenu = {}
local function wall_load(wall)
  local f = io.popen('ln -sfn '..wallpaper_dir..wall..' '..config_dir..'/themes/wallpaper.png')
  awesome.restart()
end
local function wall_menu()
  local f = io.popen('ls -1 '..wallpaper_dir)
  for l in f:lines() do
    local item = { l, function () wall_load(l) end }
    table.insert(wallmenu, item)
  end
  f:close()
end
wall_menu()
-- }}}
--}}}

-- Popups & widgets
local scratch     = require("scratch")
local keydoc      = loadrc("keydoc", "vbe/keydoc")
local cal         = loadrc("cal")

-- Menu {{{1
require("freedesktop.utils")
-- menu configuration
freedesktop.utils.terminal = terminal

-- applications menu
freedesktop.utils.icon_theme = { 'Vertix.git', 'Numix' }
require("freedesktop.menu")
menu_items = freedesktop.menu.new()
myawesomemenu = {
   { "manual", terminal.." -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help' }) },
   { "edit config", editor_cmd.." "..config_dir.."/rc.lua", freedesktop.utils.lookup_icon({ icon = 'package_settings' }) },
   { "restart", awesome.restart, freedesktop.utils.lookup_icon({ icon = 'gtk-refresh' }) },
   { "quit", awesome.quit, freedesktop.utils.lookup_icon({ icon = 'gtk-quit' }) }
}
table.insert(menu_items, { "awesome", myawesomemenu, beautiful.awesome_icon })
table.insert(menu_items, { "wallpaper", wallmenu, freedesktop.utils.lookup_icon({ icon = 'gnome-settings-background' })})

mymainmenu = awful.menu.new({ items = menu_items, height = 800 })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                   menu = mymainmenu })

-- desktop icons
require("freedesktop.desktop")
freedesktop.desktop.add_applications_icons({screen = 1, showlabels = true})
freedesktop.desktop.add_dirs_and_files_icons({screen = 1, showlabels = true})

--}}}

-- Wibox {{{1

local stats_grad = { type = "linear", from = { 0, 0 }, to = { 0, 18 }, stops = { { 0, "#A52A2A" }, { 0.5, beautiful.bg_widget_6 }, { 1, "#92B0A0" } } }

-- Music widget {{{2
local widget_music = wibox.widget.textbox()
vicious.register(widget_music, vicious.widgets.volume,
  '<span background="'..beautiful.bg_widget_1..'"><span color="'..beautiful.fg_widget_1..'">  $2  $1%  </span></span>', 144, "Master")
widget_music:buttons(awful.util.table.join(
  awful.button({ }, 1, function () awful.util.spawn_with_shell(mixer) end),
  awful.button({ modkey }, 1, function () awful.util.spawn_with_shell(musicplr1) end),
  awful.button({ altkey }, 1, function () awful.util.spawn_with_shell(musicplr2) end)))
-- Music widget }}}

-- Memory widget {{{2
vicious.cache(vicious.widgets.mem)
local widget_mem = wibox.layout.fixed.horizontal()
local widget_mem_text = wibox.widget.textbox()
local tooltip_mem

vicious.register(widget_mem_text, vicious.widgets.mem,
  '<span background="'..beautiful.bg_widget_2..'"> <span color="'..beautiful.fg_widget_2..'"><span font="whhglyphs 8"></span>  $2MB   </span></span>', 10)

tooltip_mem = awful.tooltip({ objects = { widget_mem }, timeout = timeout_tooltip, timer_function = function()
  local info_mem = vicious.widgets.mem()
  local title = "memory &amp; swap usage"
  local tlen = string.len(title)
  local text
  text = ' <span font="'..beautiful.mono_font..'">'..
         ' <span weight="bold" color="'..beautiful.fg_normal..'">'..title..'</span> \n'..
         ' <span weight="bold">'..string.rep("-", tlen)..'</span> \n'..
         ' ◌ memory <span color="'..beautiful.fg_normal..'">'..info_mem[2]..'/'..info_mem[3]..'</span> MB \n'..
         ' ○ swap   <span color="'..beautiful.fg_normal..'">'..info_mem[6]..'/'..info_mem[7]..'</span> MB </span>'
   return text
 end})

widget_mem:add(widget_mem_text)
-- Memory widget }}}

-- CPU widget {{{2
vicious.cache(vicious.widgets.cpu)
local widget_cpu = wibox.layout.fixed.horizontal()
local widget_cpu_text = wibox.widget.textbox()
local widget_cpu_graph = awful.widget.graph()
local tooltip_cpu

vicious.register(widget_cpu_text, vicious.widgets.cpu,
  '<span background="'..beautiful.bg_widget_3..'"> <span color="'..beautiful.fg_widget_3..'"><span font="whhglyphs 8"></span>  $1% </span></span>', 4)
widget_cpu_text:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn_with_shell(mytop) end)))

widget_cpu_graph:set_width(20)
widget_cpu_graph:set_background_color(beautiful.bg_widget_3)
widget_cpu_graph:set_color(stats_grad)
widget_cpu_graph:set_border_color(beautiful.bg_widget_3)
vicious.register(widget_cpu_graph, vicious.widgets.cpu, "$1", 3)

tooltip_cpu = awful.tooltip({ objects = { widget_cpu }, timeout = timeout_tooltip, timer_function = function()
  info_cpu = vicious.widgets.cpu()
  local title = "cpu usage"
  local tlen = string.len(title)
  local text
  text = ' <span font="'..beautiful.mono_font..'">'..
         ' <span weight="bold" color="'..beautiful.fg_normal..'">'..title..'</span> \n'..
         ' <span weight="bold">'..string.rep("-", tlen)..'</span> \n'
  for core = 2, #info_cpu do
    text = text..' ◈ core'..(core-1)..' <span color="'..beautiful.fg_normal..'">'..info_cpu[core]..'</span> % '
    if core < #info_cpu then
      text = text..'\n'
    end
  end
  text = text..'</span>'
  return text
end})

widget_cpu:add(widget_cpu_text)
widget_cpu:add(widget_cpu_graph)
-- CPU widget }}}

-- Temperature widget {{{2
local widget_temp = wibox.layout.fixed.horizontal()
local widget_temp_cpu = wibox.widget.textbox()

vicious.register(widget_temp_cpu, vicious.widgets.thermal,
  '<span background="'..beautiful.bg_widget_4..'"> <span color="'..beautiful.fg_widget_4..'"><span font="whhglyphs 8"></span> $1°  </span></span>', 9, { SYSTEMP, "core"} )
widget_temp_cpu:buttons(awful.util.table.join(
    awful.button({ }, 1, function () toggle_conky() end)))

widget_temp:add(widget_temp_cpu)
-- Temperature widget }}}

-- Filesystem widget {{{2
vicious.cache(vicious.widgets.fs)
local widget_hdd = wibox.layout.fixed.horizontal()
local widget_hdd_text = wibox.widget.textbox()
local tooltip_hdd

vicious.register(widget_hdd_text, vicious.widgets.fs,
  '<span background="'..beautiful.bg_widget_5..'"><span color="'..beautiful.fg_widget_5..'"><span font="whhglyphs 8"></span>  ${/ used_gb} GB  </span></span>', 244)

tooltip_hdd = awful.tooltip({ objects = { widget_hdd } , timeout = timeout_tooltip, timer_function = function()
  local info_hdd = vicious.widgets.fs()
  local title = "harddisk information"
  local tlen = string.len(title)
  local text
  text = ' <span font="'..beautiful.mono_font..'">'..
         ' <span weight="bold" color="'..beautiful.fg_normal..'">'..title..'</span> \n'..
         ' <span weight="bold">'..string.rep('-', tlen)..'</span> \n'..
         ' ⛁ on / <span color="'..beautiful.fg_normal..'">'..
         info_hdd['{/ used_p}']..'%  '..
         info_hdd['{/ used_gb}']..'/'..
         info_hdd['{/ size_gb}']..'</span> GB</span> '
  return text
end})

widget_hdd:add(widget_hdd_text)
-- Filesystem widget }}}

-- Battery/AC widget {{{2
local widget_bat
if BAT then
  widget_bat = wibox.layout.fixed.horizontal()
  vicious.cache(vicious.widgets.bat)
  local widget_bat_text = wibox.widget.textbox()
  local tooltip_bat

  vicious.register(widget_bat_text, vicious.widgets.bat,
    '<span background="'..beautiful.bg_widget_6..'"> <span color="'..beautiful.fg_widget_6..'"><span font="whhglyphs 8"></span>  $1$2%  </span></span>', 14, BAT )

  tooltip_bat = awful.tooltip({ objects = { widget_bat }, timeout = timeout_tooltip, timer_function = function()
    local info_bat = vicious.widgets.bat(widget, BAT)
    local title = "battery information"
    local tlen = string.len(title)
    local text
    text = ' <span font="'..beautiful.mono_font..'">'..
           ' <span weight="bold" color="'..beautiful.fg_normal..'">'..title..'</span> \n'..
           ' <span weight="bold">'..string.rep('-', tlen)..'</span> \n'
    if info_bat[1] == '-' then
      text = text..' ⚫ status    <span color="'..beautiful.fg_normal..'">discharging</span>\n'
    elseif info_bat[1] == '↯' then
      text = text..' ⚫ status    <span color="'..beautiful.fg_normal..'">charged</span>\n'
    else
      text = text..' ⚫ status    <span color="'..beautiful.fg_normal..'">charging</span>\n'
    end
    text = text..' ⚡ charge    <span color="'..beautiful.fg_normal..'">'..info_bat[2]..'% </span>\n'..
                 ' ◴ time left <span color="'..beautiful.fg_normal..'">'..info_bat[3]..' </span>'
    text = text..'</span>'
    return text
  end})

  widget_bat:add(widget_bat_text)
end

local widget_ac = wibox.widget.textbox('<span background="'..beautiful.bg_widget_6..'"> <span color="'..beautiful.fg_widget_6..'"><span font="whhglyphs 8"></span> AC  </span></span>')
-- Battery widget }}}

-- Net widget {{{2
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, function(widgets,args)
        if args["{wlan0 carrier}"] == 1 then
                interface = "wlan0"
        elseif args["{eth0 carrier}"] == 1 then
                interface = "eth0"
        else
                return ""
        end
        return '<span background="'..beautiful.bg_widget_7..'"><span color="'..beautiful.fg_widget_7..'" font="whhglyphs 8"></span>  '
           ..'<span color="#A52A2A">'..args["{"..interface.." down_kb}"]..'</span>'
           ..'<span font="Symbola 10" color="'..beautiful.fg_widget_7..'"> 🔃 </span>'
           ..'<span color="#185A9F">'..args["{"..interface.." up_kb}"]..'   </span></span>' end, 6)
netwidget:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(iptraf) end)))
-- Net widget }}}

-- Calendar/time widget {{{2
mytextclock = awful.widget.textclock( '<span background="#777E76" color="#FFFFFF">%a %b %d, %H:%M</span>')
cal.register(mytextclock)
-- }}}

-- Separator widgets {{{2
spr = wibox.widget.textbox(' ')
sprd = wibox.widget.textbox('<span background="#313131">  </span>')
spr3f = wibox.widget.textbox('<span background="#777e76">   </span>')
arr0 = wibox.widget.imagebox(beautiful.arr0)
arr1 = wibox.widget.imagebox(beautiful.arr1)
arr2 = wibox.widget.imagebox(beautiful.arr2)
arr3 = wibox.widget.imagebox(beautiful.arr3)
arr4 = wibox.widget.imagebox(beautiful.arr4)
arr5 = wibox.widget.imagebox(beautiful.arr5)
arr6 = wibox.widget.imagebox(beautiful.arr6)
arr7 = wibox.widget.imagebox(beautiful.arr7)
arr8 = wibox.widget.imagebox(beautiful.arr8)
arr9 = wibox.widget.imagebox(beautiful.arr9)
-- }}}

-- Create a wibox for each screen and add it {{{2
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=550 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

    -- Create a promptbox for each screen
    mypromptbox[1] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[1] = awful.widget.layoutbox(s)
    mylayoutbox[1]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[1] = awful.widget.taglist(1, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[1] = awful.widget.tasklist(1, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[1] = awful.wibox({ position = "top", height = 16 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[1])
    left_layout:add(mypromptbox[1])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(wibox.widget.systray())
    right_layout:add(widget_music)
    right_layout:add(arr8)
    right_layout:add(widget_mem)
    right_layout:add(arr7)
    right_layout:add(widget_cpu)
    right_layout:add(arr6)
    right_layout:add(widget_temp)
    right_layout:add(arr5)
    right_layout:add(widget_hdd)
    right_layout:add(arr4)
    if BAT then
      right_layout:add(widget_bat)
    else
      right_layout:add(widget_ac)
    end
    right_layout:add(arr3)
    right_layout:add(netwidget)
    right_layout:add(arr2)
    right_layout:add(spr3f)
    right_layout:add(mytextclock)
    right_layout:add(spr3f)
    right_layout:add(arr1)
    right_layout:add(mylayoutbox[1])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[1])
    layout:set_right(right_layout)

    mywibox[1]:set_widget(layout)
-- }}}
--}}}

-- Mouse bindings {{{1
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
--}}}

-- Key bindings {{{1
globalkeys = awful.util.table.join(
    keydoc.group("02. Navigation"),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       , "Goto next tag"),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       , "Goto previous tag"),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore, "Goto last tag"),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
          end, "Focus next client"),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end, "Focus previous client"),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto, "Focus highlighted client"),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end, "Focus last client"),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey, "Control" }, "n", awful.client.restore, "Restore client"),

    -- Layout manipulation
    keydoc.group("03. Layout"),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end, "Switch client with next client"),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end, "Switch client with previous client"),

    --awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    --awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end, "Increase number of master windows by 1"),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end, "Decrease number of master windows by 1"),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end, "Increase number of columns for non-master windows by 1"),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end, "Decrease number of columns for non-master windows by 1"),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end, "Switch to next layout"),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end, "Switch to previous layout"),


    -- WM control
    keydoc.group("01. Control"),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end, "Show menu"),
    awful.key({ modkey, "Shift"   }, "p", function() menubar.show() end, "Draw menu bar"),
    --awful.key({ modkey,           }, "r",     function () mypromptbox[mouse.screen]:run() end, "Run prompt"),
    awful.key({ modkey,           }, "r", function () awful.util.spawn("rofi -modi 'run,window,ssh' -show run") end, "Run dialog"),
    awful.key({ modkey, "Control" }, "r", awesome.restart, "Restart awesome"),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit, "Quit awesome"),

    -- Applications
    keydoc.group("05. Applications"),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end, "Open a terminal"),
    awful.key({ modkey,           }, "a", function () awful.util.spawn("audacity") end, "Audacity"),
    awful.key({ modkey,           }, "b", function () awful.util.spawn(browser) end, "Browser"),
    awful.key({ modkey            }, "c", function () scratch.drop(terminal ..TITLE.."'Calculator' -e wcalc","top","right",290,300) end, "Calculator"),
    awful.key({ modkey,           }, "d", function () awful.util.spawn("darktable") end, "Darktable"),
    awful.key({ modkey,           }, "e", function () awful.util.spawn(editor_cmd) end, "Editor"),
    awful.key({ modkey,           }, "g", function () awful.util.spawn("gimp") end, "Gimp"),
    awful.key({ modkey,           }, "l", function () awful.util.spawn("libreoffice") end, "Libreoffice"),
    awful.key({ modkey,           }, "m", function () scratch.drop(terminal ..TITLE.."'Explore' -e mc","top","right",1200,800) end, "Explore"),
    awful.key({ modkey,           }, "o", function () awful.util.spawn("opera") end, "Opera"),
    awful.key({ modkey,           }, "p", function () awful.util.spawn("puddletag") end, "Puddletag"),
    awful.key({ modkey,           }, "s", function () scratch.drop(terminal ..TITLE.."'Drop-down terminal'","top","left",1200,800) end, "Drop-down terminal"),
    awful.key({ modkey,           }, "t", function () awful.util.spawn("thunderbird") end, "Thunderbird"),

    -- Miscellaneous stuff
    keydoc.group("06. Misc"),
    -- Print screen
    awful.key({                   }, "Print", function() awful.util.spawn("screengrab") end, "Print screen"),

    -- Conky HUD
    awful.key({                   }, "Pause", function() toggle_conky() end, "Conky popup"),

    -- Key documentation
    awful.key({ modkey,           }, "F1", function() keydoc.display() end, "Show all keys")

)

clientkeys = awful.util.table.join(
    keydoc.group("04. Clients"),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end, "Fullscreen"),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end, "Kill client"),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     , "Toggle client floating status"),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end, "Swap current slave with master"),
    awful.key({ modkey, "Control" }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Control" }, "t",      function (c) c.ontop = not c.ontop            end, "Mark client"),
    awful.key({ modkey, "Shift"   }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end, "Minimize client"),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end, "Maximize client")
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(1)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(1)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(1)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(1)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
--}}}

-- Rules {{{1
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "Pangoterm"}, properties = { size_hints_honor = false } },
    { rule = { class = "Termite"}, properties = { size_hints_honor = false } },
    { rule = { class = "URxvt"}, properties = { size_hints_honor = false } },
    { rule = { name = "uxterm"}, properties = { size_hints_honor = false } },
    { rule = { name = "sys" }, properties = { tag = tags[1] } },
    { rule = { name = "work" }, properties = { tag = tags[2] } },
    { rule = { name = "com" }, properties = { tag = tags[3] } },
    { rule = { name = "tj" }, properties = { tag = tags[3] } },
    { rule = { name = "mimi" }, properties = { tag = tags[4] } },
    { rule = { name = "komala" }, properties = { tag = tags[5] } },
    { rule = { name = "tj-laptop" }, properties = { tag = tags[6] } },
    { rule = { name = "swimmer" }, properties = { tag = tags[6] } },
    { rule = { name = "home" }, properties = { tag = tags[6] } },
    { rule = { name = "Calculator" }, properties = { floating = true, size_hints_honor = true,  size_hints = {"program_position", "program_size"}} },
    { rule = { name = "Music" }, properties = { floating = true, size_hints_honor = true,  size_hints = {"program_position", "program_size"}} },
    { rule = { name = "Htop" }, properties = { floating = true, size_hints_honor = true,  size_hints = {"program_position", "program_size"} } },
    { rule = { name = "Explore" }, properties = { floating = true, size_hints_honor = true,  size_hints = {"program_position", "program_size"} } },
    { rule = { name = "IP traffic monitor" }, properties = { floating = true, size_hints_honor = true,  size_hints = {"program_position", "program_size"} } },
    { rule = { name = "Drop-down terminal" }, properties = { floating = true, size_hints_honor = true,  size_hints = {"program_position", "program_size"} } },
    { rule = { class = "Thunderbird" }, properties = { tag = tags[7] } },
    { rule = { class = "VirtualBox" }, properties = { tag = tags[7] } },
    { rule = { class = "Darktable" }, properties = { tag = tags[8] } },
    { rule = { class = "AftershotPro" }, properties = { tag = tags[8] } },
    { rule = { class = "Rawtherapee" }, properties = { tag = tags[8] } },
    { rule = { class = "Gimp" }, properties = { floating = true, tag = tags[8] } },
    { rule = { class = "Scribus" }, properties = { floating = true, tag = tags[8] } },
    { rule = { class = "Audacious" }, properties = { tag = tags[9] } },
    { rule = { class = "Audacity" }, properties = { floating = true, tag = tags[9] } },
    { rule = { class = "Puddletag" }, properties = { tag = tags[9] } },

    { rule = { class = "Conky" },
      properties = {
          floating = true,
          maximized_horizontal = false,
          maximized_vertical = true,
          sticky = true,
          ontop = true,
          focusable = false,
          size_hints_honor = false,
          size_hints = {"program_position", "program_size"} } },

}
--}}}

-- Signals {{{1
-- Signal function to execute when a new client appears {{{2
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end

end)
-- }}}

-- Focus {{{2
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Server {{{2
-- Save the current tag before exiting
awesome.connect_signal("exit", save_tag)
-- }}}
--}}}

-- Autostart applications {{{1
-- conky
awful.util.spawn_with_shell("killall conky")
awful.util.spawn_with_shell("conky -c "..config_dir.."/conkyrc-"..TYPE)

-- Return to last tag at restart
restore_tag()
--}}}

print("Finished reading rc.lua: "..os.date())
