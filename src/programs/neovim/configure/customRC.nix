{ inputs, lib, config, pkgs, root, super }:

let
  inherit (lib) mapAttrs' nameValuePair;

  nix = config.nix.package;

  substitutePackages = src: substitutions:
    pkgs.substituteAll ({ inherit src; } // mapAttrs'
      (k: nameValuePair (builtins.replaceStrings [ "-" ] [ "_" ] k))
      substitutions);

  codeExt = pub: ext:
    "${pkgs.vscode-extensions.${pub}.${ext}}/share/vscode/extensions/${pub}.${ext}";
in

''
  ${super.colorscheme}

  luafile ${./before.lua}

  source ${
    substitutePackages ./init.vim {
      inherit (root.pkgs) rust;
      inherit (pkgs) fd fish nixpkgs-fmt stylua util-linux;
    }
  }

  luafile ${./autopairs.lua}

  luafile ${
    substitutePackages ./init.lua {
      inherit nix;
      inherit (inputs) nixpkgs;
      inherit (pkgs) cargo-edit dafny stack;
      inherit (root.pkgs) rust;
    }
  }

  luafile ${
    substitutePackages ./plugins.lua (root.colors // {
      inherit (pkgs)
        clang-tools
        dafny
        emmet-ls
        isort
        lua-language-server
        nil
        nixpkgs-fmt
        pyright
        shellcheck
        statix
        stylua
        taplo
        typst-lsp
        vscode-langservers-extracted
        xdg-utils
        yaml-language-server
        zls
        ;
      inherit (pkgs.nodePackages)
        prettier
        typescript-language-server
        vim-language-server
        ;
      inherit (pkgs.ocamlPackages) ocaml-lsp;

      black-py = pkgs.black;

      lua-paths =
        let
          inherit (config.programs.neovim) configure package;
        in
        lib.concatMapStringsSep ''", "'' (path: "${path}/lua")
          ([ "${package}/share/nvim/runtime" ] ++ configure.packages.all.start);

      rust-analyzer = pkgs.rust-analyzer-nightly;

      vscode-lldb = codeExt "vadimcn" "vscode-lldb";
    })
  }

  luafile ${
    substitutePackages ./snippets.lua {
      inherit nix;
    }
  }
''
