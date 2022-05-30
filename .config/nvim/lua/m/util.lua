local api = vim.api
local fn = vim.fn

local M = {}

function M.lua_includeexpr(fname)
  fname = fname or vim.v.fname
  local mod = fname:gsub('%.', '/')
  local paths = api.nvim_list_runtime_paths()
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
  if api.nvim_get_current_line():match('Plug') then
    local match = (fname or vim.v.fname):match('^[^/]*/([^/]*)$')
    if match then
      local chk = vim.env.VIMPLUGINS..'/'..match
      if fn.isdirectory(chk) ~= 0 then
        return chk
      end
    end
  end
  return M.lua_includeexpr(fname)
end

do
  local REGEX = vim.regex([[\v^(n?vim|fzf)]])

  local function find_child_proc(pid, accum)
    if accum > 9 then
      return false
    end

    local proc = api.nvim_get_proc(pid)
    if proc then
      if REGEX:match_str(proc.name) then
        return true
      end
    end

    local children = api.nvim_get_proc_children(pid)
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
end

--- :redir to a new buffer
function M.redir(cmd)
  local lines = vim.split(api.nvim_exec(cmd, true), '\n', { plain = true })
  if #lines > 0 then
    vim.cmd('new')
    api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt_local.modified = false
    fn.Autosplit()
  else
    api.nvim_echo({{'No output', 'WarningMsg'}}, false, {})
  end
end

return M
