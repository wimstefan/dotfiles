-- my awesome config
-- vim: fdm=marker fdl=0 tw=200

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local shape = require("gears.shape")
local wibox = require("wibox")
local lain = require("lain")
require("collision")()
-- Appearance & theme handling library
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")

-- Basic configuration {{{1
-- Conditionals {{{2
hostname =  io.lines("/proc/sys/kernel/hostname")()
if hostname == 'tj' then
  TYPE = "laptop"
  SYSTEMP = "coretemp.0/hwmon/hwmon0"
  TEMPFILE = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon0/temp1_input"
elseif hostname == 'swimmer' or hostname == 'komala' then
  TYPE = "desktop"
  SYSTEMP = "coretemp.0/hwmon/hwmon0"
  TEMPFILE = "/sys/devices/virtual/thermal/thermal_zone0/temp"
end
-- }}}
-- Variables {{{2
home_dir = os.getenv("HOME")
config_dir = gears.filesystem.get_configuration_dir()
icon_dir = config_dir.."/icons/"
theme_dir = config_dir.."/themes/artesanal-light/"
wallpaper_dir = home_dir.."/system/wallpapers/"

terminal =  os.getenv("TERMINAL")
if terminal == 'alacritty' then
  TITLE = " --title "
  NAME = " --class "
  GEO = " --dimensions "
  CMD = " -e "
elseif terminal == 'kitty' then
  TITLE = " --title=  "
  NAME = " --class=  "
  GEO = " -o WindowGeometry=  "
  CMD = " "
else
  TITLE = " -title "
  NAME = " -name "
  GEO = " -geometry "
  CMD = " -e "
end
browser = os.getenv("BROWSER") or "my-eye-into-the-world"
editor = os.getenv("EDITOR") or "vim"
musicplr1 = terminal..TITLE.."'My Player 1'"..NAME.."'My Player 1'"..CMD.."ncmpcpp"
musicplr2 = terminal..TITLE.."'My Player 2'"..NAME.."'My Player 2'"..CMD.."mocp"
mymixer = terminal..TITLE.."'My Mixer'"..NAME.."'My Mixer'"..CMD.."alsamixer"
mytop = terminal..TITLE.."'Htop'"..NAME.."'Htop'"..CMD.."htop"
editor_cli = terminal..CMD..editor
editor_gui = "gvim"
modkey = "Mod4"
altkey = "Mod1"
markup = lain.util.markup
-- }}}
-- Themes {{{2
beautiful.init(theme_dir .. "theme.lua")
-- }}}
-- Table of layouts {{{2
if hostname == 'swimmer' then
  tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
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
    })
  end)
else
  tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
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
    })
  end)
end
-- }}}
-- }}}

