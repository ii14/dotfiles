local api = vim.api
local fn = vim.fn
local bufopt = api.nvim_buf_get_option

local M = {}

local SHORTEN = true

--- Buffer list
M.buflist = {}

--- Update smart paths
local function shorten_paths(bufs)
  -- thanks to mengelbrecht/lightline-bufferline for the algorithm
  local bs = {}
  local count_per_tail = {}

  for _, buf in ipairs(bufs) do
    local b = { buf = buf }
    local name
    if SHORTEN then
      name = fn.pathshorten(buf.path)
    else
      name = buf.path
    end

    if name and name ~= '' then
      b.path = fn.fnamemodify(name, ':p:~:.')
      local sep = fn.strridx(b.path, '/')
      if sep ~= -1 and b.path:sub(sep + 1) == '/' then
        sep = fn.strridx(b.path, '/', sep - 1)
      end
      b.sep = sep
      b.label = b.path:sub(sep + 2)
      count_per_tail[b.label] = (count_per_tail[b.label] or 0) + 1
    else
      b.path = name
      b.label = name
    end

    bs[#bs+1] = b
  end

  while true do
    local n = 0
    for k, v in pairs(count_per_tail) do
      if v > 1 then
        n = n + 1
      else
        count_per_tail[k] = nil
      end
    end
    if n == 0 then
      break
    end

    local ambiguous = count_per_tail
    count_per_tail = {}
    for _, b in ipairs(bs) do
      if #b.path > 0 then
        if b.sep > -1 and ambiguous[b.label] then
          b.sep = fn.strridx(b.path, '/', b.sep - 1)
          b.label = b.path:sub(b.sep + 2)
        end
        count_per_tail[b.label] = (count_per_tail[b.label] or 0) + 1
      end
    end
  end

  for _, v in ipairs(bs) do
    local buf = v.buf
    v.buf = nil
    buf.name = v.label
  end
  return bufs
end

--- Reload buffer list
function M.reload()
  local curbuf = api.nvim_get_current_buf()
  local altbuf = fn.bufnr('#')

  -- get buffers
  local bufinfo = fn.getbufinfo({ buflisted = 1 })
  for i, info in ipairs(bufinfo) do
    local bufnr = info.bufnr
    local buftype = bufopt(bufnr, 'buftype')

    local buf = {
      bufnr = bufnr,
      path = info.name,

      current = bufnr == curbuf,
      alternate = bufnr == altbuf,
      changed = info.changed == 1,
      buftype = buftype,
      readonly =
        (bufopt(bufnr, 'readonly') or not bufopt(bufnr, 'modifiable'))
        and bufopt(bufnr, 'filetype') ~= 'help',
    }

    bufinfo[i] = buf
  end

  local prev = {}
  for i, buf in ipairs(M.buflist) do
    prev[buf.bufnr] = i
  end

  -- merge with previous list
  for _, buf in ipairs(bufinfo) do
    local idx = prev[buf.bufnr]
    if idx then
      M.buflist[idx] = buf
      prev[buf.bufnr] = nil
    else
      M.buflist[#M.buflist+1] = buf
    end
  end

  -- remove deleted buffers
  local del = {}
  for _, idx in pairs(prev) do
    del[#del+1] = idx
  end
  table.sort(del)
  for i = #del, 1, -1 do
    table.remove(M.buflist, del[i])
  end

  shorten_paths(M.buflist)
end

--- Update buffer properties
function M.update()
  local curbuf = api.nvim_get_current_buf()
  local altbuf = fn.bufnr('#')

  for _, buf in ipairs(M.buflist) do
    local bufnr = buf.bufnr
    buf.current = bufnr == curbuf
    buf.alternate = bufnr == altbuf
    buf.changed = bufopt(bufnr, 'modified')
    buf.buftype = bufopt(bufnr, 'buftype')
    buf.readonly =
      (bufopt(bufnr, 'readonly') or not bufopt(bufnr, 'modifiable'))
      and bufopt(bufnr, 'filetype') ~= 'help'
  end
end

--- Get buffer at index
function M.go(idx)
  local buf = M.buflist[idx]
  if buf then
    api.nvim_set_current_buf(buf.bufnr)
  end
end

--- Get index of buffer
function M.index(bufnr)
  for i, buf in ipairs(M.buflist) do
    if bufnr == buf.bufnr then
      return i
    end
  end
end

--- Go to next buffer
function M.next()
  local idx = M.index(api.nvim_get_current_buf())
  if idx then
    if idx < #M.buflist then
      M.go(idx + 1)
    else
      M.go(1)
    end
  elseif #M.buflist > 0 then
    M.go(1)
  end
end

--- Go to previous buffer
function M.prev()
  local idx = M.index(api.nvim_get_current_buf())
  if idx then
    if idx > 1 then
      M.go(idx - 1)
    else
      M.go(#M.buflist)
    end
  elseif #M.buflist > 0 then
    M.go(#M.buflist)
  end
end

--- Move current buffer right
function M.move_right()
  local idx = M.index(api.nvim_get_current_buf())
  if idx then
    if idx < #M.buflist then
      local buf = M.buflist[idx]
      M.buflist[idx] = M.buflist[idx + 1]
      M.buflist[idx + 1] = buf
      require('m.ui.bufferline').update()
      vim.cmd('redraw')
    elseif #M.buflist > 1 then
      local buf = table.remove(M.buflist, #M.buflist)
      table.insert(M.buflist, 1, buf)
      require('m.ui.bufferline').update()
      vim.cmd('redraw')
    end
  end
end

--- Move current buffer left
function M.move_left()
  local idx = M.index(api.nvim_get_current_buf())
  if idx then
    if idx > 1 then
      local buf = M.buflist[idx]
      M.buflist[idx] = M.buflist[idx - 1]
      M.buflist[idx - 1] = buf
      require('m.ui.bufferline').update()
      vim.cmd('redraw')
    elseif #M.buflist > 1 then
      local buf = table.remove(M.buflist, 1)
      table.insert(M.buflist, buf)
      require('m.ui.bufferline').update()
      vim.cmd('redraw')
    end
  end
end

return M
