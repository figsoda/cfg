{ config, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = builtins.readFile (pkgs.substituteAll {
        src = ./init.vim;
        inherit (config.passthru) rust;
        inherit (pkgs) coreutils fd fish nixfmt;
        cargo_play = pkgs.cargo-play;
        nix = config.nix.package;
        nixpkgs = config.nix.registry.nixpkgs.flake;
        util_linux = pkgs.util-linux;
        colorscheme = pkgs.callPackage ./colorscheme.nix { };
        init_lua = pkgs.substituteAll {
          src = ./init.lua;
          inherit (pkgs) black shellcheck stylua;
          inherit (pkgs.nodePackages) prettier;
          rnix_lsp = pkgs.rnix-lsp;
          yaml_language_server = pkgs.yaml-language-server;
          rust_analyzer = pkgs.rust-analyzer-nightly;
        };
      });
      packages.all.start = with pkgs.vimPlugins; [
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
        nvim-colorizer-lua
        nvim-compe
        nvim-lspconfig
        nvim-tree-lua
        (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
        nvim-treesitter-textobjects
        nvim-web-devicons
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
