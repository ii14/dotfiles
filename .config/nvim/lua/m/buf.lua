local api = vim.api

---Filter table in place
---@generic T
---@param t T[]
---@param f fun(T): boolean
---@return T[]
local function filter(t, f)
  -- TODO: this is a duplicate of m.filter
  local len = #t
  local j = 1
  for i = 1, len do
    t[j], t[i] = t[i], nil
    if f(t[j]) then
      j = j + 1
    end
  end
  for i = j, len do
    t[i] = nil
  end
  return t
end

local function doautocmd(event, data)
  api.nvim_exec_autocmds('User', {
    pattern = event,
    data = data,
    modeline = false,
  })
end

local function getbuflist()
  return filter(api.nvim_list_bufs(), function(bufnr)
    return api.nvim_buf_get_option(bufnr, 'buflisted')
  end)
end

---Buffer list
---@type number[]
local list = getbuflist()

---Buffer list
local buf = { list = list }

local function validate_bufnr(bufnr)
  if bufnr == nil or bufnr == 0 then
    return api.nvim_get_current_buf()
  elseif type(bufnr) == 'number' then
    return bufnr
  else
    error('invalid bufnr: expected number')
  end
end


do
  local function add(bufnr)
    bufnr = validate_bufnr(bufnr)
    for _, b in ipairs(list) do
      if b == bufnr then
        return
      end
    end
    list[#list+1] = bufnr
    doautocmd('BuflistUpdate', { added = { bufnr } })
  end

  local function remove(bufnr)
    bufnr = validate_bufnr(bufnr)
    local removed = false
    for i = #list, 1, -1 do
      if list[i] == bufnr then
        table.remove(list, i)
        removed = true
      end
    end
    if removed then
      doautocmd('BuflistUpdate', { removed = { bufnr } })
    end
  end

  local augroup = api.nvim_create_augroup('m_buf', {})

  api.nvim_create_autocmd('BufAdd', {
    group = augroup,
    desc = 'm.buf: update',
    callback = function(ctx)
      add(ctx.buf)
    end,
  })

  api.nvim_create_autocmd('BufDelete', {
    group = augroup,
    desc = 'm.buf: update',
    callback = function(ctx)
      remove(ctx.buf)
    end,
  })

  api.nvim_create_autocmd('OptionSet', {
    group = augroup,
    desc = 'm.buf: update',
    pattern = 'buflisted',
    callback = function(ctx)
      if api.nvim_buf_get_option(ctx.buf, 'buflisted') then
        add(ctx.buf)
      else
        remove(ctx.buf)
      end
    end,
  })
end


---Go to buffer at index
---@param idx number
function buf.go(idx)
  assert(type(idx) == 'number', 'expected number')

  idx = ((idx - 1) % #list) + 1
  if list[idx] then
    api.nvim_set_current_buf(list[idx])
  end
end

---Get index of a buffer
---@param bufnr number
---@return number
function buf.index(bufnr)
  bufnr = validate_bufnr(bufnr)
  for i, b in ipairs(list) do
    if b == bufnr then
      return i
    end
  end
end

---Go to next buffer
---@param n number offset
function buf.next(n)
  assert(n == nil or type(n) == 'number', 'expected number')
  n = n or 1

  local idx = buf.index()
  if idx then
    buf.go(idx + n)
  elseif #list > 0 then
    buf.go(1)
  end
end

---Go to previous buffer
---@param n number offset
function buf.prev(n)
  assert(n == nil or type(n) == 'number', 'expected number')
  n = n or 1

  local idx = buf.index()
  if idx then
    buf.go(idx - n)
  elseif #list > 0 then
    buf.go(#list)
  end
end

do
  local function move(n)
    local idx = buf.index()
    if not idx then return end
    local nidx = ((idx + n - 1) % #list) + 1
    if idx ~= nidx then
      table.insert(list, nidx, table.remove(list, idx))
      doautocmd('BuflistReorder')
    end
  end

  function buf.move_right(n)
    assert(n == nil or type(n) == 'number')
    move(n or 1)
  end

  function buf.move_left(n)
    assert(n == nil or type(n) == 'number')
    move(-(n or 1))
  end
end

---Force update
function buf.update()
  local nlist = getbuflist()

  -- save indexes for buffers in previous list
  local prev = {}
  for i, bufnr in ipairs(list) do
    prev[bufnr] = i
  end

  -- merge new buffer list to previous list
  local added = {}
  for _, bufnr in ipairs(nlist) do
    local idx = prev[bufnr]
    if idx then
      prev[bufnr] = nil
    else
      list[#list+1] = bufnr
      added[#added+1] = bufnr
    end
  end

  -- remove missing buffers
  local del = {}
  local removed = {}
  for bufnr, idx in pairs(prev) do
    del[#del+1] = idx
    removed[#removed+1] = bufnr
  end
  table.sort(del)
  for i = #del, 1, -1 do
    table.remove(list, del[i])
  end

  if #added == 0 then
    added = nil
  end
  if #removed == 0 then
    removed = nil
  end
  if added or removed then
    doautocmd('BuflistUpdate', { added = added, removed = removed })
  end
end

return buf
