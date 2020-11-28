local widget = {}

local awful = require("awful")
local b = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local HOME = os.getenv("HOME")

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
        end
    )
    t:start()
    t:emit_signal("timeout")

    return wibox.container.margin(bat, 2, 2, 2, 2, nil, false)
end

function widget.rustup_updates()
    local txt = wibox.widget.textbox()
    txt.font = "monospace 10"
    txt.visible = false

    local function update(_, stdout)
        local x = select(2, stdout:gsub("Update available", ""))
        if x > 0 then
            txt.visible = true
            txt.markup = string.format(
                [[<span fgcolor="#20ff40">[🦀%d]</span>]], x
            )
        else
            txt.visible = false
        end
    end

    local cmd = {HOME .. "/.cargo/bin/rustup", "check"}

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
        cmd, 1800, update, --
        wibox.container.margin(txt, 8, 0, 0, 0, nil, false)
    )
end

function widget.cargo_updates()
    local txt = wibox.widget.textbox()
    txt.font = "monospace 10"
    txt.visible = false

    local function update(_, stdout)
        local x = select(2, stdout:gsub("Yes", ""))
        if x > 0 then
            txt.visible = true
            txt.markup = string.format(
                [[<span fgcolor="#20ff40">[📦%d]</span>]], x
            )
        else
            txt.visible = false
        end
    end

    local cmd = {HOME .. "/.cargo/bin/cargo", "install-update", "-l"}

    txt:buttons(
        awful.button(
            {}, 1, nil, function()
                awful.spawn.easy_async(
                    {
                        "alacritty",
                        "-e",
                        "fish",
                        "-c",
                        "fish_prompt; echo cargo install-update -a; cargo install-update -a",
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
        cmd, 1800, update, --
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

    local mmtc = {"alacritty", "-e", HOME .. "/.cargo/bin/mmtc"}
    local template = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        buttons = gears.table.join(
            awful.button(
                {}, 1, function()
                    awful.screen.focused().mpd.toggle()
                end
            ), --
            awful.button({}, 2, function() awful.spawn(mmtc) end), --
            awful.button(
                {}, 3, function()
                    awful.screen.focused().mpd.next()
                end
            )
        ),
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
                txt.markup = string.format(
                    [[<span fgcolor="#c8b8ff">%s</span>]], --
                    gears.string.xml_escape(name)
                )
                time.markup = string.format(
                    [[<span fgcolor="#ffa8a8">%s</span>]], t
                )
                template.visible = true
                return
            end
        end
        template.visible = false
    end

    local function reload()
        awful.spawn.easy_async_with_shell(
            "mpc update && mpc clear && mpc add /", --
            function() template.visible = false end
        )
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

    local function stop()
        awful.spawn.easy_async(
            {"mpc", "stop"}, --
            function() template.visible = false end
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
                if k == "reload" then
                    return reload
                elseif k == "toggle" then
                    return toggle
                elseif k == "next" then
                    return next
                elseif k == "stop" then
                    return stop
                else
                    return watch[k]
                end
            end,
            __newindex = watch,
        }
    )
end

return widget
