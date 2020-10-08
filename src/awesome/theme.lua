local themedir = require("gears.filesystem").get_themes_dir()

return {
    fullscreen_hide_border = true,
    maximized_hide_border = true,

    layout_max = themedir .. "zenburn/layouts/max.png",
    layout_tile = themedir .. "zenburn/layouts/tile.png",
    layout_tiletop = themedir .. "zenburn/layouts/tiletop.png",

    wibar_height = 24,
    hotkeys_border_width = 0,
    hotkeys_modifiers_fg = "#80b0ff",
    hotkeys_font = "monospace 10",
    hotkeys_description_font = "monospace 10",
    hotkeys_group_margin = 24,
    taglist_fg_empty = "#606060",

    font = "sans 11",
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

    calendar_start_sunday = true,
    calendar_long_weekdays = true,
    calendar_month_padding = 8,
    calendar_month_border_width = 0,
    calendar_header_fg_color = "#60f0a0",
    calendar_header_padding = 4,
    calendar_header_border_width = 0,
    calendar_weekday_fg_color = "#ffc0ff",
    calendar_weekday_border_width = 0,
    calendar_normal_fg_color = "#a0e8ff",
    calendar_normal_border_width = 0,
    calendar_focus_fg_color = "#ffe840",
    calendar_focus_bg_color = "#101010",
    calendar_focus_border_width = 0,

    wallpaper = os.getenv("HOME") .. "/wallpaper.png",
}
