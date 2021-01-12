{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        colorscheme onedark
        filetype plugin indent on
        syntax enable

        set completeopt=menuone,noinsert,noselect
        set cursorline
        set expandtab
        set laststatus=0
        set list
        set listchars=tab:-->,trail:+,extends:>,precedes:<,nbsp:·
        set mouse=a
        set nofoldenable
        set noshowmode
        set number
        set relativenumber
        set scrolloff=2
        set shiftwidth=4
        set shortmess+=c
        set showtabline=2
        set signcolumn=yes
        set smartindent
        set splitbelow
        set splitright
        set termguicolors
        set timeoutlen=400
        set title
        set updatetime=300

        let g:bufferline = { "animation": v:false }
        let g:Hexokinase_highlighters = ["backgroundfull"]
        let g:indentLine_char = "⎸"
        let g:lightline = { "colorscheme": "deus" }
        let g:nvim_tree_auto_open = 1
        let g:nvim_tree_ignore = [".git"]
        let g:onedark_terminal_italics = 1
        let g:vim_markdown_conceal = 0
        let g:vim_markdown_conceal_code_blocks = 0

        nn <c-h> <c-w>h
        nn <c-j> <c-w>j
        nn <c-k> <c-w>k
        nn <c-l> <c-w>l
        nn <m-h> :vertical :resize -2<cr>
        nn <m-j> :resize -2<cr>
        nn <m-k> :resize +2<cr>
        nn <m-l> :vertical :resize +2<cr>

        nn <c-s> :w<cr>
        nn <c-w> :w<cr>:BufferClose<cr>
        nn <tab> :BufferNext<cr>
        nn <m-tab> :BufferPick<cr>
        nn <s-tab> :BufferPrevious<cr>

        nn fc :BCommits!<cr>
        nn ff :GFiles!<cr>
        nn fg :GFiles!?<cr>
        nn fr :Rg!<cr>

        nn g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
        nn g] <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
        nn ga <cmd>lua vim.lsp.buf.code_action()<cr>
        nn gd <cmd>lua vim.lsp.buf.definition()<cr>
        nn gf <cmd>lua vim.lsp.buf.formatting()<cr>
        nn gk <cmd>lua vim.lsp.buf.hover()<cr>
        nn gr <cmd>lua vim.lsp.buf.rename()<cr>
        nn gt <cmd>lua vim.lsp.buf.type_definition()<cr>

        nn tt :NvimTreeToggle<cr>
        nn tr :NvimTreeRefresh<cr>

        nn <space>c :!cargo<space>
        nn <space>g :!git<space>
        nn <space>n :!nix<space>
        nn <space>t :12split term://${pkgs.fish}/bin/fish<cr>i

        vn < <gv
        vn > >gv

        ino <expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
        ino <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

        autocmd BufRead Cargo.toml call crates#toggle()
        autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
        autocmd BufEnter,BufWinEnter,TabEnter *.rs lua
        \ require("lsp_extensions").inlay_hints {
        \   prefix = "",
        \   highlight = "Comment",
        \   enabled = {"ChainingHint", "TypeHint"},
        \ }

        lua <<EOF
          local completion = require("completion")
          local lspconfig = require("lspconfig")

          lspconfig.rnix.setup {
            cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"},
            on_attach = completion.on_attach,
          }

          lspconfig.rust_analyzer.setup {
            cmd = {"${pkgs.rust-analyzer-nightly}/bin/rust-analyzer"},
            on_attach = completion.on_attach,
          }

          vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
              signs = true,
              update_in_insert = true,
              virtual_text = true,
            }
          )
        EOF
      '';
      packages.all.start = with pkgs.vimPlugins; [
        barbar-nvim
        completion-nvim
        fzf-vim
        indentLine
        lightline-vim
        lsp_extensions-nvim
        nvim-lspconfig
        nvim-tree-lua
        nvim-web-devicons
        onedark-vim
        plenary-nvim
        popup-nvim
        vim-commentary
        vim-hexokinase
        vim-lastplace
        vim-markdown
        vim-nix
        vim-signify
        vim-sneak
        vim-surround
        vim-toml
        vim-visual-multi
      ];
    };
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
  };
}
