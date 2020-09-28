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

local function viewonly(t) t:view_only() end

local function prevlayout() awful.layout.inc(-1) end

local function nextlayout() awful.layout.inc(1) end

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

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.tile.floating,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
}

awful.screen.connect_for_each_screen(
    function(s)
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

        s.panel = awful.wibar {
            position = "bottom",
            stretch = true,
            border_width = 0,
            height = 24,
            screen = s,
        }
        s.panel:setup{
            layout = wibox.layout.align.horizontal,
            {
                layout = wibox.layout.align.horizontal,
                s.layoutbox,
                awful.widget.taglist {
                    screen = s,
                    filter = awful.widget.taglist.filter.all,
                    buttons = gears.table.join(
                        awful.button({}, 1, viewonly),
                            awful.button({}, 3, awful.tag.viewtoggle),
                            awful.button(
                                {}, 4,
                                    function(t)
                                        awful.tag.viewprev(t.screen)
                                    end
                            ), awful.button(
                                {}, 5,
                                    function(t)
                                        awful.tag.viewnext(t.screen)
                                    end
                            )
                    ),
                },
            },
            wibox.widget.systray(),
            wibox.widget.textclock("%F %T", 1),
        }
    end
)

local kbss = {
    help = {{m, "h", hotkeys_popup.show_help, "show help"}},
    session = {
        {mc, "l", exec("xsecurelock"), "lock screen"},
        {mc, "q", awesome.quit, "quit awesome"},
        {mc, "r", awesome.restart, "restart awesome"},
    },
    layout = {},
    tag = {
        {m, "Left", awful.tag.viewprev, "view previous tag"},
        {m, "Right", awful.tag.viewnext, "view next tag"},
        {m, "BackSpace", awful.tag.history.restore, "go back"},
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
end

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

awful.spawn("xbacklight -set 10%")
awful.spawn("xset -b")
awful.spawn("flameshot")
awful.spawn("~/.fehbg")
awful.spawn("Thunar --daemon")
awful.spawn("nm-applet")
awful.spawn("volctl")
