local api, fn, setl = vim.api, vim.fn, vim.opt_local

local ns = api.nvim_create_namespace('m_ctxmenu')

api.nvim_set_hl(0, 'ctxmenuCursor', { strikethrough = true, blend = 100, default = true })
api.nvim_set_hl(0, 'ctxmenuNumber', { bold = true, default = true })
api.nvim_set_hl(0, 'ctxmenuReverse', { reverse = true, default = true })

local buf -- Popup buffer, reused
local win -- Popup window
local choice -- Selected choice
local mappings = {} -- Key mappings

for keys, func in pairs({

  [{ 'j', 'n', '<C-N>', '<Down>' }] = function()
    local lnum = api.nvim_win_get_cursor(win)[1] + 1
    local max = api.nvim_buf_line_count(buf)
    if lnum > max then lnum = 1 end
    api.nvim_win_set_cursor(win, { lnum, 0 })
  end,

  [{ 'k', 'p', '<C-P>', '<Up>' }] = function()
    local lnum = api.nvim_win_get_cursor(win)[1] - 1
    if lnum < 1 then lnum = api.nvim_buf_line_count(buf) end
    api.nvim_win_set_cursor(win, { lnum, 0 })
  end,

  [{ '<CR>', '<NL>' }] = function()
    choice = api.nvim_win_get_cursor(win)[1]
    return true
  end,

  [{ '<Esc>', 'q' }] = function()
    return true
  end,

  [{ '1', '2', '3', '4', '5', '6', '7', '8', '9' }] = function(ch)
    local num = tonumber(ch)
    if num > 0 and num <= api.nvim_buf_line_count(buf) then
      choice = num
    end
    return true
  end,

}) do
  for _, key in pairs(keys) do
    key = T(key)
    mappings[key] = func
  end
end

local function loop()
  while true do
    local ok, ch = pcall(fn.getcharstr)
    if not ok then return end -- interrupted

    local action = mappings[ch]
    if action then
      if action(ch) then ---@diagnostic disable-line: redundant-parameter
        return
      end
      vim.cmd('redraw')
    else
      return ch
    end
  end
end

---Open context menu
---@param choices string[]
---@return integer index, string choice
return function(choices)
  if type(choices) ~= 'table' or #choices < 1 then
    return
  end

  -- reset state
  win, choice = nil, nil

  local width = 2
  local height = math.min(#choices, 9)

  local lines = {}
  for i, item in ipairs(choices) do
    if i <= 9 then
      lines[i] = (' %d %s'):format(i, item)
    else
      lines[i] = ('   %s'):format(item)
    end
    width = math.max(width, #item + 4)
  end

  local anchor, row
  if fn.winline() + height > fn.winheight(0) then
    anchor, row = 'SW', 0
  else
    anchor, row = 'NW', 1
  end

  local parent = api.nvim_get_current_buf()
  local cursor = api.nvim_win_get_cursor(0)

  -- Reuse buffer
  if buf == nil or not api.nvim_buf_is_valid(buf) then
    buf = api.nvim_create_buf(false, false)
  end

  win = api.nvim_open_win(buf, false, {
    width = width, height = height,
    row = row, col = -1,
    relative = 'cursor',
    anchor = anchor,
  })

  api.nvim_buf_call(buf, function()
    setl.buftype = 'nofile'
    setl.swapfile = false
    setl.undofile = false
    setl.undolevels = -1

    setl.modifiable = true
    api.nvim_buf_set_lines(buf, 0, -1, true, lines)
    setl.modifiable = false

    setl.cursorline = true
    setl.wrap = true
    setl.number = false
    setl.relativenumber = false
    setl.foldenable = false
    setl.list = false

    setl.winhl = 'Normal:Pmenu,NormalNC:Pmenu,CursorLine:PmenuSel'
    setl.winblend = vim.o.pumblend
    vim.cmd([[syn match ctxmenuNumber "^ \d"]])
  end)

  api.nvim_win_set_cursor(win, { 1, 0 })

  local guicursor = api.nvim_get_option('guicursor')
  api.nvim_set_option('guicursor', guicursor..',a:ctxmenuCursor/lCursor')

  -- fake cursor
  local len = #api.nvim_buf_get_lines(parent, cursor[1] - 1, cursor[1], false)[1]
  local extmark
  if cursor[2] < len then
    extmark = api.nvim_buf_set_extmark(parent, ns, cursor[1] - 1, cursor[2], {
      end_row = cursor[1] - 1, end_col = cursor[2] + 1,
      hl_group = 'ctxmenuReverse',
    })
  else
    extmark = api.nvim_buf_set_extmark(parent, ns, cursor[1] - 1, cursor[2], {
      virt_text = {{' ', 'ctxmenuReverse'}},
      virt_text_pos = 'overlay',
      hl_mode = 'combine',
    })
  end

  api.nvim_command('redraw')

  local keys = loop()

  api.nvim_buf_del_extmark(parent, ns, extmark)
  api.nvim_win_close(win, true)
  api.nvim_set_option('guicursor', guicursor)

  if choice then
    return choice, choices[choice]
  elseif keys then
    api.nvim_feedkeys(keys, 'mt', false)
  end
end
