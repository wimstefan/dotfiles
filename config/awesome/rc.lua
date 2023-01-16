-- my awesome config
-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local shape = require("gears.shape")
local wibox = require("wibox")
-- Appearance & theme handling library
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local lain = require("lain")
local vicious = require("vicious")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
-- Utilities
local helpers = require("helpers")
local inspect = require("helpers.inspect")

-- {{{1 Error handling
naughty.connect_signal("request::display_error", function(message, startup)
  naughty.notification {
    urgency = "critical",
    title   = "Oops, an error happened" .. (startup and " during startup!" or "!"),
    message = message
  }
end)
-- 1}}}

-- {{{1 Variable definitions
local modkey = "Mod4"
local altkey = "Mod1"
local ctrlkey = "Control"
local shftkey = "Shift"

beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/xresources/theme.lua")

local hostname = io.lines("/proc/sys/kernel/hostname")()
if hostname == 'swimmer' then
  TYPE = "desktop"
  TEMPFILE = "/sys/devices/virtual/thermal/thermal_zone0/temp"
elseif hostname == 'tj' then
  TYPE = "laptop"
  TEMPFILE = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon3/temp1_input"
end

local terminal = os.getenv("TERMINAL")
if terminal == 'alacritty' then
  TITLE = " --title "
  CLASS = " --class "
  CMD = " -e "
elseif terminal == 'kitty' then
  TITLE = " --title "
  CLASS = " --class="
  CMD = " "
elseif terminal == 'wezterm' then
  TITLE = ""
  CLASS = " start --class "
  CMD = " "
else
  TITLE = " -title "
  CLASS = " -name "
  CMD = " -e "
end

local browser = os.getenv("BROWSER") or "my-eye-into-the-world"
local editor = os.getenv("EDITOR") or "nvim"
local myplayer = terminal .. CLASS .. "'Player'" .. CMD .. "ncmpcpp"
local mymixer = terminal .. CLASS .. "'Mixer'" .. CMD .. "alsamixer"
local mytop = terminal .. CLASS .. "'Top'" .. CMD .. "htop"
local editor_cmd = terminal .. CLASS .. "'Editing ...'" .. CMD .. editor
-- 1}}}

-- {{{1 Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end }
}
local mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
  { "open terminal", terminal }
}
})
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- 1}}}

-- {{{1 Tag layout
tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.magnifier,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.corner.nw,
  })
end)
-- 1}}}

-- {{{1 Wallpaper
screen.connect_signal("request::wallpaper", function(s)
  awful.wallpaper {
    screen = s,
    widget = {
      {
        image     = beautiful.wallpaper,
        upscale   = false,
        downscale = true,
        widget    = wibox.widget.imagebox,
      },
      valign = "center",
      halign = "right",
      tiled  = false,
      widget = wibox.container.tile,
    }
  }
end)
-- 1}}}

