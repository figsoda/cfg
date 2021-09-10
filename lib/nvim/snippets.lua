local luasnip = require("luasnip")
local c = luasnip.choice_node
local i = luasnip.insert_node
local r = require("luasnip.extras").rep
local s = luasnip.snippet
local t = luasnip.text_node

luasnip.snippets = {
  nix = {
    s("buildRustPackage", {
      t({
        "{ fetchFromGitHub, lib, rustPlatform }:",
        "",
        "rustPlatform.buildRustPackage rec {",
        '  pname = "',
      }),
      i(1),
      t({ '";', '  version = "' }),
      i(2),
      t({ '";', "", "  src = fetchFromGitHub {", '    owner = "' }),
      i(3),
      t({
        '";',
        "    repo = pname;",
        "    rev = ",
      }),
      c(4, { t('"v${version}"'), t("version") }),
      t({
        ";",
        '    sha256 = "";',
        "  };",
        "",
        '  cargoSha256 = "${lib.fakeSha256}";',
        "",
        "  meta = with lib; {",
        '    description = "";',
        '    homepage = "https://github.com/',
      }),
      r(3),
      t("/"),
      r(1),
      t({ '";', "    license = " }),
      i(5),
      t({ ";", "    maintainers = with maintainers; [ figsoda ];", "  };", "}" }),
    }, {
      condition = function()
        return vim.fn.line(".") == 1
      end,
    }),

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
      condition = function()
        return vim.fn.expand("%:t") == "flake.nix" and vim.fn.line(".") == 1
      end,
    }),

    s("mkDerivation", {
      t({
        "{ fetchFromGitHub, lib, stdenv }:",
        "",
        "stdenv.mkDerivation rec {",
        '  pname = "',
      }),
      i(1),
      t({ '";', '  version = "' }),
      i(2),
      t({ '";', "", "  src = fetchFromGitHub {", '    owner = "' }),
      i(3),
      t({
        '";',
        "    repo = pname;",
        "    rev = ",
      }),
      c(4, { t('"v${version}"'), t("version") }),
      t({
        ";",
        '    sha256 = "";',
        "  };",
        "",
        "  meta = with lib; {",
        '    description = "";',
        '    homepage = "https://github.com/',
      }),
      r(3),
      t("/"),
      r(1),
      t({ '";', "    license = " }),
      i(5),
      t({
        ";",
        "    platforms = platforms.all;",
        "    maintainers = with maintainers; [ figsoda ];",
        "  };",
        "}",
      }),
    }, {
      condition = function()
        return vim.fn.line(".") == 1
      end,
    }),
  },
}
