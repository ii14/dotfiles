local M = {}

function M.lua_includeexpr(fname)
  fname = fname or vim.v.fname
  local mod = fname:gsub('%.', '/')
  local paths = vim.api.nvim_list_runtime_paths()
  for _, template in ipairs(paths) do
    template = template .. '/lua/'
    local chk1 = template .. mod .. '.lua'
    if vim.loop.fs_stat(chk1) then return chk1 end
    local chk2 = template .. mod .. '/init.lua'
    if vim.loop.fs_stat(chk2) then return chk2 end
  end
  return fname
end

function M.vim_includeexpr(fname)
  if vim.api.nvim_get_current_line():match('Plug') then
    local match = (fname or vim.v.fname):match('^[^/]*/([^/]*)$')
    if match then
      local chk = vim.env.VIMPLUGINS..'/'..match
      if vim.fn.isdirectory(chk) ~= 0 then
        return chk
      end
    end
  end
  return M.lua_includeexpr(fname)
end

return M
