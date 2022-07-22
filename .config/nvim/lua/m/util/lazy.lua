---# Lazy expressions
---Build a lazy expression by simply indexing this object.
---Convert it into a callback function by using the unary
---`-` operator.
---
------
---*Examples:*
---- Basic
---```lua
---  local cb = -lazy.vim.lsp.buf.format({ bufnr = 0 })
---```
---- Partial
---```lua
---  local lsp = lazy.vim.lsp.buf
---  local cb1, cb2 = -lsp.definition(), -lsp.declaration()
---```
---- require
---```lua
---  local cb = -lazy.require('mod').foo.bar(1, 2, 3)
---```
---- Lazy function call with a lazy value
---```lua
---  local cb = -lazy.foo(lazy.bar)
---  -- NOTE: Only the direct arguments are checked if they
---  -- are lazy values in need to be evaluated. For lazy
---  -- tables use a function wrapper.
---```
---- Wrap function to create a lazy value
---```lua
---  local cb = -lazy.foo(lazy(function()
---    return { 'lazy', 'table' }
---  end))
---```
---- Change starting environment
---```lua
---  -- start indexing from `vim` table
---  local cb = -lazy(vim).split('a b c', '%s+')
---  -- start indexing from `require` function
---  local cb = -lazy(require)('foo').bar()
---```
local lazy = {}
local lazy_mt

---evaluate node
local function eval(node)
  local mt = getmetatable(node)
  return mt ~= lazy_mt and node or (-node)()
end

---evaluate node pack
---@param pack table arguments
---@param skip? boolean skip first index
local function eval_pack(pack, skip)
  skip = skip and 2 or 1
  local copy = {}
  for i = skip, pack.n do
    copy[i] = eval(pack[i])
  end
  return unpack(copy, skip, pack.n)
end

---store data under weak references to empty tables.
---storing the data on the table itself would mess
---up the `__index` metamethod, and that needs to be
---available for creation of nodes.
local refs = setmetatable({}, { __mode = 'k' })

---create a reference
local function mkref(data)
  local r = setmetatable({}, lazy_mt)
  refs[r] = data
  return r
end

local default_env = { env = _G }

lazy_mt = {

  __index = function(self, index)
    assert(index ~= nil, 'index cannot be nil')
    return mkref {
      prev = assert(refs[self]),
      index = index,
    }
  end,

  __call = function(self, ...)
    local this = assert(refs[self])
    return mkref {
      prev = this,
      call = this.prev ~= refs[...] and 'f' or 'm',
      n = select('#', ...),
      ...,
    }
  end,

  __unm = function(self)
    local this = assert(refs[self])

    -- wrap function: lazy(function() end)
    if this.env then
      if type(this.env) == 'table' or type(this.env) == 'userdata' then
        local mt = getmetatable(this.env)
        assert(mt and mt.__call, 'cannot wrap function: not a function')
      elseif type(this.env) ~= 'function' then
        error('cannot wrap function: not a function')
      end
      return function()
        return this.env()
      end
    end

    return function()
      local nodes, node = {}, this
      while true do
        node = node.prev
        if node == nil then
          break
        end
        nodes[#nodes+1] = node
      end

      local val, prev = assert(nodes[#nodes].env), nil

      for i = #nodes - 1, 1, -1 do
        node = nodes[i]
        if node.call == 'f' then
          val = val(eval_pack(node))
        elseif node.call == 'm' then
          val = val(prev, eval_pack(node, true))
        else
          prev = val
          val = assert(val[eval(assert(node.index))], 'attempt to index a nil value')
        end
      end

      if this.call == 'f' then
        return val(eval_pack(this))
      elseif this.call == 'm' then
        return val(prev, eval_pack(this, true))
      else
        return (assert(val[eval(assert(this.index))], 'attempt to index a nil value'))
      end
    end
  end,

  __newindex = function()
    error('assignment not allowed')
  end,

}

setmetatable(lazy, {

  __index = function(_, index)
    assert(index ~= nil, 'index cannot be nil')
    return mkref { prev = default_env, index = index }
  end,

  __call = function(_, arg)
    assert(type(arg) == 'table' or type(arg) == 'function', 'expected table or function')
    return mkref { env = arg }
  end,

  __unm = function()
    error('empty expression')
  end,

  __newindex = function()
    error('assignment not allowed')
  end,

})

return lazy