-- Error handling {{{1
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
  naughty.notification {
    urgency = "critical",
    title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
    message = message
  }
end)
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
  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "edit config", string.format("%s -e '%s %s'", terminal, editor, awesome.conffile) },
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
  notify = on,
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
mpd_box:set_max_size(dpi(440))
local tooltip_mpd = awful.tooltip({
  objects = { mpd_box },
  timeout = 0,
  margin_leftright = dpi(20),
  margin_topbottom = dpi(30),
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
local symbol_alsa = wibox.widget.imagebox()
symbol_alsa:buttons(gears.table.join(
  awful.button({ }, 1, function () awful.spawn.with_shell(mymixer) end),
  awful.button({ modkey }, 1, function () awful.spawn.with_shell(musicplr1) end),
  awful.button({ altkey }, 1, function () awful.spawn.with_shell(musicplr2) end)))
local volume = lain.widget.alsabar({
  width = dpi(40),
  colors = {
    background = beautiful.black1,
    mute = beautiful.red1,
    unmute = beautiful.green1
  },
  settings = function()
    if volume_now.status == "off" then
      volume_icon = theme.symbol_volume_mute
    elseif tonumber(volume_now.level) == 0 then
      volume_icon = theme.symbol_volume_mute
    elseif tonumber(volume_now.level) <= 40 then
      volume_icon = theme.symbol_volume_off
    elseif tonumber(volume_now.level) <= 70 then
      volume_icon = theme.symbol_volume_down
    else
      volume_icon = theme.symbol_volume_up
    end
    symbol_alsa:set_image(volume_icon)
  end
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
local volmargin = wibox.container.margin(volume.bar, dpi(4), dpi(0), dpi(4), dpi(4))
local widget_alsa = wibox.container.background(volmargin)
-- }}}
-- Memory widget {{{2
local symbol_mem = wibox.widget.imagebox(theme.symbol_memory)
local widget_mem = lain.widget.mem({
  settings = function()
    widget:set_markup(markup.font(beautiful.font, mem_now.used .. "MB"))
  end
})
local tooltip_mem = awful.tooltip({
  objects = { widget_mem.widget },
  margin_leftright = dpi(10),
  margin_topbottom = dpi(20),
  timer_function = function()
    local title = "Memory &amp; swap usage"
    local used = pad_to_length(mem_now.used, mem_now.swapused)
    local swapused = pad_to_length(mem_now.swapused, mem_now.used)
    local text
    text = ' <span weight="bold" color="'..beautiful.fg_normal..'">'..title..'</span> \n'..
           ' <span weight="bold">-------------------</span> \n'..
           ' ▪ memory <span color="'..beautiful.fg_normal..'">'..used..'</span> MB \n'..
           ' ▪ swap   <span color="'..beautiful.fg_normal..'">'..swapused..'</span> MB'
    return text
  end
})
-- Memory widget }}}
-- CPU widget {{{2
local symbol_cpu = wibox.widget.imagebox(theme.symbol_microchip)
local widget_cpu = wibox.layout.fixed.horizontal()
local widget_cpu_graph = wibox.widget.graph()
local widget_cpu_text = lain.widget.cpu({
  settings = function()
    widget:set_markup(markup.font(beautiful.font, cpu_now.usage .. "% "))
    widget_cpu_graph:add_value(cpu_now.usage/100)
  end
})
widget_cpu_graph:set_width(dpi(20))
widget_cpu_graph:set_background_color(beautiful.bg_normal)
widget_cpu_graph:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 18 }, stops = { { 0, beautiful.gradient_1 }, { 0.5, beautiful.gradient_2 }, { 1,beautiful.gradient_3 } } })
widget_cpu:add(widget_cpu_text.widget)
widget_cpu:add(widget_cpu_graph)
widget_cpu:buttons(gears.table.join( awful.button({ }, 1, function () awful.spawn.with_shell(mytop) end)))
local tooltip_cpu = awful.tooltip({
  objects = { widget_cpu_text.widget },
  margin_leftright = dpi(30),
  margin_topbottom = dpi(20),
})
awful.widget.watch('sensors', 4, function(widget, stdout)
  widget:set_markup(markup.fg(beautiful.fg_normal,stdout))
end, tooltip_cpu)
-- CPU widget }}}
-- Temperature widget {{{2
local symbol_temp = wibox.widget.imagebox(theme.symbol_thermometer)
local widget_temp = lain.widget.temp({
  tempfile = TEMPFILE,
  settings = function ()
    widget:set_markup(markup.font(beautiful.font, coretemp_now .. "°"))
  end
})
-- Temperature widget }}}
-- Power widget {{{2
local symbol_power = wibox.widget.imagebox()
local widget_power = lain.widget.bat({
  notify = "on",
  settings = function()
    if (not bat_now.status) or bat_now.status == "N/A" or type(bat_now.perc) ~= "number" then
      power_icon = theme.symbol_plug
      power_text = markup.font(beautiful.font, "AC")
    else
      if bat_now.status == "Charging" and tonumber(bat_now.perc) <= 70 then
        power_icon = theme.symbol_battery_half
        power_text = markup.font(beautiful.font, " " .. bat_now.perc .."%")
      elseif bat_now.status == "Charging" and tonumber(bat_now.perc) >= 70 then
        power_icon = theme.symbol_battery_three_quarters
        power_text = markup.font(beautiful.font, " " .. bat_now.perc .."%")
      else
        if tonumber(bat_now.perc) <= 10 then
          power_icon = theme.symbol_battery_empty
          power_text = markup.font(beautiful.font, " " .. bat_now.perc .. "%")
        elseif tonumber(bat_now.perc) <= 30 then
          power_icon = theme.symbol_battery_quarter
          power_text = markup.font(beautiful.font, " " .. bat_now.perc .. "%")
        elseif tonumber(bat_now.perc) <= 50 then
          power_icon = theme.symbol_battery_half
          power_text = markup.font(beautiful.font, " " .. bat_now.perc .. "%")
        elseif tonumber(bat_now.perc) <= 80 then
          power_icon = theme.symbol_battery_three_quarter
          power_text = markup.font(beautiful.font, " " .. bat_now.perc .. "%")
        else
          power_icon = theme.symbol_battery_full
          power_text = markup.font(beautiful.font, " " .. bat_now.perc .. "%")
        end
      end
    end
    widget:set_markup(markup.font(beautiful.font, power_text))
    symbol_power:set_image(power_icon)

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
  margin_leftright = dpi(10),
  margin_topbottom = dpi(20),
  timer_function = function()
    local text
    if (not bat_now.status) or bat_now.status == "N/A" or type(bat_now.perc) ~= "number" then
      text = '<span color="'..beautiful.fg_normal..'">'..
             ' Plugged in \n' ..
             ' No battery </span>'
    elseif bat_now.status == 'Discharging' then
      text = ' ▪ status    <span color="'..beautiful.fg_normal..'">discharging </span>\n'
      text = text..' ◴ time left <span color="'..beautiful.fg_normal..'">'..bat_now.time..' </span>'
    elseif  bat_now.status == 'Charging' then
      text = ' ▪ status    <span color="'..beautiful.fg_normal..'">charging </span>\n'
      text = text..' ◴ time left <span color="'..beautiful.fg_normal..'">'..bat_now.time..' </span>'
    elseif bat_now.status == 'Full' then
      text = ' ▪ status    <span color="'..beautiful.fg_normal..'">charged </span>'
    end
    return text
  end
})
-- Power widget }}}
-- Textclock widget {{{2
mytextclock = wibox.widget.textclock( '<span font="'..beautiful.clock_font..'" background="'..beautiful.clock_bg..'" color="'..beautiful.clock_fg..'">  %a %b %d, %H:%M  </span>' )
-- https://github.com/getzze/awesome_config/blob/master/rc.lua#L356 --
local mycalendar = awful.widget.calendar_popup.month({
  font = beautiful.clock_font,
  margin = dpi(4),
  week_numbers = true,
  style_month = {
    border_color = beautiful.clock_bg,
    border_width = beautiful.border_width,
    padding = dpi(2),
    shape = gears.shape.infobubble,
  },
  style_header = {
    border_color = beautiful.clock_bg,
    border_width = dpi(0),
    fg_color = beautiful.clock_fg,
    bg_color = beautiful.clock_bg,
    padding = dpi(8),
    shape = gears.shape.infobubble
  },
  style_weekday = {
    border_width = dpi(0),
    fg_color = beautiful.clock_bg,
    padding = dpi(6)
  },
  style_weeknumber = {
    border_width = dpi(0),
    fg_color = beautiful.green1,
    padding = dpi(6)
  },
  style_normal = {
    border_width = dpi(0),
    padding = dpi(6)
  },
  style_focus = {
    border_width = dpi(0),
    fg_color = beautiful.red1,
    padding = dpi(6)
  }
})
mycalendar:attach(mytextclock, 'tr')
-- Textclock widget }}}

