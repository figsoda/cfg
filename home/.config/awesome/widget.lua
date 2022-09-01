local widget = {}

local awful = require("awful")
local b = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

function widget.padding(w)
  return wibox.widget({ forced_width = w })
end

function widget.battery()
  local t = gears.timer({ timeout = 1 })

  local txt = wibox.widget.textbox()
  txt.align = "center"
  txt.font = b.battery_font

  local bat = wibox.container.arcchart(txt)
  bat.min_value = 0
  bat.max_value = 100
  bat.thickness = 2
  bat.start_angle = math.pi * 3 / 2

  t:connect_signal("timeout", function()
    t:stop()

    local cap = io.open("/sys/class/power_supply/BAT0/capacity")
    local st = io.open("/sys/class/power_supply/BAT0/status")

    if cap and st then
      local percent = cap:read("*n")
      bat.value = percent

      if percent >= 100 then
        bat.visible = false
      else
        bat.visible = true
        txt:set_text(percent)
        bat.colors = {
          (st:read(8) == "Charging") and "#20a020"
            or ((percent <= 30) and "#d01000" or "#a0a0a0"),
        }
      end

      cap:close()
      st:close()
    end

    t:again()
  end)
  t:start()
  t:emit_signal("timeout")

  return wibox.container.margin(bat, 2, 2, 2, 2, nil, false)
end

function widget.mpd()
  local status = wibox.widget.textbox()
  local txt = wibox.widget.textbox()
  local time = wibox.widget.textbox()
  time.font = "monospace 12.5"

  local scr = wibox.container.scroll.horizontal(txt, 60, 120, 24)
  scr.forced_width = 240
  scr:pause()

  local template = wibox.widget({
    layout = wibox.layout.fixed.horizontal,
    buttons = gears.table.join(
      awful.button({}, 1, function()
        awful.screen.focused().mpd.toggle()
      end),
      awful.button({}, 2, function()
        awful.spawn({ "alacritty", "-e", "mmtc" })
      end),
      awful.button({}, 3, function()
        awful.screen.focused().mpd.next()
      end)
    ),
    widget.padding(8),
    status,
    widget.padding(4),
    scr,
    widget.padding(4),
    time,
  })
  template:connect_signal("mouse::enter", function()
    scr:set_space_for_scrolling(4096)
    scr:continue()
  end)
  template:connect_signal("mouse::leave", function()
    scr:pause()
    scr:set_space_for_scrolling(240)
    scr:reset_scrolling()
  end)

  local function update(stdout, exitcode)
    if exitcode == 0 then
      local name, st, t =
        stdout:match("^([^\n]+)\n%[(%a+)%].-(%d:%d%d/%d:%d%d)")
      if name and st and t then
        if st == "playing" then
          status.markup = [[<span fgcolor="#d19a66"></span>]]
        elseif st == "paused" then
          status.markup = [[<span fgcolor="#d19a66"></span>]]
        else
          status.markup = [[<span fgcolor="#d19a66"></span>]]
        end
        txt.markup = string.format(
          [[<span fgcolor="#c678dd">%s</span>]],
          gears.string.xml_escape(name)
        )
        time.markup = string.format([[<span fgcolor="#d19a66">%s</span>]], t)
        template.visible = true
        return
      end
    end
    template.visible = false
  end

  local watch = awful.widget.watch(
    { "mpc", "-f", "%title% - %artist%" },
    1,
    function(_, stdout, _, _, exitcode)
      update(stdout, exitcode)
    end,
    template
  )

  local function cmd_then_update(cmd)
    return function()
      awful.spawn.easy_async(
        { "mpc", cmd, "-f", "%title% - %artist%" },
        function(stdout, _, _, exitcode)
          update(stdout, exitcode)
        end
      )
    end
  end

  return setmetatable({}, {
    __index = function(_, k)
      if k == "reload" then
        return function()
          awful.spawn.easy_async_with_shell(
            "mpc clear && mpc update && mpc add /",
            function()
              template.visible = false
            end
          )
        end
      elseif k == "toggle" then
        return cmd_then_update("toggle")
      elseif k == "prev" then
        return cmd_then_update("prev")
      elseif k == "next" then
        return cmd_then_update("next")
      elseif k == "stop" then
        return function()
          awful.spawn.easy_async({ "mpc", "stop" }, function()
            template.visible = false
          end)
        end
      else
        return watch[k]
      end
    end,
    __newindex = watch,
  })
end

return widget
