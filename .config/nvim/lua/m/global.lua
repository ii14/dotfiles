--- Pretty print
_G.P = function(...)
  local n = select('#', ...)
  local p = {...}
  for i = 1, n do
    p[i] = vim.inspect(p[i])
  end
  print(table.concat(p, ', '))
  return ...
end

--- Reload module
_G.R = function(p)
  assert(type(p) == 'string', 'expected string')
  package.loaded[p] = nil
  return require(p)
end

--- Reversed ipairs
function _G.rpairs(t)
  assert(type(t) == 'table', 'expected table')
  -- `#` behavior is undefined when table is not a sequence
  local i = 0
  while t[i + 1] do
    i = i + 1
  end

  return function()
    local k, v = i, t[i]
    i = i - 1
    if v then
      return k, v
    end
  end
end

--- Everything that is not indexed by ipairs
function _G.kpairs(t)
  assert(type(t) == 'table', 'expected table')
  if t[1] == nil then
    return pairs(t)
  end

  -- `#` behavior is undefined when table is not a sequence
  local m = 1
  while t[m + 1] ~= nil do
    m = m + 1
  end

  local modf = math.modf
  local k, v
  return function()
    repeat
      k, v = next(t, k)
    until type(k) ~= 'number' or k <= 0 or k > m or select(2, modf(k)) ~= 0
    return k, v
  end
end

--- for each
function _G.each(thing)
  local function start(x)
    return x(x)
  end

  local function body(x)
    local doit = function(...)
      thing(...)
      return x(x)
    end
    return doit
  end

  return start(body)
end

--- neovim API
_G.nvim = {}
for k, v in pairs(vim.api) do
  _G.nvim[k:gsub('^nvim_', '')] = v
end

--- Profiler
function _G.reltime(ts, msg)
  if ts then
    local f = vim.fn.reltimefloat(vim.fn.reltime(ts)) * 1000
    print(('%-20s %.3fms'):format(msg or '', f))
  end
  return vim.fn.reltime()
end
