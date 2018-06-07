-- my awesome config
-- vim: fdm=marker fdl=0 tw=200

-- Standard awesome library
local gears                  = require("gears")
local awful                  = require("awful")
require("awful.autofocus")
-- Widget and layout library
local shape                  = require("gears.shape")
local wibox                  = require("wibox")
local lain                   = require("lain")
require("collision")()
-- Appearance & theme handling library
local beautiful              = require("beautiful")
local xresources             = require("beautiful.xresources")
local dpi                    = xresources.apply_dpi
-- Notification library
local naughty                = require("naughty")
local menubar                = require("menubar")
local hotkeys_popup          = require("awful.hotkeys_popup").widget
                               require("awful.hotkeys_popup.keys")

-- Basic configuration {{{1
-- Conditionals {{{2
hostname          = io.lines("/proc/sys/kernel/hostname")()
if hostname == 'tj' then
  TYPE     = "laptop"
  BAT      = "BAT1"
  SYSTEMP  = "coretemp.0/hwmon/hwmon0"
  TEMPFILE = "/sys/devices/platform/coretemp.0/hwmon/hwmon0/temp2_input"
elseif hostname == 'mimi' then
  TYPE     = "laptop"
  BAT      = "BAT0"
  SYSTEMP  = "coretemp.0/hwmon/hwmon1"
  TEMPFILE = "/sys/devices/platform/coretemp.0/hwmon/hwmon1/temp2_input"
elseif hostname == 'swimmer' or hostname == 'komala' then
  TYPE     = "desktop"
  SYSTEMP  = "coretemp.0/hwmon/hwmon0"
  TEMPFILE = "/sys/devices/platform/coretemp.0/hwmon/hwmon0/temp2_input"
end
-- }}}
-- Variables {{{2
home_dir          = os.getenv("HOME")
config_dir        = awful.util.getdir("config")
theme_dir         = config_dir.."/themes/materia/"
wallpaper_dir     = home_dir.."/system/wallpapers/"

terminal          = "termite"
if terminal == 'alacritty' or terminal == 'termite' then
  TITLE = " --title="
  NAME  = " --name="
  GEO   = " --geometry="
  CMD   = " -e "
elseif terminal == 'kitty' then
  TITLE = " --title="
  NAME  = " --name="
  GEO   = " -o WindowGeometry="
  CMD   = " "
else
  TITLE = " -title "
  NAME  = " -name "
  GEO   = " -geometry "
  CMD   = " -e "
end
browser           = os.getenv("BROWSER") or "my-eye-into-the-world"
editor            = os.getenv("EDITOR") or "vim"
musicplr1         = terminal..TITLE.."'Music'"..GEO.."1300x800+0+16"..CMD.."ncmpcpp"
musicplr2         = terminal..TITLE.."'Music'"..GEO.."1300x800+0+16"..CMD.."mocp"
mymixer           = terminal..TITLE.."'Music'"..GEO.."1300x600+0+16"..CMD.."alsamixer"
mytop             = terminal..TITLE.."'Htop'"..GEO.."900x1000+0+16"..CMD.."htop"
editor_cli        = terminal..CMD..editor
editor_gui        = "gvim"
modkey            = "Mod4"
altkey            = "Mod1"
markup            = lain.util.markup
-- }}}
-- Themes {{{2
beautiful.init(theme_dir .. "theme.lua")
-- }}}
-- Table of layouts {{{2
if hostname == 'swimmer' then
  awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.tile,
    -- awful.layout.suit.tile.bottom,
    awful.layout.suit.max,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
  }
else
  awful.layout.layouts = {
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.tile,
    -- awful.layout.suit.tile.bottom,
    awful.layout.suit.max,
    awful.layout.suit.floating,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
  }
end
-- }}}
-- }}}

-- Error handling {{{1
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text  = awesome.startup_errors })
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
                      text  = tostring(err) })
    in_error = false
  end)
end
-- }}}