-- {{{1 Wibar
-- {{{2 Formatting aids
local spacer = wibox.widget.textbox(' ')
local spr = wibox.widget.textbox('<span color="' .. beautiful.blue_alt .. '" weight="bold"> │ </span>')
-- }}}
-- {{{2 ALSA volume bar
local symbol_alsa = wibox.widget.imagebox()
symbol_alsa:buttons(gears.table.join(
  awful.button({}, 1, function() awful.spawn.with_shell(mymixer) end),
  awful.button({ modkey }, 1, function() awful.spawn.with_shell(myplayer) end)
))
local volume = lain.widget.alsabar({
  width = dpi(40),
  colors = {
    background = beautiful.foreground .. "33",
    mute = beautiful.red_alt,
    unmute = beautiful.tint_symbol
  },
  settings = function()
    if volume_now.status == "off" then
      volume_icon = beautiful.symbol_volume_mute
    elseif tonumber(volume_now.level) == 0 then
      volume_icon = beautiful.symbol_volume_mute
    elseif tonumber(volume_now.level) <= 40 then
      volume_icon = beautiful.symbol_volume_off
    elseif tonumber(volume_now.level) <= 70 then
      volume_icon = beautiful.symbol_volume_down
    else
      volume_icon = beautiful.symbol_volume_up
    end
    symbol_alsa:set_image(volume_icon)
  end
})
-- volume.tooltip
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
-- ALSA volume bar }}}
-- {{{2 CPU widget
local symbol_cpu = wibox.widget.imagebox(beautiful.symbol_microchip)
symbol_cpu:buttons(gears.table.join(
  awful.button({}, 1, function()
    awful.spawn.with_shell(mytop)
  end)
))
local widget_cpu = wibox.layout.fixed.horizontal()
local widget_cpu_proc = wibox.widget({
  forced_width = dpi(37),
  align = "right",
  widget = wibox.widget.textbox,
})
vicious.cache(vicious.widgets.cpu)
vicious.register(widget_cpu_proc, vicious.widgets.cpu, '$1% ')
widget_cpu:add(widget_cpu_proc)
local widget_cpu_freq = wibox.widget({
  forced_width = dpi(50),
  align = "right",
  widget = wibox.widget.textbox,
})
vicious.cache(vicious.widgets.cpuinf)
vicious.register(widget_cpu_freq, vicious.widgets.cpuinf, '${cpu0 mhz}mhz')
widget_cpu:add(widget_cpu_freq)
widget_cpu:buttons(gears.table.join(
  awful.button({}, 1, function()
    awful.spawn.with_shell(mytop)
  end)
))
-- CPU widget }}}
-- {{{2 Temperature widget
local symbol_temp = wibox.widget.imagebox(beautiful.symbol_thermometer)
local widget_temp = lain.widget.temp({
  tempfile = TEMPFILE,
  settings = function()
    widget:set_markup(coretemp_now .. "°")
  end
})
local tooltip_temp = awful.tooltip({
  objects = { widget_temp.widget },
  margin_leftright = dpi(30),
  margin_topbottom = dpi(30),
})
awful.widget.watch('sensors', 4, function(widget, stdout)
  widget:set_markup(stdout)
end, tooltip_temp)
-- Temperature widget }}}
-- {{{2 Power widget
local symbol_power = wibox.widget.imagebox()
local widget_power = lain.widget.bat({
  notify = "on",
  settings = function()
    if (not bat_now.status) or bat_now.status == "N/A" or type(bat_now.perc) ~= "number" then
      power_icon = beautiful.symbol_plug
      power_text = "AC"
    else
      if bat_now.status == "Charging" and tonumber(bat_now.perc) <= 70 then
        power_icon = beautiful.symbol_battery_half
        power_text = bat_now.perc .. "%"
      elseif bat_now.status == "Charging" and tonumber(bat_now.perc) >= 70 then
        power_icon = beautiful.symbol_battery_three_quarters
        power_text = bat_now.perc .. "%"
      else
        if tonumber(bat_now.perc) == "0..9" then
          power_icon = beautiful.symbol_battery_empty
          power_text = bat_now.perc .. "%"
        elseif tonumber(bat_now.perc) <= 10 then
          power_icon = beautiful.symbol_battery_empty
          power_text = bat_now.perc .. "%"
        elseif tonumber(bat_now.perc) <= 30 then
          power_icon = beautiful.symbol_battery_quarter
          power_text = bat_now.perc .. "%"
        elseif tonumber(bat_now.perc) <= 50 then
          power_icon = beautiful.symbol_battery_half
          power_text = bat_now.perc .. "%"
        elseif tonumber(bat_now.perc) <= 80 then
          power_icon = beautiful.symbol_battery_three_quarters
          power_text = bat_now.perc .. "%"
        else
          power_icon = beautiful.symbol_battery_full
          power_text = bat_now.perc .. "%"
        end
      end
    end
    widget:set_markup(power_text)
    symbol_power:set_image(power_icon)

    bat_notification_charged_preset = {
      title   = "Battery full",
      text    = "You can unplug the cable",
      timeout = 15,
      fg      = beautiful.fg_normal,
      bg      = beautiful.bg_normal
    }
    bat_notification_low_preset = {
      title = "Battery low",
      text = "Plug the cable!",
      timeout = 15,
      font = beautiful.clock_font,
      border_color = beautiful.red,
      border_width = beautiful.border_width * 2.2,
      fg = beautiful.red,
      bg = beautiful.real_white
    }
    bat_notification_critical_preset = {
      title = "Battery exhausted",
      text = "Shutdown imminent",
      timeout = 15,
      fg = beautiful.fg_urgent,
      bg = beautiful.bg_urgent
    }
  end
})
local tooltip_bat = awful.tooltip({
  objects = { widget_power.widget },
  margin_leftright = dpi(20),
  margin_topbottom = dpi(20),
  timer_function = function()
    local text
    if (not bat_now.status) or bat_now.status == "N/A" or type(bat_now.perc) ~= "number" then
      text = "[Plugged in]\n" .. " No battery"
    elseif bat_now.status == "Discharging" then
      text = "[status] discharging\n" .. "羽 time left " .. bat_now.time
    elseif bat_now.status == "Charging" then
      text = "[status] charging\n" .. "羽 time left " .. bat_now.time
    elseif bat_now.status == "Full" then
      text = "[status] charged"
    end
    return text
  end
})
-- Power widget }}}
-- {{{2 Wifi widget
widget_wifi = wibox.widget.textbox()
vicious.register(widget_wifi, vicious.widgets.wifiiw, "[${ssid}] ${rate}MB/s ${linp}%", 10, "wlan0")
-- Wifi widget }}}
-- {{{2 Textclock widget
local mytextclock = wibox.widget.textclock('<span font="' ..
  beautiful.clock_font .. '" color="' .. beautiful.blue_alt .. '">%a %d | %H:%M</span>')
-- https://github.com/getzze/awesome_config/blob/master/rc.lua#L356 --
local mycalendar = awful.widget.calendar_popup.month({
  font = beautiful.clock_font,
  margin = dpi(4),
  week_numbers = true,
  style_month = {
    border_color = beautiful.blue_alt,
    border_width = beautiful.border_width,
    padding = dpi(2),
    shape = shape.infobubble,
  },
  style_header = {
    border_color = beautiful.blue_alt,
    border_width = dpi(0),
    fg_color = beautiful.bg_normal,
    bg_color = beautiful.blue_alt,
    padding = dpi(8),
    shape = shape.infobubble
  },
  style_weekday = {
    border_width = dpi(0),
    fg_color = beautiful.blue_alt,
    bg_color = beautiful.bg_transparent,
    padding = dpi(6)
  },
  style_weeknumber = {
    border_width = dpi(0),
    fg_color = beautiful.green_alt,
    bg_color = beautiful.bg_transparent,
    padding = dpi(6)
  },
  style_normal = {
    border_width = dpi(0),
    padding = dpi(6)
  },
  style_focus = {
    border_width = dpi(0),
    -- fg_color = beautiful.real_white,
    -- bg_color = beautiful.red_alt,
    fg_color = beautiful.red_alt,
    bg_color = beautiful.bg_transparent,
    padding = dpi(6)
  }
})
mycalendar:attach(mytextclock, 'tr')
-- Textclock widget }}}
-- {{{2 Final assembly
screen.connect_signal("request::desktop_decoration", function(s)
  -- Define the tag tables
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- Create the right widget box
  if TYPE == "laptop" then
    s.mywidgetlist = {
      layout = wibox.layout.fixed.horizontal,
      wibox.widget.systray(),
      spacer,
      wibox.container.margin(symbol_alsa, dpi(0), dpi(6), dpi(6), dpi(6)),
      wibox.container.margin(widget_alsa, dpi(0), dpi(0), dpi(5), dpi(5)),
      spr,
      wibox.container.margin(symbol_cpu, dpi(0), dpi(6), dpi(6), dpi(6)),
      widget_cpu,
      spr,
      wibox.container.margin(symbol_temp, dpi(0), dpi(6), dpi(6), dpi(6)),
      widget_temp,
      spr,
      wibox.container.margin(symbol_power, dpi(0), dpi(6), dpi(6), dpi(6)),
      widget_power,
      spr,
      widget_wifi,
      spr,
      mytextclock,
      spacer,
      spacer,
      spacer,
    }
  else
    s.mywidgetlist = {
      layout = wibox.layout.fixed.horizontal,
      wibox.widget.systray(),
      spacer,
      wibox.container.margin(symbol_alsa, dpi(0), dpi(6), dpi(6), dpi(6)),
      wibox.container.margin(widget_alsa, dpi(0), dpi(0), dpi(5), dpi(5)),
      spr,
      wibox.container.margin(symbol_cpu, dpi(0), dpi(6), dpi(6), dpi(6)),
      widget_cpu,
      spr,
      wibox.container.margin(symbol_temp, dpi(0), dpi(6), dpi(6), dpi(6)),
      widget_temp,
      spr,
      mytextclock,
      spacer,
      spacer,
      spacer,
    }
  end

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox {
    screen  = s,
    buttons = {
      awful.button({}, 1, function() awful.layout.inc(1) end),
      awful.button({}, 3, function() awful.layout.inc(-1) end),
      awful.button({}, 4, function() awful.layout.inc(-1) end),
      awful.button({}, 5, function() awful.layout.inc(1) end),
    }
  }

  ---@diagnostic disable-next-line: unused-local
  local update_tags = function(self, c3, index, objects)
    if hostname == "tj" then
      if (c3.selected) then
        beautiful.taglist_font = beautiful.taglist_font_focus
      elseif c3.urgent then
        beautiful.taglist_font = beautiful.taglist_font_focus
      else
        beautiful.taglist_font = beautiful.font_name .. "Bold 10"
      end
    else
      if (c3.selected) then
        beautiful.taglist_font = beautiful.taglist_font_focus
      elseif c3.urgent then
        beautiful.taglist_font = beautiful.taglist_font_focus
      else
        beautiful.taglist_font = beautiful.font_name .. "Bold 11"
      end
    end
  end

  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = {
      awful.button({}, 1, function(t) t:view_only() end),
      awful.button({ modkey }, 1, function(t)
        if t.focus then
          t.focus:move_to_tag(t)
        end
      end),
      awful.button({}, 3, awful.tag.viewtoggle),
      awful.button({ modkey }, 3, function(t)
        if t.focus then
          t.focus:toggle_tag(t)
        end
      end),
      awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
      awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
    },
    layout = {
      layout = wibox.layout.fixed.horizontal,
      spacing = beautiful.spacing,
      spacing_widget = {
        widget = wibox.widget.separator,
        color = beautiful.cyan,
        thickness = dpi(1.0),
        span_ratio = 0.4,
      },
    },
    widget_template = {
      {
        {
          id   = "text_role",
          widget = wibox.widget.textbox,
        },
        widget = wibox.container.margin,
        margins = beautiful.spacing
      },
      id   = "background_role",
      widget = wibox.container.background,
      create_callback = update_tags,
      update_callback = update_tags,
    }
  }

  local task_popup = awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.allscreen,
    layout = {
      layout = wibox.layout.fixed.vertical
    },
    buttons = {
      awful.button({}, 1, function(c) c:activate { context = "tasklist", raise = true, switch_to_tag = true } end),
    },
    widget_template = {
        {
          {
            {
              id = "clienticon",
              widget = awful.widget.clienticon,
            },
            widget = wibox.container.margin,
            left = beautiful.spacing,
            right = beautiful.spacing * 2,
          },
          {
            id = "text_role",
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        id = "background_role",
        widget = wibox.container.background,
        forced_width = dpi(800),
        forced_height = dpi(18),
    }
  }
  s.mytasklist = awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    widget_template = {
      {
        {
          id = "clienticon",
          widget = awful.widget.clienticon
        },
        widget = wibox.container.margin,
        margins = dpi(6)
      },
      {
        id = "text_role",
        widget = wibox.widget.textbox,
      },
      layout = wibox.layout.fixed.horizontal
    },
    buttons = {
      awful.button({}, 1, function(c) c:activate { context = "tasklist", action = "toggle_minimization" } end),
      awful.button({}, 3, function()
        awful.popup {
          widget = wibox.widget {
            task_popup,
            widget = wibox.container.margin,
            margins = beautiful.spacing * 2.4
          },
          border_color = beautiful.border_color_active,
          border_width = beautiful.border_width * 0.4,
          ontop = true,
          hide_on_right_click = true,
          placement = awful.placement.top,
          shape = gears.shape.rounded_rect,
        }
      end),
      awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
      awful.button({}, 5, function() awful.client.focus.byidx(1) end),
    },
  }

  -- Create the wibox
  s.mywibox = awful.wibar({
    type = "dock",
    position = beautiful.wibar_position,
    height = beautiful.wibar_height,
    screen = s,
    widget = {
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        s.mylayoutbox,
        spacer,
        s.mytaglist,
        s.mypromptbox,
        spacer,
      },
      s.mytasklist, -- Middle widget
      s.mywidgetlist, -- Right widgets
    },
  })
  s.mywibox:struts({
    top = beautiful.wibar_height + dpi(8),
  })
end)
-- Final assembly }}}
-- 1}}}

