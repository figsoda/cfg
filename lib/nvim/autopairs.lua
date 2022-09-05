local highlighter = require("vim.treesitter.highlighter")
local ts_utils = require("nvim-treesitter.ts_utils")

local function get(s, i)
  return s:sub(i, i)
end

local function indent_pair(r)
  local indent = string.rep(" ", vim.fn.indent("."))
  return string.format("<cr> <c-u><cr> <c-u>%s%s<up>%s<tab>", indent, r, indent)
end

local function is_string(y, x)
  local buf = vim.api.nvim_get_current_buf()
  local hl = highlighter.active[buf]

  if hl then
    local tree = hl.tree
    local lang = tree:lang()
    local match = false

    tree:for_each_tree(function(child)
      if not child then
        return
      end

      local root = child:root()
      local start_row, _, end_row, _ = root:range()

      if start_row > y - 1 or end_row < y - 1 then
        return
      end

      local q = hl:get_query(lang)
      local query = q:query()

      if not query then
        return
      end

      for capture, node in query:iter_captures(root, buf, y - 1, y) do
        if
          q.hl_cache[capture] and ts_utils.is_in_node_range(node, y - 1, x - 1)
        then
          local c = q._query.captures[capture]
          if c and c:match("^string") then
            match = true
            return
          end
        end
      end
    end)

    return match
  end

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
  ["{"] = "}",
  ['"'] = '"',
}

local function in_pair()
  local line = vim.api.nvim_get_current_line()
  local x = vim.fn.col(".")
  local r = get(line, x)
  return r ~= "" and r == autopairs[get(line, x - 1)]
end

vim.keymap.set("i", "<bs>", function()
  return in_pair() and "<bs><del>" or "<bs>"
end, { expr = true })

vim.keymap.set("i", "<cr>", function()
  return in_pair() and indent_pair("") or "<cr>"
end, { expr = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "nix" },
  callback = function()
    vim.keymap.set("i", "<cr>", function()
      local line = vim.api.nvim_get_current_line()
      local x = vim.fn.col(".")
      local r = get(line, x)
      if r ~= "" and r == autopairs[get(line, x - 1)] then
        return indent_pair("")
      elseif line:sub(x - 2, x - 1) == "''" and get(line, x - 3) ~= "'" then
        return indent_pair("''")
      else
        return "<cr>"
      end
    end, { buffer = true, expr = true })
  end,
})

for l, r in pairs(autopairs) do
  if l == r then
    vim.keymap.set("i", l, function()
      local x = vim.fn.col(".")
      local y = vim.fn.line(".")
      if
        is_string(y, x)
        and (
          x == 1 and is_string(y - 1, math.max(#vim.fn.getline(y - 1), 1))
          or is_string(y, x - 1)
        )
      then
        return get(vim.api.nvim_get_current_line(), x) == l and "<right>" or l
      else
        return l .. l .. "<left>"
      end
    end, { expr = true })
  else
    vim.keymap.set("i", l, function()
      local line = vim.api.nvim_get_current_line()
      local pos = vim.fn.col(".")
      return pos ~= #line and (get(line, pos) or ""):match("%w") and l
        or l .. r .. "<left>"
    end, { expr = true })
    vim.keymap.set("i", r, function()
      return get(vim.api.nvim_get_current_line(), vim.fn.col(".")) == r
          and "<right>"
        or r
    end, { expr = true })
  end
end
