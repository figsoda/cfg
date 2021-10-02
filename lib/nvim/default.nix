{ config, lib, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        ${pkgs.callPackage ./colorscheme.nix { }}
        source ${
          pkgs.substituteAll {
            src = ./init.vim;
            inherit (config.passthru) rust;
            inherit (config.passthru.inputs) nixpkgs;
            inherit (pkgs) coreutils fd fish stylua;
            cargo_edit = pkgs.cargo-edit;
            cargo_play = pkgs.cargo-play;
            nix = config.nix.package;
            nixpkgs_fmt = pkgs.nixpkgs-fmt;
            util_linux = pkgs.util-linux;
          }
        }
        luafile ${
          pkgs.substituteAll {
            src = ./init.lua;
            inherit (pkgs) shellcheck stylua;
            inherit (pkgs.nodePackages) prettier;
            python_lsp_server = (pkgs.python3.override {
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
            rnix_lsp = pkgs.rnix-lsp;
            rust_analyzer = pkgs.writeShellScriptBin "rust-analyzer" ''
              wrapper=()
              if ${config.nix.package}/bin/nix eval --raw .#devShell.x86_64-linux; then
                wrapper=(${config.nix.package}/bin/nix develop -c)
              fi
              "''${wrapper[@]}" ${pkgs.rust-analyzer-nightly}/bin/rust-analyzer
            '';
            sumneko_lua_language_server = pkgs.sumneko-lua-language-server;
            taplo_lsp = pkgs.taplo-lsp;
            vim_language_server = pkgs.nodePackages.vim-language-server;
            yaml_language_server = pkgs.yaml-language-server;
          }
        }
        luafile ${./autopairs.lua}
        luafile ${
          pkgs.substituteAll {
            src = ./snippets.lua;
            nix = config.nix.package;
          }
        }
      '';
      packages.all.start = with pkgs.vimPlugins; [
        bufferline-nvim
        crates-nvim
        cmp-buffer
        cmp-nvim-lsp
        cmp-nvim-lua
        cmp-path
        cmp_luasnip
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
        nvim-colorizer-lua
        nvim-gps
        nvim-lspconfig
        nvim-notify
        nvim-tree-lua
        (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
        nvim-treesitter-textobjects
        nvim-web-devicons
        nvim_context_vt
        plenary-nvim
        popup-nvim
        rust-tools-nvim
        telescope-nvim
        telescope-fzf-native-nvim
        trouble-nvim
        vim-commentary
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
