local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local c = { "Control" }
local m = { "Mod4" }
local ma = { "Mod4", "Mod1" }
local mc = { "Mod4", "Control" }
local ms = { "Mod4", "Shift" }

local function exec(cmd)
  return function()
    awful.spawn(cmd)
  end
end
local function exec_sh(cmd)
  return function()
    awful.spawn.with_shell(cmd)
  end
end

local function focus(idx, dir)
  return function(c)
    if c.screen.selected_tag.layout.name == "max" then
      awful.client.focus.byidx(idx, c)
    else
      awful.client.focus.bydirection(dir, c)
    end
  end
end

local function swap(idx, dir)
  return function(c)
    if c.screen.selected_tag.layout.name == "max" then
      awful.client.swap.byidx(idx, c)
    else
      awful.client.swap.bydirection(dir, c)
    end
  end
end

local function shotgun(flags)
  local name = os.date("%Y%m%d%H%M%S") .. ".png"
  awful.spawn.easy_async(
    { "shotgun", name, unpack(flags) },
    function(_, _, _, exitcode)
      if exitcode == 0 then
        naughty.notify({
          text = name,
          title = "screenshot saved",
          icon = os.getenv("HOME") .. "/" .. name,
          icon_size = 96,
        })
        awful.spawn({
          "xclip",
          name,
          "-selection",
          "clipboard",
          "-t",
          "image/png",
        })
      end
    end
  )
end

local ckbs = {
  {
    ms,
    "f",
    function(c)
      c.fullscreen = not c.fullscreen
    end,
  },
  {
    ms,
    "q",
    function(c)
      c:kill()
    end,
  },
  {
    ms,
    "t",
    function(c)
      c.ontop = not c.ontop
    end,
  },
  { m, "h", focus(-1, "left") },
  { m, "j", focus(1, "down") },
  { m, "k", focus(-1, "up") },
  { m, "l", focus(1, "right") },
  { ms, "h", swap(-1, "left") },
  { ms, "j", swap(1, "down") },
  { ms, "k", swap(-1, "up") },
  { ms, "l", swap(1, "right") },
}

