local cmp = require("cmp")
local jdtls = require("jdtls")
local leap = require("leap")
local lspconfig = require("lspconfig")
local luasnip = require("luasnip")
local navic = require("nvim-navic")
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
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function on_attach(c, buf)
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
  mapb("n", "gd", function()
    trouble.open("lsp_definitions")
  end)
  mapb("n", "ge", function()
    diagnostic.open_float(0, { scope = "cursor" })
  end)
  mapb("n", "gr", lsp.buf.rename)
  mapb("n", "gt", function()
    trouble.open("lsp_type_definitions")
  end)
  mapb({ "n", "v" }, "ff", function()
    lsp.buf.format({ async = true, bufnr = buf })
  end)
  mapb({ "n", "v" }, "ga", lsp.buf.code_action)

  if c.server_capabilities.documentSymbolProvider then
    navic.attach(c, buf)
  end
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
      return api.nvim_buf_get_name(n) ~= ""
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

require("colorizer").setup({
  user_default_options = {
    css = true,
  },
})

require("Comment").setup({ ignore = "^$" })

require("crates").setup()

require("dapui").setup()

require("dressing").setup({
  input = {
    anchor = "NW",
    border = "single",
    winblend = 0,
    winhighlight = "FloatBorder:DiagnosticInfo,NormalFloat:Normal",
  },
  select = {
    backend = { "builtin" },
    builtin = {
      border = "single",
      min_height = { 0, 0 },
      min_width = { 0, 0 },
      relative = "cursor",
      winblend = 0,
      winhighlight = "FloatBorder:DiagnosticInfo,NormalFloat:Normal",
    },
  },
})

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
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-17",
                path = "@openjdk17@/lib/openjdk",
              },
            },
          },
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

leap.setup({
  special_keys = {
    next_phase_one_target = "]",
    next_target = "]",
    prev_target = "[",
    next_group = "]",
    prev_group = "[",
  },
})
leap.add_default_mappings()

require("lualine").setup({
  options = {
    component_separators = "",
    section_separators = "",
    disabled_filetypes = { "NvimTree" },
    theme = {
      normal = {
        a = { fg = "@black@", bg = "@green@", bold = true },
        b = { fg = "@white@", bg = "@dimgray@" },
        c = { fg = "@white@", bg = "@black@" },
      },
      insert = { a = { fg = "@black@", bg = "@blue@", bold = true } },
      visual = { a = { fg = "@black@", bg = "@magenta@", bold = true } },
      replace = { a = { fg = "@black@", bg = "@red@", bold = true } },
      inactive = {
        a = { fg = "@lightgray@", bg = "@black@", bold = true },
        b = { fg = "@lightgray@", bg = "@black@" },
        c = { fg = "@lightgray@", bg = "@black@" },
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
      { navic.get_location, cond = navic.is_available },
    },
  },
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

lspconfig.pyright.setup({
  capabilities = capabilities,
  cmd = { "@pyright@/bin/pyright-langserver", "--stdio" },
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        diagnosticSeverityOverrides = {
          reportMissingModuleSource = "none",
        },
        useLibraryCodeForTypes = true,
      },
    },
  },
})

lspconfig.sumneko_lua.setup({
  capabilities = capabilities,
  cmd = { "@sumneko_lua_language_server@/bin/lua-language-server" },
  on_new_config = function(new_config, new_root_dir)
    local function load_lua_paths()
      new_config.settings.Lua.workspace.library = { "@lua_paths@" }
    end

    local function load_luarc(path)
      local file = io.open(new_root_dir .. "/" .. path)
      if not file then
        return false
      end

      local luarc = vim.json.decode(file:read("*a"))
      local lua = luarc.Lua
      local diagnostics = lua and lua.diagnostics or luarc["Lua.diagnostics"]
      local globals = diagnostics and diagnostics.globals
        or lua and lua["diagnostics.globals"]
        or luarc["Lua.diagnostics.globals"]

      if globals and vim.tbl_contains(globals, "vim") then
        load_lua_paths()
      end
      return true
    end

    if load_luarc(".luarc.json") or load_luarc(".luarc.jsonc") then
      return
    end

    local lcrc = loadfile(new_root_dir .. "/.luacheckrc", "t", {})
    if lcrc then
      local found_vim = false

      local function read_config(cfg)
        local function add_globals(globals)
          if globals then
            for _, global in pairs(globals) do
              table.insert(new_config.settings.Lua.diagnostics.globals, global)
              if global == "vim" then
                found_vim = true
              end
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

      if found_vim then
        load_lua_paths()
      end
    end
  end,

  on_attach = on_attach,

  settings = {
    Lua = {
      diagnostics = {
        disable = { "lowercase-global", "redefined-local" },
        globals = {},
      },
      format = {
        enable = false,
      },
      runtime = {
        pathStrict = true,
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
      },
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

null_ls.setup({
  on_attach = on_attach,
  sources = {
    nb.code_actions.refactoring,
    nb.code_actions.statix.with({ command = "@statix@/bin/statix" }),
    nb.diagnostics.shellcheck.with({ command = "@shellcheck@/bin/shellcheck" }),
    nb.diagnostics.statix.with({ command = "@statix@/bin/statix" }),
    nb.formatting.black.with({ command = "@black_py@/bin/black" }),
    nb.formatting.isort.with({ command = "@isort@/bin/isort" }),
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
            leap.leap({})
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

trouble.setup({
  auto_jump = {
    "lsp_definitions",
    "lsp_type_definitions",
  },
})
