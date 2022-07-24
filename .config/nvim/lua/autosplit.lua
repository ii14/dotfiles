-- Automatically make the new split vertical if there is enough space for it

local api, fn = vim.api, vim.fn

local TEXTWIDTH = 80

local augroup = api.nvim_create_augroup('autosplit', {})
local pending = nil

---Make the current split vertical if there is enough space for it
local function autosplit(win, prev)
  if not win or not prev then
    prev = fn.winnr('#')
    -- if prev is 0 it's probably new tab. invalid anyways
    if prev == 0 then return end
    prev = fn.win_getid(prev)

    win = api.nvim_get_current_win()
  end

  local twcurr = api.nvim_buf_get_option(api.nvim_win_get_buf(win), 'textwidth')
  if twcurr == 0 then twcurr = TEXTWIDTH end
  local twprev = api.nvim_buf_get_option(api.nvim_win_get_buf(prev), 'textwidth')
  if twprev == 0 then twprev = TEXTWIDTH end

  -- win_splitmove triggers WinNew, temporarily disable it
  local eventignore = api.nvim_get_option('eventignore')
  api.nvim_command('set eventignore+=WinNew')
  local ok, err = pcall(fn.win_splitmove, win, prev, {
    -- the vertical condition is not perfect, it doesn't take into account
    -- that there already might be another vertical split and after :wincmd =
    -- the space for next vertical split might be actually there. maybe checking
    -- &columns and excluding splits with &winfixedwidth would be better?
    vertical = api.nvim_win_get_width(prev) >= twcurr + twprev,
  })
  api.nvim_set_option('eventignore', eventignore)
  assert(ok, err)
end

local function create_bufenter()
  return api.nvim_create_autocmd('BufEnter', {
    group = augroup,
    desc = 'autosplit',
    callback = function()
      if not pending then return end

      local buf = api.nvim_get_current_buf()
      if not api.nvim_buf_is_loaded(buf) then return end

      local win = api.nvim_get_current_win()
      local prev = pending[win]
      if not prev then return end

      if not api.nvim_win_is_valid(win) or not api.nvim_win_is_valid(prev) then
        pending[win] = nil
        return
      end

      local bts = vim.g.autosplit_bt
      if type(bts) ~= 'table' then bts = {} end
      local fts = vim.g.autosplit_ft
      if type(fts) ~= 'table' then fts = {} end

      local bt = api.nvim_buf_get_option(buf, 'buftype')
      local ft = api.nvim_buf_get_option(buf, 'filetype')

      if vim.tbl_contains(bts, bt) or vim.tbl_contains(fts, ft) then
        autosplit(win, prev)
      end

      pending[win] = nil
    end,
  })
end

api.nvim_create_autocmd('WinNew', {
  group = augroup,
  desc = 'autosplit',
  callback = function()
    local win = api.nvim_get_current_win()
    if pending and pending[win] then
      return
    end

    local prev = fn.winnr('#')
    if prev == 0 then
      return
    elseif pending then
      pending[win] = fn.win_getid(prev)
    else
      pending = { [win] = fn.win_getid(prev) }
      local autocmd = create_bufenter()
      -- BufEnter should be triggered just after WinNew
      vim.schedule(function()
        api.nvim_del_autocmd(autocmd)
        pending = nil
      end)
    end
  end,
})

return { autosplit = autosplit }
