local api = vim.api
local T = require('m').T

local ns = api.nvim_create_namespace('m_ipairs')

local active_buf = nil

local prev_cr = nil
local prev_space = nil

local function restore()
  vim.on_key(nil, ns)
  if not active_buf then
    return
  end

  local buf = active_buf
  active_buf = nil
  if not api.nvim_buf_is_valid(buf) then
    return
  end

  api.nvim_buf_del_keymap(buf, 'i', '<CR>')
  api.nvim_buf_del_keymap(buf, 'i', '<Space>')

  if prev_cr then
    local rhs = prev_cr.rhs or ''
    prev_cr.rhs, prev_cr.buffer = nil, nil
    api.nvim_buf_set_keymap(buf, 'i', '<CR>', rhs, prev_cr)
    prev_cr = nil
  end

  if prev_space then
    local rhs = prev_space.rhs or ''
    prev_space.rhs, prev_space.buffer = nil, nil
    api.nvim_buf_set_keymap(buf, 'i', '<CR>', rhs, prev_space)
    prev_space = nil
  end
end

return function()
  active_buf = api.nvim_get_current_buf()

  vim.on_key(restore, ns)

  for _, keymap in ipairs(api.nvim_buf_get_keymap(0, 'i')) do
    local lhs = keymap.lhs:lower()
    if lhs == '<cr>' then
      prev_cr = keymap
    elseif lhs == '<space>' then
      prev_space = keymap
    end
  end

  api.nvim_buf_set_keymap(0, 'i', '<Space>', '', {
    expr = true,
    nowait = true,
    noremap = true,
    callback = function()
      restore()
      return T'  <C-G>U<Left>'
    end,
  })

  api.nvim_buf_set_keymap(0, 'i', '<CR>', '', {
    expr = true,
    nowait = true,
    noremap = true,
    callback = function()
      restore()
      return T'<CR><C-O>O'
    end,
  })
end
