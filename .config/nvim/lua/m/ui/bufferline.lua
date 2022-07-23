local api, fn = vim.api, vim.fn
local bl = require('m.buf')
local H = require('m.ui.palette').hl

local bufferline = {}

---Pending redraw
local pending = false


local EVENTS = {
  'BufEnter',
  'BufFilePost',
  'BufLeave',
  'BufModifiedSet',
  'FileType',
  'TabClosed',
  'TabEnter',
  'TabNew',
  'VimResized',
}

local EVENTS_USER = {
  'BuflistReorder',
  'BuflistUpdate',
}

local EVENTS_OPTIONSET = {
  'buftype',
  'modifiable',
  'modified',
  'readonly',
  'showtabline',
}


local NO_BUFS = H'EL'..' no buffers'..H'BG'..'▕'
local NO_BUFS_LEN = 12
local NO_NAME = '[No Name]'


local get_name = api.nvim_buf_get_name
local get_opt = api.nvim_buf_get_option


---Get buffer list
local function get()
  local curbuf = api.nvim_get_current_buf()
  local altbuf = fn.bufnr('#')

  local bufs = {}
  for i, bufnr in ipairs(bl.list) do
    local name = get_name(bufnr)
    bufs[i] = {
      bufnr = bufnr,
      path = name,
      name = name:match('[^/]*$'),

      -- TODO: is modified the same as getbufinfo().changed?
      changed = get_opt(bufnr, 'modified'),
      buftype = get_opt(bufnr, 'buftype'),
      readonly =
        (get_opt(bufnr, 'readonly') or not get_opt(bufnr, 'modifiable'))
        and get_opt(bufnr, 'filetype') ~= 'help',

      current = bufnr == curbuf,
      alternate = bufnr == altbuf,
    }
  end

  return bufs
end


---Render buffer section
local function render_bufs(width)
  local ok, bufs = pcall(get)
  -- if events that update the buffer list were
  -- silenced and an error occurred, force update
  if not ok then
    bl.update()
    bufs = get()
  end

  for _, buf in ipairs(bufs) do
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

    buf.display, buf.displaylen = name, len
  end

  if #bufs == 0 then
    return NO_BUFS, NO_BUFS_LEN
  end

  local strs = {}
  local len = 0
  local curidx = nil

  for i, buf in ipairs(bufs) do
    len = len + buf.displaylen
    strs[#strs+1] = { buf.display, buf.displaylen }
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

---Render tab section
local function render_tabs()
  local last = fn.tabpagenr('$')
  if last > 1 then
    return ' '..fn.tabpagenr()..'/'..last..' '
  end
end


---Redraw bufferline
function bufferline.redraw()
  pending = false

  local show = api.nvim_get_option('showtabline')
  if show == 0 or (show == 1 and fn.tabpagenr('$') < 2) then
    return
  end

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


---Schedule update
function bufferline.update()
  local show = api.nvim_get_option('showtabline')
  if show == 0 or (show == 1 and fn.tabpagenr('$') < 2) then
    return
  end

  if not pending then
    pending = true
    vim.schedule(function()
      if pending then
        bufferline.redraw()
      end
    end)
  end
end


---Initialize bufferline
function bufferline.setup()
  vim.cmd([[
    function! BufferlineGoto(minwid, clicks, btn, modifiers)
      execute 'b'..a:minwid
    endfunction
  ]])

  local augroup = api.nvim_create_augroup('m_bufferline', {})

  local function callback()
    bufferline.update()
  end

  api.nvim_create_autocmd(EVENTS, {
    desc = 'm.bufferline: update',
    callback = callback,
    group = augroup,
  })

  api.nvim_create_autocmd('User', {
    desc = 'm.bufferline: update',
    pattern = EVENTS_USER,
    callback = callback,
    group = augroup,
  })

  api.nvim_create_autocmd('OptionSet', {
    desc = 'm.bufferline: update',
    pattern = EVENTS_OPTIONSET,
    callback = callback,
    group = augroup,
  })

  api.nvim_set_var('bufferline', '')
  api.nvim_set_option('tabline', [[%{%g:bufferline%}]])
  api.nvim_set_option('showtabline', 2)
end

return bufferline
