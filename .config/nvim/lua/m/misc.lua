local api, fn, uv, echo = vim.api, vim.fn, vim.loop, require('m').echo

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

---:redir to a new buffer
function misc.redir(cmd)
  assert(type(cmd) == 'string')
  local lines = vim.split(api.nvim_exec(cmd, true), '\n', { plain = true })
  if #lines > 0 then
    vim.cmd('new')
    api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt_local.modified = false
    require('autosplit').autosplit()
  else
    echo('No output', 'WarningMsg')
  end
end

---Fill the rest of the current line with a character
function misc.hr(char)
  assert(char == nil or type(char) == 'string')
  if char == nil or char == '' then
    char = '-'
  elseif #char ~= 1 then
    return echo('Expected zero or one characters', 'ErrorMsg', false)
  end

  local tw = vim.o.textwidth
  if not tw or tw == 0 then
    tw = 80
  end

  local line = api.nvim_get_current_line()
  local len = #line
  if len >= tw then return end

  local last = line:sub(-1, -1)
  if last == char or last:find('^%s$') or len == 0 then
    line = line..(char):rep(tw - #line)
  else
    line = line..' '..(char):rep(tw - #line - 1)
  end
  api.nvim_set_current_line(line)
end

do
  local OPTS
  ---:set prompt
  function misc.set(option)
    assert(type(option) == 'string')
    if not OPTS then
      OPTS = {}
      local info = api.nvim_get_all_options_info()
      for _, opt in pairs(info) do
        local valid = opt.type == 'string'
        OPTS[opt.name] = valid
        if opt.shortname and opt.shortname ~= '' then
          OPTS[opt.shortname] = valid
        end
      end
    end

    local valid = OPTS[option]
    if valid == nil then
      return echo(('Invalid option: %s'):format(option), 'ErrorMsg', true)
    elseif valid == false then
      return echo(('Not a string option: %s'):format(option), 'ErrorMsg', true)
    end

    local ok, value = pcall(fn.input, option..'=', vim.o[option])
    if ok and value ~= '' then
      vim.o[option] = value
    else
      api.nvim_command('redraw')
    end
  end
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

---xdg-open
function misc.open(file)
  assert(type(file) == 'string')
  file = file == '' and '%' or file
  fn.system({ 'xdg-open', fn.expand(file) })
end

---Rename current file
function misc.rename_file()
  -- TODO: improve this
  local old = fn.expand('%')
  local ok, new = pcall(fn.input, 'New file name: ', old)
  if ok and new and new ~= '' and new ~= old then
    vim.cmd(([[
      saveas %s
      silent !rm %s
      bd! %s
      redraw!
    ]]):format(new, old, old))
  end
end

return misc