-- {{{1 Mouse bindings
awful.mouse.append_global_mousebindings({
  awful.button({}, 3, function() mymainmenu:toggle() end),
  awful.button({}, 4, awful.tag.viewprev),
  awful.button({}, 5, awful.tag.viewnext),
})
-- 1}}}

-- {{{1 Key bindings
-- {{{2 General Awesome keys
awful.keyboard.append_global_keybindings({
  awful.key({ modkey }, "F1", hotkeys_popup.show_help,
    { description = "show help", group = "awesome" }),
  awful.key({ modkey }, "w", function() mymainmenu:show() end,
    { description = "show main menu", group = "awesome" }),
  awful.key({ modkey, shftkey }, "r", awesome.restart,
    { description = "reload awesome", group = "awesome" }),
  awful.key({ modkey, shftkey }, "q", awesome.quit,
    { description = "quit awesome", group = "awesome" }),
  awful.key({ modkey }, "Return", function() awful.spawn(terminal) end,
    { description = "Open a terminal", group = "awesome" }),
  awful.key({ modkey }, "r",
    function() awful.spawn("rofi -theme '~/.config/rofi/config-sidebar.rasi' -modi combi,window,drun,run,ssh -show combi -combi-modi window,run,ssh") end ,
    { description = "Rofi dialog", group = "awesome" }),
})
-- 2}}}
-- {{{2 Tag related keybindings
awful.keyboard.append_global_keybindings({
  awful.key({ modkey, }, "Left", awful.tag.viewprev,
    { description = "view previous", group = "tag" }),
  awful.key({ modkey, }, "Right", awful.tag.viewnext,
    { description = "view next", group = "tag" }),
  awful.key({ modkey }, "Escape", awful.tag.history.restore,
    { description = "go back", group = "tag" }),
  awful.key {
    modifiers = { modkey },
    keygroup = "numrow",
    description = "only view tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  },
  awful.key {
    modifiers = { modkey, ctrlkey },
    keygroup = "numrow",
    description = "toggle tag",
    group = "tag",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end,
  },
  awful.key {
    modifiers = { modkey, shftkey },
    keygroup = "numrow",
    description = "move focused client to tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
  },
  awful.key {
    modifiers = { modkey, ctrlkey, shftkey },
    keygroup = "numrow",
    description = "toggle focused client on tag",
    group = "tag",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end,
  },
})
-- 2}}}
-- {{{2 Client related keybindings
awful.keyboard.append_global_keybindings({
  awful.key({ modkey }, "Tab", function() awful.client.focus.byidx(1) end,
    { description = "focus next by index", group = "client" }),
  awful.key({ modkey, shftkey }, "Tab", function() awful.client.focus.byidx(-1) end,
    { description = "focus previous by index", group = "client" }),
  awful.key({ shftkey }, "Right", function() awful.client.focus.bydirection("right") end,
    {description = "focus right", group = "client"}),
  awful.key({ shftkey }, "Left", function() awful.client.focus.bydirection("left") end,
    {description = "focus left", group = "client"}),
  awful.key({ shftkey }, "Up", function() awful.client.focus.bydirection("up") end,
    {description = "focus up", group = "client"}),
  awful.key({ shftkey }, "Down", function() awful.client.focus.bydirection("down") end,
    {description = "focus down", group = "client"}),
  awful.key({ modkey, shftkey }, "j", function() awful.client.swap.byidx(1) end,
    { description = "swap with next client by index", group = "client" }),
  awful.key({ modkey, shftkey }, "k", function() awful.client.swap.byidx(-1) end,
    { description = "swap with previous client by index", group = "client" }),
  awful.key({ modkey, shftkey }, "u", awful.client.urgent.jumpto,
    { description = "jump to urgent client", group = "client" }),
})
client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings({
    awful.key({ modkey }, "f",
      function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
      end,
      { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, shftkey }, "c", function(c) c:kill() end,
      { description = "close", group = "client" }),
    awful.key({ modkey, shftkey }, "d",
      function()
        local clients = awful.screen.focused().clients
        for _, c in pairs(clients) do
          c:kill()
        end
      end,
      { description = "kill all visible clients for the current tag", group = "client" }
    ),
    awful.key({ modkey, ctrlkey }, "space", function(c) c.floating = true end,
      { description = "toggle floating", group = "client" }),
    awful.key({ modkey, ctrlkey }, "t", function(c) c.ontop = not c.ontop end,
      { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey }, "n",
      function(c)
        c.minimized = true
      end,
      { description = "minimize", group = "client" }),
    awful.key({ modkey, ctrlkey }, "n",
      function()
        local c = awful.client.restore()
        if c then
          c:activate { raise = true, context = "key.unminimize" }
        end
      end,
      { description = "restore minimized", group = "client" }),
    awful.key({ modkey, }, "m",
      function(c)
        c.maximized = not c.maximized
        c:raise()
      end,
      { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, ctrlkey }, "m",
      function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
      end,
      { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, shftkey }, "m",
      function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
      end,
      { description = "(un)maximize horizontally", group = "client" }),
    awful.key({ modkey, shftkey }, "t", function(c) awful.titlebar.toggle(c) end,
      { description = "toggle titlebar", group = "client" }),
    awful.key({ modkey, altkey }, "m", lain.util.magnify_client,
      { description = "(de)magnify", group = "client" }),
    awful.key({ modkey, altkey }, "Down", function(c) helpers.resize_dwim(c, "down") end,
      { description = "resize down", group = "client" }),
    awful.key({ modkey, altkey }, "Up", function(c) helpers.resize_dwim(c, "up") end,
      { description = "resize up", group = "client" }),
    awful.key({ modkey, altkey }, "Left", function(c) helpers.resize_dwim(c, "left") end,
      {description = "resize left", group = "client" }),
    awful.key({ modkey, altkey }, "Right", function(c) helpers.resize_dwim(c, "right") end,
      { description = "resize right", group = "client" }),
    awful.key({ altkey, shftkey }, "Down", function (c) helpers.move_client_dwim(c, "down") end,
      { description = "move down", group = "client" }),
    awful.key({ altkey, shftkey }, "Up", function (c) helpers.move_client_dwim(c, "up") end,
      { description = "move up", group = "client" }),
    awful.key({ altkey, shftkey }, "Left", function (c) helpers.move_client_dwim(c, "left") end,
      { description = "move left", group = "client" }),
    awful.key({ altkey, shftkey }, "Right", function (c) helpers.move_client_dwim(c, "right") end,
      { description = "move right", group = "client" })
    })
end)
-- 2}}}
-- {{{2 Layout related keybindings
awful.keyboard.append_global_keybindings({
  awful.key({ modkey, shftkey }, "Right", function() awful.tag.incnmaster(1, nil, true) end,
    { description = "increase the number of master clients", group = "layout" }),
  awful.key({ modkey, shftkey }, "Left", function() awful.tag.incnmaster(-1, nil, true) end,
    { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ modkey, shftkey, ctrlkey }, "Right", function() awful.tag.incncol(1, nil, true) end,
    { description = "increase the number of columns", group = "layout" }),
  awful.key({ modkey, shftkey, ctrlkey }, "Left", function() awful.tag.incncol(-1, nil, true) end,
    { description = "decrease the number of columns", group = "layout" }),
  awful.key({ modkey, ctrlkey }, "Right", function() awful.tag.incmwfact(0.05) end,
    { description = "increase master width factor", group = "layout" }),
  awful.key({ modkey, ctrlkey }, "Left", function() awful.tag.incmwfact(-0.05) end,
    { description = "decrease master width factor", group = "layout" }),
  awful.key({ modkey, ctrlkey }, "Up", function() awful.tag.incmwfact(0.05) end,
    { description = "increase master height factor", group = "layout" }),
  awful.key({ modkey, ctrlkey }, "Down", function() awful.tag.incmwfact(-0.05) end,
    { description = "decrease master height factor", group = "layout" }),
  awful.key({ modkey }, "space", function() awful.layout.inc(1) end,
    { description = "select next", group = "layout" }),
  awful.key({ modkey, shftkey }, "space", function() awful.layout.inc(-1) end,
    { description = "select previous", group = "layout" }),
  awful.key {
    modifiers = { modkey },
    keygroup = "numpad",
    description = "select layout directly",
    group = "layout",
    on_press = function(index)
      local t = awful.screen.focused().selected_tag
      if t then
        t.layout = t.layouts[index] or t.layout
      end
    end,
  },
  awful.key({ modkey, shftkey }, "=", function () awful.tag.incgap(5, nil) end,
    {description = "increment gaps size for the current tag", group = "gaps"}
  ),
  awful.key({ modkey, shftkey }, "minus", function () awful.tag.incgap(-5, nil) end,
    {description = "decrement gap size for the current tag", group = "gaps"}
  ),
})
-- 2}}}
-- {{{2 Keybindings for theme changing
awful.keyboard.append_global_keybindings({
  awful.key({ altkey, shftkey }, "d",
    function() awful.spawn.with_shell("=bg-toggle dark") end,
    { description = "Enable dark theme", group = "controls" }),
  awful.key({ altkey, shftkey }, "l",
    function() awful.spawn.with_shell("=bg-toggle light") end,
    { description = "Enable light theme", group = "controls" }),
})
-- 2}}}
-- {{{2 Application keybindings
awful.keyboard.append_global_keybindings({
  awful.key({ modkey }, "a", function() awful.spawn("audacity") end,
    { description = "Audacity", group = "applications" }),
  awful.key({ modkey }, "b", function() awful.spawn(browser) end,
    { description = "Browser", group = "applications" }),
  awful.key({ modkey }, "c",
    function()
      awful.spawn.with_shell("tdrop -n Calculator -a -m -w 30% -h 30% -y " ..
        math.floor(beautiful.wibar_height + 20) .. " -x 69% " .. terminal .. CLASS .. "'Calculator' " .. CMD .. "wcalc")
    end,
    { description = "Calculator", group = "applications" }),
  awful.key({ modkey }, "d", function() awful.spawn("darktable") end,
    { description = "Darktable", group = "applications" }),
  awful.key({ modkey }, "e", function() awful.spawn(editor_cmd) end,
    { description = "Editor", group = "applications" }),
  awful.key({ modkey }, "g", function() awful.spawn("gimp") end,
    { description = "Gimp", group = "applications" }),
  awful.key({ modkey }, "o", function() awful.spawn("libreoffice") end,
    { description = "Libreoffice", group = "applications" }),
  awful.key({ modkey }, "p", function() awful.spawn("puddletag") end,
    { description = "Puddletag", group = "applications" }),
  awful.key({ modkey }, "x",
    function()
      awful.spawn.with_shell("tdrop -n Explore -a -m -w 90% -h 90% -y 9% -x 9% " ..
        terminal .. CLASS .. "'Explore' " .. CMD .. "vifm")
    end,
    { description = "Explore", group = "applications" }),
  awful.key({ modkey }, "s",
    function()
      awful.spawn.with_shell("tdrop -n Scratchpad -a -m -w 75% -h 66% -y " ..
        math.floor(beautiful.wibar_height + 20) .. " -x 14 " .. terminal .. CLASS .. "'Scratchpad'")
    end,
    { description = "Scratchpad", group = "applications" }),
  awful.key({ modkey }, "t", function() awful.spawn("thunderbird") end,
    { description = "Thunderbird", group = "applications" }),
  awful.key({ modkey }, "u", function() awful.spawn("ta-mixxx") end,
    { description = "Mixxx", group = "applications" }),
  awful.key({ modkey }, "v", function() awful.spawn("lxappearance") end,
    { description = "Lxappearance", group = "applications" }),
  awful.key({ modkey }, "z",
    function() awful.spawn("rofi -theme '~/.config/rofi/config-sidebar.rasi' -modi emoji -show emoji") end,
    { description = "Emoji picker 😸", group = "applications" }),
  awful.key({}, "Print",
    function() awful.spawn.with_shell("scrot -s -F ~/tmp/screenshots/scrot-%F-%R.png") end,
    { description = "Print screen", group = "controls" }),
})

client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings({
    awful.button({}, 1, function(c)
      c:activate { context = "mouse_click" }
    end),
    awful.button({ modkey }, 1, function(c)
      c:activate { context = "mouse_click", action = "mouse_move" }
    end),
    awful.button({ modkey }, 3, function(c)
      c:activate { context = "mouse_click", action = "mouse_resize" }
    end),
  })
end)

-- 2}}}
-- 1}}}

