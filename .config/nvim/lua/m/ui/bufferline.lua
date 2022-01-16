local api = vim.api
local fn = vim.fn
local H = require('m.ui.palette').hl
local bl = require('m.ui.buf')

local M = {}

--- pending redraw flag
local pending_redraw = false
--- pending buffer reload flag
local pending_reload = true
--- pending buffer properties update flag
local pending_update = true

local function make_lookup(t)
  for k, v in ipairs(t) do
    t[k] = nil
    t[v] = true
  end
  return t
end

local UPDATE_EVENTS = {
  'BufEnter', 'BufAdd', 'BufLeave', 'BufDelete',
  'BufModifiedSet', 'BufFilePost', 'TabNew',
  'TabEnter', 'TabClosed', 'FileType', 'VimResized',
}
local UPDATE_OPTIONS = {
  'buflisted', 'readonly', 'modifiable', 'buftype', 'showtabline',
}
local BUF_RELOAD_EVENTS = make_lookup {
  'BufAdd', 'BufDelete', 'BufFilePost',
}
local BUF_UPDATE_EVENTS = make_lookup {
  'BufEnter', 'BufLeave', 'BufModifiedSet', 'TabEnter', 'FileType',
}
local BUF_UPDATE_OPTIONS = make_lookup {
  'readonly', 'modifiable', 'buftype',
}

local NO_BUFS = H'EL'..' no buffers'..H'BG'..'▕'
local NO_BUFS_LEN = 12
local NO_NAME = '[No Name]'

local function render_buf(buf)
  local name = buf.name

  if name == '' then
    name = NO_NAME
  end

  -- changed indicator
  if buf.changed then
    name = name..' +'
  end

  local len = #name + 2

  name = name:gsub('%%', '%%%%')

  -- highlighting
  if buf.current then
    name = H'A'..' '..name..H'AS'..'▕'
  else
    name = H'B'..' '..name..H'BS'..'▕'
  end

  -- clickable
  name = '%'..buf.bufnr..'@BufferlineGoto@'..name..'%X'

  return name, len
end

local function process()
  if pending_reload then
    pending_reload = false
    pending_update = false
    bl.reload()
    return true
  elseif pending_update then
    pending_update = false
    bl.update()
    return true
  end
  return false
end

--- Render buffer section
local function render_bufs(width)
  if process() then
    for _, buf in ipairs(bl.buflist) do
      buf.display, buf.displaylen = render_buf(buf)
    end
  end

  if #bl.buflist == 0 then
    return NO_BUFS, NO_BUFS_LEN
  end

  local strs = {}
  local len = 0
  local curidx = nil

  for i, buf in ipairs(bl.buflist) do
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
  if trimbeg then s = H'EL' .. '<' .. s end
  if trimend then s = s .. H'EL' .. '>' end
  return s, len
end

--- Render tab section
local function render_tabs()
  local last = fn.tabpagenr('$')
  if last > 1 then
    return ' '..fn.tabpagenr()..'/'..last..' '
  end
end

--- Redraw bufferline
function M.redraw()
  pending_redraw = false
  local width = api.nvim_get_option('columns')

  local tab = render_tabs()
  if tab then
    width = width - #tab
    tab = H'B'..tab
  end

  local bufs, len = render_bufs(width)
  width = width - len

  local spacer
  if width > 0 then
    spacer = H'BG'..string.rep('▁', width)
  end

  api.nvim_set_var('bufferline', (bufs or '')..(spacer or '')..(tab or ''))
  vim.cmd('redrawtabline')
end

--- Update bufferline
--- reload buffers if ev is true
function M.update(ev, opt)
  local show = api.nvim_get_option('showtabline')
  if show == 0 or (show == 1 and fn.tabpagenr('$') < 2) then
    return
  end

  if ev then
    if ev == true or BUF_RELOAD_EVENTS[ev] or opt == 'buflisted' then
      pending_reload = true
    elseif BUF_UPDATE_EVENTS[ev] or BUF_UPDATE_OPTIONS[opt] then
      pending_update = true
    end
  end

  pending_redraw = true
  -- if not pending_redraw then
  --   pending_redraw = true
  --   vim.schedule(M.redraw)
  -- end
end

local function on_start()
  if pending_redraw then
    pending_redraw = true
    M.redraw()
  end
end

function M.setup()
  if not _G.m then _G.m = {} end
  _G.m.bufferline = M

  local ns = api.nvim_create_namespace('bufferline')
  api.nvim_set_decoration_provider(ns, { on_start = on_start })

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

  api.nvim_set_var('bufferline', '')
  api.nvim_set_option('tabline', [[%{%g:bufferline%}]])
  api.nvim_set_option('showtabline', 2)
end

return M
