local api = vim.api
local fn = vim.fn
local hl = require('m.ui.palette').hl

local M = {}

local WIDTH_SMALL = 70
local WIDTH_TINY = 40

local MODE_MAP = {
  ['n']      = 'Normal',
  ['no']     = 'O-Pending',
  ['nov']    = 'O-Pending',
  ['noV']    = 'O-Pending',
  ['no\x16'] = 'O-Pending',
  ['niI']    = 'Normal',
  ['niR']    = 'Normal',
  ['niV']    = 'Normal',
  ['nt']     = 'Normal',
  ['v']      = 'Visual',
  ['vs']     = 'Visual',
  ['V']      = 'V-Line',
  ['Vs']     = 'V-Line',
  ['\x16']   = 'V-Block',
  ['\x16s']  = 'V-Block',
  ['s']      = 'Select',
  ['S']      = 'S-Line',
  ['\x13']   = 'S-Block',
  ['i']      = 'Insert',
  ['ic']     = 'Insert',
  ['ix']     = 'Insert',
  ['R']      = 'Replace',
  ['Rc']     = 'Replace',
  ['Rx']     = 'Replace',
  ['Rv']     = 'V-Replace',
  ['Rvc']    = 'V-Replace',
  ['Rvx']    = 'V-Replace',
  ['c']      = 'Command',
  ['cv']     = 'Ex',
  ['ce']     = 'Ex',
  ['r']      = 'Replace',
  ['rm']     = 'More',
  ['r?']     = 'Confirm',
  ['!']      = 'Shell',
  ['t']      = 'Terminal',
}

local MODE_MAP_SMALL = {
  ['Normal']    = 'N',
  ['O-Pending'] = 'N',
  ['Visual']    = 'V',
  ['V-Line']    = 'VL',
  ['V-Block']   = 'VB',
  ['Select']    = 'S',
  ['S-Line']    = 'SL',
  ['S-Block']   = 'SB',
  ['Insert']    = 'I',
  ['Replace']   = 'R',
  ['V-Replace'] = 'VR',
  ['Command']   = 'C',
  ['Ex']        = 'E',
  ['More']      = 'M',
  ['Confirm']   = 'C',
  ['Shell']     = 'S',
  ['Terminal']  = 'T',
}

local MODE_HL = {
  ['Normal']    = 'N',
  ['O-Pending'] = 'N',
  ['Visual']    = 'V',
  ['V-Line']    = 'V',
  ['V-Block']   = 'V',
  ['Select']    = 'V',
  ['S-Line']    = 'V',
  ['S-Block']   = 'V',
  ['Insert']    = 'I',
  ['Replace']   = 'R',
  ['V-Replace'] = 'R',
  ['Command']   = 'N',
  ['Ex']        = 'N',
  ['More']      = 'N',
  ['Confirm']   = 'N',
  ['Shell']     = 'N',
  ['Terminal']  = 'I',
}

local function get_mode()
  local c = api.nvim_get_mode().mode
  return MODE_MAP[c] or c
end

local function is_special(bt, ft)
  return bt == 'quickfix' or ft == 'fern' or ft == 'Trouble'
end

local function render_name(ctx)
  local name
  if ctx.buftype == 'quickfix' then
    local info = fn.getwininfo(ctx.winid)[1]
    if info then
      if info.loclist == 1 then
        name = '[Location] '..fn.getloclist(0, { title = 1 }).title
      elseif info.quickfix == 1 then
        name = '[Quickfix] '..fn.getqflist({ title = 1 }).title
      end
    end
  elseif ctx.filetype == 'fern' then
    local fern = api.nvim_buf_get_var(ctx.bufnr, 'fern')
    name = fn.fnamemodify(fern.root._path, ':~')
  elseif ctx.filetype == 'termdebug' then
    name = '[GDB]'
  elseif ctx.filetype == 'terminal' then
    local term_title = api.nvim_buf_get_var(ctx.bufnr, 'term_title')
    name = '[Term] '..term_title
  elseif ctx.filetype == 'Trouble' then
    name = '[Trouble]'
  else
    name = fn.expand('%:t')
    if name == '' then
      name = '[No Name]'
    end
  end
  return name
end

local function render_mod(ctx)
  local res
  local opt = api.nvim_buf_get_option
  if opt(ctx.bufnr, 'modified') then
    res = '+'
  end
  if not ctx.special and (not opt(ctx.bufnr, 'modifiable') or opt(ctx.bufnr, 'readonly')) then
    res = (res or '')..'-'
  end
  if res then
    return ' ['..res..']'
  end
end

local function render_head(ctx)
  if ctx.width >= WIDTH_SMALL then
    local ok, res = pcall(fn.FugitiveHead)
    if ok then return res end
  end
end