-- Helper functions {{{1
-- Running apps {{{2
local function client_menu_toggle_fn()
  local instance = nil

  return function ()
    if instance and instance.wibox.visible then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ theme = { width = dpi(250) } })
    end
  end
end
-- }}}
-- Align text to the right {{{2
local function pad_to_length(value, ...)
  local max_length = 0
  value = tostring(value)
  for i=1, select('#', ...) do
    local arg = tostring(select(i, ...))
    max_length = math.max(max_length, #arg)
  end
  if max_length > #value then
    value = string.rep(' ', max_length - #value) .. value
  end
  return value
end
-- }}}
-- Represent a number of seconds as a string of minutes:seconds {{{2
local function format_time(s)
  local seconds = tonumber(s)
  if seconds then
    return string.format("%d:%.2d", math.floor(seconds/60), seconds%60)
  else
    return 0
  end
end
-- }}}
-- }}}

-- Menu {{{1
-- Create a launcher widget and a main menu
myawesomemenu = {
  { "hotkeys", function() return false, hotkeys_popup.show_help end},
  { "manual", string.format("%s -e '%s'", "uxterm", "man awesome") },
  { "edit config", string.format("%s -e '%s %s'", "uxterm", editor, awesome.conffile) },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Wibar {{{1
-- Formatting aids {{{2
local spacer = wibox.widget.textbox('  ')
local spr = wibox.widget.textbox('<span color="'..beautiful.border_focus..'" weight="bold"> │ </span>')
-- }}}
-- Mpd widget {{{2
local widget_mpd = lain.widget.mpd({
  notify = "on";
  settings = function()
    mpd_notification_preset = {
      text = string.format("  %s \n %s \n %s  %s  ",
        markup.bold(markup.fg(beautiful.blue2, markup.font(beautiful.icon_font, "") .. "   " .. mpd_now.artist)),
        markup.fg(beautiful.red2, markup.font(beautiful.icon_font, "") .. "   " .. mpd_now.album),
        markup.fg(beautiful.green1, markup.font(beautiful.icon_font, "") .. "   " .. mpd_now.title),
        markup.fg(beautiful.orange1, markup.font(beautiful.icon_font, "") .. "   " .. format_time(mpd_now.time))
      )
    }

    if mpd_now.state == "play" then
      artist = " │ " .. mpd_now.artist .. " │ "
      title  = mpd_now.title .. " "
    elseif mpd_now.state == "pause" then
      artist = "mpd "
      title  = "paused "
    else
      artist = ""
      title  = ""
    end
    widget:set_markup(markup.fontfg(beautiful.tasklist_font, beautiful.blue2, artist) .. markup.fontfg(beautiful.tasklist_font, beautiful.green1, title))
  end
})
local mpd_box = wibox.container.scroll.horizontal(widget_mpd.widget)
mpd_box:set_fps(5)
mpd_box:set_max_size(340)
local tooltip_mpd = awful.tooltip({
  objects = { mpd_box },
  timeout = 0,
  margin_leftright = 10,
  margin_topbottom = 10,
  -- shape = gears.shape.infobubble,
  shape = gears.shape.rounded_rect,
  timer_function = function()
    if mpd_now.time ~= "N/A" and mpd_now.elapsed ~= "N/A" then
      time = string.format("%s/%s", format_time(mpd_now.elapsed), format_time(mpd_now.time))
    end
    local text = string.format(" %s \n %s \n %s \n %s ",
      markup.bold(markup.fg(beautiful.blue2, markup.font(beautiful.icon_font, "") .. "   " .. mpd_now.artist)),
      markup.fg(beautiful.red2, markup.font(beautiful.icon_font, "") .. "   " .. mpd_now.album),
      markup.fg(beautiful.green1, markup.font(beautiful.icon_font, "") .. "   " .. mpd_now.title),
      markup.fg(beautiful.orange1, markup.font(beautiful.icon_font, "") .. "   " .. time)
    )
    return text
  end
})
-- Mpd widget }}}
-- ALSA volume bar {{{2
local icon_alsa = wibox.widget.textbox()
icon_alsa:buttons(gears.table.join(
  awful.button({ }, 1, function () awful.spawn.with_shell(mymixer) end),
  awful.button({ modkey }, 1, function () awful.spawn.with_shell(musicplr1) end),
  awful.button({ altkey }, 1, function () awful.spawn.with_shell(musicplr2) end)))
local volume = lain.widget.alsabar({
  width = 35, ticks = true, ticks_size = 4, step = "2%",
  notification_preset = { font = beautiful.taglist_font },
  settings = function()
      if volume_now.status == "off" then
          volume_icon = ""
      elseif tonumber(volume_now.level) == 0 then
          volume_icon = ""
      elseif tonumber(volume_now.level) <= 50 then
          volume_icon = ""
      else
          volume_icon = ""
      end
      icon_alsa:set_markup(markup.font(beautiful.icon_font, volume_icon))
  end,
  -- colors = {
  --     background = beautiful.bg_normal,
  --     mute = beautiful.grey2,
  --     settings = function()
  --       if tonumber(volume_now.level) <= 10 then
  --         bar_colour = beautiful.red2
  --       elseif tonumber(volume_now.level) <= 50 then
  --         bar_colour = beautiful.blue2
      --   else
  --         bar_colour = beautiful.green1
      --   end
  --       unmute = bar_colour
      -- end
  --     -- unmute = beautiful.fg_normal
  -- }
})
volume.bar:buttons(gears.table.join(
    awful.button({}, 1, function() -- left click
        awful.spawn.with_shell(mymixer)
    end),
    awful.button({}, 2, function() -- middle click
        awful.spawn(string.format("%s set %s 100%%", volume.cmd, volume.channel))
        volume.update()
    end),
    awful.button({}, 3, function() -- right click
        awful.spawn(string.format("%s set %s toggle", volume.cmd, volume.togglechannel or volume.channel))
        volume.update()
    end),
    awful.button({}, 4, function() -- scroll up
        awful.spawn(string.format("%s set %s 1%%+", volume.cmd, volume.channel))
        volume.update()
    end),
    awful.button({}, 5, function() -- scroll down
        awful.spawn(string.format("%s set %s 1%%-", volume.cmd, volume.channel))
        volume.update()
    end)
))
local volmargin = wibox.container.margin(volume.bar, 8, 0, 5, 5)
local widget_alsa = wibox.container.background(volmargin)
-- }}}
-- Memory widget {{{2
local widget_mem = lain.widget.mem({
      settings = function()
        widget:set_markup(markup.font(beautiful.icon_font, "") .. markup.font(beautiful.font, "  " .. mem_now.used .. "MB "))
      end
})
local tooltip_mem = awful.tooltip({
  objects = { widget_mem.widget },
  margin_leftright = 10,
  margin_topbottom = 10,
  shape = gears.shape.infobubble,
  timer_function = function()
  local title = "Memory &amp; swap usage"
  local used = pad_to_length(mem_now.used, mem_now.swapused)
  local swapused = pad_to_length(mem_now.swapused, mem_now.used)
  local text
  text = ' <span font="'..beautiful.mono_font..'">'..
         ' <span weight="bold" color="'..beautiful.fg_normal..'">'..title..'</span> \n'..
         ' <span weight="bold">-------------------</span> \n'..
         ' ▪ memory <span color="'..beautiful.fg_normal..'">'..used..'</span> MB \n'..
         ' ▪ swap   <span color="'..beautiful.fg_normal..'">'..swapused..'</span> MB </span>'
   return text
 end
})
-- Memory widget }}}
-- CPU widget {{{2
local widget_cpu = wibox.layout.fixed.horizontal()
local widget_cpu_graph = wibox.widget.graph()
local widget_cpu_text = lain.widget.cpu({
      settings = function()
        widget:set_markup(markup.font(beautiful.icon_font, "") .. markup.font(beautiful.font, "  " .. cpu_now.usage .. "% "))
        widget_cpu_graph:add_value(cpu_now.usage/100)
      end
})
widget_cpu_graph:set_width(20)
widget_cpu_graph:set_background_color(beautiful.bg_normal)
widget_cpu_graph:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 18 }, stops = { { 0, beautiful.gradient_1 }, { 0.5, beautiful.gradient_2 }, { 1,beautiful.gradient_3 } } })
widget_cpu:add(widget_cpu_text.widget)
widget_cpu:add(widget_cpu_graph)
widget_cpu:buttons(gears.table.join( awful.button({ }, 1, function () awful.spawn.with_shell(mytop) end)))
-- CPU widget }}}
-- Temperature widget {{{2
local widget_temp = lain.widget.temp({
  tempfile = TEMPFILE,
  settings = function ()
    widget:set_markup(markup.font(beautiful.icon_font, "") .. markup.font(beautiful.font, " " .. coretemp_now .. "° "))
  end
})
-- Temperature widget }}}
-- Filesystem widget {{{2
-- local widget_fs = lain.widget.fs({
--   notification_preset = { font = beautiful.mono_font },
--   settings = function()
--     widget:set_markup(markup.font(beautiful.icon_font, "") .. markup.font(beautiful.font, "  " .. fs_now["/"].used .. " " .. fs_now["/"].units))
--   end
-- })
-- Filesystem widget }}}
-- Power widget {{{2
local icon_power = wibox.widget.textbox()
local widget_power = lain.widget.bat({
      battery = BAT,
      notify = "on",
      settings = function()
        if bat_now.status == "N/A" then
          power_icon = markup.font(beautiful.icon_font, "") .. markup.font(beautiful.font, "  AC ")
        elseif bat_now.status == "Charging" and tonumber(bat_now.perc) <= 70 then
          power_icon = markup.font(beautiful.icon_font, "") .. markup.font(beautiful.font, " " .. bat_now.perc .."%  ")
        elseif bat_now.status == "Charging" and tonumber(bat_now.perc) >= 70 then
          power_icon = markup.font(beautiful.icon_font, "") .. markup.font(beautiful.font, " " .. bat_now.perc .."%  ")
        else
          if tonumber(bat_now.perc) <= 10 then
            power_icon = markup.font(beautiful.icon_font, "") .. markup.font(beautiful.font, " " .. bat_now.perc .. "%  ")
          elseif tonumber(bat_now.perc) <= 30 then
            power_icon = markup.font(beautiful.icon_font, "") .. markup.font(beautiful.font, " " .. bat_now.perc .. "%  ")
          elseif tonumber(bat_now.perc) <= 50 then
            power_icon = markup.font(beautiful.icon_font, "") .. markup.font(beautiful.font, " " .. bat_now.perc .. "%  ")
          elseif tonumber(bat_now.perc) <= 70 then
            power_icon = markup.font(beautiful.icon_font, "") .. markup.font(beautiful.font, " " .. bat_now.perc .. "%  ")
          elseif tonumber(bat_now.perc) <= 85 then
            power_icon = markup.font(beautiful.icon_font, "") .. markup.font(beautiful.font, " " .. bat_now.perc .. "%  ")
          else
            power_icon = markup.font(beautiful.icon_font, "") .. markup.font(beautiful.font, " " .. bat_now.perc .. "%  ")
          end
        end
        widget:set_markup(markup.font(beautiful.font, power_icon))

        bat_notification_low_preset = {
          title = "Battery low",
          text = "Plug the cable!",
          timeout = 15,
          fg = beautiful.red1,
          bg = beautiful.black2
        }
        bat_notification_critical_preset = {
          title = "Battery exhausted",
          text = "Shutdown imminent",
          timeout = 15,
          fg = beautiful.white1,
          bg = beautiful.black2
        }
      end
})
local tooltip_bat = awful.tooltip({
  objects = { widget_power.widget },
  margin_leftright = 10,
  margin_topbottom = 10,
  shape = gears.shape.infobubble,
  timer_function = function()
    local title = "Power status"
    local tlen = string.len(title)
    local text
    if bat_now.status == 'N/A' then
      text = ' <span font="'..beautiful.mono_font..'">'..
             ' <span weight="bold" color="'..beautiful.fg_normal..'">'..title..'</span> \n'..
             ' <span weight="bold">'..string.rep('-', tlen)..'</span> \n'..
             ' ▪ status    <span color="'..beautiful.fg_normal..'">\n   Plugged in \n   No battery </span>'
      text = text..'</span>'
    else
      text = ' <span font="'..beautiful.mono_font..'">'..
             ' <span weight="bold" color="'..beautiful.fg_normal..'">'..title..'</span> \n'..
             ' <span weight="bold">'..string.rep('-', tlen)..'</span> \n'
      text = text..' ⚡ level     <span color="'..beautiful.fg_normal..'">'..bat_now.perc..'% </span>\n'
      if bat_now.status == 'Discharging' then
        text = text..' ▪ status    <span color="'..beautiful.fg_normal..'">discharging </span>\n'
        text = text..' ◴ time left <span color="'..beautiful.fg_normal..'">'..bat_now.time..' </span>'
      elseif  bat_now.status == 'Charging' then
        text = text..' ▪ status    <span color="'..beautiful.fg_normal..'">charging </span>\n'
        text = text..' ◴ time left <span color="'..beautiful.fg_normal..'">'..bat_now.time..' </span>'
      elseif bat_now.status == 'Full' then
        text = text..' ▪ status    <span color="'..beautiful.fg_normal..'">charged </span>'
      end
      text = text..'</span>'
    end
    return text
  end
})
-- Power widget }}}
-- Textclock widget {{{2
mytextclock = wibox.widget.textclock( '<span font="'..beautiful.taglist_font..'" background="'..beautiful.blue2..'" color="'..beautiful.background..'"> %a %b %d, %H:%M </span>' )
lain.widget.calendar({
  attach_to = { mytextclock },
  cal = "/usr/bin/cal -w -m --color=always",
  notification_preset = {
    font = beautiful.taglist_font,
    fg   = beautiful.fg_normal,
    bg   = beautiful.white2
  }
})
-- Textclock widget }}}

-- Final assembly {{{2
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
      if client.focus then
          client.focus:move_to_tag(t)
      end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
      if client.focus then
          client.focus:toggle_tag(t)
      end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
      -- Without this, the following
      -- :isvisible() makes no sense
      c.minimized = false
      if not c:isvisible() and c.first_tag then
        c.first_tag:view_only()
      end
      -- This will also un-minimize
      -- the client, if needed
      client.focus = c
      c:raise()
    end
  end),
  awful.button({ }, 3, client_menu_toggle_fn()),
  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
  end))

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.fit(wallpaper, s, beautiful.background)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Quake terminals {{{2
  s.quakescratch = lain.util.quake({
    app     = terminal,
    name    = "Scratchpad",
    argname = "--name %s",
    height  = 0.8,
    width   = 0.9,
    vert    = "top",
    horiz   = "left"
  })

  s.quakecalc = lain.util.quake({
    app     = terminal,
    name    = "Calculator",
    argname = "--name %s",
    extra   = CMD.." wcalc",
    height  = 0.3,
    width   = 0.3,
    vert    = "top",
    horiz   = "right"
  })

  s.quakexplore = lain.util.quake({
    app     = terminal,
    name    = "Explore",
    argname = "--name %s",
    extra   = CMD.." mc",
    height  = 0.7,
    width   = 0.8,
    vert    = "bottom",
    horiz   = "right"
  })
  -- }}}
  -- Wallpaper
  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)))
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", height = dpi(18), screen = s })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.mylayoutbox,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      wibox.widget.systray(),
      mpd_box,
      spr,
      icon_alsa,
      widget_alsa,
      spr,
      widget_mem,
      spr,
      widget_cpu,
      spr,
      widget_temp,
      spr,
      -- widget_fs,
      -- spr,
      widget_power,
      spacer,
      mytextclock,
    },
  }
