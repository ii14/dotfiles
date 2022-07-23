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
  return bt == 'quickfix'
      or bt == 'terminal'
      or bt == 'help'
      or ft == 'lir'
      or ft == 'Trouble'
      or ft == 'fugitive'
      or ft == 'floggraph'
      or ft == 'git'
      or ft == 'DiffviewFiles'
      or ft == 'DiffviewFileHistory'
end

local MODE_OVERRIDES_FILETYPE = {
  lir       = 'Files',
  floggraph = 'Flog',
  fugitive  = 'Fugitive',
  Trouble   = 'Trouble',
  DiffviewFiles = 'DiffFiles',
  DiffviewFileHistory = 'DiffHistory',
}

local function mode_override(ctx)
  if ctx.quickfix then
    if ctx.quickfix.loclist then
      return 'Location'
    else
      return 'Quickfix'
    end
  elseif ctx.buftype == 'help' then
    return 'Help'
  else
    return MODE_OVERRIDES_FILETYPE[ctx.filetype]
  end
end

-- TODO: for special buffers nothing renders when window is inactive
local function render_name(ctx)
  if ctx.quickfix then
    return ctx.quickfix.title
  elseif ctx.filetype == 'lir' then
    return fn.fnamemodify(require('lir').get_context().dir, ':~')
  elseif ctx.filetype == 'termdebug' then
    return '[GDB]'
  elseif ctx.buftype == 'terminal' then
    return vim.b[ctx.bufnr].term_title or '-'
  elseif ctx.filetype == 'Trouble' then
    return
  else
    local name = fn.expand('%:t')
    if name == '' then
      name = '[No Name]'
    end
    return name
  end
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
    return ' '..res
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
      res[#res+1] = 'E'..count[d.severity.ERROR]
    end
    if count[d.severity.WARN] then
      res[#res+1] = 'W'..count[d.severity.WARN]
    end
    if count[d.severity.INFO] then
      res[#res+1] = 'I'..count[d.severity.INFO]
    end
    if count[d.severity.HINT] then
      res[#res+1] = 'H'..count[d.severity.HINT]
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
      for _, client in pairs(lsp.buf_get_clients(ctx.bufnr)) do
        res[#res+1] = client.name
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
    t[#t+1] = ' '..v
  end
end

function M.render(inactive)
  local bufnr = api.nvim_get_current_buf()
  local winid = api.nvim_get_current_win()
  local width = api.nvim_win_get_width(winid)
  local buftype = api.nvim_buf_get_option(bufnr, 'buftype')
  local filetype = api.nvim_buf_get_option(bufnr, 'filetype')
  local special = is_special(buftype, filetype)
  local quickfix
  if buftype == 'quickfix' then
    local info = fn.getwininfo(winid)[1]
    if info then
      if info.loclist == 1 then
        quickfix = {
          loclist = true,
          title = fn.getloclist(0, { title = 1 }).title,
        }
      elseif info.quickfix == 1 then
        quickfix = {
          loclist = false,
          title = fn.getqflist({ title = 1 }).title,
        }
      end
    end
  end

  local ctx = {
    bufnr = bufnr,
    winid = winid,
    width = width,
    buftype = buftype,
    filetype = filetype,
    special = special,
    quickfix = quickfix,
  }

  local name = render_name(ctx) or ''
  name = name:gsub('%%', '%%%%')
  local mod = render_mod(ctx)

  if inactive then
    return hl('B')..' '..name..(mod or '')..'%<'
  elseif mod then
    name = name..mod
  end

  local mode = get_mode()
  local himode = MODE_HL[mode] or 'N'
  if mode == 'Normal' then
    mode = mode_override(ctx) or mode
  end
  if width < WIDTH_TINY then
    mode = ' '
  elseif width < WIDTH_SMALL then
    mode = ' '..(MODE_MAP_SMALL[mode] or 'N')..' '
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
  s = s..[[%<%=]]..right..' '
  if width >= WIDTH_SMALL then
    s = s..hl('BS')..'▏'..hl('B')..[[%3p%% ]]
    s = s..hi..[[ %3l:%-2c ]]
  end

  return s
end

function M.setup()
  vim.g.qf_disable_statusline = 1
  vim.o.statusline = [[%!v:lua.require('m.ui.statusline').render()]]
  vim.cmd([=[
    augroup m_statusline
      autocmd!
      autocmd WinLeave,BufLeave * lua vim.wo.statusline = require('m.ui.statusline').render(1)
      autocmd WinEnter,BufEnter * set statusline<
    augroup end
  ]=])
end

return M
