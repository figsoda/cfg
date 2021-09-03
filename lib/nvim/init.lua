local cmp = require("cmp")
local gps = require("nvim-gps")
local lspconfig = require("lspconfig")
local lspkind = require("lspkind")
local luasnip = require("luasnip")
local notify = require("notify")
local null_ls = require("null-ls")
local nb = null_ls.builtins
local telescope = require("telescope")
local ts_utils = require("nvim-treesitter.ts_utils")

local border = { "", "", "", " ", "", "", "", " " }

local cap = vim.lsp.protocol.make_client_capabilities()
cap.textDocument.completion.completionItem.snippetSupport = true
cap.textDocument.completion.completionItem.resovleSupport = {
  properties = { "additionalTextEdits" },
}

local function on_attach(_, buf)
  local map = {
    K = "lua vim.lsp.buf.hover()",
    ["<space>d"] = "Trouble lsp_document_diagnostics",
    ["<space>e"] = "Trouble lsp_workspace_diagnostics",
    ["<space>f"] = "lua vim.lsp.buf.formatting()",
    ["<space>r"] = "Trouble lsp_references",
    ["[d"] = "lua vim.lsp.diagnostic.goto_prev()",
    ["]d"] = "lua vim.lsp.diagnostic.goto_next()",
    ga = "lua vim.lsp.buf.code_action()",
    gd = "lua vim.lsp.buf.definition()",
    ge = "lua vim.lsp.diagnostic.show_line_diagnostics()",
    gr = "lua vim.lsp.buf.rename()",
    gt = "lua vim.lsp.buf.type_definition()",
  }

  for k, v in pairs(map) do
    vim.api.nvim_buf_set_keymap(
      buf,
      "n",
      k,
      "<cmd>" .. v .. "<cr>",
      { noremap = true }
    )
  end

  vim.api.nvim_buf_set_keymap(
    buf,
    "v",
    "ga",
    "<cmd>lua vim.lsp.buf.range_code_action()<cr>",
    { noremap = true }
  )
end

require("bufferline").setup({
  highlights = {
    background = { guibg = "#1f2227" },
    buffer_visible = { guibg = "#1f2227" },
    close_button = { guibg = "#1f2227" },
    duplicate = { guibg = "#1f2227" },
    duplicate_visible = { guibg = "#1f2227" },
    error = { guibg = "#1f2227" },
    error_visible = { guibg = "#1f2227" },
    fill = { guibg = "#1f2227" },
    indicator_selected = { guifg = "#61afef" },
    modified = { guibg = "#1f2227" },
    modified_visible = { guibg = "#1f2227" },
    pick = { guibg = "#1f2227" },
    pick_visible = { guibg = "#1f2227" },
    separator = {
      guifg = "#1f2227",
      guibg = "#1f2227",
    },
    separator_visible = {
      guifg = "#1f2227",
      guibg = "#1f2227",
    },
    tab = { guibg = "#1f2227" },
    tab_close = { guibg = "#1f2227" },
    warning = { guibg = "#1f2227" },
    warning_selected = { guifg = "#e5c07b" },
    warning_visible = { guibg = "#1f2227" },
  },
  options = {
    custom_filter = function(n)
      return vim.fn.bufname(n) ~= ""
        and vim.api.nvim_buf_get_option(n, "buftype") ~= "terminal"
    end,
    diagnostics = "nvim_lsp",
    show_close_icon = false,
  },
})

cmp.setup({
  confirmation = { default_behavior = cmp.ConfirmBehavior.Replace },
  formatting = {
    format = function(_, item)
      item.kind = lspkind.presets.default[item.kind]
      return item
    end,
  },
  mapping = {
    ["<cr>"] = cmp.mapping.confirm(),
    ["<s-tab>"] = cmp.mapping.select_prev_item(),
    ["<tab>"] = cmp.mapping.select_next_item(),
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "buffer" },
    { name = "nvim_lsp" },
    { name = "path" },
  },
})

require("colorizer").setup(nil, { css = true })

require("gitsigns").setup({
  keymaps = {},
  preview_config = { border = border },
  status_formatter = function(status)
    return " "
      .. (status.head == "" and "detached HEAD" or status.head)
      .. (status.added and status.added > 0 and "  " .. status.added or "")
      .. (status.changed and status.changed > 0 and "  " .. status.changed or "")
      .. (
        status.removed
          and status.removed > 0
          and "  " .. status.removed
        or ""
      )
  end,
})

gps.setup()

require("lualine").setup({
  options = {
    component_separators = "",
    section_separators = "",
    disabled_filetypes = { "NvimTree" },
    theme = {
      normal = {
        a = { fg = "#1f2227", bg = "#98c379", gui = "bold" },
        b = { fg = "#abb2bf", bg = "#282c34" },
        c = { fg = "#abb2bf", bg = "#1f2227" },
      },
      insert = { a = { fg = "#1f2227", bg = "#61afef", gui = "bold" } },
      visual = { a = { fg = "#1f2227", bg = "#c678dd", gui = "bold" } },
      replace = { a = { fg = "#1f2227", bg = "#e06c75", gui = "bold" } },
      inactive = {
        a = { fg = "#5c6370", bg = "#1f2227", gui = "bold" },
        b = { fg = "#5c6370", bg = "#1f2227" },
        c = { fg = "#5c6370", bg = "#1f2227" },
      },
    },
  },
  sections = {
    lualine_b = { "b:gitsigns_status" },
    lualine_c = {
      "filename",
      { "diagnostics", sources = { "nvim_lsp" } },
      { gps.get_location, condition = gps.is_available },
    },
  },
})

