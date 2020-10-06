local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

return {
    battery = function()
        local t = gears.timer {timeout = 5}

        local txt = wibox.widget.textbox()
        txt.align = "center"
        txt.font = beautiful.battery_font

        local bat = wibox.container.arcchart(txt)
        bat.min_value = 0
        bat.max_value = 100
        bat.thickness = 2
        bat.start_angle = math.pi * 3 / 2

        t:connect_signal(
            "timeout", function()
                t:stop()

                local cap = io.open("/sys/class/power_supply/BAT0/capacity")
                local st = io.open("/sys/class/power_supply/BAT0/status")

                if cap and st then
                    local percent = cap:read("*n")
                    bat.value = percent

                    if percent == 100 then
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
            end
        )
        t:start()
        t:emit_signal("timeout")

        return wibox.container.margin(bat, 2, 2, 2, 2, nil, false)
    end,

    xbps_updates = function()
        local txt = wibox.widget.textbox()
        txt.font = "monospace 12"
        txt.visible = false

        local function update(_, stdout)
            local x = gears.string.linecount(stdout) - 1
            if x > 0 then
                txt.visible = true
                txt.markup = "<span fgcolor=\"#20ff40\">[↑" .. x .. "]</span>"
            else
                txt.visible = false
            end
        end

        txt:buttons(
            awful.button(
                {}, 1, nil, function()
                    awful.spawn.easy_async(
                        {
                            "alacritty",
                            "-e",
                            "fish",
                            "-c",
                            "fish_prompt; echo sudo xbps-install -Su; sudo xbps-install -Su",
                        }, --
                        function()
                            awful.spawn.easy_async(
                                {"xbps-install", "-Sun"}, --
                                function(stdout)
                                    update(nil, stdout)
                                end
                            )
                        end
                    )
                end
            )
        )

        return awful.widget.watch(
            {"xbps-install", "-Sun"}, 60, update, --
            wibox.container.margin(txt, 8, 0, 0, 0, nil, false)
        )
    end,
}