local kbs = {
  { mc, "l", exec("lockscreen") },
  {
    mc,
    "Return",
    function()
      awful.spawn.easy_async_with_shell(
        "echo '1 ⏻  shutdown | poweroff,2   reboot,3 ⏼  suspend,4 望  hibernate,5   lock screen,6   quit | log out,7   reload awesome,8   restart firefox' | rofi -dmenu -sep , -p session -format i -no-custom -select 8",
        function(stdout)
          ({
            exec("poweroff"),
            exec("reboot"),
            exec({ "systemctl", "suspend" }),
            exec({ "systemctl", "hibernate" }),
            exec("lockscreen"),
            awesome.quit,
            awesome.restart,
            exec_sh("killall .firefox-wrapped && firefox"),
          })[stdout:byte() - 47]()
        end
      )
    end,
  },

  {
    ms,
    "Left",
    function()
      awful.layout.inc(-1)
    end,
  },
  {
    ms,
    "Right",
    function()
      awful.layout.inc(1)
    end,
  },
  {
    m,
    " ",
    function()
      awful.layout.inc(1)
    end,
  },
  {
    m,
    "[",
    function()
      awful.tag.incmwfact(-0.05)
    end,
  },
  {
    m,
    "]",
    function()
      awful.tag.incmwfact(0.05)
    end,
  },
  {
    m,
    "\\",
    function()
      awful.screen.focused().selected_tag.master_width_factor = 0.5
    end,
  },
  {
    ms,
    "[",
    function()
      awful.tag.incncol(-1)
    end,
  },
  {
    ms,
    "]",
    function()
      awful.tag.incncol(1)
    end,
  },
  {
    ms,
    "\\",
    function()
      awful.screen.focused().selected_tag.column_count = 1
    end,
  },

  { m, "Left", awful.tag.viewprev },
  { m, "Right", awful.tag.viewnext },
  { m, "BackSpace", awful.tag.history.restore },
  { m, "Tab", awful.tag.viewnext },
  { ms, "Tab", awful.tag.viewprev },
  {
    m,
    "n",
    function()
      local c = client.focus
      if c then
        c.minimized = true
      else
        awful.client.restore(awful.screen.focused())
      end
    end,
  },
  {
    ms,
    "n",
    function()
      local c = awful.client.restore(awful.screen.focused())
      if c then
        c:emit_signal("request::activate", "mouse_click", { raise = true })
      end
    end,
  },
  {
    m,
    "p",
    function()
      local panel = awful.screen.focused().panel
      panel.visible = not panel.visible
    end,
  },

  { {}, "XF86AudioLowerVolume", exec({ "pamixer", "-d", "5" }) },
  { {}, "XF86AudioMicMute", exec({ "pamixer", "-t", "--default-source" }) },
  { {}, "XF86AudioMute", exec({ "pamixer", "-t" }) },
  {
    {},
    "XF86AudioNext",
    function()
      awful.screen.focused().mpd.next()
    end,
  },
  {
    {},
    "XF86AudioPlay",
    function()
      awful.screen.focused().mpd.toggle()
    end,
  },
  {
    {},
    "XF86AudioPrev",
    function()
      awful.screen.focused().mpd.prev()
    end,
  },
  { {}, "XF86AudioRaiseVolume", exec({ "pamixer", "-i", "5" }) },
  {
    {},
    "XF86KbdBrightnessDown",
    exec({ "brightnessctl", "s", "1-", "-d", "asus::kbd_backlight" }),
  },
  {
    {},
    "XF86KbdBrightnessUp",
    exec({ "brightnessctl", "s", "1+", "-d", "asus::kbd_backlight" }),
  },
  { {}, "XF86MonBrightnessDown", exec({ "brightnessctl", "s", "4-" }) },
  { {}, "XF86MonBrightnessUp", exec({ "brightnessctl", "s", "4+" }) },
  { c, "XF86MonBrightnessDown", exec({ "brightnessctl", "s", "1-" }) },
  { c, "XF86MonBrightnessUp", exec({ "brightnessctl", "s", "1+" }) },

  {
    {},
    "Print",
    function()
      shotgun({})
    end,
  },
  {
    c,
    "Print",
    function()
      awful.spawn.easy_async("hacksaw", function(stdout, _, _, exitcode)
        if exitcode == 0 then
          shotgun({ "-g", stdout:sub(1, -2) })
        end
      end)
    end,
  },
  { m, "Return", exec("alacritty") },
  { m, "a", exec("pavucontrol") },
  { m, "b", exec("firefox") },
  { m, "c", exec_sh("CM_LAUNCHER=rofi clipmenu -p clipmenu") },
  { ms, "c", exec_sh("xclip -selection clipboard /dev/null; clipdel -d .") },
  {
    m,
    "e",
    exec_sh(
      "fd -d 1 -t d --strip-cwd-prefix --path-separator '' | rofi -dmenu -p edit -i | xargs -r alacritty -e nvim"
    ),
  },
  { m, "f", exec("spacefm") },
  { m, "m", exec({ "alacritty", "-e", "mmtc" }) },
  {
    ms,
    "m",
    function()
      awful.screen.focused().mpd.reload()
    end,
  },
  {
    m,
    "o",
    exec_sh(
      "xdg-open (fd -E /nixpkgs/ --strip-cwd-prefix | rofi -dmenu -p open -i -matching fuzzy)"
    ),
  },
  { m, "q", exec("qalculate-gtk") },
  {
    m,
    "r",
    exec({
      "rofi",
      "-modes",
      "combi",
      "-show",
      "combi",
      "-combi-modes",
      "run,drun",
      "-combi-display-format",
      "{text}",
    }),
  },
  { m, "s", exec({ "alacritty", "-e", "btm" }) },
  { m, "t", exec("rofi-todo") },
  {
    m,
    "u",
    function()
      root.fake_input("key_release", "u")
      root.fake_input("key_release", "Super_L")
      root.fake_input("key_press", "Alt_L")
      root.fake_input("key_press", "Control_L")
      root.fake_input("key_press", "Shift_L")
      root.fake_input("key_press", "u")
      root.fake_input("key_release", "u")
      root.fake_input("key_release", "Alt_L")
      root.fake_input("key_release", "Control_L")
      root.fake_input("key_release", "Shift_L")
    end,
  },
  { m, "w", exec({ "rofi", "-show", "window", "-modes", "window" }) },
  {
    m,
    ",",
    function()
      awful.screen.focused().mpd.toggle()
    end,
  },
  {
    m,
    ".",
    function()
      awful.screen.focused().mpd.next()
    end,
  },
  {
    m,
    ";",
    function()
      awful.screen.focused().mpd.stop()
    end,
  },
}

for i = 1, 6 do
  local key = i == 1 and "`" or i - 1
  table.insert(kbs, {
    m,
    key,
    function()
      awful.screen.focused().tags[i]:view_only()
    end,
  })
  table.insert(kbs, {
    ma,
    key,
    function()
      awful.tag.viewtoggle(awful.screen.focused().tags[i])
    end,
  })
  table.insert(ckbs, {
    ms,
    key,
    function(c)
      c:move_to_tag(awful.screen.focused().tags[i])
    end,
  })
  table.insert(ckbs, {
    mc,
    key,
    function(c)
      c:toggle_tag(awful.screen.focused().tags[i])
    end,
  })
end

local keys = { client = {}, global = {} }

for _, kb in pairs(ckbs) do
  keys.client = gears.table.join(keys.client, awful.key(kb[1], kb[2], kb[3]))
end

for _, kb in pairs(kbs) do
  keys.global = gears.table.join(keys.global, awful.key(kb[1], kb[2], kb[3]))
end

return keys
