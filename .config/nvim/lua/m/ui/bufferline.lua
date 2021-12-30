local api = vim.api
local fn = vim.fn
local hl = require('m.ui.palette').hl

local M = {}

--- redraw flag
local redraw = false
--- reload buffers flag
local bufs_reload = true
--- update buffer properties flag
local bufs_update = true
--- buffer list
local buflist = {}

local function make_lookup(t)
  for k, v in ipairs(t) do
    t[k] = nil
    t[v] = true
  end
  return t
end

local UPDATE_EVENTS = {
  'BufEnter', 'BufAdd', 'BufLeave', 'BufDelete', 'BufModifiedSet',
  'TabNew', 'TabEnter', 'TabClosed', 'FileType', 'VimResized',
}
local UPDATE_OPTIONS = {
  'buflisted', 'readonly', 'modifiable', 'buftype', 'showtabline',
}
local BUF_RELOAD_EVENTS = make_lookup {
  'BufAdd', 'BufDelete',
}
local BUF_UPDATE_EVENTS = make_lookup {
  'BufEnter', 'BufLeave', 'BufModifiedSet', 'TabEnter', 'FileType',
}
local BUF_UPDATE_OPTIONS = make_lookup {
  'readonly', 'modifiable', 'buftype',
}

local NO_BUFS = hl('EL')..' no buffers'..hl('BG')..'▕'
local NO_NAME = '[No Name]'
local SHORTEN = true

--- Update smart paths
local function update_paths(bufs)
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

    table.insert(bs, b)
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

local function render_buf(buf)
  local name = buf.name

  if name == '' then
    name = NO_NAME
  end

  -- changed and readonly indicators
  if buf.changed then
    if buf.readonly then
      name = name..' +-'
    else
      name = name..' +'
    end
  elseif buf.readonly then
    name = name..' -'
  end

  local len = #name + 2

  name = name:gsub('%%', '%%%%')

  -- highlighting
  if buf.current then
    name = hl('A')..' '..name..hl('AS')..'▕'
  else
    name = hl('B')..' '..name..hl('BS')..'▕'
  end

  -- clickable
  name = '%'..buf.bufnr..'@BufferlineGoto@'..name..'%X'

  return name, len
end

--- Update all buffers
local function reload_bufs()
  bufs_reload = false
  bufs_update = false

  local opt = api.nvim_buf_get_option
  local curbuf = api.nvim_get_current_buf()
  local bufinfo = fn.getbufinfo({ buflisted = 1 })

  for i, info in ipairs(bufinfo) do
    local bufnr = info.bufnr
    local buftype = opt(bufnr, 'buftype')

    local buf = {
      bufnr = bufnr,
      path = info.name,

      current = bufnr == curbuf,
      changed = info.changed == 1,
      buftype = buftype,
      readonly =
        (opt(bufnr, 'readonly') or not opt(bufnr, 'modifiable'))
        and opt(bufnr, 'filetype') ~= 'help',
    }

    bufinfo[i] = buf
  end

  -- shorten paths
  buflist = update_paths(bufinfo)

  -- render individual buffers
  for _, buf in ipairs(buflist) do
    local str, slen = render_buf(buf)
    buf.display = str
    buf.displaylen = slen
  end
end

--- Update buffer properties
local function update_bufs()
  bufs_update = false

  local opt = api.nvim_buf_get_option
  local curbuf = api.nvim_get_current_buf()

  for _, buf in ipairs(buflist) do
    local bufnr = buf.bufnr
    buf.current = bufnr == curbuf
    buf.changed = opt(bufnr, 'modified')
    buf.buftype = opt(bufnr, 'buftype')
    buf.readonly =
      (opt(bufnr, 'readonly') or not opt(bufnr, 'modifiable'))
      and opt(bufnr, 'filetype') ~= 'help'

    local str, slen = render_buf(buf)
    buf.display = str
    buf.displaylen = slen
  end
end

--- Render the buffer section
local function render_bufs(width)
  if bufs_reload then
    reload_bufs()
  elseif bufs_update then
    update_bufs()
  end

  if #buflist == 0 then
    return NO_BUFS, 12
  end

  local strs = {}
  local len = 0
  local curidx = nil

  for i, buf in ipairs(buflist) do
    len = len + buf.displaylen
    table.insert(strs, { buf.display, buf.displaylen })
    if buf.current then
      curidx = i
    end
  end

  if not curidx then
    curidx = 1
  end

  local trimbeg = false
  local trimend = false

  while len > width and strs[curidx + 2] do
    len = len - strs[#strs][2]
    strs[#strs] = nil
    if not trimend then
      trimend = true
      len = len + 1
    end
  end

  while len > width and curidx > 2 do
    len = len - strs[1][2]
    table.remove(strs, 1)
    curidx = curidx - 1
    if not trimbeg then
      trimbeg = true
      len = len + 1
    end
  end

  if len > width and strs[curidx + 1] then
    len = len - strs[#strs][2]
    strs[#strs] = nil
    if not trimend then
      trimend = true
      len = len + 1
    end
  end

  if len > width and curidx > 1 then
    len = len - strs[1][2]
    table.remove(strs, 1)
    curidx = curidx - 1
    if not trimbeg then
      trimbeg = true
      len = len + 1
    end
  end

  for k, v in ipairs(strs) do
    strs[k] = v[1]
  end
  local s = table.concat(strs)
  if trimbeg then s = hl('EL')..'<'..s end
  if trimend then s = s..hl('EL')..'>' end
  return s, len
end

--- Render the tab section
local function render_tabs()
  local max = fn.tabpagenr('$')
  if max == 1 then return end
  return ' '..fn.tabpagenr()..'/'..max..' '
end

--- Render bufferline
function M.render()
  local width = vim.o.columns
  local tab = render_tabs() or ''
  local tlen = #tab
  local buf, blen = render_bufs(width - tlen)
  local str = (buf or '')..hl('BG')..string.rep('▁', width - blen - tlen)..hl('B')..tab
  vim.g.bufferline = str
  vim.cmd('redrawtabline')
end

local function _update()
  if redraw then
    redraw = false
    M.render()
  end
end

--- Update bufferline
function M.update(ev, opt)
  if vim.o.showtabline == 0 then
    return
  end

  if ev == nil and opt == nil then
    bufs_reload = true
  elseif BUF_RELOAD_EVENTS[ev] or opt == 'buflisted' then
    bufs_reload = true
  elseif BUF_UPDATE_EVENTS[ev] or BUF_UPDATE_OPTIONS[opt] then
    bufs_update = true
  end

  if not redraw then
    redraw = true
    vim.schedule(_update)
  end
end

function M.setup()
  _G.m = _G.m or {}
  _G.m.bufferline = M

  vim.cmd([[
    function! BufferlineGoto(minwid, clicks, btn, modifiers)
      execute 'b'..a:minwid
    endfunction
  ]])

  local lines = {}
  for _, v in ipairs(UPDATE_EVENTS) do
    table.insert(lines, 'autocmd '..v..' * lua m.bufferline.update("'..v..'")')
  end
  for _, v in ipairs(UPDATE_OPTIONS) do
    table.insert(lines, 'autocmd OptionSet '..v..' lua m.bufferline.update("OptionSet", "'..v..'")')
  end
  vim.cmd(string.format([[
    augroup Bufferline
      autocmd!
      %s
    augroup end
  ]], table.concat(lines, '\n')))

  vim.g.bufferline = ''
  vim.o.tabline = [[%{%g:bufferline%}]]
  vim.o.showtabline = 2
end

return M
