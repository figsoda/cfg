local cmp = require("cmp")
local gps = require("nvim-gps")
local lspconfig = require("lspconfig")
local luasnip = require("luasnip")
local notify = require("notify")
local null_ls = require("null-ls")
local nb = null_ls.builtins
local telescope = require("telescope")
local ts_utils = require("nvim-treesitter.ts_utils")

local border = { "", "", "", " ", "", "", "", " " }

local capabilities = require("cmp_nvim_lsp").update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

vim.g.mapleader = " "
vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_conceal_code_blocks = 0

local function on_attach(_, buf)
  local map = {
    K = "lua vim.lsp.buf.hover()",
    ["<space>d"] = "Trouble document_diagnostics",
    ["<space>e"] = "Trouble workspace_diagnostics",
    ["<space>f"] = "lua vim.lsp.buf.formatting()",
    ["<space>r"] = "Trouble lsp_references",
    ["[d"] = "lua vim.lsp.diagnostic.goto_prev()",
    ["]d"] = "lua vim.lsp.diagnostic.goto_next()",
    ga = "CodeActionMenu",
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
    "<space>f",
    "<cmd>lua vim.lsp.buf.range_formatting()<cr>",
    { noremap = true }
  )

  vim.api.nvim_buf_set_keymap(
    buf,
    "v",
    "ga",
    "<cmd>CodeActionMenu<cr>",
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
    format = require("lspkind").cmp_format({ with_text = false }),
  },
  mapping = {
    ["<C-e>"] = function(fallback)
      cmp.close()
      fallback()
    end,
    ["<cr>"] = cmp.mapping.confirm(),
    ["<m-cr>"] = cmp.mapping.confirm({ select = true }),
    ["<S-Tab>"] = cmp.mapping({
      i = function(fallback)
        if not cmp.select_prev_item() and not luasnip.jump(-1) then
          fallback()
        end
      end,
      c = cmp.mapping.select_prev_item(),
    }),
    ["<Tab>"] = cmp.mapping({
      i = function(fallback)
        if not cmp.select_next_item() and not luasnip.jump(1) then
          fallback()
        end
      end,
      c = cmp.mapping.select_next_item(),
    }),
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "crates" },
    { name = "path" },
    { name = "luasnip" },
    { name = "buffer", keyword_length = 3 },
  },
})

cmp.setup.cmdline("/", {
  sources = {
    { name = "nvim_lsp_document_symbol" },
    { name = "buffer" },
  },
})

cmp.setup.cmdline(":", {
  sources = {
    { name = "cmdline" },
    { name = "path" },
  },
})

require("colorizer").setup(nil, { css = true })

require("Comment").setup({ ignore = "^$" })

require("crates").setup()

require("gitsigns").setup({
  keymaps = {},
  preview_config = { border = border },
  status_formatter = function(status)
    return "  "
      .. (status.head == "" and "detached HEAD" or status.head)
      .. (status.added and status.added > 0 and " %#StatusLineGitAdded# " .. status.added or "")
      .. (status.changed and status.changed > 0 and " %#StatusLineGitChanged# " .. status.changed or "")
      .. (
        status.removed
          and status.removed > 0
          and " %#StatusLineGitRemoved# " .. status.removed
        or ""
      )
  end,
})

gps.setup()

require("indent_blankline").setup({
  buftype_exclude = { "terminal" },
  char = "│",
  filetype_exclude = { "help", "NvimTree", "Trouble" },
  use_treesitter = true,
})

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
      { "diagnostics", sources = { "nvim_diagnostic" } },
      { gps.get_location, condition = gps.is_available },
    },
  },
})

lspconfig.pylsp.setup({
  capabilities = capabilities,
  cmd = { "@python_lsp_server@/bin/pylsp" },
  on_attach = on_attach,
})

lspconfig.rnix.setup({
  capabilities = capabilities,
  cmd = { "@rnix_lsp@/bin/rnix-lsp" },
  on_attach = on_attach,
})

lspconfig.sumneko_lua.setup({
  capabilities = capabilities,
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
    c.resolved_capabilities.document_formatting = false
    for _, i in pairs(c.config.settings.Lua.diagnostics.globals) do
      if i == "vim" then
        cmp.setup.buffer({
          sources = {
            { name = "nvim_lua" },
            { name = "nvim_lsp" },
            { name = "crates" },
            { name = "path" },
            { name = "luasnip" },
            { name = "buffer", keyword_length = 3 },
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

lspconfig.taplo.setup({
  capabilities = capabilities,
  cmd = { "@taplo_lsp@/bin/taplo-lsp", "run" },
  on_attach = on_attach,
})

lspconfig.vimls.setup({
  capabilities = capabilities,
  cmd = { "@vim_language_server@/bin/vim-language-server", "--stdio" },
  on_attach = on_attach,
})

lspconfig.yamlls.setup({
  capabilities = capabilities,
  cmd = { "@yaml_language_server@/bin/yaml-language-server", "--stdio" },
  on_attach = on_attach,
})

notify.setup({ stages = "static" })
vim.notify = notify

null_ls.setup({
  on_attach = on_attach,
  sources = {
    nb.diagnostics.shellcheck.with({ command = "@shellcheck@/bin/shellcheck" }),
    nb.formatting.prettier.with({ command = "@prettier@/bin/prettier" }),
    nb.formatting.stylua.with({ command = "@stylua@/bin/stylua" }),
  },
})

require("numb").setup()

require("nvim-tree").setup({
  diagnostics = { enable = true },
  filters = {
    custom = { "^.git$" },
  },
  hijack_cursor = true,
  open_on_setup = true,
  update_cwd = true,
  renderer = {
    icons = {
      glyphs = { default = "" },
    },
  },
  view = {
    mappings = {
      list = {
        {
          key = "o",
          cb = "<cmd>lua require('nvim-tree').on_keypress('system_open')<cr>",
        },
        {
          key = "s",
          cb = "<cmd>lua require('lightspeed').sx:go()<cr>",
        },
      },
    },
  },
})

require("nvim-treesitter.configs").setup({
  actions = {
    open_file = {
      quit_on_open = true,
      window_picker = {
        exclude = {
          buftype = { "terminal" },
          filetype = { "notify", "Trouble" },
        },
      },
    },
  },
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
    capabilities = capabilities,
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
