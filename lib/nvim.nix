{ config, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = let nix = "${config.nix.package}/bin/nix";
      in ''
        set clipboard+=unnamedplus
        set colorcolumn=10000
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
        set shortmess=aoOtTIcF
        set showtabline=2
        set signcolumn=yes
        set smartindent
        set splitbelow
        set splitright
        set termguicolors
        set timeoutlen=400
        set title
        set updatetime=300

        let g:indent_blankline_buftype_exclude = ["terminal"]
        let g:indent_blankline_char = "⎸"
        let g:indent_blankline_filetype_exclude = ["help", "NvimTree"]
        let g:lightline = #{
        \ colorscheme: "onedark",
        \ enable: #{ tabline: 0 },
        \ }
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

        let s:pairs = {
        \ '"': '"',
        \ "(": ")",
        \ "[": "]",
        \ "`": "`",
        \ "{": "}",
        \ }

        function s:close()
          if &buftype == "terminal"
            quit
          else
            confirm bdelete
          end
        endf

        function s:indent_pair(r)
          let indent = repeat(" ", indent(line(".")))
          return printf("\<cr> \<c-u>\<cr> \<c-u>%s%s\<up>%s\<tab>", indent, a:r, indent)
        endf

        function s:init()
          let name = bufname(1)
          if isdirectory(name)
            exec "cd" name
            bdelete 1
          end
        endf

        function s:in_pair()
          let line = getline(".")
          let pos = col(".")
          return (get(s:pairs, line[pos - 2], 1) == line[pos - 1])
        endf

        function s:in_word()
          let line = getline(".")
          let pos = col(".") - 1
          return (pos != len(line) && line[pos] =~ '\w')
        endf

        function s:play(...)
          if a:0
            exec "e" system("${pkgs.coreutils}/bin/mktemp --suffix ." . a:1)
          else
            exec "e" system("${pkgs.coreutils}/bin/mktemp")
          end
        endf

        function s:quote(c)
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
        no <c-q> <cmd>confirm quitall<cr>
        no <c-s> <cmd>write<cr>
        no <c-w> <cmd>call <sid>close()<cr>

        nn <c-h> <c-w>h
        nn <c-j> <c-w>j
        nn <c-k> <c-w>k
        nn <c-l> <c-w>l
        nn <m-down> <cmd>move +1<cr>
        nn <m-h> <cmd>vertical resize -2<cr>
        nn <m-j> <cmd>resize -2<cr>
        nn <m-k> <cmd>resize +2<cr>
        nn <m-l> <cmd>vertical resize +2<cr>
        nn <m-tab> <cmd>BufferLinePick<cr>
        nn <m-up> <cmd>move -2<cr>
        nn <s-tab> <cmd>BufferLineCyclePrev<cr>
        nn <space>c<space> :!cargo<space>
        nn <space>cU <cmd>!cargo upgrade<cr>
        nn <space>cb <cmd>T cargo build<cr>i
        nn <space>cd <cmd>T cargo doc --open<cr>i
        nn <space>cf <cmd>!cargo fmt<cr>
        nn <space>cp <cmd>!${pkgs.cargo-play}/bin/cargo-play %<cr>
        nn <space>cr <cmd>T cargo run<cr>i
        nn <space>ct <cmd>T cargo test<cr>i
        nn <space>cu <cmd>!cargo update<cr>
        nn <space>g<space> :Git<space>
        nn <space>gB <cmd>Git blame<cr>
        nn <space>gR <cmd>lua require("gitsigns").reset_buffer()<cr>
        nn <space>ga <cmd>Git add -p<cr>
        nn <space>gb <cmd>lua require("gitsigns").blame_line()<cr>
        nn <space>gc <cmd>Git commit<cr>
        nn <space>gf <cmd>Rg!<cr>
        nn <space>gh <cmd>lua require("gitsigns").preview_hunk()<cr>
        nn <space>gi <cmd>Git<cr>
        nn <space>gl <cmd>Commits!<cr>
        nn <space>go <cmd>GFiles!<cr>
        nn <space>gp <cmd>Git push<cr>
        nn <space>gr <cmd>lua require("gitsigns").reset_hunk()<cr>
        nn <space>gs <cmd>lua require("gitsigns").stage_hunk()<cr>
        nn <space>gu <cmd>lua require("gitsigns").undo_stage_hunk()<cr>
        nn <space>n<space> :!nix<space>
        nn <space>nb <cmd>T ${nix} build<cr>i
        nn <space>nf <cmd>!${pkgs.fd}/bin/fd -H '.nix$' -x ${pkgs.nixfmt}/bin/nixfmt<cr>
        nn <space>ni <cmd>T ${nix} repl ${config.nix.registry.nixpkgs.flake}<cr>i
        nn <space>nr <cmd>T ${nix} run<cr>i
        nn <space>nt <cmd>T ${nix} flake check<cr>i
        nn <space>nu <cmd>!${nix} flake update<cr>
        nn <space>t <cmd>T ${pkgs.fish}/bin/fish<cr>i
        nn <tab> <cmd>BufferLineCycleNext<cr>
        nn R "_diwhp
        nn X "_X
        nn g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
        nn g] <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
        nn ga <cmd>lua vim.lsp.buf.code_action()<cr>
        nn gd <cmd>lua vim.lsp.buf.definition()<cr>
        nn gf <cmd>lua vim.lsp.buf.formatting()<cr>
        nn gk <cmd>lua vim.lsp.buf.hover()<cr>
        nn gr <cmd>lua vim.lsp.buf.rename()<cr>
        nn gt <cmd>lua vim.lsp.buf.type_definition()<cr>
        nn tr <cmd>NvimTreeRefresh<cr>
        nn tt <cmd>NvimTreeToggle<cr>
        nn x "_x

        vn < <gv
        vn > >gv

        ino <c-a> <home>
        ino <c-e> <end>
        ino <c-l> <cmd>call setline(".", getline(".") . nr2char(getchar()))<cr>
        ino <c-q> <cmd>confirm quitall<cr>
        ino <c-s> <cmd>write<cr>
        ino <c-w> <cmd>confirm bdelete<cr><esc>
        ino <expr> <bs> <sid>in_pair() ? "<bs><del>" : "<bs>"
        ino <expr> <cr> compe#confirm(<sid>in_pair() ? <sid>indent_pair("") : "<cr>")
        ino <expr> <s-tab> pumvisible() ? "<c-p>" : "<s-tab>"
        ino <expr> <tab> pumvisible() ? "<c-n>" : "<tab>"
        ino <m-down> <cmd>move +1<cr>
        ino <m-up> <cmd>move -2<cr>

        for [l, r] in items(s:pairs)
          if l == r
            exec printf("ino <expr> %s <sid>quote('%s')", l, l)
          else
            exec printf("ino <expr> %s <sid>in_word() ? '%s' : '%s%s<left>'", l, l, l, r)
            exec printf("ino <expr> %s getline('.')[col('.') - 1] == '%s' ? '<right>' : '%s'", r, r, r)
          end
        endfor

        tno <expr> <esc> stridx(b:term_title, "#FZF") == -1 ? "<c-\><c-n>" : "<esc>"

        autocmd BufEnter,BufWinEnter,TabEnter *.rs lua
        \ require("lsp_extensions").inlay_hints {
        \   prefix = "",
        \   highlight = "Comment",
        \   enabled = {"ChainingHint", "TypeHint"},
        \ }

        autocmd FileType nix ino <buffer> <expr> '''<cr> "'''" . <sid>indent_pair("'''")
        autocmd FileType nix ino <buffer> '''' ''''

        autocmd FileType yaml setlocal shiftwidth=2

        autocmd VimEnter * silent exec "!kill -s SIGWINCH" getpid() | call s:init()

        command -nargs=? P call s:play(<f-args>)
        command -nargs=+ T botright 12split term://<args>

        colorscheme onedark
        filetype plugin indent on
        syntax enable

        lua <<EOF
          local lspconfig = require("lspconfig")

          local cap = vim.lsp.protocol.make_client_capabilities()
          cap.textDocument.completion.completionItem.snippetSupport = true
          cap.textDocument.completion.completionItem.resovleSupport = {
            properties = {"additionalTextEdits"},
          }

          require("bufferline").setup {
            highlights = {
              background = {guibg = "#1f2227"},
              buffer_visible = {guibg = "#1f2227"},
              duplicate = {guibg = "#1f2227"},
              duplicate_visible = {guibg = "#1f2227"},
              error = {guibg = "#1f2227"},
              error_visible = {guibg = "#1f2227"},
              fill = {guibg = "#1f2227"},
              indicator_selected = {guifg = "#61afef"},
              modified = {guibg = "#1f2227"},
              modified_visible = {guibg = "#1f2227"},
              pick = {guibg = "#1f2227"},
              pick_visible = {guibg = "#1f2227"},
              separator = {
                guifg = "#1f2227",
                guibg = "#1f2227",
              },
              separator_visible = {
                guifg = "#1f2227",
                guibg = "#1f2227",
              },
              tab = {guibg = "#1f2227"},
              tab_close = {guibg = "#1f2227"},
              warning = {guibg = "#1f2227"},
              warning_selected = {guifg = "#e5c07b"},
              warning_visible = {guibg = "#1f2227"},
            },
            options = {
              custom_filter = function(n)
                return vim.fn.bufname(n) ~= ""
              end,
              diagnostics = "nvim_lsp",
              show_close_icon = false,
            },
          }

          require("colorizer").setup(nil, {css = true})

          require("compe").setup {
            source = {
              buffer = true,
              path = true,
              nvim_lsp = true,
            },
          }

          require("gitsigns").setup()

          require("lspkind").init()

          lspconfig.rnix.setup {
            cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"},
          }

          lspconfig.rust_analyzer.setup {
            capabilities = cap,
            cmd = {"${pkgs.rust-analyzer-nightly}/bin/rust-analyzer"},
            on_attach = function()
              require("lsp_signature").on_attach {
                handler_opts = {
                  border = "double",
                },
              }
            end,
            settings = {
              ["rust-analyzer"] = {
                assist = {
                  importPrefix = "by_crate",
                },
                checkOnSave = {
                  command = "clippy",
                },
              },
            },
          }

          vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
              update_in_insert = true,
            }
          )
        EOF
      '';
      packages.all.start = with pkgs.vimPlugins; [
        fzf-vim
        gitsigns-nvim
        indent-blankline-nvim-lua
        lightline-vim
        lsp_extensions-nvim
        lsp_signature-nvim
        lspkind-nvim
        nvim-bufferline-lua
        nvim-colorizer-lua
        nvim-compe
        nvim-lspconfig
        nvim-tree-lua
        nvim-web-devicons
        onedark-vim
        plenary-nvim
        popup-nvim
        vim-commentary
        vim-fugitive
        vim-json
        vim-lastplace
        vim-markdown
        vim-nix
        vim-sneak
        vim-surround
        vim-toml
        vim-visual-multi
        vim-vsnip
      ];
    };
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
  };
}
