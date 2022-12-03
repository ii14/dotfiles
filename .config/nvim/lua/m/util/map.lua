local set_keymap = vim.api.nvim_set_keymap
local buf_set_keymap = vim.api.nvim_buf_set_keymap
-- local replace_termcodes = vim.api.nvim_replace_termcodes

local buf_map_cache = {}
local function buf_map(buf)
  local fn = buf_map_cache[buf]
  if not fn then
    function fn(mode, lhs, rhs, opts)
      buf_set_keymap(buf, mode, lhs, rhs, opts)
    end
    buf_map_cache[buf] = fn
  end
  return fn
end

local function resolve_mode(key)
  if key ~= '' then
    local modes = {}
    for char in key:gmatch('.') do
      if not char:find('[!abcilnostvx]') then
        error(('invalid mode "%s"'):format(char))
      end
      modes[char] = true
    end

    -- alias a -> :map and b -> :map!
    if modes.a then
      modes.a = nil
      modes[''] = true
    end
    if modes.b then
      modes.b = nil
      modes['!'] = true
    end

    -- convert xs -> :vmap, nvo -> :map, ic -> :map!
    if modes.x and modes.s then
      modes.v = true
    end
    if modes.n and modes.v and modes.o then
      modes[''] = true
    end
    if modes.i and modes.c then
      modes['!'] = true
    end

    -- remove redundant modes for :map and :vmap
    if modes[''] then
      modes.n = nil
      modes.v = nil
      modes.o = nil
      modes.x = nil
      modes.s = nil
    elseif modes.v then
      modes.x = nil
      modes.s = nil
    end

    -- remove redundant modes for :lmap and :map!
    if modes.l then
      modes['!'] = nil
      modes.i = nil
      modes.c = nil
    elseif modes['!'] then
      modes.i = nil
      modes.c = nil
    end

    return modes
  else
    return {''}
  end
end

local function merge(t, n)
  if n then
    for k, v in pairs(n) do
      t[k] = v
    end
  end
  return t
end

-- local function wrap_expr(func, replace)
--   local cb = func
--   if replace ~= false then
--     return function()
--       local res = cb()
--       return res ~= nil and (replace_termcodes(res, true, true, true)) or ''
--     end
--   else
--     return function()
--       local res = cb() or ''
--       return res ~= nil and (res) or ''
--     end
--   end
-- end

local function index(self, key)
  assert(type(key) == 'string', 'invalid key')
  local modes = resolve_mode(key)

  local function map_fn(arg1, arg2, arg3)
    local opts, maps

    if type(arg1) == 'string' and (type(arg2) == 'string' or type(arg2) == 'function') then
      opts = arg3
      assert(opts == nil or type(opts) == 'table', 'expected table as argument #3')
    elseif type(arg1) == 'table' then
      opts, maps = arg2, arg1
      assert(opts == nil or type(opts) == 'table', 'expected table as argument #2')
    else
      error('expected (string, string|function, table?) or (table, table?)')
    end

    do
      local opts_copy = {}
      merge(opts_copy, rawget(self, 'opts'))
      merge(opts_copy, opts)
      opts = opts_copy
    end

    if opts.remap then
      opts.remap = nil
      opts.noremap = true
    elseif opts.noremap == nil then
      opts.noremap = true
    end

    local replace_keycodes = opts.replace_keycodes

    local map
    if not opts.buf then
      map = set_keymap
    else
      map = buf_map(opts.buf)
      opts.buf = nil
    end

    if not maps then
      if type(arg2) == 'function' then
        -- if opts.expr then
        --   opts.callback = wrap_expr(arg2, opts.replace_keycodes)
        -- else
          opts.callback = arg2
        -- end
        arg2 = ''
        if opts.expr and replace_keycodes == nil then
          opts.replace_keycodes = true
        end
      else
        opts.callback = nil
      end

      for mode in pairs(modes) do
        map(mode, arg1, arg2, opts)
      end
    else
      for lhs, rhs in pairs(maps) do
        if type(rhs) == 'function' then
          -- if opts.expr then
          --   opts.callback = wrap_expr(rhs, opts.replace_keycodes)
          -- else
            opts.callback = rhs
          -- end
          rhs = ''
          if opts.expr and replace_keycodes == nil then
            opts.replace_keycodes = true
          end
        elseif type(rhs) == 'string' then
          opts.callback = nil
          if opts.expr and replace_keycodes == nil then
            opts.replace_keycodes = false
          end
        else
          error('expected string or function as rhs')
        end

        for mode in pairs(modes) do
          map(mode, lhs, rhs, opts)
        end
      end
    end
  end

  rawset(self, key, map_fn)
  return map_fn
end

local mt = { __index = index }

local function new(opts)
  assert(opts == nil or type(opts) == 'table', 'expected table')
  return setmetatable({
    opts = opts,
    new = new,
  }, mt)
end

---# Keymap definitions
---
------
---*Examples:*
---- Basic normal mode mapping
---```lua
---  map.n('a', ':a<CR>')
---```
---- Multiple modes: normal and visual mode
---```lua
---  map.nx('b', ':b<CR>')
---```
---- `a` is `:map`, `b` is `:map!`
---```lua
---  map.a('c', ':c<CR>')
---  map.b('d', ':d<CR>')
---```
---- Attributes
---```lua
---  map.n('e', ':e<CR>', { buffer=0, remap=true })
---```
---- Lua function
---```lua
---  map.n('f', function() print('f') end)
---```
---- Batch
---```lua
---  map.n({ g = ':g<CR>', h = ':h<CR>' }, { expr=true })
---```
---
------
---*Map table:*
--- KEY      | a n b i c v x s o t l
-------------|-----------------------
--- Normal   | ✓ ✓
--- Insert   |     ✓ ✓             ✓
--- Command  |     ✓   ✓
--- Visual   | ✓         ✓ ✓
--- Select   | ✓         ✓   ✓
--- Operator |                 ✓
--- Terminal |                   ✓
--- Lang-Arg |                     ✓
local map = new()

return map
