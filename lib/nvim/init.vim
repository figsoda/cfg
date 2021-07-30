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

let indent_blankline_buftype_exclude = ["terminal"]
let indent_blankline_char = "⎸"
let indent_blankline_filetype_exclude = ["help", "NvimTree"]
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

let s:pairs = {
\ '"': '"',
\ "(": ")",
\ "[": "]",
\ "`": "`",
\ "{": "}",
\ }

function s:cr_nix()
  let line = getline(".")
  let pos = col(".")
  if get(s:pairs, line[pos - 2], 1) == line[pos - 1]
    return s:indent_pair("")
  elseif line[pos - 3 : pos - 2] == "'''" && line[pos - 4] != "'"
    return s:indent_pair("'''")
  else
    return "\<cr>"
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
  let file = system("@coreutils@/bin/mktemp" .. (a:0 ? " --suffix ." . a:1 : ""))
  exec "edit" file
  exec "autocmd BufDelete <buffer> silent !@coreutils@/bin/rm" file
endf

function s:quote(c)
  let x = col(".")
  let y = line(".")
  let line = getline(".")

  if x == 1
    let i = y
    while i > 1
      let i -= 1
      let len = strlen(getline(i))
      if len != 0
        let l = synID(i, len, 1)
        break
      end
    endw
  end
  if !exists("l")
    let l = synID(y, x - 1, 1)
  end

  if x > strlen(line)
    let i = y
    while i < nvim_buf_line_count(0)
      let i += 1
      if !empty(getline(i))
        let r = synID(i, 1, 1)
        break
      end
    endw
  end
  if !exists("r")
    let r = synID(y, x, 1)
  end

  if synIDattr(l, "name") =~? "string\\|interpolationdelimiter"
  \ && synIDattr(r, "name") =~? "string\\|interpolationdelimiter"
    return line[x - 1] == a:c ? "\<right>" : a:c
  else
    return a:c . a:c . "\<left>"
  end
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
nn <space>cU <cmd>!@rust@ upgrade<cr>
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
nn <space>n<space> :!nix<space>
nn <space>nb <cmd>T @nix@/bin/nix build<cr>i
nn <space>nf <cmd>!@fd@/bin/fd -H '.nix$' -x @nixfmt@/bin/nixfmt<cr>
nn <space>ni <cmd>T @nix@/bin/nix repl @nixpkgs@<cr>i
nn <space>nr <cmd>T @nix@/bin/nix run<cr>i
nn <space>nt <cmd>T @nix@/bin/nix flake check<cr>i
nn <space>nu <cmd>!@nix@/bin/nix flake update<cr>
nn <space>t <cmd>T @fish@/bin/fish<cr>i
nn <tab> <cmd>BufferLineCycleNext<cr>
nn R "_diwhp
nn T <cmd>NvimTreeToggle<cr>
nn X "_X
nn [h <cmd>lua require("gitsigns.actions").prev_hunk()<cr>
nn ]h <cmd>lua require("gitsigns.actions").next_hunk()<cr>
nn x "_x

vn < <gv
vn <c-a> <home>
vn <c-e> <end>
vn <silent> <m-down> :move '>+1<cr>gv
vn <silent> <m-up> :move -2<cr>gv
vn > >gv

ino <c-a> <esc>I
ino <c-e> <end>
ino <c-h> <esc>l"_dbi
ino <c-j> <esc>o
ino <c-k> <esc>O
ino <c-q> <cmd>confirm quitall<cr>
ino <c-s> <cmd>write<cr>
ino <c-w> <cmd>confirm bdelete<cr><esc>
ino <expr> <bs> <sid>in_pair() ? "<bs><del>" : "<bs>"
ino <expr> <cr> compe#confirm(<sid>in_pair() ? <sid>indent_pair("") : "<cr>")
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

for [l, r] in items(s:pairs)
  if l == r
    exec printf("ino <expr> %s <sid>quote('%s')", l, l)
  else
    exec printf("ino <expr> %s <sid>in_word() ? '%s' : '%s%s<left>'", l, l, l, r)
    exec printf("ino <expr> %s getline('.')[col('.') - 1] == '%s' ? '<right>' : '%s'", r, r, r)
  end
endfor

tno <expr> <esc> stridx(b:term_title, "#FZF") == -1 ? "<c-\><c-n>" : "<esc>"

autocmd FileType nix ino <buffer> <expr> <cr> compe#confirm(<sid>cr_nix())

autocmd FileType rust nn <buffer> J <cmd>RustJoinLines<cr>
autocmd FileType rust nn <buffer> gm <cmd>RustExpandMacro<cr>

autocmd FileType yaml setlocal shiftwidth=2

autocmd VimEnter * silent exec "!@util_linux@/bin/kill -s SIGWINCH" getpid() | call s:init()

command -nargs=? P call s:play(<f-args>)
command -nargs=+ T botright 12split term://<args>

@colorscheme@

luafile @init_lua@
