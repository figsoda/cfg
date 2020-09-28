local themedir = require("gears.filesystem").get_themes_dir()

return {
    fullscreen_hide_border = true,
    maximized_hide_border = true,

    layout_floating = themedir .. "zenburn/layouts/floating.png",
    layout_max = themedir .. "zenburn/layouts/max.png",
    layout_fullscreen = themedir .. "zenburn/layouts/fullscreen.png",
    layout_tile = themedir .. "zenburn/layouts/tile.png",
    layout_tiletop = themedir .. "zenburn/layouts/tile.png",
    layout_tilebottom = themedir .. "zenburn/layouts/tilebottom.png",
    layout_tileleft = themedir .. "zenburn/layouts/tileleft.png",

    wibar_height = 24,
    wibar_bg = "#202020",
    wibar_fg = "#d0d0d0",

    font = "Noto Sans 12",

    bg_normal = "#202020",
    bg_focus = "#404040",
    bg_urgent = "ffa000",
    bg_minimize = "#202020",

    fg_normal = "#d0d0d0",
    fg_focus = "#f0f0f0",
    fg_urgent = "#ffffff",
    fg_minimize = "#a0a0a0",

    border_width = 1,
    border_normal = "#606060",
    border_focus = "#0074b8",

    wallpaper = "/home/figsoda/wallpaper.png",
}