-- Quake terminals {{{2
awful.screen.connect_for_each_screen(function(s)
  s.quakescratch = lain.util.quake({
    app = terminal,
    name = "Scratchpad",
    argname = NAME.."%s",
    height = 0.8,
    width = 0.8,
    vert = "top",
    horiz = "left"
  })
  s.quakecalc = lain.util.quake({
    app = terminal,
    name = "Calculator",
    argname = NAME.."%s",
    extra = CMD.." wcalc",
    height = 0.3,
    width = 0.3,
    vert = "top",
    horiz = "right"
  })
  s.quakexplore = lain.util.quake({
    app = terminal,
    name = "Explore",
    argname = NAME.."%s",
    extra = CMD.." mc",
    height = 0.7,
    width = 0.8,
    vert = "bottom",
    horiz = "right"
  })
  s.quakeranger = lain.util.quake({
    app = "kitty",
    name = "Ranger",
    argname = NAME.."%s",
    extra = CMD.." ranger",
    height = 1.0,
    width = 0.9,
    vert = "bottom",
    horiz = "left"
  })
end)
-- Quake terminals }}}

-- Wallpaper {{{2
screen.connect_signal("request::wallpaper", function(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.fit(wallpaper, s, beautiful.background)
  end
end)
-- Wallpaper }}}

-- Final assembly {{{2
screen.connect_signal("request::desktop_decoration", function(s)
  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox {
    screen  = s,
    buttons = {
      awful.button({ }, 1, function () awful.layout.inc( 1) end),
      awful.button({ }, 3, function () awful.layout.inc(-1) end),
      awful.button({ }, 4, function () awful.layout.inc(-1) end),
      awful.button({ }, 5, function () awful.layout.inc( 1) end),
    }
  }

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = {
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
      awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
      awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
    }
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
      screen  = s,
      filter  = awful.widget.tasklist.filter.currenttags,
      buttons = {
        awful.button({ }, 1, function (c)
          c:activate { context = "tasklist", action = "toggle_minimization" }
        end),
        awful.button({ }, 3, function() awful.menu.client_list { theme = { width = dpi(250) } } end),
        awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
        awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
      }
  }

  -- Create the wibox
  s.mywibox = awful.wibar({ position = beautiful.wibar_position, height = beautiful.wibar_height, screen = s })

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
      wibox.container.margin(symbol_alsa, dpi(0), dpi(2), dpi(3), dpi(3)),
      widget_alsa,
      spr,
      wibox.container.margin(symbol_mem, dpi(0), dpi(6), dpi(2), dpi(2)),
      widget_mem,
      spr,
      wibox.container.margin(symbol_cpu, dpi(0), dpi(6), dpi(3), dpi(3)),
      widget_cpu,
      spr,
      wibox.container.margin(symbol_temp, dpi(0), dpi(6), dpi(3), dpi(3)),
      widget_temp,
      spr,
      wibox.container.margin(symbol_power, dpi(0), dpi(6), dpi(2), dpi(2)),
      widget_power,
      spacer,
      mytextclock,
    },
  }
end)
-- Final assembly }}}
-- }}}

