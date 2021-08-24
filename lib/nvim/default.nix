{ config, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        source ${
          pkgs.substituteAll rec {
            src = ./init.vim;
            inherit (config.passthru) rust;
            inherit (pkgs) coreutils fd fish nixfmt stylua;
            cargo_edit = pkgs.cargo-edit;
            cargo_play = pkgs.cargo-play;
            nix = config.nix.package;
            nixpkgs = config.nix.registry.nixpkgs.flake;
            util_linux = pkgs.util-linux;
            colorscheme = pkgs.callPackage ./colorscheme.nix { };
          }
        }
        luafile ${
          pkgs.substituteAll {
            src = ./init.lua;
            inherit (pkgs) nixfmt shellcheck stylua;
            inherit (pkgs.nodePackages) prettier;
            python_lsp_server = pkgs.python3.withPackages (ps:
              with ps; [
                pyls-isort
                python-lsp-black
                python-lsp-server
              ]);
            rnix_lsp = pkgs.rnix-lsp;
            rust_analyzer = pkgs.writeShellScriptBin "rust-analyzer" ''
              wrapper=()
              if ${config.nix.package}/bin/nix eval --raw .#devShell.x86_64-linux; then
                wrapper=(${config.nix.package}/bin/nix develop -c)
              fi
              "''${wrapper[@]}" ${pkgs.rust-analyzer-nightly}/bin/rust-analyzer
            '';
            sumneko_lua_language_server = pkgs.sumneko-lua-language-server;
            vim_language_server = pkgs.nodePackages.vim-language-server;
            yaml_language_server = pkgs.yaml-language-server;
          }
        }
        luafile ${./autopairs.lua}
        ${pkgs.callPackage ./colorscheme.nix { }}
      '';
      packages.all.start = with pkgs.vimPlugins; [
        cmp-buffer
        cmp-nvim-lsp
        cmp-nvim-lua
        cmp-path
        fzf-vim
        gitsigns-nvim
        indent-blankline-nvim
        lightspeed-nvim
        lsp_signature-nvim
        lspkind-nvim
        lualine-nvim
        luasnip
        null-ls-nvim
        numb-nvim
        nvim-bufferline-lua
        nvim-cmp
        nvim-colorizer-lua
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
