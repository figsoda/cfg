local gitsigns = require("gitsigns")
local luasnip = require("luasnip")

local api = vim.api
local g = vim.g
local map = vim.keymap.set
local o = vim.o

g.mapleader = " "
g.vim_markdown_conceal = 0
g.vim_markdown_conceal_code_blocks = 0

o.clipboard = "unnamedplus"
o.completeopt = "menuone,noinsert,noselect"
o.cursorline = true
o.expandtab = true
o.ignorecase = true
o.list = true
o.listchars = "tab:-->,trail:+,extends:>,precedes:<,nbsp:·"
o.mouse = "a"
o.foldenable = false
o.showmode = false
o.swapfile = false
o.number = true
o.relativenumber = true
o.scrolloff = 2
o.shiftwidth = 4
o.shortmess = "aoOtTIcF"
o.showtabline = 2
o.signcolumn = "yes"
o.smartcase = true
o.smartindent = true
o.splitbelow = true
o.splitright = true
o.termguicolors = true
o.timeoutlen = 400
o.title = true
o.updatetime = 300

api.nvim_create_autocmd("BufRead", {
  pattern = "all-packages.nix",
  callback = function()
    require("cmp").setup.buffer({ enabled = false })
  end,
})

api.nvim_create_autocmd("TermClose", {
  callback = function()
    vim.defer_fn(function()
      if api.nvim_get_current_line() == "[Process exited 0]" then
        api.nvim_buf_delete(0, { force = true })
      end
    end, 50)
  end,
})

api.nvim_create_autocmd("TextYankPost", { callback = vim.highlight.on_yank })
api.nvim_create_user_command("P", function(input)
  local ext = input.fargs[1]
  local file = vim.fn.tempname()
  if ext and ext ~= "" then
    file = file .. "." .. ext
  end
  api.nvim_command("edit " .. file)
end, { nargs = "?" })

map("n", " ca", function()
  vim.ui.input({ prompt = "Add dependencies: " }, function(flags)
    if flags then
      api.nvim_command(
        "!@rust@/bin/cargo add " .. flags .. " && @rust@/bin/cargo update"
      )
      api.nvim_command("NvimTreeRefresh")
    end
  end)
end)
map("n", " gR", gitsigns.reset_buffer)
map("n", " gb", gitsigns.blame_line)
map("n", " gh", gitsigns.preview_hunk)
map("n", " gr", gitsigns.reset_hunk)
map("n", " gs", gitsigns.stage_hunk)
map("n", " gu", gitsigns.undo_stage_hunk)
map("n", "[h", gitsigns.prev_hunk)
map("n", "]h", gitsigns.next_hunk)

map("s", "<s-tab>", function()
  luasnip.jump(-1)
end)
map("s", "<tab>", function()
  luasnip.jump(1)
end)

map({ "i", "s" }, "<c-x>", function()
  luasnip.change_choice(1)
end)

map({ "n", "v", "s" }, "<c-w>", function()
  if vim.bo.buftype == "terminal" then
    api.nvim_buf_delete(0, { force = true })
  else
    api.nvim_command("confirm bdelete")
  end
end)
