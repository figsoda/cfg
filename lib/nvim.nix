{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        set clipboard+=unnamedplus
        set completeopt=menuone,noinsert,noselect
        set cursorline
        set expandtab
        set list
        set listchars=tab:-->,trail:+,extends:>,precedes:<,nbsp:·
        set mouse=a
        set nofoldenable
        set noshowmode
        set noswapfile
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

        let g:bufferline = #{ animation: v:false }
        let g:Hexokinase_highlighters = ["backgroundfull"]
        let g:indentLine_char = "⎸"
        let g:lightline = #{ colorscheme: "onedark" }
        let g:nvim_tree_auto_open = 1
        let g:nvim_tree_icons = #{ default: "" }
        let g:nvim_tree_ignore = [".git"]
        let g:nvim_tree_width = 24
        let g:onedark_color_overrides = #{
        \ black: #{gui: "#1f2227", cterm: "234", cterm16: "0"},
        \ cursor_grey: #{gui: "#282c34", cterm: "235", cterm16: "8"},
        \ visual_grey: #{gui: "#2c323c", cterm: "236", cterm16: "8"},
        \ menu_grey: #{gui: "#2c323c", cterm: "236", cterm16: "8"},
        \ }
        let g:onedark_terminal_italics = 1
        let g:vim_markdown_conceal = 0
        let g:vim_markdown_conceal_code_blocks = 0

        function Close()
          let win = winnr("$")
          if win == 1 || win == 2 && bufnr("NvimTree") != -1
            :BufferClose
          else
            :quit
          end
        endf

        no <c-s> <cmd>write<cr>
        no <c-w> <cmd>call Close()<cr>

        nn <c-h> <c-w>h
        nn <c-j> <c-w>j
        nn <c-k> <c-w>k
        nn <c-l> <c-w>l
        nn <m-h> <cmd>vertical :resize -2<cr>
        nn <m-j> <cmd>resize -2<cr>
        nn <m-k> <cmd>resize +2<cr>
        nn <m-l> <cmd>vertical :resize +2<cr>

        nn <tab> <cmd>BufferNext<cr>
        nn <m-tab> <cmd>BufferPick<cr>
        nn <s-tab> <cmd>BufferPrevious<cr>

        nn ff <cmd>GFiles!<cr>
        nn fg <cmd>GFiles!?<cr>
        nn fl <cmd>Commits!<cr>
        nn fr <cmd>Rg!<cr>

        nn g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
        nn g] <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
        nn ga <cmd>lua vim.lsp.buf.code_action()<cr>
        nn gd <cmd>lua vim.lsp.buf.definition()<cr>
        nn gf <cmd>lua vim.lsp.buf.formatting()<cr>
        nn gk <cmd>lua vim.lsp.buf.hover()<cr>
        nn gr <cmd>lua vim.lsp.buf.rename()<cr>
        nn gt <cmd>lua vim.lsp.buf.type_definition()<cr>

        nn tt <cmd>NvimTreeToggle<cr>
        nn tr <cmd>NvimTreeRefresh<cr>

        nn <space>c :!cargo<space>
        nn <space>g :Git<space>
        nn <space>ga <cmd>Git add -p<cr>
        nn <space>gb <cmd>Git blame<cr>
        nn <space>gc <cmd>Git commit<cr>
        nn <space>gi <cmd>Git<cr>
        nn <space>gp <cmd>Git push<cr>
        nn <space>n :!nix<space>
        nn <space>t <cmd>12split term://${pkgs.fish}/bin/fish<cr>i

        vn < <gv
        vn > >gv

        ino <expr> <tab> pumvisible() ? "<c-n>" : "<tab>"
        ino <expr> <s-tab> pumvisible() ? "<c-p>" : "<s-tab>"
        ino <c-s> <cmd>write<cr>
        ino <c-w> <cmd>call Close()<cr>

        tno <expr> <esc> stridx(b:term_title, "#FZF") == -1 ? "<c-\><c-n>" : "<esc>"

        autocmd BufEnter,BufWinEnter,TabEnter *.rs lua
        \ require("lsp_extensions").inlay_hints {
        \   prefix = "",
        \   highlight = "Comment",
        \   enabled = {"ChainingHint", "TypeHint"},
        \ }

        autocmd ColorScheme * call onedark#extend_highlight(
        \ "TabLineFill",
        \ #{ bg: #{ gui: "#1f2227" } },
        \ )

        colorscheme onedark
        filetype plugin indent on
        syntax enable

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
        vim-fugitive
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
