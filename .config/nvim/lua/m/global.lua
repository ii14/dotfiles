local m = require('m')

_G.m = m
_G.P = m.P
_G.R = m.R
_G.T = m.T
_G.rpairs = m.rpairs
_G.kpairs = m.kpairs

do
  ---Neovim API
  ---@type table<string, function>
  local A = {
    b = {},
    w = {},
    t = {},
  }

  for k, v in pairs(vim.api) do
    local n
    k, n = k:gsub('^nvim_', '')
    if n < 0 then
      goto next
    end

    k, n = k:gsub('^buf_', '')
    if n > 0 then
      A.b[k] = v
      goto next
    end

    k, n = k:gsub('^win_', '')
    if n > 0 then
      A.w[k] = v
      goto next
    end

    k, n = k:gsub('^tabpage_', '')
    if n > 0 then
      A.t[k] = v
      goto next
    end

    A[k] = v
    ::next::
  end

  _G.A = A
end

---@deprecated
---**For command line only**
_G.uv = vim.loop
