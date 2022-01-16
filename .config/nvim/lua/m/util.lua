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

local TERM_FWD_ESC_PROCS = [[\v\c^(n?vim|fzf)]]

local function find_child_proc(pid, accum)
  if accum > 9 then
    return false
  end

  local proc = vim.api.nvim_get_proc(pid)
  if proc then
    if vim.fn.match(proc.name, TERM_FWD_ESC_PROCS) >= 0 then
      return true
    end
  end

  local children = vim.api.nvim_get_proc_children(pid)
  children[9] = nil -- trim array to 8 elements
  for _, child in ipairs(children) do
    if find_child_proc(child, accum + 1) then
      return true
    end
  end

  return false
end

function M.term_fwd_esc(pid)
  local override = vim.b.term_fwd_esc
  if override and (override == false or override == 0) then
    return false
  end
  return find_child_proc(pid or vim.b.terminal_job_pid, 0)
end

return M
