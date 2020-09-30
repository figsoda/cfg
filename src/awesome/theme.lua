local themedir = require("gears.filesystem").get_themes_dir()

return {
    fullscreen_hide_border = true,
    maximized_hide_border = true,

    layout_max = themedir .. "zenburn/layouts/max.png",
    layout_tile = themedir .. "zenburn/layouts/tile.png",
    layout_tiletop = themedir .. "zenburn/layouts/tile.png",

    wibar_height = 20,

    font = "Noto Sans 9",

    bg_normal = "#181818",
    bg_focus = "#282828",
    bg_urgent = "ffa000",
    bg_minimize = "#181818",

    fg_normal = "#d0d0d0",
    fg_focus = "#f0f0f0",
    fg_urgent = "#ffffff",
    fg_minimize = "#a0a0a0",

    border_width = 1,
    border_normal = "#606060",
    border_focus = "#0074b8",

    wallpaper = os.getenv("HOME") .. "/wallpaper.png",
}
