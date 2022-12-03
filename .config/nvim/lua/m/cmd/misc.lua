local api, fn, echo = vim.api, vim.fn, require('m').echo

local misc = {}

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

---Redirect command to a new buffer
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

---Rename current file
function misc.rename(force)
  local old = fn.expand('%')

  local ok, new, err
  ok, new = pcall(fn.input, 'Rename: ', old)
  vim.cmd('redraw')
  if not ok or not new or new == '' or new == old then
    return
  end

  ok, err = pcall(api.nvim_command, ('saveas%s %s'):format(force and '!' or '', new))
  if not ok then
    api.nvim_err_writeln(err:match('^Vim%(.-%):(.*)') or err)
    return
  end

  vim.cmd(([[
    silent !rm %s
    bwipe! #
  ]]):format(old))
end

---xdg-open
function misc.open(file)
  assert(type(file) == 'string')
  file = file == '' and '%' or file
  fn.system({ 'xdg-open', fn.expand(file) })
end

---Scratch buffer
function misc.scratch(filetype)
  vim.cmd('new')
  vim.opt_local.buftype = 'nofile'
  if filetype ~= nil and filetype ~= '' then
    assert(type(filetype) == 'string')
    vim.opt_local.filetype = filetype
  end
  api.nvim_buf_set_name(0, '[Scratch]')
  vim.cmd('resize 15')
end

return misc
