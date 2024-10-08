local dpi = require("beautiful").xresources.apply_dpi
local themedir = require("gears.filesystem").get_themes_dir()

return {
  fullscreen_hide_border = true,
  maximized_hide_border = true,

  layout_max = themedir .. "zenburn/layouts/max.png",
  layout_tile = themedir .. "zenburn/layouts/tile.png",

  notification_max_width = dpi(280),
  notification_max_height = dpi(140),
  notification_icon_size = dpi(20),
  wibar_height = dpi(14),

  font = "sans 8",
  battery_font = "monospace 5.5",
  taglist_font = "monospace 8",
  textclock_font = "monospace 7",

  bg_normal = "#101014",
  bg_focus = "#202428",
  bg_urgent = "#e5c076",
  bg_minimize = "#101014",
  taglist_fg_normal = "#b8b8b8",
  taglist_fg_empty = "#585858",
  tasklist_bg_focus = "#101014",

  fg_normal = "#c8c8c8",
  fg_focus = "#d8d8d8",
  fg_urgent = "#f0f0f0",
  fg_minimize = "#606060",
  tasklist_fg_normal = "#a0a0a0",
  tasklist_fg_focus = "#c8c8c8",

  border_width = dpi(0.75),
  border_normal = "#586068",
  border_focus = "#56b6c2",

  calendar_start_sunday = true,
  calendar_long_weekdays = true,
  calendar_month_bg_color = "#101014",
  calendar_month_padding = dpi(4),
  calendar_month_border_width = 0,
  calendar_header_bg_color = "#101014",
  calendar_header_fg_color = "#e5c07b",
  calendar_header_padding = dpi(2),
  calendar_header_border_width = 0,
  calendar_weekday_bg_color = "#101014",
  calendar_weekday_fg_color = "#e06c75",
  calendar_weekday_border_width = 0,
  calendar_normal_bg_color = "#101014",
  calendar_normal_fg_color = "#abb2bf",
  calendar_normal_border_width = 0,
  calendar_focus_fg_color = "#56b6c2",
  calendar_focus_bg_color = "#101014",
  calendar_focus_border_width = 0,

  wallpaper = os.getenv("HOME") .. "/.config/wallpaper.png",
}
