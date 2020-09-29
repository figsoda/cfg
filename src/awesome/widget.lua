local arcchart = require("wibox.container").arcchart
local textbox = require("wibox.widget").textbox
local timer = require("gears.timer")

return {
    battery = function(timeout)
        local cap = io.open("/sys/class/power_supply/BAT0/capacity")
        local t = timer {timeout = timeout or 5}

        local txt = textbox()
        txt.align = "center"

        local bat = arcchart(txt)
        bat.min_value = 0
        bat.max_value = 100
        bat.thickness = 2
        bat.start_angle = math.pi * 3 / 2

        t:connect_signal(
            "timeout", function()
                t:stop()

                local percent = cap:read("*n")
                bat.value = percent
                txt:set_text(percent)
                cap:seek("set")

                t:again()
            end
        )
        t:start()
        t:emit_signal("timeout")

        return bat
    end,
}
