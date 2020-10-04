local awful = require("awful")
local b = require("beautiful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local naughty = require("naughty")
local wibox = require("wibox")

local widget = require("widget")

require("awful.autofocus")

local m = {"Mod4"}
local ma = {"Mod4", "Mod1"}
local mc = {"Mod4", "Control"}
local ms = {"Mod4", "Shift"}

local function setwallpaper(s)
    if b.wallpaper then
        local wallpaper = b.wallpaper
        if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
        gears.wallpaper.maximized(wallpaper, s)
    end
end

local function focusclient(c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
end

local function viewonly(t) t:view_only() end

local function prevlayout() awful.layout.inc(-1) end

local function nextlayout() awful.layout.inc(1) end

local function prevclient() awful.client.focus.byidx(-1) end

local function nextclient() awful.client.focus.byidx(1) end

local function exec(cmd) return function() awful.spawn(cmd) end end

local function maptag(f, i)
    return function()
        local s = awful.screen.focused()
        if s ~= nil then
            local tag = i and s.tags[i] or s.selected_tag
            if tag ~= nil then f(tag) end
        end
    end
end

local l = awful.layout.suit
local p = awful.placement

b.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

naughty.config.defaults.position = "bottom_right"

screen.connect_signal("property::geometry", setwallpaper)

screen.connect_signal(
    "arrange", function(s)
        local max = #s.tiled_clients == 1 or s.selected_tag.layout == l.max
        for _, c in pairs(s.clients) do
            c.border_width = (max and not c.floating) and 0 or b.border_width
        end
    end
)

awful.layout.layouts = {l.tile, l.tile.top, l.max}

awful.screen.connect_for_each_screen(
    function(s)
        setwallpaper(s)

        awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, l.tile)

        local padding = wibox.container.constraint(nil, "exact", 8)

        local layoutbox = awful.widget.layoutbox(s);
        layoutbox:buttons(
            gears.table.join(
                awful.button({}, 4, prevlayout), awful.button({}, 5, nextlayout)
            )
        )

        local panel = awful.wibar {position = "bottom", screen = s}
        panel:setup{
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.fixed.horizontal,
                layoutbox,
                padding,
                awful.widget.taglist {
                    screen = s,
                    filter = awful.widget.taglist.filter.all,
                    buttons = gears.table.join(
                        awful.button({}, 1, viewonly), --
                        awful.button({}, 3, awful.tag.viewtoggle), --
                        awful.button(
                            {}, 4, function(t)
                                awful.tag.viewprev(t.screen)
                            end
                        ), --
                        awful.button(
                            {}, 5, function(t)
                                awful.tag.viewnext(t.screen)
                            end
                        )
                    ),
                    widget_template = {
                        id = "background_role",
                        widget = wibox.container.background,
                        {
                            id = 'text_role',
                            widget = wibox.widget.textbox,
                            align = "center",
                            forced_width = b.wibar_height,
                        },
                    },
                },
                padding,
            },
            awful.widget.tasklist {
                screen = s,
                filter = awful.widget.tasklist.filter.currenttags,
                buttons = gears.table.join(
                    awful.button(
                        {}, 1, function(c)
                            if c ~= client.focus and c.first_tag.layout == l.max
                                or c.minimized then
                                client.focus = c
                                c.minimized = false
                                c:raise()
                            else
                                c.minimized = true
                            end
                        end
                    ), --
                    awful.button({}, 4, prevclient), --
                    awful.button({}, 5, nextclient)
                ),
                widget_template = {
                    id = "background_role",
                    widget = wibox.container.background,
                    {
                        {
                            {id = "icon", widget = awful.widget.clienticon},
                            widget = wibox.container.margin,
                            left = 4,
                            right = 4,
                            top = 2,
                            bottom = 2,
                        },
                        {id = "text_role", widget = wibox.widget.textbox},
                        layout = wibox.layout.fixed.horizontal,
                    },
                    create_callback = function(self, c, _, _)
                        self:get_children_by_id("icon")[1].client = c
                    end,
                },
            },
            {
                layout = wibox.layout.fixed.horizontal,
                padding,
                wibox.widget.systray(),
                widget.battery(),
                {
                    widget = wibox.widget.textclock(" %F %T ", 1),
                    font = "DejaVu 12",
                },
            },
        }
    end
)

local ckbs = {
    {m, "j", prevclient, "previous client"},
    {m, "k", nextclient, "next client"},
    {
        ms,
        "f",
        function(c) c.fullscreen = not c.fullscreen end,
        "toggle fullscreen",
    },
    {ms, "m", function(c) c.maximized = not c.maximized end, "toggle maximized"},
    {ms, "n", function(c) c.minimized = true end, "minimize the client"},
    {ms, "q", function(c) c:kill() end, "kill the client"},
}

