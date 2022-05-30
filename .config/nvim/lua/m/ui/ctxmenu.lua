local api, fn, setl = vim.api, vim.fn, vim.opt_local

api.nvim_set_hl(0, 'TransparentCursor', { strikethrough = true, blend = 100 })
api.nvim_set_hl(0, 'ctxmenuNumber', { bold = true })

local buf --- Reused buffer

return function(choices)
  if type(choices) ~= 'table' or #choices < 1 then
    return
  end

  local width = 2
  local height = math.min(#choices, 9)

  local lines = {}
  for i, choice in ipairs(choices) do
    if i <= 9 then
      lines[i] = (' %d %s'):format(i, choice)
    else
      lines[i] = ('   %s'):format(choice)
    end
    width = math.max(width, #choice + 4)
  end

  local anchor, row
  if fn.winline() + height > fn.winheight(0) then
    anchor, row = 'SW', 0
  else
    anchor, row = 'NW', 1
  end

  if buf == nil or not api.nvim_buf_is_valid(buf) then
    buf = api.nvim_create_buf(false, false)
  end

  local win = api.nvim_open_win(buf, false, {
    width = width, height = height,
    row = row, col = -1,
    relative = 'cursor',
    anchor = anchor,
  })

  api.nvim_buf_call(buf, function()
    setl.buftype = 'nofile'
    setl.modifiable = true
    api.nvim_buf_set_lines(buf, 0, -1, true, lines)
    setl.modifiable = false
    setl.wrap = true
    setl.number = false
    setl.relativenumber = false
    setl.cursorline = true
    setl.foldenable = false
    setl.list = false
    setl.statusline = ''
    setl.swapfile = false
    setl.winhl = 'Normal:Pmenu,NormalNC:Pmenu,CursorLine:PmenuSel'
    vim.cmd([[syn match ctxmenuNumber "^ \d"]])
  end)

  local guicursor = api.nvim_get_option('guicursor')
  api.nvim_set_option('guicursor', guicursor..',a:TransparentCursor/lCursor')
  vim.cmd('redraw')

  local choice --- Selected choice

  local mappings = {}
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
      key = api.nvim_replace_termcodes(key, true, false, true)
      mappings[key] = func
    end
  end

  local keys --- Pass keys

  while true do
    local ch = fn.getcharstr()
    local action = mappings[ch]
    if action then
      if action(ch) then ---@diagnostic disable-line: redundant-parameter
        break
      end
      vim.cmd('redraw')
    else
      keys = ch
      break
    end
  end

  api.nvim_win_close(win, true)
  api.nvim_set_option('guicursor', guicursor)

  if choice then
    return choice, choices[choice]
  elseif keys then
    api.nvim_feedkeys(keys, 'mt', false)
  end
end