-- Mouse bindings {{{1
awful.mouse.append_global_mousebindings({
  awful.button({ }, 3, function () mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewprev),
  awful.button({ }, 5, awful.tag.viewnext),
})
-- }}}

-- {{{ Key bindings
-- General Awesome keys
awful.keyboard.append_global_keybindings({
  awful.key({ modkey,           }, "F1",      hotkeys_popup.show_help,
            {description="show help", group="awesome"}),
  awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
            {description = "show main menu", group = "awesome"}),
  awful.key({ modkey, "Control" }, "r", awesome.restart,
            {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit,
            {description = "quit awesome", group = "awesome"}),
})
-- Tags related keybindings
awful.keyboard.append_global_keybindings({
  -- already provided by Collision
  -- awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
            -- {description = "view previous", group = "tag"}),
  -- awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
            -- {description = "view next", group = "tag"}),
  awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
            {description = "go back", group = "tag"}),
})
-- Focus related keybindings
awful.keyboard.append_global_keybindings({
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
  awful.key({ modkey,           }, "Tab",
            function ()
              awful.client.focus.history.previous()
              if client.focus then
                client.focus:raise()
              end
            end,
            {description = "go back", group = "client"}),
  awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
            {description = "focus the next screen", group = "screen"}),
  awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
            {description = "focus the previous screen", group = "screen"}),
  awful.key({ modkey, "Control" }, "n",
            function ()
              local c = awful.client.restore()
              -- Focus restored client
              if c then
                c:activate { raise = true, context = "key.unminimize" }
              end
            end,
            {description = "restore minimized", group = "client"}),
})
-- Layout related keybindings
awful.keyboard.append_global_keybindings({
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
            {description = "swap with next client by index", group = "client"}),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
            {description = "swap with previous client by index", group = "client"}),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
            {description = "jump to urgent client", group = "client"}),
  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
            {description = "increase master width factor", group = "layout"}),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
            {description = "decrease master width factor", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
            {description = "increase the number of master clients", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
            {description = "decrease the number of master clients", group = "layout"}),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
            {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
            {description = "decrease the number of columns", group = "layout"}),
  awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
            {description = "select next", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
            {description = "select previous", group = "layout"}),
})

