local awful = require("awful")
local b = require("beautiful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")

local m = {"Mod4"}
local ma = {"Mod4", "Mod1"}
local mc = {"Mod4", "Control"}
local ms = {"Mod4", "Shift"}

local function exec(cmd) return function() awful.spawn(cmd) end end
local function exec_sh(cmd) return function() awful.spawn.with_shell(cmd) end end

local function maptag(f, i)
    return function()
        local s = awful.screen.focused()
        if s ~= nil then
            local tag = i and s.tags[i] or s.selected_tag
            if tag ~= nil then f(tag) end
        end
    end
end

local ckbs = {
    {m, "k", function() awful.client.focus.byidx(-1) end, "previous client"},
    {m, "l", function() awful.client.focus.byidx(1) end, "next client"},
    {
        ms,
        "f",
        function(c) c.fullscreen = not c.fullscreen end,
        "toggle fullscreen",
    },
    {ms, "n", function(c) c.minimized = true end, "minimize the client"},
    {ms, "q", function(c) c:kill() end, "kill the client"},
    {ms, "t", function(c) c.ontop = not c.ontop end, "toggle stay on top"},
}

local kbss = {
    help = {{m, "h", hotkeys_popup.show_help, "show help"}},
    session = {
        {mc, "l", exec {"xset", "s", "activate"}, "lock screen"},
        {
            mc,
            "Return",
            function()
                awful.spawn.easy_async_with_shell(
                    "echo '\z
                    1 ⏻  shutdown,\z
                    2   reboot,\z
                    3 ⏼  suspend,\z
                    4 望  hibernate,\z
                    5   lock screen,\z
                    6   quit awesome,\z
                    7   reload awesome\z
                    ' | rofi -dmenu -sep , \z
                        -p session -format i -no-custom -select 7", --
                    function(stdout)
                        ({
                            exec("poweroff"),
                            exec("reboot"),
                            exec {"systemctl", "suspend"},
                            exec {"systemctl", "hibernate"},
                            exec {"xset", "s", "activate"},
                            awesome.quit,
                            awesome.restart,
                        })[stdout:byte() - 47]()
                    end
                )
            end,
            "session menu",
        },
    },
    layout = {
        {ms, "Left", function() awful.layout.inc(-1) end, "previous layout"},
        {ms, "Right", function() awful.layout.inc(1) end, "next layout"},
        {
            m,
            "i",
            function() awful.tag.incmwfact(-0.05) end,
            "reduce master width",
        },
        {
            m,
            "o",
            function() awful.tag.incmwfact(0.05) end,
            "increase master width",
        },
        {
            m,
            "p",
            maptag(
                function(t)
                    t.master_width_factor = b.master_width_factor or 0.5
                end
            ),
            "reset master width",
        },
        {ms, "i", function() awful.tag.incncol(-1) end, "remove a column"},
        {ms, "o", function() awful.tag.incncol(1) end, "add a column"},
        {
            ms,
            "p",
            maptag(function(t) t.column_count = b.column_count or 1 end),
            "reset column count",
        },
    },
    client = {
        {
            ms,
            "k",
            function() awful.client.swap.byidx(-1) end,
            "swap with previous client",
        },
        {
            ms,
            "l",
            function() awful.client.swap.byidx(1) end,
            "swap with next client",
        },
    },
    tag = {
        {m, "Left", awful.tag.viewprev, "view previous tag"},
        {m, "Right", awful.tag.viewnext, "view next tag"},
        {m, "BackSpace", awful.tag.history.restore, "go back"},
        {m, "Tab", awful.tag.viewnext, "view next tag"},
        {ms, "Tab", awful.tag.viewprev, "view previous tag"},
    },
    volume = {
        {
            {},
            "XF86AudioLowerVolume",
            exec {"pamixer", "-d", "5"},
            "lower volume",
        },
        {
            {},
            "XF86AudioRaiseVolume",
            exec {"pamixer", "-i", "5"},
            "raise volume",
        },
        {{}, "XF86AudioMute", exec {"pamixer", "-t"}, "toggle mute"},
    },
    brightness = {
        {
            {},
            "XF86MonBrightnessDown",
            exec {"xbacklight", "-4", "-time", "0"},
            "reduce brightness",
        },
        {
            {},
            "XF86MonBrightnessUp",
            exec {"xbacklight", "+4", "-time", "0"},
            "increase brightness",
        },
    },
    application = {
        {
            {},
            "Print",
            exec_sh("maim -us ~/(date +%Y%m%d%H%M%S).png"),
            "take a screenshot",
        },
        {m, "Return", exec("alacritty"), "launch alacritty"},
        {
            m,
            "/",
            exec_sh(
                "fd . ~ \z
                    | sd \"^$HOME/(.*)\" '$1' \z
                    | rofi -dmenu \z
                        -p 'fuzzy finder' -fullscreen \z
                        -i -matching fuzzy -sorting-method fzf \z
                    | xargs -I {} xdg-open ~/{}"
            ),
            "launch rofi as a fuzzy finder",
        },
        {m, "b", exec("firefox"), "launch firefox"},
        {
            m,
            "c",
            exec_sh("CM_LAUNCHER=rofi clipmenu -p clipmenu"),
            "launch clipmenu",
        },
        {ms, "c", exec {"clipdel", "-d", "."}, "clear clipmenu"},
        {m, "e", exec("codium"), "launch vscodium"},
        {m, "f", exec("thunar"), "launch thunar"},
        {m, "m", exec {"alacritty", "-e", "mmtc"}, "launch mmtc"},
        {
            ms,
            "m",
            function() awful.screen.focused().mpd.reload() end,
            "reload mpd",
        },
        {m, "r", exec {"rofi", "-show", "run", "-modi", "run"}, "launch rofi"},
        {
            m,
            "u",
            exec {
                "rofi",
                "-show",
                "calc",
                "-modi",
                "calc,emoji",
                "-location",
                "4",
                "-theme-str",
                "* { width: 40%; height: 100%; }",
            },
            "launch rofi utilities",
        },
        {
            m,
            "w",
            exec {"rofi", "-show", "window", "-modi", "window"},
            "launch rofi with window modi",
        },
        {
            m,
            ",",
            function() awful.screen.focused().mpd.toggle() end,
            "play or pause music",
        },
        {
            m,
            ".",
            function() awful.screen.focused().mpd.next() end,
            "next song in the playlist",
        },
        {
            m,
            ";",
            function() awful.screen.focused().mpd.stop() end,
            "stop playing music",
        },
    },
}

for i = 1, 9 do
    table.insert(
        kbss.tag,
            {m, i, maptag(function(t) t:view_only() end, i), "view tag " .. i}
    )
    table.insert(
        kbss.tag, {ma, i, maptag(awful.tag.viewtoggle, i), "toggle tag " .. i}
    )
    table.insert(
        ckbs, {
            ms,
            i,
            function(c) maptag(function(t) c:move_to_tag(t) end, i)() end,
            "move client to tag " .. i,
        }
    )
    table.insert(
        ckbs, {
            mc,
            i,
            function(c) maptag(function(t) c:toggle_tag(t) end, i)() end,
            "toggle tag " .. i .. " for client",
        }
    )
end

local keys = {client = {}, global = {}}

for _, kb in pairs(ckbs) do
    keys.client = gears.table.join(
        keys.client, --
        awful.key(kb[1], kb[2], kb[3], {description = kb[4], group = "client"})
    )
end

for group, kbs in pairs(kbss) do
    for _, kb in pairs(kbs) do
        keys.global = gears.table.join(
            keys.global, awful.key(
                kb[1], kb[2], kb[3], {description = kb[4], group = group}
            )
        )
    end
end

return keys
