local container = require("wibox.container")
local beautiful = require("beautiful")
local textbox = require("wibox.widget").textbox
local timer = require("gears.timer")

return {
    battery = function(timeout)
        local t = timer {timeout = timeout or 5}

        local txt = textbox()
        txt.align = "center"
        txt.font = beautiful.battery_font

        local bat = container.arcchart(txt)
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

        return container.margin(bat, 2, 2, 2, 2, nil, false)
    end,
}
