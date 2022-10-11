local cmp = require("cmp")
local gps = require("nvim-gps")
local jdtls = require("jdtls")
local lspconfig = require("lspconfig")
local luasnip = require("luasnip")
local null_ls = require("null-ls")
local nb = null_ls.builtins
local rust_tools = require("rust-tools")
local telescope = require("telescope")
local trouble = require("trouble")

local api = vim.api
local diagnostic = vim.diagnostic
local fn = vim.fn
local lsp = vim.lsp
local treesitter = vim.treesitter

local border = { "", "", "", " ", "", "", "", " " }

local capabilities = require("cmp_nvim_lsp").update_capabilities(
  lsp.protocol.make_client_capabilities()
)

local function on_attach(_, buf)
  local function mapb(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf })
  end

  mapb("n", " e", function()
    trouble.open("workspace_diagnostics")
  end)
  mapb("n", " r", function()
    trouble.open("lsp_references")
  end)
  mapb("n", "K", lsp.buf.hover)
  mapb("n", "[d", diagnostic.goto_prev)
  mapb("n", "]d", diagnostic.goto_next)
  mapb("n", "gd", lsp.buf.definition)
  mapb("n", "ge", function()
    diagnostic.open_float(0, { scope = "cursor" })
  end)
  mapb("n", "gr", lsp.buf.rename)
  mapb("n", "gt", lsp.buf.type_definition)
  mapb({ "n", "v" }, "ff", function()
    lsp.buf.format({ async = true, bufnr = buf })
  end)
  mapb({ "n", "v" }, "ga", require("code_action_menu").open_code_action_menu)
end

