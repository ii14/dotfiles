local api = vim.api
local fn = vim.fn
local bufopt = api.nvim_buf_get_option

local M = {}

local SHORTEN = true

--- Buffer list
M.buflist = {}

-- TODO: shorten buffer names

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
      name = info.name:match('[^/]*$'),

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
