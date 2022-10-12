no ; :
no <c-_> <cmd>let @/ = ""<cr>
no <c-q> <cmd>confirm quitall<cr>
no <c-s> <cmd>write<cr>

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
nn <space>fc <cmd>!@rust@/bin/cargo fmt<cr>
nn <space>fl <cmd>!@fd@/bin/fd -H '.lua$' -x @stylua@/bin/stylua<cr>
nn <space>fn <cmd>!@fd@/bin/fd -H '.nix$' -x @nixpkgs_fmt@/bin/nixpkgs-fmt<cr>
nn <space>g<space> :Git<space>
nn <space>gB <cmd>Telescope git_bcommits<cr>
nn <space>gS <cmd>Telescope git_stash<cr>
nn <space>ga <cmd>Git add -p<cr>
nn <space>gc <cmd>Git commit<cr>
nn <space>gi <cmd>exec "Git rebase -i HEAD~" . (v:count ? v:count : 2)<cr>
nn <space>gl <cmd>Telescope git_commits<cr>
nn <space>gn <cmd>Git commit --amend --no-edit<cr>
nn <space>go <cmd>Telescope git_branches<cr>
nn <space>gp <cmd>Git push<cr>
nn <space>j <cmd>move +1<cr>
nn <space>k <cmd>move -2<cr>
nn <space>m <cmd>Telescope man_pages<cr>
nn <space>o <cmd>Telescope find_files<cr>
nn <space>t <cmd>T @fish@/bin/fish<cr>i
nn <tab> <cmd>BufferLineCycleNext<cr>
nn N Nzz
nn R "_di"hp
nn X "_X
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
ino <m-,> <cmd>call setline(".", getline(".") . ",")<cr>
ino <m-;> <cmd>call setline(".", getline(".") . ";")<cr>
ino <m-down> <cmd>move +1<cr>
ino <m-h> <s-left>
ino <m-j> <esc><down>a
ino <m-k> <esc><up>a
ino <m-l> <esc>ea
ino <m-up> <cmd>move -2<cr>

tno <esc> <c-\><c-n>

autocmd BufRead,BufNewFile *.rasi setfiletype css

autocmd BufRead,BufNewFile flake.lock setfiletype json

autocmd BufRead,BufNewFile Cargo.lock setfiletype toml

autocmd FileType lua setlocal shiftwidth=2

autocmd FileType markdown setlocal shiftwidth=2

autocmd FileType vim setlocal shiftwidth=2

autocmd FileType yaml setlocal shiftwidth=2

autocmd User TelescopePreviewerLoaded setlocal number

autocmd VimEnter * silent exec "!@util_linux@/bin/kill -s SIGWINCH" getpid()

command -nargs=+ T botright 12split term://<args>
