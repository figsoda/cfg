{ config, lib, pkgs, ... }:

let
  substitutePackages = src: substitutions:
    pkgs.substituteAll ({ inherit src; } // lib.mapAttrs'
      (k: lib.nameValuePair (builtins.replaceStrings [ "-" ] [ "_" ] k))
      substitutions);
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
            inherit (config.passthru.inputs) nixpkgs;
            inherit (pkgs)
              cargo-edit cargo-play fd fish nixpkgs-fmt stylua util-linux;
            nix = config.nix.package;
          }
        }

        luafile ${./autopairs.lua}

        luafile ${
          substitutePackages ./init.lua {
            inherit (config.passthru) rust;
          }
        }

        luafile ${
          substitutePackages ./plugins.lua {
            inherit (pkgs)
              jdt-language-server openjdk17 rnix-lsp shellcheck stylua
              sumneko-lua-language-server taplo yaml-language-server;
            inherit (pkgs.nodePackages) prettier vim-language-server;
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
        crates-nvim
        cmp-buffer
        cmp-cmdline
        cmp-nvim-lsp
        cmp-nvim-lsp-document-symbol
        cmp-nvim-lua
        cmp-path
        cmp_luasnip
        comment-nvim
        editorconfig-nvim
        gitsigns-nvim
        indent-blankline-nvim
        lightspeed-nvim
        lsp_signature-nvim
        lspkind-nvim
        lualine-nvim
        luasnip
        null-ls-nvim
        numb-nvim
        nvim-cmp
        nvim-code-action-menu
        nvim-colorizer-lua
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
