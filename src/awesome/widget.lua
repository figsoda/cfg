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

function widget.mpd()
    local status = wibox.widget.textbox()
    local txt = wibox.widget.textbox()
    local time = wibox.widget.textbox()
    time.font = "monospace 10"

    local scr = wibox.container.scroll.horizontal(
        txt, 60, 60, 16, true, 160, nil, 160
    )
    scr.forced_width = 160
    scr:pause()

    local template = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        widget.padding(8),
        status,
        widget.padding(4),
        scr,
        widget.padding(4),
        time,
    }
    template:connect_signal(
        "mouse::enter", function()
            scr:set_space_for_scrolling(4096)
            scr:continue()
        end
    )
    template:connect_signal(
        "mouse::leave", function()
            scr:pause()
            scr:set_space_for_scrolling(160)
            scr:reset_scrolling()
        end
    )

    local function update(stdout, exitcode)
        if exitcode == 0 then
            local name, st, t = stdout:match(
                "^([^\n]+)\n%[(%a+)%].-(%d:%d%d/%d:%d%d)"
            )
            if name and st and t then
                if st == "playing" then
                    status.text = "▶️"
                elseif st == "paused" then
                    status.text = "⏸️"
                else
                    status.text = "⏹️"
                end
                txt.text = name
                time.text = t
                template.visible = true
            else
                template.visible = false
            end
        else
            template.visible = false
        end
    end

    local function toggle()
        awful.spawn.easy_async(
            {"mpc", "toggle", "-f", "%title% - %artist%"}, --
            function(stdout, _, _, exitcode) update(stdout, exitcode) end
        )
    end

    local function next()
        awful.spawn.easy_async(
            {"mpc", "next", "-f", "%title% - %artist%"}, --
            function(stdout, _, _, exitcode) update(stdout, exitcode) end
        )
    end

    local watch = awful.widget.watch(
        {"mpc", "-f", "%title% - %artist%"}, 1, --
        function(_, stdout, _, _, exitcode) update(stdout, exitcode) end, --
        template
    )

    return setmetatable(
        {}, {
            __index = function(_, k)
                if k == "toggle" then
                    return toggle
                elseif k == "next" then
                    return next
                else
                    return watch[k]
                end
            end,
            __newindex = watch,
        }
    )
end

return widget