local kbss = {
    help = {{m, "h", hotkeys_popup.show_help, "show help"}},
    session = {
        {mc, "l", exec({"xset", "s", "activate"}), "lock screen"},
        {
            mc,
            "Return",
            function()
                awful.spawn.easy_async_with_shell(
                    "echo \z
                    1 - shutdown,\z
                    2 - reboot,\z
                    3 - lock screen,\z
                    4 - quit awesome,\z
                    5 - restart awesome\z
                    | rofi -dmenu -sep , -p session -lines 5", --
                    function(stdout)
                        ({
                            exec({"sudo", "init", "0"}),
                            exec({"sudo", "init", "6"}),
                            exec({"xset", "s", "activate"}),
                            awesome.quit,
                            awesome.restart,
                        })[stdout:byte() - 48]()
                    end
                )
            end,
            "session menu",
        },
        {mc, "q", awesome.quit, "quit awesome"},
        {mc, "r", awesome.restart, "restart awesome"},
    },
    layout = {
        {ms, "Left", prevlayout, "previous layout"},
        {ms, "Right", nextlayout, "next layout"},
        {
            m,
            "y",
            maptag(
                function(t)
                    t.master_width_factor = b.master_width_factor or 0.5
                end
            ),
            "reset master width",
        },
        {
            m,
            "u",
            function() awful.tag.incmwfact(-0.05) end,
            "reduce master width",
        },
        {
            m,
            "i",
            function() awful.tag.incmwfact(0.05) end,
            "increase master width",
        },
        {
            ms,
            "y",
            maptag(function(t) t.column_count = b.column_count or 1 end),
            "reset column count",
        },
        {ms, "u", function() awful.tag.incncol(-1) end, "remove a column"},
        {ms, "i", function() awful.tag.incncol(1) end, "add a column"},
    },
    client = {
        {
            ms,
            "j",
            function() awful.client.swap.byidx(-1) end,
            "swap with previous client",
        },
        {
            ms,
            "k",
            function() awful.client.swap.byidx(1) end,
            "swap with next client",
        },
    },
    tag = {
        {m, "Left", awful.tag.viewprev, "view previous tag"},
        {m, "Right", awful.tag.viewnext, "view next tag"},
        {m, "BackSpace", awful.tag.history.restore, "go back"},
    },
    volume = {
        {
            {},
            "XF86AudioLowerVolume",
            exec({"pamixer", "-d", "5"}),
            "lower volume",
        },
        {
            {},
            "XF86AudioRaiseVolume",
            exec({"pamixer", "-i", "5"}),
            "raise volume",
        },
        {{}, "XF86AudioMute", exec({"pamixer", "-t"}), "toggle mute"},
    },
    brightness = {
        {
            {},
            "XF86MonBrightnessDown",
            exec({"xbacklight", "-5", "-time", "0"}),
            "reduce brightness",
        },
        {
            {},
            "XF86MonBrightnessUp",
            exec({"xbacklight", "+5", "-time", "0"}),
            "increase brightness",
        },
    },
    app = {
        {{}, "Print", exec({"flameshot", "gui"}), "launch flameshot"},
        {m, "Return", exec("alacritty"), "launch alacritty"},
        {
            m,
            "/",
            function()
                awful.spawn.with_shell(
                    "fd . ~ \z
                    | xdg-open $(rofi -dmenu -p \"fuzzy finder\" -fullscreen \z
                        -i -matching fuzzy \z
                        -sorting-method fzf)"
                )
            end,
            "launch rofi as a fuzzy finder",
        },
        {m, "b", exec("firefox"), "launch firefox"},
        {
            m,
            "c",
            exec({"rofi", "-show", "calc", "-modi", "calc"}),
            "launch rofi calculator",
        },
        {m, "e", exec("code-oss"), "launch vscode"},
        {m, "f", exec("Thunar"), "launch thunar"},
        {m, "r", exec({"rofi", "-show", "run", "-modi", "run"}), "launch rofi"},
        {
            m,
            "w",
            exec({"rofi", "-show", "window", "-modi", "window"}),
            "launch rofi with window modi",
        },
    },
}

for i = 1, 9 do
    table.insert(kbss.tag, {m, i, maptag(viewonly, i), "view tag " .. i})
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

local ckeys = {}
for _, kb in pairs(ckbs) do
    ckeys = gears.table.join(
        ckeys, --
        awful.key(kb[1], kb[2], kb[3], {description = kb[4], group = "client"})
    )
end

awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = b.border_width,
            border_color = b.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            maximized = false,
            keys = ckeys,
            buttons = gears.table.join(
                awful.button({}, 1, focusclient), --
                awful.button(
                    m, 1, function(c)
                        focusclient(c)
                        awful.mouse.client.move(c)
                    end
                ), --
                awful.button(
                    m, 3, function(c)
                        focusclient(c)
                        awful.mouse.client.resize(c)
                    end
                )
            ),
            screen = awful.screen.preferred,
            placement = p.no_overlap + p.no_offscreen,
        },
    },
}

client.connect_signal(
    "manage", function(c)
        if awesome.startup then
            if not c.size_hints.user_position
                and not c.size_hints.program_position then
                p.no_offscreen(c)
            end
        else
            awful.client.setslave(c)
        end
    end
)

client.connect_signal(
    "mouse::enter", function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end
)

client.connect_signal("focus", function(c) c.border_color = b.border_focus end)

client.connect_signal(
    "unfocus", function(c) c.border_color = b.border_normal end
)

local keys = {}
for group, kbs in pairs(kbss) do
    for _, kb in pairs(kbs) do
        keys = gears.table.join(
            keys, awful.key(
                kb[1], kb[2], kb[3], {description = kb[4], group = group}
            )
        )
    end
end
root.keys(keys)

awful.spawn({"xbacklight", "=10"})
awful.spawn({"xset", "-b"})
awful.spawn({"xset", "s", "900", "900"})
awful.spawn({"xset", "dpms", "900", "900", "900"})
awful.spawn({"xss-lock", "-l", "xsecurelock"})
awful.spawn("flameshot")
awful.spawn({"Thunar", "--daemon"})
awful.spawn("blueman-applet")
awful.spawn("nm-applet")
awful.spawn("volctl")
