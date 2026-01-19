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
      "    flake-parts = {",
      '      url = "github:hercules-ci/flake-parts";',
      '      inputs.nixpkgs-lib.follows = "nixpkgs";',
      "    };",
      '    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";',
      "  };",
      "",
      "  outputs =",
      "    inputs@{ flake-parts, ... }:",
      "    flake-parts.lib.mkFlake { inherit inputs; } {",
      "      systems = [",
      '        "aarch64-darwin"',
      '        "aarch64-linux"',
      '        "x86_64-darwin"',
      '        "x86_64-linux"',
      "      ];",
      "",
      "      perSystem =",
      "        { pkgs, ... }:",
      "        let",
      "          inherit (pkgs)",
      "            mkShell",
      "            ;",
      "        in",
      "        {",
      "          devShells.default = mkShell {",
      "            packages = [ ",
    }),
    i(0),
    t({
      " ];",
      "          };",
      "        };",
      "    };",
      "}",
    }),
  }, {
    show_condition = function()
      return fn.expand("%:t") == "flake.nix" and fn.line(".") == 1
    end,
  }),
})
