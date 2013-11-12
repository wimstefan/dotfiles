-- my awesome config
-- swimmer@xs4all.nl - 2013-06-20
-- vim: fdl=0 tw=200

print("Reading rc.lua: " .. os.date())

-- Standard awesome library
local gears       = require("gears")
local awful       = require("awful")
awful.rules       = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox       = require("wibox")
local vicious     = require("vicious")
local menubar     = require("menubar")
-- Theme handling library
local beautiful   = require("beautiful")
-- Notification library
local naughty     = require("naughty")
local blingbling  = require("blingbling")

-- Basic configuration {{{1
local hostname    = io.lines("/proc/sys/kernel/hostname")()
home_dir          = os.getenv("HOME")
config_dir        = awful.util.getdir("config")
wallpaper_dir     = home_dir .. "/system/wallpapers/"
icon_path         = config_dir .. "/icons/"

terminal          = "urxvt"
browser           = os.getenv("BROWSER") or "google-chrome"
editor            = os.getenv("EDITOR") or "gvim"
editor_cmd        = "gvim"
modkey            = "Mod4"
altkey            = "Mod1"

beautiful.init(config_dir .. "/themes/theme.lua")
if beautiful.wallpaper then
  gears.wallpaper.maximized(beautiful.wallpaper, 1, true)
end

local layouts =
{
    awful.layout.suit.floating,           --1
    --awful.layout.suit.tile,
    awful.layout.suit.tile.left,          --2
    --awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,           --3
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,                --4
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier           --5
}

tags = awful.tag({ "➊", "➋", "➌", "➍", "➎", "➏", "➐", "➑", "➒", "➓" }, 1, layouts[4])
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
   local path = config_dir .. "/" .. 
      (mod and "lib" or "rc") .. 
      "/" .. name .. ".lua"

   -- If the module is already loaded, don't load it again
   if mod and package.loaded[mod] then return package.loaded[mod] end

   -- Execute the RC/module file
   success, result = pcall(function() return dofile(path) end)
   if not success then
      naughty.notify({ title = "Error while loading an RC file",
           text = "When loading `" .. name .. 
        "`, got the following error:\n" .. result,
           preset = naughty.config.presets.critical
         })
      return print("E: error loading RC file '" .. name .. "': " .. result)
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
  local f = io.open( config_dir .. "/tag.id", 'w+')
  f:write(curtag)
  f:close()
end

function restore_tag()
  local f = io.open( config_dir .. "/tag.id", 'r')
  local lasttag = f:read("*all")
  f:close()
  awful.tag.viewidx(lasttag)
  awful.tag.viewprev()
end
-- }}}

