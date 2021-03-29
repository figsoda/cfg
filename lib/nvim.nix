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
        let g:completion_confirm_key = ""
        let g:indentLine_char = "⎸"
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

        let g:pairs = {
        \ '"': '"',
        \ "(": ")",
        \ "[": "]",
        \ "`": "`",
        \ "{": "}",
        \ }

        function s:close()
          let win = winnr("$")
          if win == 1 || win == 2 && bufnr("NvimTree") != -1
            bdelete
          else
            quit
          end
        endf

        function s:cr()
          if pumvisible()
            if complete_info()["selected"] != "-1"
              call completion#completion_confirm()
              return ""
            else
              let pre = "\<c-e>"
            end
          else
            let pre = ""
          end

          let line = getline(".")
          let pos = col(".")
          if get(g:pairs, line[pos - 2], 1) == line[pos - 1]
            let indent = repeat(" ", indent(line(".")))
            return printf("%s\<cr>\<c-u>\<cr>\<c-u>%s\<up>%s\<tab>", pre, indent, indent)
          else
            return pre . "\<cr>"
          end
        endf

        function s:indent_pair(r)
          let indent = repeat(" ", indent(line(".")))
          return printf("\<cr>\<c-u>\<cr>\<c-u>%s%s\<up>%s\<tab>", indent, a:r, indent)
        endf

        function s:in_pair()
          let line = getline(".")
          let pos = col(".")
          return (get(g:pairs, line[pos - 2], 1) == line[pos - 1])
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

        nn R "_diwhp
        nn x "_x
        nn X "_X

        nn <c-h> <c-w>h
        nn <c-j> <c-w>j
        nn <c-k> <c-w>k
        nn <c-l> <c-w>l
        nn <m-h> <cmd>vertical resize -2<cr>
        nn <m-j> <cmd>resize -2<cr>
        nn <m-k> <cmd>resize +2<cr>
        nn <m-l> <cmd>vertical resize +2<cr>

        nn <tab> <cmd>BufferLineCycleNext<cr>
        nn <m-tab> <cmd>BufferLinePick<cr>
        nn <s-tab> <cmd>BufferLineCyclePrev<cr>

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
        nn <space>cp <cmd>!${pkgs.cargo-play}/bin/cargo-play %<cr>
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
        nn <space>ni <cmd>12split term://${nix} repl<cr>ipkgs = import <nixpkgs> {}<cr><c-l>
        nn <space>nr <cmd>12split term://${nix} run<cr>i
        nn <space>nt <cmd>12split term://${nix} flake check<cr>i
        nn <space>nu <cmd>!${nix} flake update<cr>
        nn <space>t <cmd>12split term://${pkgs.fish}/bin/fish<cr>i

        vn < <gv
        vn > >gv

        ino <expr> <tab> pumvisible() ? "<c-n>" : "<tab>"
        ino <expr> <s-tab> pumvisible() ? "<c-p>" : "<s-tab>"
        ino <c-a> <home>
        ino <c-e> <end>
        ino <c-q> <cmd>confirm quitall<cr>
        ino <c-s> <cmd>write<cr>
        ino <c-w> <cmd>call <sid>close()<cr><esc>
        ino <expr> <bs> <sid>in_pair() ? "<bs><del>" : "<bs>"
        ino <expr> <cr> <sid>cr()

        for [l, r] in items(g:pairs)
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

        command -nargs=? P call <sid>play(<f-args>)

        colorscheme onedark
        filetype plugin indent on
        syntax enable

        lua <<EOF
          local completion = require("completion")
          local lspconfig = require("lspconfig")

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
                return vim.fn.isdirectory(vim.fn.bufname(n)) == 0
              end,
              diagnostics = "nvim_lsp",
            },
          }

          require("colorizer").setup(nil, {css = true})

          require("gitsigns").setup()

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
              signs = true,
              update_in_insert = true,
              virtual_text = true,
            }
          )
        EOF
      '';
      packages.all.start = with pkgs.vimPlugins; [
        completion-nvim
        fzf-vim
        gitsigns-nvim
        indentLine
        lightline-vim
        lsp_extensions-nvim
        nvim-bufferline-lua
        nvim-colorizer-lua
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
      ];
    };
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
  };
}
