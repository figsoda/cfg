{ pkgs }:

{
  all.start = with pkgs.vimPlugins; [
    bufferline-nvim
    cmp-buffer
    cmp-cmdline
    cmp-dap
    cmp-nvim-lsp
    cmp-nvim-lsp-document-symbol
    cmp-path
    cmp_luasnip
    comment-nvim
    crates-nvim
    dressing-nvim
    editorconfig-nvim
    gitsigns-nvim
    indent-blankline-nvim
    leap-nvim
    lspkind-nvim
    lualine-nvim
    luasnip
    neo-tree-nvim
    nix-develop-nvim
    noice-nvim
    null-ls-nvim
    numb-nvim
    nvim-cmp
    nvim-colorizer-lua
    nvim-dap
    nvim-dap-ui
    nvim-jdtls
    nvim-lspconfig
    nvim-navic
    nvim-notify
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
    nvim-web-devicons
    nvim_context_vt
    playground
    refactoring-nvim
    ron-vim
    rust-tools-nvim
    telescope-fzf-native-nvim
    telescope-nvim
    trouble-nvim
    vim-fugitive
    vim-lastplace
    vim-visual-multi
  ];
}
