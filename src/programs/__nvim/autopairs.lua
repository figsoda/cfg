local api = vim.api
local fn = vim.fn
local map = vim.keymap.set
local treesitter = vim.treesitter

local function get(s, i)
  return s:sub(i, i)
end

local function indent_pair(r)
  local indent = string.rep(" ", fn.indent("."))
  return string.format("<cr> <c-u><cr> <c-u>%s%s<up>%s<tab>", indent, r, indent)
end

local function ts_string(buf, x, y)
  for _, capture in pairs(treesitter.get_captures_at_pos(buf, y - 1, x)) do
    if capture.capture:match("^string") then
      return true
    end
  end
  return false
end

local function syn_string(x, y)
  local ids = fn.synstack(y, x + 1)
  local len = #ids
  if len == 0 then
    return false
  else
    local syn = fn.synIDattr(ids[len], "name")
    return syn:find("String") or syn:find("InterpolationDelimiter")
  end
end

local function in_string(x, y)
  local last_x, last_y
  if x == 0 then
    last_y = y - 1
    last_x = math.max(#fn.getline(last_y), 1)
  else
    last_x = x - 1
    last_y = y
  end

  local buf = api.nvim_get_current_buf()
  if treesitter.highlighter.active[buf] then
    return ts_string(buf, x, y) and ts_string(buf, last_x, last_y)
  else
    return syn_string(x, y) and syn_string(last_x, last_y)
  end
end

local autopairs = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ['"'] = '"',
}

local function in_pair()
  local line = api.nvim_get_current_line()
  local x = fn.col(".")
  local r = get(line, x)
  return r ~= "" and r == autopairs[get(line, x - 1)]
end

map("i", "<bs>", function()
  return in_pair() and "<bs><del>" or "<bs>"
end, { expr = true })

map("i", "<cr>", function()
  return in_pair() and indent_pair("") or "<cr>"
end, { expr = true })

api.nvim_create_autocmd("FileType", {
  pattern = "nix",
  callback = function(ctx)
    map("i", "<cr>", function()
      local line = api.nvim_get_current_line()
      local x = fn.col(".")
      local r = get(line, x)
      if r ~= "" and r == autopairs[get(line, x - 1)] then
        return indent_pair("")
      elseif line:sub(x - 2, x - 1) == "''" and get(line, x - 3) ~= "'" then
        return indent_pair("''")
      else
        return "<cr>"
      end
    end, { buffer = ctx.buf, expr = true })
  end,
})

for l, r in pairs(autopairs) do
  if l == r then
    map("i", l, function()
      local y, x = unpack(api.nvim_win_get_cursor(0))
      if in_string(x, y) then
        return get(api.nvim_get_current_line(), x + 1) == l and "<right>" or l
      else
        return l .. l .. "<left>"
      end
    end, { expr = true })
  else
    map("i", l, function()
      local line = api.nvim_get_current_line()
      local pos = fn.col(".")
      return pos ~= #line and (get(line, pos) or ""):match("%w") and l
        or l .. r .. "<left>"
    end, { expr = true })
    map("i", r, function()
      return get(api.nvim_get_current_line(), fn.col(".")) == r and "<right>"
        or r
    end, { expr = true })
  end
end
