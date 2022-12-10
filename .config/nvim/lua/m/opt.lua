local api = vim.api

local saved = {}
local autocmd = nil

local function resolve_bufnr(bufnr)
  if bufnr == 0 then
    return api.nvim_get_current_buf()
  elseif type(bufnr) == 'number' and api.nvim_buf_is_valid(bufnr) then
    return bufnr
  else
    return nil
  end
end

local function create_autocmd()
  if autocmd ~= nil then
    return
  end

  autocmd = api.nvim_create_autocmd('BufWinEnter', {
    nested = true,
    desc = 'set buffer-local options',
    callback = function(ev)
      local bufnr = resolve_bufnr(ev.buf)
      if not bufnr then return end

      local opts = saved[bufnr]
      if opts == nil then return end
      saved[bufnr] = nil

      if next(saved) == nil then
        api.nvim_del_autocmd(autocmd)
        autocmd = nil
      end

      for k, v in pairs(opts) do
        api.nvim_set_option_value(k, v, { scope = 'local' })
      end
    end,
  })
end

---Set window options for a buffer.
---Handles the edge case where buffer is not visible.
---@param bufnr number
---@param opts table
local function set(bufnr, opts)
  bufnr = assert(resolve_bufnr(bufnr), 'invalid buffer')
  assert(type(opts) == 'table', 'invalid options')

  local save = true
  local wins = api.nvim_list_wins()
  api.nvim_buf_call(bufnr, function()
    for _, win in ipairs(wins) do
      if api.nvim_win_get_buf(win) == bufnr then
        save = false
        api.nvim_win_call(win, function()
          for k, v in pairs(opts) do
            api.nvim_set_option_value(k, v, { scope = 'local' })
          end
        end)
      end
    end
  end)

  if save then
    if not saved[bufnr] then
      saved[bufnr] = {}
    end
    for k, v in pairs(opts) do
      saved[bufnr][k] = v
    end
    create_autocmd()
  end
end

return { set = set }
