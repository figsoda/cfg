require("notify").setup({
  max_width = 80,
  minimum_width = 20,
  on_open = function(win)
    vim.api.nvim_win_set_config(win, { border = "single" })
  end,
  stages = "static",
  render = "minimal",
})

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
