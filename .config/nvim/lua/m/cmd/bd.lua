local api, fn = vim.api, vim.fn

local function find_prev(bufnr)
  local bufs = api.nvim_list_bufs()

  local idx = nil
  for i, buf in ipairs(bufs) do
    if buf == bufnr then
      idx = i
      break
    end
  end

  for i = idx - 1, 1, -1 do
    if api.nvim_buf_get_option(bufs[i], 'buflisted') then
      return bufs[i]
    end
  end

  for i = #bufs, idx + 1, -1 do
    if api.nvim_buf_get_option(bufs[i], 'buflisted') then
      return bufs[i]
    end
  end

  return nil
end

---@param action string
local function mk(action)
  ---@param buf string|integer|nil
  ---@param force boolean|nil
  ---@return string|nil err
  return function(buf, force)
    if type(buf) == 'string' then
      if buf:match('^%d+$') then
        buf = tonumber(buf)
      elseif not buf:match('%S') then
        buf = nil
      end
    end

    local bufnr
    if buf == nil or buf == 0 then
      bufnr = api.nvim_get_current_buf()
    elseif type(buf) == 'number' then
      if not api.nvim_buf_is_valid(buf) then
        return ('E516: No buffers were deleted')
      end
      bufnr = buf
    elseif type(buf) == 'string' then
      bufnr = fn.bufnr(buf)
      if bufnr < 1 then
        return ('E94: No matching buffer for %s'):format(buf)
      end
    else
      return ('Invalid buffer %s'):format(tostring(buf))
    end

    local terminal = api.nvim_buf_get_option(bufnr, 'buftype') == 'terminal'
    if terminal and not vim.b[bufnr].term_closed then
      if not force then
        return ('E89: %s will be killed (add ! to override)'):format(api.nvim_buf_get_name(bufnr))
      end
      api.nvim_buf_set_option(bufnr, 'bufhidden', 'hide')
    elseif api.nvim_buf_get_option(bufnr, 'modified') then
      if not force then
        return ('E89: No write since last change for buffer %d (add ! to override)'):format(bufnr)
      end
      api.nvim_buf_set_option(bufnr, 'bufhidden', 'hide')
    end

    local nbuf = nil
    for _, win in ipairs(api.nvim_list_wins()) do
      if api.nvim_win_get_buf(win) == bufnr then
        api.nvim_win_call(win, function()
          local alt = fn.bufnr('#')
          if alt > 0 and alt ~= bufnr and api.nvim_buf_get_option(alt, 'buflisted') then
            api.nvim_set_current_buf(alt)
          elseif nbuf then
            api.nvim_set_current_buf(nbuf)
          else
            nbuf = find_prev(bufnr)
            if nbuf ~= nil then
              api.nvim_set_current_buf(nbuf)
            else
              vim.cmd('enew')
              nbuf = api.nvim_get_current_buf()
              api.nvim_buf_set_option(nbuf, 'swapfile', false)
              api.nvim_buf_set_option(nbuf, 'bufhidden', 'wipe')
              api.nvim_buf_set_option(nbuf, 'buftype', '')
              api.nvim_create_autocmd('BufModifiedSet', {
                buffer = nbuf,
                callback = function()
                  api.nvim_buf_set_option(nbuf, 'bufhidden', '')
                end,
                once = true,
                nested = true,
              })
            end
          end
        end)
      end
    end

    if api.nvim_buf_is_valid(bufnr) then
      if terminal then
        force = true
      end
      vim.cmd(('%s%s %d'):format(action, force and '!' or '', bufnr))
    end
  end
end

return {
  bd = mk('bdelete'),
  bw = mk('bwipeout'),
}