-- Battery status {{{2
function batstate()
  local file = io.open("/sys/class/power_supply/" .. mybat .. "/status", "r")
  if (file == nil) then
    return "Cable plugged"
  end
  local batstate = file:read("*line")
  file:close()
  if (batstate == 'Discharging' or batstate == 'Charging') then
    return batstate
  else
    return "Fully charged"
  end
end
function battery_widget()
--  mybatwidget = awful.widget.progressbar()
--  mybatwidget:set_width(11)
--  mybatwidget:set_vertical(true)
--  mybatwidget:set_background_color("#ff0000")
--  mybatwidget:set_border_color(nil)
--  mybatwidget:set_color("#6fb126")

  mybatwidget = blingbling.progress_graph()
  mybatwidget:set_width(14)
  mybatwidget:set_height(26)
  mybatwidget:set_rounded_size(0.1)
  mybatwidget:set_label("$percent %")
  mybatwidget:set_graph_color("#6fb126")
  mybatwidget:set_graph_background_color("#ff0000")
  vicious.register(mybatwidget, vicious.widgets.bat,
  function (widget, args)
    -- plugged
    if (batstate() == 'Cable plugged') then
      return ''
      -- critical
    elseif (args[2] <= 5 and batstate() == 'Discharging') then
      naughty.notify{
        text = "Shutdown imminent...",
        title = "Battery running out!",
        position = "top_right",
        timeout = 0,
        fg="#000000",
        bg="#ffffff",
        screen = 1,
        ontop = true,
      }
      -- low
    elseif (args[2] <= 10 and batstate() == 'Discharging') then
      naughty.notify({
        text = "Plug the cable!",
        title = "Low battery",
        position = "top_right",
        timeout = 0,
        fg="#ffffff",
        bg="#262729",
        screen = 1,
        ontop = true,
      })
    end
    return args[2]
  end, 144, mybat)
end
-- }}}
-- Wallpaper changer {{{2
local wallmenu = {}
local function wall_load(wall)
  local f = io.popen('ln -sfn ' .. wallpaper_dir .. wall .. ' ' .. config_dir .. '/themes/wallpaper.png')
  awesome.restart()
end
local function wall_menu()
  local f = io.popen('ls -1 ' .. wallpaper_dir)
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
freedesktop.utils.icon_theme = { 'Clarity', 'Faenza' }
require("freedesktop.menu")
menu_items = freedesktop.menu.new()
myawesomemenu = {
   { "manual", terminal .. " -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help' }) },
   { "edit config", editor_cmd .. " " .. config_dir .. "/rc.lua", freedesktop.utils.lookup_icon({ icon = 'package_settings' }) },
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
space = wibox.widget.textbox("  ")

-- Time {{{2
mydatewidget = wibox.widget.textbox()
vicious.register(mydatewidget, vicious.widgets.date, "%a %b %d, %H:%M", 10)
-- Calendar popup
cal.register(mydatewidget)
-- }}}

-- System {{{2
--mycpuwidget = awful.widget.graph()
--mycpuwidget:set_width(50)
--mycpuwidget:set_background_color("#707070")
--mycpuwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 }, stops = { {0, "#ee2c2c"}, {0.5, "#b6e354"}, {1, "#6fb126" } } })
--vicious.register(mycpuwidget, vicious.widgets.cpu, "$1")

mycpuwidget = blingbling.line_graph()
mycpuwidget:set_height(26)
mycpuwidget:set_rounded_size(0.1)
mycpuwidget:set_graph_background_color("#c6c6c644")
mycpuwidget:set_show_text(false)
mycpuwidget:set_label("Load $percent %")
vicious.register(mycpuwidget, vicious.widgets.cpu,"$1",2)
-- }}}

-- Battery {{{2
if hostname == 'asuca' then
  mybat = "BAT0"
  battery_widget()
end

if hostname == 'mimi' then
  mybat = "BAT1"
  battery_widget()
end
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
    mywibox[1] = awful.wibox({ position = "top" })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[1])
    left_layout:add(mypromptbox[1])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    --if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(wibox.widget.systray())
    right_layout:add(mycpuwidget)
    if (hostname == 'asuca' or hostname == 'mimi') then
      right_layout:add(mybatwidget)
      right_layout:add(space)
    end
    right_layout:add(mydatewidget)
    right_layout:add(space)
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
    awful.key({ modkey,           }, "p", function() menubar.show() end, "Draw menu bar"),
    --awful.key({ modkey,           }, "p",
     -- function()
      --  awful.util.spawn("dmenu_run -i -p 'Run command:' -fn 'Terminal Dosis-10' -nb '" ..  beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal ..  "' -sb '" .. beautiful.bg_focus ..  "' -sf '" .. beautiful.fg_focus .. "'") 
      --end, "Draw menu bar"),
    awful.key({ modkey,           }, "r",     function () mypromptbox[mouse.screen]:run() end, "Run prompt"),
    awful.key({ modkey,           }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end, "Lua prompt"),
    awful.key({ modkey, "Control" }, "r", awesome.restart, "Restart awesome"),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit, "Quit awesome"),

    -- Applications
    keydoc.group("05. Applications"),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end, "Open a terminal"),
    awful.key({ modkey,           }, "a", function () awful.util.spawn("audacity") end, "Audacity"),
    awful.key({ modkey,           }, "b", function () awful.util.spawn("google-chrome") end, "Chrome"),
    awful.key({ modkey            }, "c", function () scratch.drop(terminal .." -e wcalc","top","right",250,300) end, "Calculator"),
    awful.key({ modkey,           }, "d", function () awful.util.spawn("darktable") end, "Darktable"),
    awful.key({ modkey,           }, "e", function () awful.util.spawn(editor_cmd) end, "Editor"),
    awful.key({ modkey,           }, "g", function () awful.util.spawn("gimp") end, "Gimp"),
    awful.key({ modkey,           }, "l", function () awful.util.spawn("libreoffice") end, "Libreoffice"),
    awful.key({ modkey,           }, "o", function () awful.util.spawn("opera") end, "Opera"),
    awful.key({ modkey,           }, "s", function () awful.util.spawn("spacefm") end, "Spacefm"),
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
    keydoc.group("06. Clients"),
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end, "Fullscreen"),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end, "Kill client"),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     , "Toggle client floating status"),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Control" }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Control" }, "t",      function (c) c.ontop = not c.ontop            end, "Mark client"),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end, "Minimize client"),
    awful.key({ modkey,           }, "m",
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
    { rule = { class = "Termite"}, properties = { max = true } },
    { rule = { class = "Termite", name = "sys" }, properties = { tag = tags[1] } },
    { rule = { class = "Termite", name = "work" }, properties = { tag = tags[2] } },
    { rule = { class = "Termite", name = "com" }, properties = { tag = tags[3] } },
    { rule = { class = "Termite", name = "tj" }, properties = { tag = tags[3] } },
    { rule = { class = "Termite", name = "mimi" }, properties = { tag = tags[4] } },
    { rule = { class = "Termite", name = "komala" }, properties = { tag = tags[5] } },
    { rule = { class = "Termite", name = "asuca" }, properties = { tag = tags[6] } },
    { rule = { class = "Termite", name = "swimmer" }, properties = { tag = tags[6] } },
    { rule = { class = "URxvt", name = "sys" }, properties = { tag = tags[1] } },
    { rule = { class = "URxvt", name = "work" }, properties = { tag = tags[2] } },
    { rule = { class = "URxvt", name = "com" }, properties = { tag = tags[3] } },
    { rule = { class = "URxvt", name = "tj" }, properties = { tag = tags[3] } },
    { rule = { class = "URxvt", name = "mimi" }, properties = { tag = tags[4] } },
    { rule = { class = "URxvt", name = "komala" }, properties = { tag = tags[5] } },
    { rule = { class = "URxvt", name = "asuca" }, properties = { tag = tags[6] } },
    { rule = { class = "URxvt", name = "swimmer" }, properties = { tag = tags[6] } },
    { rule = { class = "Thunderbird" }, properties = { tag = tags[7] } },
    { rule = { class = "Darktable" }, properties = { tag = tags[8] } },
    { rule = { class = "AftershotPro" }, properties = { tag = tags[8] } },
    { rule = { class = "Rawtherapee" }, properties = { tag = tags[8] } },
    { rule = { class = "Audacity" }, properties = { tag = tags[9] } },
    { rule = { class = "Puddletag" }, properties = { tag = tags[9] } },
    { rule = { class = "Gimp" }, properties = { floating = true, tag = tags[9] } },

    { rule = { class = "Conky" },
      properties = {
          floating = true,
          maximized_horizontal = false,
          maximized_vertical = true,
          sticky = true,
          ontop = true,
          focusable = false,
          honor_size_hints = false,
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
awful.util.spawn_with_shell("killall conky")
awful.util.spawn_with_shell("conky -c " .. config_dir  .. "/" .. hostname .. "-conkyrc")

-- Return to last tag at restart
restore_tag()
--}}}

print("Finished reading rc.lua: " .. os.date())
