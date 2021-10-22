local M = {}

local function_node = require('luasnip.nodes.functionNode').F
local snippet = require('luasnip.nodes.snippet').S

function M.copy(pos)
  return function_node(function(args) return args[1] end, pos)
end

function M.snip(args)
  local a = {}
  local b = {}
  for idx, val in ipairs(args) do
    a[idx] = val
    args[idx] = nil
  end
  for key, val in pairs(args) do
    b[key] = val
  end
  return snippet(b, a)
end

return M
