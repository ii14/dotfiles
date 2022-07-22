local fn = vim.fn

local echo = require('m').echo

local function var(name)
  return vim.t[name] or vim.g[name]
end

local has_compiledb = nil

local function run(path)
  if not has_compiledb then
    has_compiledb = fn.executable('compiledb') ~= 0
    if not has_compiledb then
      return echo('compiledb: compiledb not in PATH', 'ErrorMsg', true)
    end
  end

  if path == nil or path == '' then
    path = var('compiledb_path')
  end
  if path then
    if type(path) ~= 'string' then
      return echo('compiledb: g:compiledb_path is not a string', 'ErrorMsg', true)
    end
    if fn.isdirectory(path) == 0 then
      return echo('compiledb: not a valid directory: '..path, 'ErrorMsg', true)
    end
  end

  local output = fn.getcwd()..'/compile_commands.json'
  local cmd = {'compiledb', '-f', '-o', output, '--command-style', '-n', 'make'}

  local exclude = var('compiledb_exclude')
  if exclude then
    if type(exclude) ~= 'string' then
      return echo('compiledb: g:compiledb_exclude is not a string', 'ErrorMsg', true)
    end
    table.insert(cmd, 2, '-e')
    table.insert(cmd, 3, exclude)
  end

  local lines = {}
  local function on_lines(_, data)
    for _, line in ipairs(data) do
      if line ~= '' then
        table.insert(lines, {line..'\n', 'ErrorMsg'})
      end
    end
  end

  echo(table.concat(cmd, ' '), 'Comment', false)
  fn.jobstart(cmd, {
    cwd = path,
    on_stderr = on_lines,
    on_stdout = on_lines,
    on_exit = function(_, code)
      if code ~= 0 then
        table.insert(lines, {'compiledb: exitted with non-zero code: '..code, 'ErrorMsg'})
        return echo(lines, true)
      end
      if fn.filereadable(output) == 0 then
        return echo('compiledb: file not readable: '..output, 'ErrorMsg', true)
      end
      local json = table.concat(fn.readfile(output, 'b'), '\n')
      local n = #vim.json.decode(json)
      echo('compiledb: generated '..n..' rules', 'Function', true)
    end,
  })
end

return { run = run }
