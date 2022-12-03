local api, fn = vim.api, vim.fn
local define = api.nvim_create_user_command

local CMD = ([[cnorea <expr> %s getcmdtype() == ':' && getcmdline() ==# '%s' ? '%s' : '%s']])
local function abbrev(lhs, rhs)
  api.nvim_command(CMD:format(lhs, lhs, rhs, lhs))
end

-- Delete buffers without changing window layout
define('Bd', function(ctx)
  local err = require('m.cmd.bd').bd(ctx.args, ctx.bang)
  if err then api.nvim_err_writeln(err) end
end, { bang = true, nargs = '?', complete = 'buffer' })
define('Bw', function(ctx)
  local err = require('m.cmd.bd').bw(ctx.args, ctx.bang)
  if err then api.nvim_err_writeln(err) end
end, { bang = true, nargs = '?', complete = 'buffer' })
define('Bq', [[
  if <q-args> ==# '' && &bt ==# 'terminal' && get(b:, 'term_closed', 1) == 0 |
    bd! |
  else |
    bd<bang> <args> |
  endif
]], { bang = true, nargs = '?', complete = 'buffer' })
abbrev('bd', 'Bd')
abbrev('bw', 'Bw')
abbrev('bq', 'Bq')

-- Fill the rest of the line with a character
define('Hr', function(ctx)
  require('m.cmd.misc').hr(ctx.args)
end, { nargs = '?' })
abbrev('hr', 'Hr')

-- Redirect command to a new buffer
define('Redir', function(ctx)
  require('m.cmd.misc').redir(ctx.args)
end, { nargs = '+', complete = 'command' })

-- :set prompt
define('Set', function(ctx)
  require('m.cmd.misc').set(ctx.args)
end, { nargs = 1, complete = 'option' })

-- Rename current file
define('Rename', function(ctx)
  require('m.cmd.misc').rename(ctx.bang)
end, { bang = true })

-- xdg-open
define('Open', function(ctx)
  require('m.cmd.misc').open(ctx.args)
end, { nargs = '?', complete = function(arg)
  return fn.getcompletion(arg, 'file', 1)
end })

-- compiledb
define('Compiledb', function(ctx)
  require('m.cmd.compiledb').run(ctx.args)
end, { nargs = '?', complete = 'dir' })

-- Lorem ipsum
define('Lorem', function(ctx)
  require('m.cmd.lorem').run(ctx.args)
end, { bar = true, nargs = '*', complete = function(arg)
  return require('m.cmd.lorem').complete(arg)
end })

-- Edit register
define('Regedit', function(ctx)
  require('m.cmd.regedit').run(ctx.args)
end, { nargs = '?' })

-- Scratch buffer
define('Scratch', function(ctx)
  require('m.cmd.misc').scratch(ctx.args)
end, { bar = true, nargs = '?', complete = 'filetype' })
abbrev('scra', 'Scratch')
abbrev('scrat', 'Scratch')
abbrev('scratc', 'Scratch')
abbrev('scratch', 'Scratch')

-- Insert template
define('Template', function(ctx)
  require('m.cmd.template').run(ctx.args)
end, { nargs = 1, complete = function(arg)
  return require('m.cmd.template').complete(arg)
end })
