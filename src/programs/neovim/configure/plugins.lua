local cmp = require("cmp")
local leap = require("leap")
local lspconfig = require("lspconfig")
local luasnip = require("luasnip")
local navic = require("nvim-navic")
local neo_tree = require("neo-tree")
local null_ls = require("null-ls")
local nb = null_ls.builtins
local rust_tools = require("rust-tools")
local telescope = require("telescope")
local trouble = require("trouble")

local api = vim.api
local diagnostic = vim.diagnostic
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
    border = "single",
    override = function(cfg)
      cfg.anchor = "NW"
      return cfg
    end,
    win_options = {
      winblend = 0,
      winhighlight = "FloatBorder:DiagnosticInfo,NormalFloat:Normal",
    },
  },
  select = {
    backend = { "builtin" },
    builtin = {
      border = "single",
      min_height = { 0, 0 },
      min_width = { 0, 0 },
      relative = "cursor",
      win_options = {
        winblend = 0,
        winhighlight = "FloatBorder:DiagnosticInfo,NormalFloat:Normal",
      },
    },
  },
})

require("gitsigns").setup({
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

require("ibl").setup({
  indent = {
    char = "▏",
  },
})

leap.opts.special_keys = {
  next_phase_one_target = "]",
  next_target = "]",
  prev_target = "[",
  next_group = "]",
  prev_group = "[",
}
leap.add_default_mappings()

require("lualine").setup({
  options = {
    component_separators = "",
    section_separators = "",
    disabled_filetypes = { "neo-tree" },
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

lspconfig.clangd.setup({
  capabilities = capabilities,
  cmd = { "@clang_tools@/bin/clangd" },
  on_attach = on_attach,
})

lspconfig.dafny.setup({
  capabilities = capabilities,
  cmd = { "@dafny@/bin/dafny", "server" },
  on_attach = on_attach,
})

lspconfig.emmet_ls.setup({
  capabilities = capabilities,
  cmd = { "@emmet_ls@/bin/emmet-ls", "--stdio" },
  on_attach = on_attach,
})

lspconfig.cssls.setup({
  capabilities = capabilities,
  cmd = {
    "@vscode_langservers_extracted@/bin/vscode-css-language-server",
    "--stdio",
  },
  on_attach = on_attach,
})

lspconfig.eslint.setup({
  capabilities = capabilities,
  cmd = {
    "@vscode_langservers_extracted@/bin/vscode-eslint-language-server",
    "--stdio",
  },
  on_attach = on_attach,
})

lspconfig.jsonls.setup({
  capabilities = capabilities,
  cmd = {
    "@vscode_langservers_extracted@/bin/vscode-json-language-server",
    "--stdio",
  },
  on_attach = on_attach,
})

lspconfig.html.setup({
  capabilities = capabilities,
  cmd = {
    "@vscode_langservers_extracted@/bin/vscode-html-language-server",
    "--stdio",
  },
  on_attach = on_attach,
})

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  cmd = { "@lua_language_server@/bin/lua-language-server" },
  on_new_config = function(config, root_dir)
    local function load_lua_paths()
      config.settings.Lua.workspace.library = { "@lua_paths@" }
    end

    local function load_luarc(path)
      local file = io.open(root_dir .. "/" .. path)
      if not file then
        return false
      end

      local luarc = vim.json.decode(file:read("*a"))
      local lua = luarc.Lua or luarc
      local diagnostics = lua and lua.diagnostics or luarc["Lua.diagnostics"]
      local globals = diagnostics and diagnostics.globals
        or lua and lua["diagnostics.globals"]
        or luarc["Lua.diagnostics.globals"]

      if globals and vim.tbl_contains(globals, "vim") then
        load_lua_paths()
      end
      return true
    end

    config.settings.Lua.workspace.library = {}
    config.settings.Lua.diagnostics.globals = {}

    if load_luarc(".luarc.json") or load_luarc(".luarc.jsonc") then
      return
    end

    local lcrc = loadfile(root_dir .. "/.luacheckrc", "t", {})
    if lcrc then
      local found_vim = false

      local function read_config(cfg)
        local function add_globals(globals)
          if globals then
            for _, global in pairs(globals) do
              table.insert(config.settings.Lua.diagnostics.globals, global)
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
      completion = {
        callSnippet = "Replace",
        postfix = ".",
      },
      diagnostics = {
        disable = { "lowercase-global", "redefined-local" },
        groupSeverity = {
          unused = "Warning",
        },
        libraryFiles = "Disable",
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

lspconfig.nil_ls.setup({
  capabilities = capabilities,
  cmd = { "@nil@/bin/nil" },
  on_attach = on_attach,
  settings = {
    ["nil"] = {
      formatting = {
        command = { "@nixpkgs_fmt@/bin/nixpkgs-fmt" },
      },
      nix = {
        flake = {
          autoArchive = true,
          autoEvalImports = true,
        },
      },
    },
  },
})

lspconfig.ocamllsp.setup({
  capabilities = capabilities,
  cmd = { "@ocaml_lsp@/bin/ocamllsp" },
  on_attach = on_attach,
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

lspconfig.taplo.setup({
  capabilities = capabilities,
  cmd = { "@taplo@/bin/taplo", "lsp", "stdio" },
  on_attach = on_attach,
})

lspconfig.tsserver.setup({
  capabilities = capabilities,
  cmd = {
    "@typescript_language_server@/bin/typescript-language-server",
    "--stdio",
  },
  on_attach = function(c, buf)
    on_attach(c, buf)
    c.server_capabilities.documentFormattingProvider = false
    c.server_capabilities.documentRangeFormattingProvider = false
  end,
})

lspconfig.typst_lsp.setup({
  capabilities = capabilities,
  cmd = { "@typst_lsp@/bin/typst-lsp" },
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

lspconfig.zls.setup({
  capabilities = capabilities,
  cmd = { "@zls@/bin/zls" },
  on_attach = on_attach,
  settings = {
    enable_autofix = false,
  },
})

luasnip.config.setup({
  region_check_events = "InsertEnter",
})

neo_tree.setup({
  default_component_configs = {
    icon = {
      default = "",
    },
  },
  event_handlers = {
    {
      event = "file_opened",
      handler = function()
        require("neo-tree.command").execute({ action = "close" })
      end,
    },
  },
  filesystem = {
    commands = {
      system_open = function(state)
        local path = state.tree:get_node():get_id()
        vim.loop.spawn(
          "@xdg_utils@/bin/xdg-open",
          { args = { path } },
          function(code)
            if code ~= 0 then
              vim.notify(
                "xdg-open " .. path .. " exited with code " .. code,
                vim.log.levels.WARN
              )
            end
          end
        )
      end,
    },
    filtered_items = {
      hide_by_name = { ".git" },
      hide_dotfiles = false,
      show_hidden_count = false,
      use_libuv_file_watcher = true,
    },
    find_by_full_path_words = true,
    window = {
      mappings = {
        ["<c-_>"] = "clear_filter",
      },
    },
  },
  popup_border_style = "single",
  use_popups_for_input = false,
  window = {
    width = 32,
    mappings = {
      S = "noop",
      ["<c-v>"] = "open_vsplit",
      ["<c-x>"] = "open_split",
      ["<cr>"] = "open_drop",
      o = "system_open",
      s = "noop",
      t = "noop",
    },
  },
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
    nb.formatting.prettier.with({
      command = "@prettier@/bin/prettier",
      disabled_filetypes = { "html" },
    }),
    nb.formatting.stylua.with({ command = "@stylua@/bin/stylua" }),
  },
})

require("numb").setup()

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  playground = {
    enable = true,
  },
  query_linter = {
    enable = true,
  },
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
    local text = treesitter.get_node_text(node, 0, { concat = false })[1]
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
