local awful = require("awful")
local b = require("beautiful")
local dpi = b.xresources.apply_dpi
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

local keys = require("keys")
local widget = require("widget")

require("awful.autofocus")

local m = { "Mod4" }
local ms = { "Mod4", "Shift" }

local function setwallpaper(s)
  if b.wallpaper then
    local wallpaper = b.wallpaper
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.tiled(wallpaper, s)
  end
end

local function focusclient(c)
  c:emit_signal("request::activate", "mouse_click", { raise = true })
end

local l = awful.layout.suit
local p = awful.placement

b.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

naughty.config.defaults.position = "bottom_right"
naughty.config.icon_formats = { "png", "svg" }

screen.connect_signal("property::geometry", setwallpaper)

screen.connect_signal("arrange", function(s)
  local only = #s.tiled_clients == 1 or s.selected_tag.layout.name == "max"
  for _, c in pairs(s.clients) do
    local max = c.fullscreen or c.maximized or only and not c.floating
    c.border_width = max and 0 or b.border_width
  end
end)

awful.layout.layouts = { l.tile, l.max }

awful.screen.connect_for_each_screen(function(s)
  setwallpaper(s)

  awful.tag({ "~", "1", "2", "3", "4", "5" }, s, l.tile)

  s.mpd = widget.mpd()

  local textclock = wibox.widget.textclock(
    ' <span fgcolor="#98c379">%F</span> <span fgcolor="#61afef">%T</span> ',
    1
  )
  textclock.font = b.textclock_font
  awful.widget.calendar_popup
    .month({ font = "monospace 9" })
    :attach(textclock, "tr")

  s.panel = awful.wibar({ screen = s })
  s.panel:setup({
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      awful.widget.layoutbox(s),
      widget.padding(3),
      awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = gears.table.join(
          awful.button({}, 1, function(t)
            t:view_only()
          end),
          awful.button({}, 3, awful.tag.viewtoggle),
          awful.button({}, 4, function(t)
            awful.tag.viewprev(t.screen)
          end),
          awful.button({}, 5, function(t)
            awful.tag.viewnext(t.screen)
          end)
        ),
        widget_template = {
          id = "background_role",
          widget = wibox.container.background,
          {
            id = "text_role",
            widget = wibox.widget.textbox,
            align = "center",
            forced_width = b.wibar_height,
          },
        },
      }),
      widget.padding(3),
    },
    awful.widget.tasklist({
      screen = s,
      filter = awful.widget.tasklist.filter.currenttags,
      buttons = gears.table.join(
        awful.button({}, 1, function(c)
          client.focus = c
          c.minimized = false
          c:raise()
        end),
        awful.button({}, 4, function()
          awful.client.focus.byidx(-1)
        end),
        awful.button({}, 5, function()
          awful.client.focus.byidx(1)
        end)
      ),
      widget_template = {
        id = "background_role",
        widget = wibox.container.background,
        {
          {
            { id = "icon", widget = awful.widget.clienticon },
            widget = wibox.container.margin,
            left = 4,
            right = 4,
            top = 2,
            bottom = 2,
          },
          { id = "text_role", widget = wibox.widget.textbox },
          layout = wibox.layout.fixed.horizontal,
        },
        create_callback = function(self, c)
          self:get_children_by_id("icon")[1].client = c
        end,
      },
    }),
    {
      layout = wibox.layout.fixed.horizontal,
      s.mpd,
      widget.padding(3),
      (function()
        local tray = wibox.widget.systray()
        tray:set_base_size(dpi(12))
        return tray
      end)(),
      widget.battery(),
      textclock,
    },
  })
end)

awful.rules.rules = {
  {
    rule = {},
    properties = {
      border_width = b.border_width,
      border_color = b.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = keys.client,
      buttons = gears.table.join(
        awful.button({}, 1, focusclient),
        awful.button(m, 1, function(c)
          focusclient(c)
          awful.mouse.client.move(c)
        end),
        awful.button(m, 3, function(c)
          focusclient(c)
          awful.mouse.client.resize(c)
        end),
        awful.button(ms, 1, function(c)
          c.floating = not c.floating
        end)
      ),
      screen = awful.screen.preferred,
      placement = p.no_overlap + p.no_offscreen,
    },
  },
  {
    rule = { class = "Qalculate-gtk" },
    properties = {
      floating = true,
      ontop = true,
      placement = p.centered,
    },
  },
}

client.connect_signal("manage", function(c)
  if awesome.startup then
    if not c.size_hints.user_position and not c.size_hints.program_position then
      p.no_offscreen(c)
    end
  else
    awful.client.setslave(c)
  end
end)

client.connect_signal("property::maximized", function(c)
  c.maximized = false
end)

client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
  c.border_color = b.border_focus
end)

client.connect_signal("unfocus", function(c)
  c.border_color = b.border_normal
end)

root.keys(keys.global)