require("bufferline").setup({
  highlights = {
    background = { bg = "@black@" },
    buffer_visible = { bg = "@black@" },
    close_button = { bg = "@black@" },
    duplicate = { bg = "@black@" },
    duplicate_visible = { bg = "@black@" },
    error = { bg = "@black@" },
    error_visible = { bg = "@black@" },
    fill = { bg = "@black@" },
    indicator_selected = { fg = "@blue@" },
    modified = { bg = "@black@" },
    modified_visible = { bg = "@black@" },
    pick = { bg = "@black@" },
    pick_visible = { bg = "@black@" },
    separator = {
      fg = "@black@",
      bg = "@black@",
    },
    separator_visible = {
      fg = "@black@",
      bg = "@black@",
    },
    tab = { bg = "@black@" },
    tab_close = { bg = "@black@" },
    warning = { bg = "@black@" },
    warning_selected = { fg = "@yellow@" },
    warning_visible = { bg = "@black@" },
  },
  options = {
    custom_filter = function(n)
      return fn.bufname(n) ~= ""
        and api.nvim_buf_get_option(n, "buftype") ~= "terminal"
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
    ["<s-tab>"] = cmp.mapping({
      i = function(fallback)
        if not cmp.select_prev_item() and not luasnip.jump(-1) then
          fallback()
        end
      end,
      c = cmp.mapping.select_prev_item(),
    }),
    ["<tab>"] = cmp.mapping({
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

cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
  enabled = true,
  sources = {
    { name = "dap" },
  },
})

require("colorizer").setup(nil, { css = true })

require("Comment").setup({ ignore = "^$" })

require("crates").setup()

require("dapui").setup()

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
  char = "▏",
  use_treesitter = true,
})

jdtls.setup_dap()
api.nvim_create_autocmd({ "FileType" }, {
  pattern = "java",
  callback = function()
    local root_dir = jdtls.setup.find_root({ "java-workspace" })
    jdtls.start_or_attach({
      capabilities = capabilities,
      cmd = {
        "@jdt_language_server@/bin/jdt-language-server",
        "-data",
        root_dir,
      },
      init_options = {
        bundles = fn.readfile("@jdtls_bundles@"),
      },
      on_attach = on_attach,
      root_dir = root_dir,
      settings = {
        configuration = {
          runtimes = {
            name = "JavaSE-17",
            path = "@openjdk17@",
          },
        },
        java = {
          format = {
            settings = {
              url = "@jdtls_format@",
            },
          },
        },
      },
    })
  end,
})

require("lualine").setup({
  options = {
    component_separators = "",
    section_separators = "",
    disabled_filetypes = { "NvimTree" },
    theme = {
      normal = {
        a = { fg = "@black@", bg = "@green@", bold = true },
        b = { fg = "@white@", bg = "@darkgray@" },
        c = { fg = "@white@", bg = "@black@" },
      },
      insert = { a = { fg = "@black@", bg = "@blue@", bold = true } },
      visual = { a = { fg = "@black@", bg = "@magenta@", bold = true } },
      replace = { a = { fg = "@black@", bg = "@red@", bold = true } },
      inactive = {
        a = { fg = "@dimwhite@", bg = "@black@", bold = true },
        b = { fg = "@dimwhite@", bg = "@black@" },
        c = { fg = "@dimwhite@", bg = "@black@" },
      },
    },
  },
  sections = {
    lualine_b = {
      function()
        return vim.b.gitsigns_status or ""
      end,
    },
    lualine_c = {
      "filename",
      { "diagnostics", sources = { "nvim_diagnostic" } },
      { gps.get_location, condition = gps.is_available },
    },
  },
})

require("lsp_signature").setup({
  handler_opts = { border = border },
})

lspconfig.nil_ls.setup({
  capabilities = capabilities,
  cmd = { "@nil@/bin/nil" },
  on_attach = on_attach,
  settings = {
    ["nil"] = {
      formatting = {
        command = { "@nixpkgs_fmt@/bin/nixpkgs-fmt" },
      },
    },
  },
})

lspconfig.pylsp.setup({
  capabilities = capabilities,
  cmd = { "@python_lsp_server@/bin/pylsp" },
  on_attach = on_attach,
})

lspconfig.sumneko_lua.setup({
  capabilities = capabilities,
  cmd = { "@sumneko_lua_language_server@/bin/lua-language-server" },
  root_dir = function(file)
    return lspconfig.util.root_pattern("lua-globals", ".luacheckrc")(file)
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
      return
    end

    local lcrc = loadfile(new_root_dir .. "/.luacheckrc", "t", {})
    if lcrc then
      local function read_config(cfg)
        local function add_globals(globals)
          if globals then
            for _, global in pairs(globals) do
              table.insert(new_config.settings.Lua.diagnostics.globals, global)
            end
          end
        end

        add_globals(cfg.globals)
        add_globals(cfg.new_globals)
        add_globals(cfg.new_read_globals)
        add_globals(cfg.read_globals)
      end

      local lc = {}
      setfenv(lcrc, lc)
      lcrc()

      read_config(lc)
      if lc.std then
        read_config(lc.std)
      end

      if lc.files then
        for _, cfg in lc.files do
          if cfg then
            read_config(cfg)
            if cfg.std then
              read_config(cfg.std)
            end
          end
        end
      end
    end
  end,
  on_attach = function(c, buf)
    on_attach(c, buf)
    c.server_capabilities.documentFormattingProvider = false
    c.server_capabilities.documentRangeFormattingProvider = false
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
  cmd = { "@taplo@/bin/taplo", "lsp", "stdio" },
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

require("notify").setup({ stages = "static" })

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
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
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
          action = "system_open",
        },
        {
          key = "s",
          cb = function()
            require("lightspeed").sx:go({})
          end,
        },
      },
    },
  },
})

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
  custom_parser = function(node)
    local text = treesitter.query.get_node_text(node, 0, { concat = false })[1]
    if text and #text > 3 then
      local start_row, _, end_row, _ = treesitter.get_node_range(node)
      return end_row - start_row > 6 and "<- " .. text or nil
    end
  end,
})

rust_tools.setup({
  dap = {
    adapter = require("rust-tools.dap").get_codelldb_adapter(
      "@vscode_lldb@/adapter/codelldb",
      "@vscode_lldb@/lldb/lib/liblldb.so"
    ),
  },
  server = {
    capabilities = capabilities,
    cmd = { "@rust_analyzer@/bin/rust-analyzer" },
    on_attach = function(c, buf)
      on_attach(c, buf)
      vim.keymap.set(
        "n",
        "K",
        rust_tools.hover_actions.hover_actions,
        { buffer = buf }
      )
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

trouble.setup()
