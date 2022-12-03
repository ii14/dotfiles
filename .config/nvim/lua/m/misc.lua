local api, uv = vim.api, vim.loop

local misc = {}

---vim and lua includeexpr
function misc.includeexpr(fname)
  assert(fname == nil or type(fname) == 'string')
  fname = fname or vim.v.fname

  if api.nvim_get_current_line():match('Plug') then
    local dir = vim.env.VIMPLUGINS
    local match = fname:match('^[^/]*/([^/]*)$')
    if match then
      local path = dir..'/'..match
      local stat = uv.fs_stat(path)
      if stat and stat.type == 'directory' then
        return path
      end
    end
  end

  local mod = fname:gsub('%.', '/')
  ---@diagnostic disable-next-line: undefined-field
  return api.nvim__get_runtime({
    'lua/'..mod..'.lua',
    'lua/'..mod..'/init.lua',
  }, false, {})[1] or fname
end

do
  local LINE_NUMBERS = {
    ff = '  number   relativenumber',
    ft = '  number norelativenumber',
    tf = 'nonumber norelativenumber',
    tt = '  number norelativenumber',
  }
  ---Toggle line numbers
  function misc.toggle_line_numbers()
    local n = vim.o.number         and 't' or 'f'
    local r = vim.o.relativenumber and 't' or 'f'
    local cmd = LINE_NUMBERS[n..r]
    api.nvim_command('set '..cmd)
    m.echo(cmd, nil, false)
  end
end

return misc
