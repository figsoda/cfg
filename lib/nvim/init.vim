set clipboard+=unnamedplus
set colorcolumn=10000
set completeopt=menuone,noinsert,noselect
set cursorline
set expandtab
set hidden
set inccommand=nosplit
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

let indent_blankline_buftype_exclude = ["terminal"]
let indent_blankline_char = "│"
let indent_blankline_filetype_exclude = ["help", "NvimTree"]
let indent_blankline_use_treesitter = v:true
let mapleader = " "
let nvim_tree_auto_open = 1
let nvim_tree_git_hl = 1
let nvim_tree_gitignore = 1
let nvim_tree_icons = #{ default: "" }
let nvim_tree_ignore = [".git"]
let nvim_tree_lsp_diagnostics = 1
let nvim_tree_quit_on_open = 1
let nvim_tree_width_allow_resize = 1
let nvim_tree_window_picker_exclude = #{ buftype: ["terminal"] }
let vim_markdown_conceal = 0
let vim_markdown_conceal_code_blocks = 0

function s:init()
  let name = bufname(1)
  if isdirectory(name)
    exec "cd" name
    bdelete 1
  end
endf

function s:play(...)
  let file = system("@coreutils@/bin/mktemp" .. (a:0 ? " --suffix ." . a:1 : ""))
  exec "edit" file
  exec "autocmd BufDelete <buffer> silent !@coreutils@/bin/rm" file
endf

no <c-_> <cmd>let @/ = ""<cr>
no <c-q> <cmd>confirm quitall<cr>
no <c-s> <cmd>write<cr>
no <silent> <expr> <c-w> (&buftype == "terminal" ? ":bdelete!" : ":confirm bdelete") . "<cr>"

nn <c-a> <home>
nn <c-e> <end>
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
nn <space>cU <cmd>!@cargo_edit@/bin/cargo-upgrade upgrade<cr>
nn <space>cb <cmd>T @rust@/bin/cargo build<cr>i
nn <space>cd <cmd>T @rust@/bin/cargo doc --open<cr>i
nn <space>cf <cmd>!@rust@/bin/cargo fmt<cr>
nn <space>cp <cmd>!@cargo_play@/bin/cargo-play %<cr>
nn <space>cr <cmd>T @rust@/bin/cargo run<cr>i
nn <space>ct <cmd>T @rust@/bin/cargo test<cr>i
nn <space>cu <cmd>!@rust@/bin/cargo update<cr>
nn <space>g/ <cmd>Rg!<cr>
nn <space>g<space> :Git<space>
nn <space>gB <cmd>Git blame<cr>
nn <space>gR <cmd>lua require("gitsigns").reset_buffer()<cr>
nn <space>ga <cmd>Git add -p<cr>
nn <space>gb <cmd>lua require("gitsigns").blame_line()<cr>
nn <space>gc <cmd>Git commit<cr>
nn <space>gh <cmd>lua require("gitsigns").preview_hunk()<cr>
nn <space>gi <cmd>Git<cr>
nn <space>gl <cmd>Commits!<cr>
nn <space>go <cmd>GFiles!<cr>
nn <space>gp <cmd>Git push<cr>
nn <space>gr <cmd>lua require("gitsigns").reset_hunk()<cr>
nn <space>gs <cmd>lua require("gitsigns").stage_hunk()<cr>
nn <space>gu <cmd>lua require("gitsigns").undo_stage_hunk()<cr>
nn <space>j <cmd>move +1<cr>
nn <space>k <cmd>move -2<cr>
nn <space>lf <cmd>!@fd@/bin/fd -H '.lua$' -x @stylua@/bin/stylua<cr>
nn <space>n<space> :!nix<space>
nn <space>nb <cmd>T @nix@/bin/nix build<cr>i
nn <space>nf <cmd>!@fd@/bin/fd -H '.nix$' -x @nixfmt@/bin/nixfmt<cr>
nn <space>ni <cmd>T @nix@/bin/nix repl @nixpkgs@<cr>i
nn <space>nr <cmd>T @nix@/bin/nix run<cr>i
nn <space>nt <cmd>T @nix@/bin/nix flake check<cr>i
nn <space>nu <cmd>!@nix@/bin/nix flake update<cr>
nn <space>t <cmd>T @fish@/bin/fish<cr>i
nn <tab> <cmd>BufferLineCycleNext<cr>
nn N Nzz
nn R "_diwhp
nn T <cmd>NvimTreeToggle<cr>
nn X "_X
nn [h <cmd>lua require("gitsigns.actions").prev_hunk()<cr>
nn ]h <cmd>lua require("gitsigns.actions").next_hunk()<cr>
nn n nzz
nn x "_x

vn < <gv
vn <c-a> <home>
vn <c-e> <end>
vn <silent> <m-down> :move '>+1<cr>gv
vn <silent> <m-up> :move -2<cr>gv
vn <silent> <space>j :move '>+1<cr>gv
vn <silent> <space>k :move -2<cr>gv
vn > >gv

ino <c-a> <esc>I
ino <c-e> <end>
ino <c-h> <esc>l"_dbi
ino <c-j> <esc>o
ino <c-k> <esc>O
ino <c-q> <cmd>confirm quitall<cr>
ino <c-s> <cmd>write<cr>
ino <c-w> <cmd>confirm bdelete<cr><esc>
ino <expr> <s-tab> pumvisible() ? "<c-p>" : "<s-tab>"
ino <expr> <tab> pumvisible() ? "<c-n>" : "<tab>"
ino <m-,> <cmd>call setline(".", getline(".") . ",")<cr>
ino <m-;> <cmd>call setline(".", getline(".") . ";")<cr>
ino <m-down> <cmd>move +1<cr>
ino <m-h> <s-left>
ino <m-j> <down>
ino <m-k> <up>
ino <m-l> <esc>ea
ino <m-up> <cmd>move -2<cr>

tno <expr> <esc> stridx(b:term_title, "#FZF") == -1 ? "<c-\><c-n>" : "<esc>"

autocmd FileType lua setlocal shiftwidth=2

autocmd FileType rust nn <buffer> J <cmd>RustJoinLines<cr>
autocmd FileType rust nn <buffer> gm <cmd>RustExpandMacro<cr>

autocmd FileType vim setlocal shiftwidth=2

autocmd FileType yaml setlocal shiftwidth=2

autocmd TextYankPost * silent lua vim.highlight.on_yank()

autocmd VimEnter * silent exec "!@util_linux@/bin/kill -s SIGWINCH" getpid() | call s:init()

command -nargs=? P call s:play(<f-args>)
command -nargs=+ T botright 12split term://<args>
