{ config, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = let nix = "${config.nix.package}/bin/nix";
      in ''
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
        let g:onedark_hide_endofbuffer = 1
        let g:onedark_terminal_italics = 1
        let g:vim_json_syntax_conceal = 0
        let g:vim_markdown_conceal = 0
        let g:vim_markdown_conceal_code_blocks = 0

        let g:pairs = {
        \ '"': '"',
        \ "(": ")",
        \ "[": "]",
        \ "`": "`",
        \ "{": "}",
        \ }

        function Close()
          let win = winnr("$")
          if win == 1 || win == 2 && bufnr("NvimTree") != -1
            BufferClose
          else
            quit
          end
        endf

        function InPair()
          let line = getline(".")
          let pos = col(".")
          return (get(g:pairs, line[pos - 2], 1) == line[pos - 1])
        endf

        function InWord()
          let line = getline(".")
          let pos = col(".") - 1
          return (pos != len(line) && line[pos] =~ '\w')
        endf

        function Quote(c)
          let line = getline(".")
          let pos = col(".") - 1
          let r = line[pos]
          if r == a:c
            return "\<right>"
          elseif pos == len(line) || r !~ '\w'
            return a:c . a:c . "\<left>"
          else
            return a:c
          end
        endf

        no <c-_> <cmd>let @/ = ""<cr>
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

        nn <space>c<space> :!cargo<space>
        nn <space>cU <cmd>!cargo upgrade<cr>
        nn <space>cb <cmd>12split term://cargo build<cr>i
        nn <space>cd <cmd>12split term://cargo doc --open<cr>i
        nn <space>cf <cmd>!cargo fmt<cr>
        nn <space>cr <cmd>12split term://cargo run<cr>i
        nn <space>ct <cmd>12split term://cargo test<cr>i
        nn <space>cu <cmd>!cargo update<cr>
        nn <space>g<space> :Git<space>
        nn <space>ga <cmd>Git add -p<cr>
        nn <space>gb <cmd>Git blame<cr>
        nn <space>gc <cmd>Git commit<cr>
        nn <space>gf <cmd>GFiles!<cr>
        nn <space>gi <cmd>Git<cr>
        nn <space>gl <cmd>Commits!<cr>
        nn <space>gp <cmd>Git push<cr>
        nn <space>gr <cmd>Rg!<cr>
        nn <space>gs <cmd>GFiles!?<cr>
        nn <space>n<space> :!nix<space>
        nn <space>nb <cmd>12split term://${nix} build<cr>i
        nn <space>nf <cmd>!${pkgs.fd}/bin/fd -H '.nix$' -x ${pkgs.nixfmt}/bin/nixfmt<cr>
        nn <space>ni <cmd>12split term://${nix} repl<cr>ipkgs = import <nixpkgs> {}<cr>
        nn <space>nr <cmd>12split term://${nix} run<cr>i
        nn <space>nt <cmd>12split term://${nix} flake check<cr>i
        nn <space>nu <cmd>!${nix} flake update<cr>
        nn <space>t <cmd>12split term://${pkgs.fish}/bin/fish<cr>i

        vn < <gv
        vn > >gv

        ino <expr> <tab> pumvisible() ? "<c-n>" : "<tab>"
        ino <expr> <s-tab> pumvisible() ? "<c-p>" : "<s-tab>"
        ino <c-s> <cmd>write<cr>
        ino <c-w> <cmd>call Close()<cr><esc>
        ino <expr> <bs> InPair() ? "<bs><del>" : "<bs>"

        for [l, r] in items(g:pairs)
          exec printf("ino %s<cr> %s<cr>%s<up><end><cr><tab>", l, l, r)
          if l == r
            exec printf("ino <expr> %s Quote('%s')", l, l)
          else
            exec printf("ino <expr> %s InWord() ? '%s' : '%s%s<left>'", l, l, l, r)
            exec printf("ino <expr> %s getline('.')[col('.') - 1] == '%s' ? '<right>' : '%s'", r, r, r)
          end
        endfor

        tno <expr> <esc> stridx(b:term_title, "#FZF") == -1 ? "<c-\><c-n>" : "<esc>"

        autocmd BufEnter *.nix :ino <buffer> '''<cr> '''<cr>'''<up><end><cr><tab>

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

        autocmd FileType yaml setlocal shiftwidth=2

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
            settings = {
              ["rust-analyzer"] = {
                assist = {
                  importMergeBehavior = "full",
                  importPrefix = "by_crate",
                },
                cargo = {
                  loadOutDirsFromCheck = true,
                },
                checkOnSave = {
                  command = "clippy",
                },
                procMacro = {
                  enable = true,
                },
              },
            },
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
        vim-json
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
