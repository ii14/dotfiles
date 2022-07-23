local api, uv = vim.api, vim.loop

local m = {
  buf = require('m.buf'),
  map = require('m.util.map'),
  lazy = require('m.util.lazy'),
}


---Pretty print
function m.P(...)
  local n = select('#', ...)
  local p = {...}
  for i = 1, n do
    p[i] = vim.inspect(p[i])
  end
  print(table.concat(p, ', '))
  return ...
end


---Reload module
---@param mod string
---@return any
function m.R(mod)
  assert(type(mod) == 'string', 'expected string')
  package.loaded[mod] = nil
  return require(mod)
end


---Replace termcodes
---@type table<string, string> | fun(s: string): string
m.T = setmetatable({}, {
  __index = function(t, s)
    assert(type(s) == 'string', 'expected string')
    local r = api.nvim_replace_termcodes(s, true, false, true)
    rawset(t, s, r)
    return r
  end,
  __call = function(t, s)
    assert(type(s) == 'string', 'expected string')
    return t[s]
  end,
})


---Print message
---@param text string message
---@param hlgroup? string highlight group
---@param history? boolean save to :messages history, defaults to false
---@overload fun(chunks: { [1]: string, [2]: string }[], history?: boolean)
function m.echo(text, hlgroup, history)
  if type(text) == 'string' then
    assert(hlgroup == nil or type(hlgroup) == 'string', 'expected string as argument #2')
    if history == nil then
      history = false
    elseif type(history) ~= 'boolean' then
      error('expected boolean as argument #2')
    end
    api.nvim_echo({{ text, hlgroup }}, history, {})
  elseif type(text) == 'table' then
    if hlgroup == nil then
      hlgroup = false
    elseif type(hlgroup) ~= 'boolean' then
      error('expected boolean as argument #2')
    end
    api.nvim_echo(text, hlgroup, {})
  else
    error('expected string or table as argument #1')
  end
end

---Print message and save it to :messages history
---@param text string message
---@param hlgroup? string highlight group
---@overload fun(chunks: { [1]: string, [2]: string }[])
function m.echomsg(text, hlgroup)
  if type(text) == 'string' then
    m.echo(text, hlgroup, true)
  else
    m.echo(text, true)
  end
end


---Pack varargs
function m.pack(...)
  return { n = select('#', ...), ... }
end

---Unpack packed varargs
---@param pack table
---@param from? integer
---@param to? integer
function m.unpack(pack, from, to)
  return unpack(pack, from or 1, to or assert(pack.n, 'not a pack'))
end


---Shallow copy
---@generic T : table
---@param t T
---@return T
function m.copy(t)
  assert(type(t) == 'table', 'expected table')
  local copy = {}
  for k, v in pairs(t) do
    copy[k] = v
  end
  return copy
end

---Create a lookup table
---@generic T
---@param t T[]
---@return table<T, boolean>
function m.make_lookup(t)
  assert(type(t) == 'table', 'expected table')
  local r = {}
  for _, v in ipairs(t) do
    r[v] = true
  end
  return r
end

---Reverse table in place
---@generic T
---@param t T[]
---@return T[]
function m.reverse(t)
  assert(type(t) == 'table', 'expected table')
  local len = #t
  for i = 0, #t / 2 - 1 do
    t[i+1], t[len-i] = t[len-i], t[i+1]
  end
  return t
end

---Reversed ipairs
---@param t any[]
function m.rpairs(t)
  assert(type(t) == 'table', 'expected table')
  local i = #t
  return function()
    local k, v = i, t[i]
    i = i - 1
    if v then
      return k, v
    end
  end
end

---Everything that is not indexed by ipairs
---@param t table
function m.kpairs(t)
  assert(type(t) == 'table', 'expected table')

  if t[1] == nil then
    return pairs(t)
  end

  -- `#` behavior is undefined when table is not a sequence.
  -- traverse through the table to get the real length.
  local i = 1
  while t[i + 1] ~= nil do
    i = i + 1
  end

  local modf = math.modf
  local k, v
  return function()
    repeat
      k, v = next(t, k)
    until type(k) ~= 'number' or k < 1 or k > i or select(2, modf(k)) ~= 0
    return k, v
  end
end


---Create a new debounce timer
---@param ms integer
---@param fast? boolean
function m.new_debounce(ms, fast)
  assert(type(ms) == 'number', 'expected number as argument #1')
  assert(fast == nil or type(fast) == 'boolean', 'expected boolean as argument #2')

  local timer = uv.new_timer() -- rely on gc?
  ---@param func function
  return function(func, ...)
    assert(type(func) == 'function', 'expected function as argument #1')
    local args = m.pack(...)
    timer:stop()
    timer:start(ms, 0, function()
      timer:stop()
      if fast or not vim.in_fast_event() then
        func(m.unpack(args))
      else
        vim.schedule(function()
          func(m.unpack(args))
        end)
      end
    end)
  end
end

---Wrap function with a debounce timer
---@generic F : function
---@param func F
---@param ms integer
---@param fast? boolean
---@return F
function m.debounce_wrap(func, ms, fast)
  assert(type(func) == 'function', 'expected function as argument #1')
  assert(type(ms) == 'number', 'expected number as argument #2')
  assert(fast == nil or type(fast) == 'boolean', 'expected boolean as argument #3')

  local debounce = m.new_debounce(ms, fast)
  return function(...)
    debounce(func, ...)
  end
end


---Profiling
---@param ts number? timestamp
---@param msg string? message
---@return number
function m.reltime(ts, msg)
  if ts then
    local f = (uv.hrtime() - ts) / 1000000
    print(('%-20s %.3fms'):format(msg or '', f))
  end
  return uv.hrtime()
end


return m