local function render_diff(ctx)
  if ctx.width < WIDTH_SMALL then
    return
  end
  local status
  local ok, gitsigns = pcall(api.nvim_buf_get_var, ctx.bufnr, 'gitsigns_status_dict')
  if ok then
    if (gitsigns.added or 0) > 0 then
      status = (status or '')..'+'..gitsigns.added
    end
    if (gitsigns.changed or 0) > 0 then
      status = (status or '')..'~'..gitsigns.changed
    end
    if (gitsigns.removed or 0) > 0 then
      status = (status or '')..'-'..gitsigns.removed
    end
  end
  return status
end

local function render_pro(ctx)
  if ctx.width >= WIDTH_SMALL then
    local ok, res = pcall(fn['pro#selected'])
    if ok then return res end
  end
end

local function render_diagnostic(ctx)
  local d = rawget(vim, 'diagnostic')
  if d and ctx.width >= WIDTH_SMALL then
    local count = {}
    local diags = d.get(ctx.bufnr)
    for _, v in ipairs(diags) do
      local s = v.severity
      count[s] = (count[s] or 0) + 1
    end
    local res = {}
    if count[d.severity.ERROR] then
      table.insert(res, 'E'..count[d.severity.ERROR])
    end
    if count[d.severity.WARN] then
      table.insert(res, 'W'..count[d.severity.WARN])
    end
    if count[d.severity.INFO] then
      table.insert(res, 'I'..count[d.severity.INFO])
    end
    if count[d.severity.HINT] then
      table.insert(res, 'H'..count[d.severity.HINT])
    end
    if #res > 0 then
      return table.concat(res, ' ')
    end
  end
end

local function render_lsp(ctx)
  local lsp = rawget(vim, 'lsp')
  if lsp then
    if ctx.width >= WIDTH_TINY then
      local res = {}
      for _, client in ipairs(lsp.buf_get_clients(ctx.bufnr)) do
        table.insert(res, client.name)
      end
      return table.concat(res, ',')
    end
  end
end

local function render_encoding(ctx)
  if ctx.width >= WIDTH_SMALL then
    local res = api.nvim_buf_get_option(ctx.bufnr, 'fileencoding')
    if res ~= 'utf-8' then return res end
  end
end

local function render_format(ctx)
  if ctx.width >= WIDTH_SMALL then
    local res = api.nvim_buf_get_option(ctx.bufnr, 'fileformat')
    if res ~= 'unix' then return res end
  end
end

local function insert(t, v)
  if v and v ~= '' then
    table.insert(t, ' '..v)
  end
end

function M.render(inactive)
  local bufnr = api.nvim_get_current_buf()
  local winid = api.nvim_get_current_win()
  local width = api.nvim_win_get_width(winid)
  local buftype = api.nvim_buf_get_option(bufnr, 'buftype')
  local filetype = api.nvim_buf_get_option(bufnr, 'filetype')
  local special = is_special(buftype, filetype)

  local ctx = {
    bufnr = bufnr,
    winid = winid,
    width = width,
    buftype = buftype,
    filetype = filetype,
    special = special,
  }

  local name = render_name(ctx)
  local mod = render_mod(ctx)

  if inactive then
    return hl('B')..' '..name..(mod or '')..'%<'
  elseif mod then
    name = name..hl('CS')..mod
  end

  local mode = get_mode()
  local himode = MODE_HL[mode] or 'N'
  if width < WIDTH_TINY then
    mode = ' '
  elseif width < WIDTH_SMALL then
    mode = ' '..MODE_MAP_SMALL[mode]..' '
  else
    mode = ' '..mode..' '
  end

  local hi = hl(himode)
  local hi2 = hl('F'..himode)

  local left
  if not special then
    left = {}
    insert(left, render_head(ctx))
    insert(left, render_diff(ctx))
    insert(left, render_pro(ctx))
    insert(left, render_diagnostic(ctx))
    left = table.concat(left, hl('BS')..'▕'..hl('B'))
  end

  local right = {}
  if not special then
    insert(right, render_lsp(ctx))
    insert(right, render_encoding(ctx))
    insert(right, render_format(ctx))
  end
  if not special or width >= WIDTH_TINY then
    insert(right, filetype)
  end
  right = table.concat(right, hl('CS')..'▕'..hl('C'))

  local s = hi..mode
  if left and left ~= '' then
    s = s..hl('B')..left..hl('BS')..'▕'
  end
  s = s..hi2..' '..name..' '..hl('C')
  s = s..[[%<%=]]
  s = s..right..' '
  if width >= WIDTH_SMALL then
    s = s..hl('BS')..'▏'..hl('B')..[[%3p%% ]]
    s = s..hi..[[ %3l:%-2c ]]
  end

  return s
end

return M
