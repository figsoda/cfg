require("notify").setup({ stages = "static" })

require("noice").setup({
  cmdline = {
    icons = {
      ["/"] = { firstc = false },
      ["?"] = { firstc = false },
    },
  },

  popupmenu = {
    backend = "cmp",
  },

  routes = {
    {
      filter = {
        event = "msg_show",
        kind = "search_count",
      },
      opts = { skip = true },
    },
  },

  views = {
    cmdline_popup = {
      border = {
        style = "single",
        text = { top = "" },
      },
      filter_options = {},
    },
  },
})
