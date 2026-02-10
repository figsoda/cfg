local cmp = require("cmp")
local leap = require("leap")
local luasnip = require("luasnip")
local neo_tree = require("neo-tree")
local null_ls = require("null-ls")
local nb = null_ls.builtins
local telescope = require("telescope")
local trouble = require("trouble")

local api = vim.api
local diagnostic = vim.diagnostic
local lsp = vim.lsp

local border = { "", "", "", " ", "", "", "", " " }

local function on_attach(_, buf)
  local function mapb(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = buf })
  end

  mapb("n", " e", function()
    trouble.open("diagnostics")
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

  lsp.inlay_hint.enable(true, { bufnr = buf })
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
    fields = { "abbr", "icon", "menu" },
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
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")

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
    },
  },
})

lsp.config["*"] = {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  on_attach = on_attach,
}

lsp.config.bashls = {
  cmd = { "@bash_language_server@/bin/bash-language-server", "start" },
  settings = {
    bashIde = {
      shellcheckPath = "@shellcheck@/bin/shellcheck",
      shfmt = {
        path = "@shfmt@/bin/shfmt",
      },
    },
  },
}

lsp.config.clangd = {
  cmd = { "@clang_tools@/bin/clangd" },
}

lsp.config.cssls = {
  cmd = {
    "@vscode_langservers_extracted@/bin/vscode-css-language-server",
    "--stdio",
  },
}

lsp.config.dafny = {
  cmd = { "@dafny@/bin/dafny", "server" },
}

lsp.config.emmet_ls = {
  cmd = { "@emmet_language_server@/bin/emmet-language-server", "--stdio" },
}

lsp.config.eslint = {
  cmd = {
    "@vscode_langservers_extracted@/bin/vscode-eslint-language-server",
    "--stdio",
  },
}

lsp.config.html = {
  cmd = {
    "@vscode_langservers_extracted@/bin/vscode-html-language-server",
    "--stdio",
  },
}

lsp.config.jsonls = {
  cmd = {
    "@vscode_langservers_extracted@/bin/vscode-json-language-server",
    "--stdio",
  },
}

lsp.config.lua_ls = {
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
}

lsp.config.nil_ls = {
  cmd = { "@nil@/bin/nil" },
  settings = {
    ["nil"] = {
      nix = {
        flake = {
          autoArchive = true,
          autoEvalImports = true,
        },
      },
    },
  },
}

lsp.config.ocamllsp = {
  cmd = { "@ocaml_lsp@/bin/ocamllsp" },
}

lsp.config.ruff = {
  cmd = { "@ruff@/bin/ruff", "server" },
  on_attach = function(c, buf)
    on_attach(c, buf)
    c.server_capabilities.hoverProvider = false
  end,
}

lsp.config.taplo = {
  cmd = { "@taplo@/bin/taplo", "lsp", "stdio" },
}

lsp.config.tinymist = {
  cmd = { "@tinymist@/bin/tinymist" },
}

lsp.config.ts_ls = {
  cmd = {
    "@typescript_language_server@/bin/typescript-language-server",
    "--stdio",
  },
  on_attach = function(c, buf)
    on_attach(c, buf)
    c.server_capabilities.documentFormattingProvider = false
    c.server_capabilities.documentRangeFormattingProvider = false
  end,
}

lsp.config.ty = {
  cmd = { "@ty@/bin/ty", "server" },
}

lsp.config.vimls = {
  cmd = { "@vim_language_server@/bin/vim-language-server", "--stdio" },
}

lsp.config.yamlls = {
  cmd = { "@yaml_language_server@/bin/yaml-language-server", "--stdio" },
}

lsp.config.zls = {
  cmd = { "@zls@/bin/zls" },
  settings = {
    enable_autofix = false,
  },
}

lsp.enable({
  "bashls",
  "clangd",
  "cssls",
  "dafny",
  "emmet_ls",
  "eslint",
  "hls",
  "html",
  "jsonls",
  "lua_ls",
  "nil_ls",
  "ocamllsp",
  "racket_langserver",
  "ruff",
  "taplo",
  "tinymist",
  "ts_ls",
  "ty",
  "vimls",
  "yamlls",
  "zls",
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
    nb.diagnostics.statix.with({ command = "@statix@/bin/statix" }),
    nb.formatting.prettier.with({
      command = "@prettier@/bin/prettier",
      disabled_filetypes = { "html" },
    }),
    nb.formatting.stylua.with({ command = "@stylua@/bin/stylua" }),
    nb.formatting.typstyle.with({ command = "@typstyle@/bin/typstyle" }),
  },
})

require("numb").setup()

require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
  },
})

require("nvim_context_vt").setup({
  min_rows = 6,
  prefix = "",
  custom_validator = function(node, ft, opts)
    local utils = require("nvim_context_vt.utils")
    return utils.default_validator(node, ft, opts)
      and #utils.get_node_text(node)[1] > 3
  end,
})

vim.g.rustaceanvim = {
  dap = {
    adapter = require("rustaceanvim.config").get_codelldb_adapter(
      "@vscode_lldb@/adapter/codelldb",
      "@vscode_lldb@/lldb/lib/liblldb.so"
    ),
  },
  server = {
    cmd = { "@rust_analyzer@/bin/rust-analyzer" },
    on_attach = function(c, buf)
      on_attach(c, buf)
      vim.keymap.set("n", "K", function()
        vim.cmd.RustLsp({ "hover", "actions" })
      end, { buffer = buf })
    end,
    settings = {
      ["rust-analyzer"] = {
        assist = { importPrefix = "by_crate" },
        checkOnSave = { command = "clippy" },
        inlayHints = {
          closingBraceHints = { enable = false },
          parameterHints = {
            missingArguments = { enable = true },
          },
        },
      },
    },
  },
  tools = {
    float_win_config = { border = border },
  },
}

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
        ["<c-s>"] = require("trouble.sources.telescope").open,
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

require("typst-preview").setup({
  invert_colors = "always",
  open_cmd = "firefox --new-window %s",
})
