local themedir = require("gears.filesystem").get_themes_dir()

return {
    fullscreen_hide_border = true,
    maximized_hide_border = true,

    layout_max = themedir .. "zenburn/layouts/max.png",
    layout_tile = themedir .. "zenburn/layouts/tile.png",
    layout_tiletop = themedir .. "zenburn/layouts/tiletop.png",

    wibar_height = 24,
    hotkeys_modifiers_fg = "#80b0ff",
    taglist_fg_empty = "#606060",

    font = "sans-serif 11",
    battery_font = "monospace 8",
    taglist_font = "monospace 12",
    textclock_font = "monospace 12",

    bg_normal = "#101010",
    bg_focus = "#202020",
    bg_urgent = "ffa000",
    bg_minimize = "#101010",

    fg_normal = "#c8c8c8",
    fg_focus = "#e0e0e0",
    fg_urgent = "#ffffff",
    fg_minimize = "#606060",

    border_width = 2,
    border_normal = "#606060",
    border_focus = "#0074b8",

    wallpaper = os.getenv("HOME") .. "/wallpaper.png",
}
