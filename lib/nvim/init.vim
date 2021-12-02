set clipboard+=unnamedplus
set colorcolumn=10000
set completeopt=menuone,noinsert,noselect
set cursorline
set expandtab
set ignorecase
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
set smartcase
set smartindent
set splitbelow
set splitright
set termguicolors
set timeoutlen=400
set title
set updatetime=300

function s:cargo_add()
  let flags = input("Add dependencies: ")
  if flags != ""
    exec "!@cargo_edit@/bin/cargo-add add" flags "&& @rust@/bin/cargo update"
    NvimTreeRefresh
  end
endf

function s:play(...)
  let file = system("@coreutils@/bin/mktemp" .. (a:0 ? " --suffix ." . a:1 : ""))
  exec "edit" file
  exec "autocmd BufDelete <buffer> silent !@coreutils@/bin/rm" file
endf

function s:term_close()
  if getline(".") == "[Process exited 0]"
    bdelete!
  end
endf

snor <c-x> <cmd>lua require("luasnip").change_choice(1)<cr>
snor <s-tab> <cmd>lua require("luasnip").jump(-1)<cr>
snor <tab> <cmd>lua require("luasnip").jump(1)<cr>

no ; :
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
nn <space>/ <cmd>Telescope live_grep<cr>
nn <space>c<space> :!cargo<space>
nn <space>cU <cmd>!@cargo_edit@/bin/cargo-upgrade upgrade<cr>
nn <space>ca <cmd>call <sid>cargo_add()<cr>
nn <space>cb <cmd>T @rust@/bin/cargo build<cr>i
nn <space>cd <cmd>T @rust@/bin/cargo doc --open<cr>i
nn <space>cf <cmd>!@rust@/bin/cargo fmt<cr>
nn <space>cp <cmd>!@cargo_play@/bin/cargo-play %<cr>
nn <space>cr <cmd>T @rust@/bin/cargo run<cr>i
nn <space>ct <cmd>T @rust@/bin/cargo test<cr>i
nn <space>cu <cmd>!@rust@/bin/cargo update<cr>
nn <space>g<space> :Git<space>
nn <space>gB <cmd>Telescope git_bcommits<cr>
nn <space>gR <cmd>lua require("gitsigns").reset_buffer()<cr>
nn <space>gS <cmd>Telescope git_stash<cr>
nn <space>ga <cmd>Git add -p<cr>
nn <space>gb <cmd>lua require("gitsigns").blame_line()<cr>
nn <space>gc <cmd>Git commit<cr>
nn <space>gh <cmd>lua require("gitsigns").preview_hunk()<cr>
nn <space>gi <cmd>exec "Git rebase -i HEAD~" . (v:count ? v:count : 2)<cr>
nn <space>gl <cmd>Telescope git_commits<cr>
nn <space>gn <cmd>Git commit --amend --no-edit<cr>
nn <space>go <cmd>Telescope git_branches<cr>
nn <space>gp <cmd>Git push<cr>
nn <space>gr <cmd>lua require("gitsigns").reset_hunk()<cr>
nn <space>gs <cmd>lua require("gitsigns").stage_hunk()<cr>
nn <space>gu <cmd>lua require("gitsigns").undo_stage_hunk()<cr>
nn <space>j <cmd>move +1<cr>
nn <space>k <cmd>move -2<cr>
nn <space>lf <cmd>!@fd@/bin/fd -H '.lua$' -x @stylua@/bin/stylua<cr>
nn <space>m <cmd>Telescope man_pages<cr>
nn <space>n<space> :!nix<space>
nn <space>nb <cmd>T @nix@/bin/nix build<cr>i
nn <space>nf <cmd>!@fd@/bin/fd -H '.nix$' -x @nixpkgs_fmt@/bin/nixpkgs-fmt<cr>
nn <space>ni <cmd>T @nix@/bin/nix repl @nixpkgs@<cr>i
nn <space>nr <cmd>T @nix@/bin/nix run<cr>i
nn <space>nt <cmd>T @nix@/bin/nix flake check<cr>i
nn <space>nu <cmd>!@nix@/bin/nix flake update<cr>
nn <space>o <cmd>Telescope find_files<cr>
nn <space>t <cmd>T @fish@/bin/fish<cr>i
nn <tab> <cmd>BufferLineCycleNext<cr>
nn N Nzz
nn R "_di"hp
nn X "_X
nn [h <cmd>lua require("gitsigns.actions").prev_hunk()<cr>
nn ]h <cmd>lua require("gitsigns.actions").next_hunk()<cr>
nn n nzz
nn t <cmd>NvimTreeFindFileToggle<cr>
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
ino <c-j> <esc>o
ino <c-k> <esc>O
ino <c-q> <cmd>confirm quitall<cr>
ino <c-s> <cmd>write<cr>
ino <c-x> <cmd>lua require("luasnip").change_choice(1)<cr>
ino <m-,> <cmd>call setline(".", getline(".") . ",")<cr>
ino <m-;> <cmd>call setline(".", getline(".") . ";")<cr>
ino <m-down> <cmd>move +1<cr>
ino <m-h> <s-left>
ino <m-j> <esc><down>a
ino <m-k> <esc><up>a
ino <m-l> <esc>ea
ino <m-up> <cmd>move -2<cr>

tno <esc> <c-\><c-n>

autocmd BufRead all-packages.nix lua require("cmp").setup.buffer({ enabled = false })

autocmd BufRead,BufNewFile *.rasi setfiletype css

autocmd BufRead,BufNewFile flake.lock setfiletype json

autocmd BufRead,BufNewFile Cargo.lock setfiletype toml

autocmd FileType lua setlocal shiftwidth=2

autocmd FileType markdown setlocal shiftwidth=2

autocmd FileType rust nn <buffer> J <cmd>RustJoinLines<cr>
autocmd FileType rust nn <buffer> gm <cmd>RustExpandMacro<cr>

autocmd FileType vim setlocal shiftwidth=2

autocmd FileType yaml setlocal shiftwidth=2

autocmd TermClose * call timer_start(50, { -> s:term_close() })

autocmd TextYankPost * silent lua vim.highlight.on_yank()

autocmd User TelescopePreviewerLoaded setlocal number

autocmd VimEnter * silent exec "!@util_linux@/bin/kill -s SIGWINCH" getpid()

command -nargs=? P call s:play(<f-args>)
command -nargs=+ T botright 12split term://<args>
