vim.g.mapleader = " "
vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_conceal_code_blocks = 0

vim.api.nvim_create_autocmd("TermClose", {
  callback = function()
    vim.defer_fn(function()
      if vim.api.nvim_get_current_line() == "[Process exited 0]" then
        vim.api.nvim_buf_delete(0, { force = true })
      end
    end, 50)
  end,
})

vim.api.nvim_create_user_command("P", function(input)
  local ext = input.fargs[1]
  local file = vim.fn.tempname()
  if ext and ext ~= "" then
    file = file .. "." .. ext
  end
  vim.api.nvim_command("edit " .. file)
end, { nargs = "?" })

vim.keymap.set("n", " ca", function()
  vim.ui.input({ prompt = "Add dependencies: " }, function(flags)
    if flags then
      vim.api.nvim_command(
        "!@rust@/bin/cargo add " .. flags .. " && @rust@/bin/cargo update"
      )
      vim.api.nvim_command("NvimTreeRefresh")
    end
  end)
end)