end)
-- Final assembly }}}
-- }}}

-- Mouse bindings {{{1
root.buttons(gears.table.join(
  awful.button({ }, 3, function () mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- Key bindings {{{1
globalkeys = gears.table.join(
  awful.key({ modkey,           }, "F1",
            hotkeys_popup.show_help,
            {description="show help", group="awesome"}),
  awful.key({ modkey,           }, "Left",
            awful.tag.viewprev,
            {description = "view previous", group = "tag"}),
  awful.key({ modkey,           }, "Right",
            awful.tag.viewnext,
            {description = "view next", group = "tag"}),
  awful.key({ modkey,           }, "Escape",
            awful.tag.history.restore,
            {description = "go back", group = "tag"}),

  awful.key({ modkey,           }, "j",
            function ()
              awful.client.focus.byidx( 1)
            end,
            {description = "focus next by index", group = "client"}
  ),
  awful.key({ modkey,           }, "k",
            function ()
              awful.client.focus.byidx(-1)
            end,
            {description = "focus previous by index", group = "client"}
  ),
  awful.key({ modkey,           }, "w",
            function () mymainmenu:show() end,
            {description = "show main menu", group = "awesome"}),

-- Layout manipulation {{{2
  awful.key({ modkey, "Shift"   }, "j",
            function () awful.client.swap.byidx(  1)    end,
            {description = "swap with next client by index", group = "client"}),
  awful.key({ modkey, "Shift"   }, "k",
            function () awful.client.swap.byidx( -1)    end,
            {description = "swap with previous client by index", group = "client"}),
  awful.key({ modkey, "Control" }, "j",
            function () awful.screen.focus_relative( 1) end,
            {description = "focus the next screen", group = "screen"}),
  awful.key({ modkey, "Control" }, "k",
            function () awful.screen.focus_relative(-1) end,
            {description = "focus the previous screen", group = "screen"}),
  awful.key({ modkey,           }, "u",
            awful.client.urgent.jumpto,
            {description = "jump to urgent client", group = "client"}),
  awful.key({ modkey,           }, "Tab",
            function ()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end,
            {description = "go back", group = "client"}),

  awful.key({ modkey, "Control" }, "n",
            function ()
                local c = awful.client.restore()
                -- Focus restored client
                if c then
                    client.focus = c
                    c:raise()
                end
            end,
            {description = "restore minimized", group = "client"}),
-- }}}
-- Controls {{{2
  awful.key({ modkey, "Control" }, "r",
            awesome.restart,
            {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Shift"   }, "q",
            awesome.quit,
            {description = "quit awesome", group = "awesome"}),

  awful.key({ modkey, altkey    }, "l",
            function () awful.tag.incmwfact( 0.05)          end,
            {description = "increase master width factor", group = "layout"}),
  awful.key({ modkey, altkey    }, "h",
            function () awful.tag.incmwfact(-0.05)          end,
            {description = "decrease master width factor", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "h",
            function () awful.tag.incnmaster( 1, nil, true) end,
            {description = "increase the number of master clients", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "l",
            function () awful.tag.incnmaster(-1, nil, true) end,
            {description = "decrease the number of master clients", group = "layout"}),
  awful.key({ modkey, "Control" }, "h",
            function () awful.tag.incncol( 1, nil, true)    end,
            {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, "Control" }, "l",
            function () awful.tag.incncol(-1, nil, true)    end,
            {description = "decrease the number of columns", group = "layout"}),
  awful.key({ modkey,           }, "space",
            function () awful.layout.inc( 1)                end,
            {description = "select next", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "space",
            function () awful.layout.inc(-1)                end,
            {description = "select previous", group = "layout"}),
-- ALSA volume control
  awful.key({ altkey, "Shift"     }, "Up",
            function ()
                  os.execute(string.format("amixer set %s 1%%+", volume.channel))
                  volume.notify()
            end,
            {description = "Raise volume", group = "controls"}),
  awful.key({ altkey, "Shift"     }, "Down",
            function ()
                  os.execute(string.format("amixer set %s 1%%-", volume.channel))
                  volume.notify()
            end,
            {description = "Lower volume", group = "controls"}),
  awful.key({ altkey, "Shift"     }, "m",
            function ()
                  os.execute(string.format("amixer set %s toggle", volume.togglechannel or volume.channel))
                  volume.notify()
            end,
            {description = "Mute volume", group = "controls"}),
-- }}}
-- Applications {{{2
  awful.key({ modkey,           }, "a",
            function () awful.spawn("audacity") end,
            {description = "Audacity", group = "applications"}),
  awful.key({ modkey,           }, "b",
            function () awful.spawn(browser) end,
            {description = "Browser", group = "applications"}),
  awful.key({ modkey            }, "c",
            function () awful.screen.focused().quakecalc:toggle() end,
            {description = "Calculator", group = "applications"}),
  awful.key({ modkey,           }, "d",
            function () awful.spawn("darktable") end,
            {description = "Darktable", group = "applications"}),
  awful.key({ modkey,           }, "e",
            function () awful.spawn(editor_gui) end,
            {description = "Editor", group = "applications"}),
  awful.key({ modkey,           }, "g",
            function () awful.spawn("gimp") end,
            {description = "Gimp", group = "applications"}),
  awful.key({ modkey,           }, "l",
            function () awful.spawn("libreoffice") end,
            {description = "Libreoffice", group = "applications"}),
  awful.key({ modkey,           }, "m",
            function () awful.screen.focused().quakexplore:toggle() end,
            {description = "Explore", group = "applications"}),
  awful.key({ modkey,           }, "o",
            function () awful.spawn("opera") end,
            {description = "Opera", group = "applications"}),
  awful.key({ modkey,           }, "p",
            function () awful.spawn("puddletag") end,
            {description = "Puddletag", group = "applications"}),
  awful.key({ modkey            }, "r",
            function () awful.spawn("rofi -show combi") end,
            {description = "Run dialog", group = "controls"}),
  awful.key({ modkey,           }, "s",
            function () awful.screen.focused().quakescratch:toggle() end,
            {description = "Scratchpad", group = "applications"}),
  awful.key({ modkey,           }, "t",
            function () awful.spawn("thunderbird") end,
            {description = "Thunderbird", group = "applications"}),
  awful.key({ modkey,           }, "u",
            function () awful.spawn("scribus") end,
            {description = "Scribus", group = "applications"}),
  awful.key({ modkey,           }, "x",
            function () awful.spawn("lxappearance") end,
            {description = "Lxappearance", group = "applications"}),
  awful.key({                   }, "Print",
            function() awful.util.spawn("screengrab") end,
            {description = "Print screen", group = "controls"}),
  awful.key({ modkey,           }, "Return",
            function () awful.spawn(terminal) end,
            {description = "Open a terminal", group = "controls"})
)
-- }}}

clientkeys = gears.table.join(
  awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),
  awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
            {description = "close", group = "client"}),
  awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
            {description = "toggle floating", group = "client"}),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
            {description = "move to master", group = "client"}),
  awful.key({ modkey, "Control" }, "o",      function (c) c:move_to_screen()               end,
            {description = "move to screen", group = "client"}),
  awful.key({ modkey, "Control" }, "t",      function (c) c.ontop = not c.ontop            end,
            {description = "toggle keep on top", group = "client"}),
  awful.key({ modkey, "Shift"   }, "n",
            function (c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end ,
            {description = "minimize", group = "client"}),
  awful.key({ modkey, "Shift"   }, "m",
            function (c)
                c.maximized = not c.maximized
                c:raise()
            end ,
            {description = "maximize", group = "client"}),
  awful.key({ modkey, "Shift"   }, "t",      function (c) awful.titlebar.toggle(c)         end,
            {description = "toggle titlebar", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
  -- View tag only.
  awful.key({ modkey }, "#" .. i + 9,
            function ()
                  local screen = awful.screen.focused()
                  local tag = screen.tags[i]
                  if tag then
                      tag:view_only()
                  end
            end,
            {description = "view tag #"..i, group = "tag"}),
  -- Toggle tag display.
  awful.key({ modkey, "Control" }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}),
  -- Move client to tag.
  awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #"..i, group = "tag"}),
  -- Toggle tag on focused client.
  awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"})
  )
end

clientbuttons = gears.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- Rules {{{1
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus        = awful.client.focus.filter,
      raise        = true,
      keys         = clientkeys,
      buttons      = clientbuttons,
      screen       = awful.screen.preferred,
      placement    = awful.placement.no_overlap+awful.placement.no_offscreen
    },
    -- Add a titlebar and hide for most windows
    callback = function (c)
      -- buttons for the titlebar
      local buttons = gears.table.join(
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

      awful.titlebar(c) : setup {
        { -- Left
          awful.titlebar.widget.iconwidget(c),
          buttons = buttons,
          layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
          { -- Title
            align  = "center",
            widget = awful.titlebar.widget.titlewidget(c)
          },
          buttons = buttons,
          layout  = wibox.layout.flex.horizontal
        },
        { -- Right
          awful.titlebar.widget.floatingbutton (c),
          awful.titlebar.widget.maximizedbutton(c),
          awful.titlebar.widget.stickybutton   (c),
          awful.titlebar.widget.ontopbutton    (c),
          awful.titlebar.widget.closebutton    (c),
          layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
      }
      -- Only show titlebars for dialogs
      if c.type ~=  "dialog" then
        awful.titlebar.hide(c)
      end
    end
    },

  -- Floating clients.
  { rule_any = {
    class = {
      "Apvlv",
      "Audacity",
      "Lxappearance",
      "pinentry",
      "Scribus",
      "Thunderbird",
      "Wpa_gui",
      "Zathura",
    },
    name = {
      "Calculator",
      "Event Tester",
      "Explore",
      "Htop",
      "IP Traffic",
      "Music",
      "Scratchpad",
    },
    role = {
      "AlarmWindow",  -- Thunderbird's calendar.
      "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
    }
  }, properties = { floating = true }},

  -- Tag associations
  { rule = { name  = "^sys" }        , properties = { tag = "1" } } ,
  { rule = { name  = "^work" }       , properties = { tag = "2" } } ,
  { rule = { name  = "^com" }        , properties = { tag = "3" } } ,
  { rule = { name  = "^tj" }         , properties = { tag = "3" } } ,
  { rule = { name  = "^mimi" }       , properties = { tag = "4" } } ,
  { rule = { name  = "^komala" }     , properties = { tag = "5" } } ,
  { rule = { name  = "laptop$" }     , properties = { tag = "6" } } ,
  { rule = { name  = "^swimmer" }    , properties = { tag = "6" } } ,
  { rule = { name  = "^home" }       , properties = { tag = "6" } } ,
  { rule = { class = "Thunderbird" } , properties = { tag = "7" } } ,
  { rule = { class = "Scribus" }     , properties = { tag = "7" } } ,
  { rule = { class = "VirtualBox" }  , properties = { tag = "7" } } ,
  { rule = { class = "Darktable" }   , properties = { tag = "8" } } ,
  { rule = { class = "Gimp" }        , properties = { tag = "8" } } ,
  { rule = { class = "Inkscape" }    , properties = { tag = "8" } } ,
  { rule = { class = "Audacious" }   , properties = { tag = "9" } } ,
  { rule = { class = "Audacity" }    , properties = { tag = "9" } } ,
  { rule = { class = "Puddletag" }   , properties = { tag = "9" } } ,

  -- Application specific rules
  { rule_any = {
    name  = {
      "Open File",
      "Save File",
    }
  },
    properties = {
      floating = true,
      width    = dpi(1000),
      height   = dpi(600),
    }
  },

}
-- }}}

-- Signals {{{1
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and
    not c.size_hints.user_position
    and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
  end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    and awful.client.focus.filter(c) then
    client.focus = c
  end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Autostart applications {{{1
-- compton
awful.spawn.with_shell("killall compton")
awful.spawn.with_shell("compton &")

--}}}
