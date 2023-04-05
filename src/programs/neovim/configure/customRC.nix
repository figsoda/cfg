{ inputs, lib, config, pkgs, root, super }:

let
  inherit (lib) mapAttrs' nameValuePair;

  jdk = pkgs.openjdk17;
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
      inherit jdk nix;
      inherit (inputs) nixpkgs;
      inherit (pkgs) cargo-edit cargo-play;
      inherit (root.pkgs) rust;
    }
  }

  luafile ${
    substitutePackages ./plugins.lua (root.colors // {
      inherit jdk;
      inherit (pkgs)
        isort jdt-language-server lua-language-server nil nixpkgs-fmt shellcheck
        statix stylua taplo yaml-language-server xdg-utils;
      inherit (pkgs.nodePackages) prettier pyright vim-language-server;

      black-py = pkgs.black;

      jdtls-bundles = let jars = ext:
        "${codeExt "vscjava" ext}/server/*.jar";
      in pkgs.runCommand "jdtls-bundles" { } ''
        for jar in ${jars "vscode-java-debug"} ${jars "vscode-java-test"}; do
          echo "$jar" >> $out
        done
      '';

      jdtls-format = pkgs.writeText "jdtls-format.xml" ''
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <profile kind="CodeFormatterProfile">
          <setting id="org.eclipse.jdt.core.formatter.continuation_indentation" value="1"/>
          <setting id="org.eclipse.jdt.core.formatter.continuation_indentation_for_array_initializer" value="1"/>
          <setting id="org.eclipse.jdt.core.formatter.join_wrapped_lines" value="false"/>
          <setting id="org.eclipse.jdt.core.formatter.lineSplit" value="80"/>
          <setting id="org.eclipse.jdt.core.formatter.parentheses_positions_in_method_delcaration" value="separate_lines_if_wrapped"/>
          <setting id="org.eclipse.jdt.core.formatter.tabulation.char" value="space"/>
        </profile>
      '';

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