awful.keyboard.append_global_keybindings({
    awful.key {
      modifiers = { modkey },
      keygroup = "numrow",
      description = "only view tag",
      group = "tag",
      on_press = function (index)
        local screen = awful.screen.focused()
        local tag = screen.tags[index]
        if tag then
          tag:view_only()
        end
      end,
    },
    awful.key {
      modifiers   = { modkey, "Control" },
      keygroup    = "numrow",
      description = "toggle tag",
      group       = "tag",
      on_press    = function (index)
        local screen = awful.screen.focused()
        local tag = screen.tags[index]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
    },
    awful.key {
      modifiers = { modkey, "Shift" },
      keygroup    = "numrow",
      description = "move focused client to tag",
      group       = "tag",
      on_press    = function (index)
        if client.focus then
          local tag = client.focus.screen.tags[index]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
    },
    awful.key {
      modifiers   = { modkey, "Control", "Shift" },
      keygroup    = "numrow",
      description = "toggle focused client on tag",
      group       = "tag",
      on_press    = function (index)
        if client.focus then
          local tag = client.focus.screen.tags[index]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
    },
    awful.key {
      modifiers   = { modkey },
      keygroup    = "numpad",
      description = "select layout directly",
      group       = "layout",
      on_press    = function (index)
        local t = awful.screen.focused().selected_tag
        if t then
          t.layout = t.layouts[index] or t.layout
        end
      end,
    }
})
-- Keybindings for volume control & theme changing
awful.keyboard.append_global_keybindings({
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
  awful.key({ altkey, "Shift"     }, "a",
            function () awful.spawn.with_shell("bg-toggle") end,
            {description = "Toggle between light &amp; dark", group = "controls"}),
})
-- Application keybindings
awful.keyboard.append_global_keybindings({
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
            {description = "Rofi dialog", group = "awesome"}),
  awful.key({ altkey,           }, "r",
            function () awful.screen.focused().quakeranger:toggle() end,
            {description = "Ranger", group = "applications"}),
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
  awful.key({ modkey,           }, "z",
            function () awful.spawn("rofimoji") end,
            {description = "Emoji picker 😸", group = "applications"}),
  awful.key({                   }, "Print",
            function() awful.spawn("screengrab") end,
            {description = "Print screen", group = "controls"}),
  awful.key({ modkey,           }, "Return",
            function () awful.spawn(terminal) end,
            {description = "Open a terminal", group = "awesome"})
})

client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings({
    awful.button({ }, 1, function (c)
      c:activate { context = "mouse_click" }
    end),
    awful.button({ modkey }, 1, function (c)
      c:activate { context = "mouse_click", action = "mouse_move"  }
    end),
    awful.button({ modkey }, 3, function (c)
      c:activate { context = "mouse_click", action = "mouse_resize"}
    end),
  })
end)

client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings({
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
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
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
              {description = "(un)maximize", group = "client"}),
  awful.key({ modkey, "Shift"     }, "t",      function (c) awful.titlebar.toggle(c)         end,
              {description = "toggle titlebar", group = "client"})
  })
end)
-- }}}

