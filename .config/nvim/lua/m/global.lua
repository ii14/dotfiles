local m = require('m')

_G.m = m
_G.P = m.P
_G.R = m.R
_G.T = m.T
_G.rpairs = m.rpairs
_G.kpairs = m.kpairs

do
  ---neovim API
  ---@type table<string, function>
  local nvim = {}
  for k, v in pairs(vim.api) do
    nvim[k:gsub('^nvim_', '')] = v
  end
  _G.nvim = nvim
end

_G.uv = vim.loop
