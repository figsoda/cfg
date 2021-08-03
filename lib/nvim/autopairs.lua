Fn = { count = 0 }

local function makefn(f)
  Fn.count = Fn.count + 1
  Fn["_" .. Fn.count] = f
  return "v:lua.Fn._" .. Fn.count .. "()"
end

local function map(lhs, rhs)
  vim.api.nvim_set_keymap("i", lhs, rhs, { noremap = true, expr = true })
end

local function t(c)
  return vim.api.nvim_replace_termcodes(c, true, true, true)
end

local function get(s, i)
  return s:sub(i, i)
end

local function indent_pair(r)
  local indent = string.rep(" ", vim.fn.indent("."))
  return t(
    string.format("<cr> <c-u><cr> <c-u>%s%s<up>%s<tab>", indent, r, indent)
  )
end

local function is_string(y, x)
  local ids = vim.fn.synstack(y, x)
  local len = #ids
  if len == 0 then
    return false
  else
    local syn = vim.fn.synIDattr(ids[len], "name")
    return syn:match("String") or syn:match("InterpolationDelimiter")
  end
end

local autopairs = {
  ["("] = ")",
  ["["] = "]",
  ["`"] = "`",
  ["{"] = "}",
  ['"'] = '"',
}

local function in_pair()
  local line = vim.api.nvim_get_current_line()
  local x = vim.fn.col(".")
  local r = get(line, x)
  return r ~= "" and r == autopairs[get(line, x - 1)]
end

map(
  "<bs>",
  makefn(function()
    return in_pair() and t("<bs><del>") or t("<bs>")
  end)
)

map("<cr>", "compe#confirm(" .. makefn(function()
  return in_pair() and indent_pair("") or t("<cr>")
end) .. ")")

vim.api.nvim_command(
  "autocmd FileType nix ino <buffer> <expr> <cr> compe#confirm("
    .. makefn(function()
      local line = vim.api.nvim_get_current_line()
      local x = vim.fn.col(".")
      local r = get(line, x)
      if r ~= "" and r == autopairs[get(line, x - 1)] then
        return indent_pair("")
      elseif line:sub(x - 2, x - 1) == "''" and get(line, x - 3) ~= "'" then
        return indent_pair("''")
      else
        return t("<cr>")
      end
    end)
    .. ")"
)

for l, r in pairs(autopairs) do
  if l == r then
    map(
      l,
      makefn(function()
        local x = vim.fn.col(".")
        local y = vim.fn.line(".")
        if
          is_string(y, x)
          and (
            x == 1 and is_string(y - 1, #vim.fn.getline(y - 1))
            or is_string(y, x - 1)
          )
        then
          return get(vim.api.nvim_get_current_line(), x) == l and t("<right>")
            or l
        else
          return l .. l .. t("<left>")
        end
      end)
    )
  else
    map(
      l,
      makefn(function()
        local line = vim.api.nvim_get_current_line()
        local pos = vim.fn.col(".")
        return pos ~= #line and (get(line, pos) or ""):match("%w") and l
          or l .. r .. t("<left>")
      end)
    )
    map(
      r,
      makefn(function()
        return get(vim.api.nvim_get_current_line(), vim.fn.col(".")) == r
            and t("<right>")
          or r
      end)
    )
  end
end