lspconfig.pylsp.setup({
  cmd = { "@python_lsp_server@/bin/pylsp" },
  on_attach = on_attach,
})

lspconfig.rnix.setup({
  cmd = { "@rnix_lsp@/bin/rnix-lsp" },
  on_attach = function(c, buf)
    on_attach(c, buf)
    c.resolved_capabilities.document_formatting = false
  end,
})

lspconfig.sumneko_lua.setup({
  cmd = { "@sumneko_lua_language_server@/bin/lua-language-server" },
  root_dir = function(file)
    return lspconfig.util.root_pattern("lua-globals")(file)
      or lspconfig.util.find_git_ancestor(file)
      or lspconfig.util.path.dirname(file)
  end,
  on_new_config = function(new_config, new_root_dir)
    new_config.settings.Lua.diagnostics.globals = {}
    local file = io.open(new_root_dir .. "/lua-globals", "r")
    if file then
      for line in file:lines() do
        table.insert(new_config.settings.Lua.diagnostics.globals, line)
      end
      file:close()
    end
  end,
  on_attach = function(c, buf)
    on_attach(c, buf)
    for _, i in pairs(c.config.settings.Lua.diagnostics.globals) do
      if i == "vim" then
        cmp.setup.buffer({
          sources = {
            { name = "buffer" },
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "path" },
          },
        })
        break
      end
    end
  end,
  settings = {
    Lua = {
      diagnostics = {
        disable = { "lowercase-global", "redefined-local" },
      },
      runtime = { version = "LuaJIT" },
    },
  },
})

lspconfig.vimls.setup({
  cmd = { "@vim_language_server@/bin/vim-language-server", "--stdio" },
  on_attach = on_attach,
})

lspconfig.yamlls.setup({
  cmd = { "@yaml_language_server@/bin/yaml-language-server", "--stdio" },
  on_attach = on_attach,
})

lspkind.init({ with_text = false })

notify.setup({ stages = "static" })
vim.notify = notify

null_ls.setup({
  on_attach = on_attach,
  sources = {
    nb.diagnostics.shellcheck.with({ command = "@shellcheck@/bin/shellcheck" }),
    nb.formatting.nixfmt.with({ command = "@nixfmt@/bin/nixfmt" }),
    nb.formatting.prettier.with({ command = "@prettier@/bin/prettier" }),
    nb.formatting.stylua.with({ command = "@stylua@/bin/stylua" }),
  },
})

require("numb").setup()

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = { "nix" },
  },
  indent = { enable = true },
  textobjects = {
    lsp_interop = {
      enable = true,
      border = border,
      peek_definition_code = {
        gp = "@function.outer",
      },
    },
    move = {
      enable = true,
      goto_next_start = {
        ["]]"] = "@class.outer",
        ["]m"] = "@function.outer",
      },
      goto_next_end = {
        ["]["] = "@class.outer",
        ["]M"] = "@function.outer",
      },
      goto_previous_start = {
        ["[["] = "@class.outer",
        ["[m"] = "@function.outer",
      },
      goto_previous_end = {
        ["[]"] = "@class.outer",
        ["[M"] = "@function.outer",
      },
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ab = "@block.outer",
        ib = "@block.inner",
        ac = "@class.outer",
        ic = "@class.inner",
        af = "@function.outer",
        ["if"] = "@function.inner",
        ai = "@conditional.outer",
        ii = "@conditional.inner",
        al = "@loop.outer",
        il = "@loop.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        glc = "@class.outer",
        glf = "@function.outer",
        glp = "@parameter.inner",
      },
      swap_previous = {
        ghc = "@class.outer",
        ghf = "@function.outer",
        ghp = "@parameter.inner",
      },
    },
  },
})

require("nvim_context_vt").setup({
  custom_text_handler = function(node)
    local text = ts_utils.get_node_text(node)[1]
    local start_row, _, end_row, _ = ts_utils.get_node_range(node)
    return #text > 3 and end_row - start_row > 12 and "<- " .. text or nil
  end,
})

require("rust-tools").setup({
  server = {
    capabilities = cap,
    cmd = { "@rust_analyzer@/bin/rust-analyzer" },
    on_attach = function(c, buf)
      on_attach(c, buf)
      require("lsp_signature").on_attach({
        handler_opts = { border = border },
      })
    end,
    settings = {
      ["rust-analyzer"] = {
        assist = { importPrefix = "by_crate" },
        checkOnSave = { command = "clippy" },
      },
    },
  },
  tools = {
    hover_actions = { border = border },
    inlay_hints = {
      other_hints_prefix = "",
      show_parameter_hints = false,
    },
  },
})

telescope.setup({
  defaults = {
    borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    layout_config = {
      height = 0.9,
      preview_width = 80,
      width = 0.9,
    },
    mappings = {
      i = {
        ["<c-s>"] = require("trouble.providers.telescope").open_with_trouble,
        ["<esc>"] = require("telescope.actions").close,
      },
    },
    prompt_prefix = " ",
    selection_caret = "❯ ",
  },
  pickers = {
    find_files = { hidden = true },
  },
})
telescope.load_extension("fzf")

require("trouble").setup()
