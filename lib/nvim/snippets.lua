local luasnip = require("luasnip")
local c = luasnip.choice_node
local f = luasnip.function_node
local i = luasnip.insert_node
local r = require("luasnip.extras").rep
local s = luasnip.snippet
local t = luasnip.text_node

local function fetch_sha256(args)
  local repo = args[1][1]
  local version = args[2][1]
  local owner = args[3][1]
  local rev = args[4][1]

  if repo == "" or version == "" or owner == "" then
    return ""
  end

  if rev == '"v${version}"' then
    rev = "v" .. version
  elseif rev == "version" then
    rev = version
  else
    return ""
  end

  local res = vim.fn.systemlist(
    string.format(
      "@nix@/bin/nix-prefetch-url --unpack https://github.com/%s/%s/archive/%s.tar.gz 2>/dev/null",
      owner,
      repo,
      rev
    )
  )

  return vim.v.shell_error == 0 and res[1] or ""
end

luasnip.snippets = {
  nix = {
    s("buildRustPackage", {
      t({
        "{ lib, rustPlatform, fetchFromGitHub }:",
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
      t({ ";", '    sha256 = "' }),
      f(fetch_sha256, { 1, 2, 3, 4 }),
      t({
        '";',
        "  };",
        "",
        '  cargoSha256 = "";',
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
        "    maintainers = with maintainers; [ figsoda ];",
        "  };",
        "}",
      }),
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
        "{ lib, stdenv, fetchFromGitHub }:",
        "",
        "stdenv.mkDerivation rec {",
        '  pname = "',
      }),
      i(1),
      t({ '";', '  version = "' }),
      i(2),
      t({ '";', "", "  src = fetchFromGitHub {", '    owner = "' }),
      i(3),
      t({ '";', "    repo = pname;", "    rev = " }),
      c(4, { t('"v${version}"'), t("version") }),
      t({ ";", '    sha256 = "' }),
      f(fetch_sha256, { 1, 2, 3, 4 }),
      t({
        '";',
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
