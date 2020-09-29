local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local wibox = require("wibox")

require("awful.autofocus")

local m = {"Mod4"}
local ma = {"Mod4", "Mod1"}
local mc = {"Mod4", "Control"}
local ms = {"Mod4", "Shift"}

local function setwallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
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
            local tag = s.tags[i]
            if tag ~= nil then f(tag) end
        end
    end
end

local l = awful.layout.suit
local p = awful.placement

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

screen.connect_signal("property::geometry", setwallpaper)

awful.layout.layouts = {l.tile, l.tile.top, l.max}

awful.screen.connect_for_each_screen(
    function(s)
        setwallpaper(s)

        awful.tag(
            {"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s,
                awful.layout.layouts[1]
        )

        s.layoutbox = awful.widget.layoutbox(s);
        s.layoutbox:buttons(
            gears.table.join(
                awful.button({}, 4, prevlayout), awful.button({}, 5, nextlayout)
            )
        )

        s.panel = awful.wibar {position = "bottom", screen = s}
        s.panel:setup{
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.align.horizontal,
                s.layoutbox,
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
                },
            },
            awful.widget.tasklist {
                screen = s,
                filter = awful.widget.tasklist.filter.currenttags,
                buttons = gears.table.join(
                    awful.button(
                        {}, 1, function(c)
                            if c.minimized then
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
            },
            {
                layout = wibox.layout.align.horizontal,
                wibox.widget.systray(),
                wibox.widget.textclock("%F %T", 1),
            },
        }
    end
)

local ckeys = gears.table.join(
    awful.key(m, "q", function(c) c:kill() end), --
    awful.key(m, "n", function(c) c.minimized = not c.minimized end), --
    awful.key(m, "j", prevclient), --
    awful.key(m, "k", nextclient)
)

local kbss = {
    help = {{m, "h", hotkeys_popup.show_help, "show help"}},
    session = {
        {mc, "l", exec("xsecurelock"), "lock screen"},
        {mc, "q", awesome.quit, "quit awesome"},
        {mc, "r", awesome.restart, "restart awesome"},
    },
    layout = {},
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
        {{}, "XF86AudioLowerVolume", exec("pamixer -d 5"), "lower volume"},
        {{}, "XF86AudioRaiseVolume", exec("pamixer -i 5"), "raise volume"},
    },
    brightness = {
        {
            {},
            "XF86MonBrightnessDown",
            exec("xbacklight -5 -time 0"),
            "reduce brightness",
        },
        {
            {},
            "XF86MonBrightnessUp",
            exec("xbacklight +5 -time 0"),
            "increase brightness",
        },
    },
    app = {
        {{}, "Print", exec("flameshot gui"), "launch flameshot"},
        {m, "Return", exec("alacritty"), "launch alacritty"},
        {m, "b", exec("firefox"), "launch firefox"},
        {m, "c", exec("code-oss"), "launch vscode"},
        {m, "e", exec("Thunar"), "launch thunar"},
    },
}

for i = 1, 9 do
    table.insert(kbss.tag, {m, i, maptag(viewonly, i), "view tag " .. i})
    table.insert(
        kbss.tag, {ma, i, maptag(awful.tag.viewtoggle, i), "toggle tag " .. i}
    )
    ckeys = gears.table.join(
        ckeys, --
        awful.key(
            ms, i, function(c)
                maptag(function(t) c:move_to_tag(t) end, i)()
            end
        ), --
        awful.key(
            mc, i, function(c)
                maptag(function(t) c:toggle_tag(t) end, i)()
            end
        )
    )
end

awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
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
            awful.client.setslave(c)
            if not c.size_hints.user_position
                and not c.size_hints.program_position then
                p.no_offscreen(c)
            end
        end
    end
)

client.connect_signal(
    "mouse::enter", function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end
)

client.connect_signal(
    "focus", function(c) c.border_color = beautiful.border_focus end
)

client.connect_signal(
    "unfocus", function(c) c.border_color = beautiful.border_normal end
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

awful.spawn("xbacklight = 10")
awful.spawn("xset -b")
awful.spawn("flameshot")
awful.spawn("Thunar --daemon")
awful.spawn("nm-applet")
awful.spawn("volctl")