-- {{{1 Rules
-- Rules to apply to new clients (through the "manage" signal).
ruled.client.connect_signal("request::rules", function()
  -- All clients will match this rule.
  ruled.client.append_rule {
    id = "global",
    rule = {},
    properties = {
      border_width   = beautiful.border_width,
      border_color   = beautiful.border_color_normal,
      focus          = awful.client.focus.filter,
      raise          = true,
      screen         = awful.screen.preferred,
      shape          = beautiful.app_shape,
      honor_workarea = true,
      honor_padding  = true,
      placement      = awful.placement.no_offscreen + awful.placement.centered
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
        "Audacity",
        "puddletag",
        "Lxappearance",
        "Gpick",
        "pinentry",
        "scribus",
        "Thunderbird",
        "Wpa_gui",
        "Zathura",
        "Scratchpad",
      },
      name = {
        "Calculator",
        "Event Tester",
        "Explore",
        "Top",
        "IP Traffic",
        "Scratchpad",
      },
      role = {
        "AlarmWindow", -- Thunderbird's calendar.
        "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
      },
      type = {
        "dialog",
      }
    },
    properties = { floating = true }
  }
  -- Tag associations
  ruled.client.append_rule { rule_any = { class = { "^sys" } }, properties = { tag = "1" } }
  ruled.client.append_rule { rule_any = { class = { "^work" } }, properties = { tag = "2" } }
  ruled.client.append_rule { rule_any = { class = { "^com" } }, properties = { tag = "3" } }
  ruled.client.append_rule { rule_any = { class = { "^tj" } }, properties = { tag = "3" } }
  ruled.client.append_rule { rule_any = { class = { "^komala" } }, properties = { tag = "5" } }
  ruled.client.append_rule { rule_any = { class = { "laptop$", "^home", "^swimmer" } }, properties = { tag = "6" } }
  ruled.client.append_rule { rule_any = { class = { "thunderbird" } }, properties = { tag = "7" } }
  ruled.client.append_rule { rule_any = { class = { "Darktable", "Gimp", "Inkscape", "scribus" } }, properties = { tag = "8" } }
  ruled.client.append_rule { rule_any = { class = { "Audacious", "Audacity", "puddletag" } }, properties = { tag = "9" } }

  -- Application & host specific rules
  ruled.client.append_rule { rule_any = { class = { "Mixxx", "libreoffice" } }, properties = { shape = shape.rectangle } }

  if hostname == "swimmer" then
    ruled.client.append_rule {
      rule_any = {
        role = { "GtkFileChooserDialog" },
        name = {
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
        geometry = { width = 2940, height = 2080, y = math.floor(beautiful.wibar_height + 20) }
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
      rule = { class = "Player" },
      properties = {
        floating = true,
        width = dpi(1400), height = dpi(880), x = dpi(240), y = beautiful.wibar_height
      }
    }
    ruled.client.append_rule {
      rule = { class = "Mixer" },
      properties = {
        floating = true,
        height = dpi(400), y = beautiful.wibar_height
      }
    }
  else
    ruled.client.append_rule {
      rule_any = {
        role = { "GtkFileChooserDialog" },
        name = {
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
      rule = { class = "Top" },
      properties = {
        floating = true,
        width = dpi(1000), height = dpi(800), x = dpi(400), y = beautiful.wibar_height
      }
    }
    ruled.client.append_rule {
      rule = { class = "Player" },
      properties = {
        floating = true,
        width = dpi(1000), height = dpi(660), x = dpi(140), y = beautiful.wibar_height
      }
    }
    ruled.client.append_rule {
      rule = { class = "Mixer" },
      properties = {
        floating = true,
        height = dpi(400), y = beautiful.wibar_height
      }
    }
  end
end)
-- 1}}}

-- {{{1 Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  local top_titlebar = awful.titlebar(c, {
    size = dpi(18),
    position = "top"
  })
  -- buttons for the titlebar
  local buttons = {
    awful.button({}, 1, function() c:activate { context = "titlebar", action = "mouse_move" } end),
    awful.button({}, 3, function() c:activate { context = "titlebar", action = "mouse_resize" } end)
  }
  top_titlebar:setup {
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
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)
-- 1}}}

-- {{{1 Notifications
ruled.notification.connect_signal('request::rules', function()
  -- All notifications will match this rule.
  ruled.notification.append_rule {
    rule = {},
    properties = {
      screen = awful.screen.preferred,
      margin = dpi(22),
      implicit_timeout = 5,
    }
  }
end)

naughty.connect_signal("request::display", function(n)
  naughty.layout.box { notification = n }
end)
-- 1}}}

-- {{{1 Signals
-- Signal function to execute when a new client appears.
screen.connect_signal("arrange", function(s)
  local only = #s.tiled_clients == 1 or s.selected_tag.layout.name == "max"
  for _, c in pairs(s.clients) do
    local max = c.fullscreen or c.maximized or only and not c.floating
    c.border_width = max and 0 or beautiful.border_width
  end
end)
client.connect_signal("manage", function(c)
  if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
  -- c.shape = beautiful.app_shape
end)
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:activate { context = "mouse_enter", raise = false }
end)
-- Change border colour with focus
client.connect_signal("focus", function(c) c.border_color = beautiful.border_color_active end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_color_normal end)
-- 1}}}

-- {{{1 Applications
awful.spawn.with_shell(
  "pkill picom;" ..
  "while pgrep -x picom >/dev/null; do sleep 1; done;" ..
  -- "/usr/local/src/Tools/x11/picom-FT-Labs.git/build/src/picom --config $HOME/.config/picom/awesomewm.conf &;"
  "picom --config $HOME/.config/picom/awesomewm.conf &;"
)
-- 1}}}

-- {{{1 Memory management
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
gears.timer({
  timeout = 5,
  autostart = true,
  call_now = true,
  callback = function()
    collectgarbage("collect")
  end,
})
-- 1}}}

-- vim: fdm=marker fdl=0 tw=200
