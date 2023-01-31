local luasnip = require("luasnip")
local i = luasnip.insert_node
local s = luasnip.snippet
local t = luasnip.text_node

local fn = vim.fn
luasnip.add_snippets("nix", {
  s("flake", {
    t({
      "{",
      "  inputs = {",
      '    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";',
      "  };",
      "",
      "  outputs = { self, nixpkgs }: {",
      "    ",
    }),
    i(0),
    t({ "", "  };", "}" }),
  }, {
    show_condition = function()
      return fn.expand("%:t") == "flake.nix" and fn.line(".") == 1
    end,
  }),
})
