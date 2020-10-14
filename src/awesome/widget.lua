local widget = {}

local awful = require("awful")
local b = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

function widget.padding(w) return wibox.widget {forced_width = w} end

function widget.battery()
    local t = gears.timer {timeout = 1}

    local txt = wibox.widget.textbox()
    txt.align = "center"
    txt.font = b.battery_font

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
end

function widget.xbps_updates()
    local txt = wibox.widget.textbox()
    txt.font = "monospace 12"
    txt.visible = false

    local function update()
        awful.spawn.easy_async(
            {"xbps-install", "-un"}, --
            function(stdout)
                local x = gears.string.linecount(stdout) - 1
                if x > 0 then
                    txt.visible = true
                    txt.markup = string.format(
                        [[<span fgcolor="#20ff40">[↑%d]</span>]], x
                    )
                else
                    txt.visible = false
                end
            end
        )
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
                        "fish_prompt; echo sudo xbps-install -Suy; sudo xbps-install -Suy",
                    }, --
                    function()
                        awful.spawn.easy_async({"sudo", "xsync"}, update)
                    end
                )
            end
        )
    )

    return awful.widget.watch(
        {"sudo", "xsync"}, 600, update, --
        wibox.container.margin(txt, 8, 0, 0, 0, nil, false)
    )
end

function widget.rustup_updates()
    local txt = wibox.widget.textbox(
        [[<span fgcolor="#20ff40">[↑🦀]</span>]]
    )
    txt.font = "monospace 12"
    txt.visible = false

    local function update(_, stdout)
        txt.visible = stdout:find("Update available", 1, true) ~= nil
    end

    local cmd = {os.getenv("HOME") .. "/.cargo/bin/rustup", "check"}

    txt:buttons(
        awful.button(
            {}, 1, nil, function()
                awful.spawn.easy_async(
                    {
                        "alacritty",
                        "-e",
                        "fish",
                        "-c",
                        "fish_prompt; echo rustup update; rustup update",
                    }, --
                    function()
                        awful.spawn.easy_async(
                            cmd, --
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
        cmd, 600, update, --
        wibox.container.margin(txt, 8, 0, 0, 0, nil, false)
    )
end

return widget
