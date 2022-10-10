{ config, lib, pkgs, ... }:

let
  substitutePackages = src: substitutions:
    pkgs.substituteAll ({ inherit src; } // lib.mapAttrs'
      (k: lib.nameValuePair (builtins.replaceStrings [ "-" ] [ "_" ] k))
      substitutions);

  codeExt = pub: ext:
    "${pkgs.vscode-extensions.${pub}.${ext}}/share/vscode/extensions/${pub}.${ext}";
in

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        ${pkgs.callPackage ./colorscheme.nix { }}

        source ${
          substitutePackages ./init.vim {
            inherit (config.passthru) rust;
            inherit (pkgs) fd fish nixpkgs-fmt stylua util-linux;
          }
        }

        luafile ${./autopairs.lua}

        luafile ${
          substitutePackages ./init.lua {
            inherit (config.passthru) rust;
            inherit (config.passthru.inputs) nixpkgs;
            inherit (pkgs) cargo-edit cargo-play openjdk17;
            nix = config.nix.package;
          }
        }

        luafile ${
          substitutePackages ./plugins.lua {
            inherit (pkgs)
              jdt-language-server nil nixpkgs-fmt openjdk17 shellcheck stylua
              sumneko-lua-language-server taplo yaml-language-server;
            inherit (pkgs.nodePackages) prettier vim-language-server;

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

            python-lsp-server = (pkgs.python3.override {
              packageOverrides = _: super: {
                python-lsp-server = super.python-lsp-server.override {
                  withAutopep8 = false;
                  withFlake8 = false;
                  withMccabe = false;
                  withPyflakes = false;
                  withPylint = false;
                  withYapf = false;
                };
              };
            }).withPackages
              (ps: with ps; [ pyls-isort python-lsp-black python-lsp-server ]);

            rust-analyzer = pkgs.writers.writeBashBin "rust-analyzer" ''
              if ${config.nix.package}/bin/nix eval --raw .#devShell.x86_64-linux; then
                wrapper=(${config.nix.package}/bin/nix develop -c)
              fi
              "''${wrapper[@]}" ${pkgs.rust-analyzer-nightly}/bin/rust-analyzer
            '';

            vscode-lldb = codeExt "vadimcn" "vscode-lldb";
          }
        }

        luafile ${
          substitutePackages ./snippets.lua {
            nix = config.nix.package;
          }
        }
      '';
      packages.all.start = with pkgs.vimPlugins; [
        bufferline-nvim
        cmp-buffer
        cmp-cmdline
        cmp-dap
        cmp-nvim-lsp
        cmp-nvim-lsp-document-symbol
        cmp-nvim-lua
        cmp-path
        cmp_luasnip
        comment-nvim
        crates-nvim
        editorconfig-nvim
        gitsigns-nvim
        indent-blankline-nvim
        lightspeed-nvim
        lsp_signature-nvim
        lspkind-nvim
        lualine-nvim
        luasnip
        noice-nvim
        null-ls-nvim
        numb-nvim
        nvim-cmp
        nvim-code-action-menu
        nvim-colorizer-lua
        nvim-dap
        nvim-dap-ui
        nvim-gps
        nvim-jdtls
        nvim-lspconfig
        nvim-notify
        nvim-tree-lua
        (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
        nvim-treesitter-textobjects
        nvim-web-devicons
        nvim_context_vt
        plenary-nvim
        popup-nvim
        ron-vim
        rust-tools-nvim
        telescope-nvim
        telescope-fzf-native-nvim
        trouble-nvim
        vim-fugitive
        vim-lastplace
        vim-markdown
        vim-nix
        vim-visual-multi
      ];
    };
    viAlias = true;
    vimAlias = true;
    withRuby = false;
  };
}
