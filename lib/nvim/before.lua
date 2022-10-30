local no_top_text = {
  opts = {
    border = {
      text = { top = "" },
    },
  },
}

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
    format = {
      cmdline = no_top_text,
      filter = no_top_text,
      lua = no_top_text,
      search_down = no_top_text,
      search_up = no_top_text,
    },
  },

  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["cmp.entry.get_documentation"] = true,
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
      },
    },
    confirm = {
      border = {
        style = "single",
        text = { top = "" },
      },
    },
  },
})