-- Rules {{{1
-- Rules to apply to new clients (through the "manage" signal).
ruled.client.connect_signal("request::rules", function()
  -- All clients will match this rule.
  ruled.client.append_rule {
    id = "global",
    rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      shape = app_shape,
      honor_workarea = true,
      honor_padding  = true,
      placement = awful.placement.no_offscreen+awful.placement.centered
    }
  }

  -- Add titlebars only to dialogs
  ruled.client.append_rule {
    id = "titlebars",
    rule_any = { type = { "dialog" } },
    properties = { titlebars_enabled = true }
  }

  -- Floating clients.
  ruled.client.append_rule {
    id = "floating",
    rule_any = {
      class = {
        "Apvlv",
        "Audacity",
        "Lxappearance",
        "pinentry",
        "Scribus",
        "Thunderbird",
        "Wpa_gui",
        "Zathura",
        "Scratchpad",
      },
      name = {
        "Calculator",
        "Event Tester",
        "Explore",
        "Htop",
        "IP Traffic",
        "Scratchpad",
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
      },
      type = {
        "dialog",
      }
    },
    properties = { floating = true }
  }

  -- Tag associations
  ruled.client.append_rule {
    rule_any = {
      name = {
        "^sys"
      }
    },
    properties = { tag = "1" }
  }
  ruled.client.append_rule {
    rule_any = {
      name = {
        "^work"
      }
    },
    properties = { tag = "2" }
  }
  ruled.client.append_rule {
    rule_any = {
      name = {
        "^com"
      }
    },
    properties = { tag = "3" }
  }
  ruled.client.append_rule {
    rule_any = {
      name = {
        "^tj"
      }
    },
    properties = { tag = "3" }
  }
  ruled.client.append_rule {
    rule_any = {
      name = {
        "^komala"
      }
    },
    properties = { tag = "5" }
  }
  ruled.client.append_rule {
    rule_any = {
      name = {
        "laptop$",
        "^home",
        "^swimmer"
      }
    },
    properties = { tag = "6" }
  }
  ruled.client.append_rule {
    rule_any = {
      class = {
        "Thunderbird",
        "Scribus",
        "VirtualBox"
      }
    },
    properties = { tag = "7" }
  }
  ruled.client.append_rule {
    rule_any = {
      class = {
        "Darktable",
        "Gimp",
        "Inkscape"
      }
    },
    properties = { tag = "8" }
  }
  ruled.client.append_rule {
    rule_any = {
      class = {
        "Audacious",
        "Audacity",
        "Puddletag"
      }
    },
    properties = { tag = "9" }
  }

  -- Application & host specific rules
  if hostname == "swimmer" then
    ruled.client.append_rule {
      rule_any = {
        role = { "GtkFileChooserDialog" },
        name  = {
          "^Edit",
          "^Open",
          "^Save",
        }
      },
      properties = {
        floating = true,
        width = dpi(1000), height = dpi(600)
      }
    }
    ruled.client.append_rule {
      rule_any = {
        name = {
          "^sys",
          "^work",
          "^com",
          "^komala",
          "laptop$"
        }
      },
      properties = {
        geometry = { width = 2940, height = 2100, x = 440, y = 18 }
      }
    }
    ruled.client.append_rule {
      rule_any = {
        name = { "Firefox" },
        class = {
          "Firefox",
          "Nightly",
          "Google-chrome-beta",
          "Thunderbird"
        }
      },
      properties = {
        x = dpi(0), y = dpi(20)
      }
    }
    ruled.client.append_rule {
      rule = { name = "Htop" },
      properties = {
        floating = true,
        width = dpi(1000), height = dpi(800), x = dpi(600), y = dpi(20)
      }
    }
    ruled.client.append_rule {
      rule = { name = "My Player 1" },
      properties = {
        floating = true,
        width = dpi(1400), height = dpi(880), x = dpi(240), y = dpi(20)
      }
    }
    ruled.client.append_rule {
      rule = { name = "My Player 2" },
      properties = {
        floating = true,
        width = dpi(1000), height = dpi(660), x = dpi(440), y = dpi(20)
      }
    }
    ruled.client.append_rule {
      rule = { name = "My Mixer" },
      properties = {
        floating = true,
        width = dpi(1600), height = dpi(400), x = dpi(440), y = dpi(20)
      }
    }
  else
    ruled.client.append_rule {
      rule_any = {
        role = { "GtkFileChooserDialog" },
        name  = {
          "^Edit",
          "^Open",
          "^Save",
        }
      },
      properties = {
        floating = true,
        width = dpi(660), height = dpi(440)
      }
    }
    ruled.client.append_rule {
      rule = { name = "Htop" },
      properties = {
        floating = true,
        width = dpi(800), height = dpi(600), x = dpi(400), y = dpi(20)
      }
    }
    ruled.client.append_rule {
      rule = { name = "My Player 1" },
      properties = {
        floating = true,
        width = dpi(1000), height = dpi(660), x = dpi(140), y = dpi(20)
      }
    }
    ruled.client.append_rule {
      rule = { name = "My Player 2" },
      properties = {
        floating = true,
        width = dpi(800), height = dpi(600), x = dpi(240), y = dpi(20)
      }
    }
    ruled.client.append_rule {
      rule = { name = "My Mixer" },
      properties = {
        floating = true,
        width = dpi(1600), height = dpi(400), x = dpi(240), y = dpi(20)
      }
    }
  end
end)
-- }}}

-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function (c)
  -- buttons for the titlebar
  local buttons = {
    awful.button({ }, 1, function() c:activate { context = "titlebar", action = "mouse_move"  } end),
    awful.button({ }, 3, function() c:activate { context = "titlebar", action = "mouse_resize"} end)
  }
  awful.titlebar(c).widget = {
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout = wibox.layout.fixed.horizontal
    },
    { -- Middle
      { -- Title
        align = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout = wibox.layout.flex.horizontal
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
end)
-- }}}

-- {{{ Notifications
ruled.notification.connect_signal('request::rules', function()
  -- All notifications will match this rule.
  ruled.notification.append_rule {
    rule = { },
    properties = {
      screen = awful.screen.preferred,
      border_width = beautiful.border_width * 1.4,
      margin = dpi(10),
      implicit_timeout = 5,
    }
  }
end)

naughty.connect_signal("request::display", function(n)
  naughty.layout.box { notification = n }
end)
-- }}}

-- Signals {{{1
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  if awesome.startup and
    not c.size_hints.user_position
    and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
  end
end)
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:activate { context = "mouse_enter", raise = false }
end)
-- Change border colour with focus
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
