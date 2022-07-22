local M = {}

local function_node = require('luasnip.nodes.functionNode').F
local snippet = require('luasnip.nodes.snippet').S

function M.copy(pos)
  return function_node(function(args) return args[1] end, pos)
end

function M.snip(args)
  local a = {}
  local b = {}
  local c = nil
  for idx, val in ipairs(args) do
    a[idx] = val
    args[idx] = nil
  end
  for key, val in pairs(args) do
    if key == 'condition' then
      c = { condition = val, show_condition = val }
    else
      b[key] = val
    end
  end
  return snippet(b, a, c)
end

function M.begins(s)
  return function(line)
    return line == s
  end
end

return M
