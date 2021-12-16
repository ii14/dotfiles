--- Pretty print
P = function(...)
  local objs = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objs))
  return ...
end

--- Reload module
R = function(p)
  package.loaded[p] = nil
  return require(p)
end

--- neovim API
_G.nvim = {}
for k, v in pairs(vim.api) do
  _G.nvim[k:gsub('^nvim_', '')] = v
end
