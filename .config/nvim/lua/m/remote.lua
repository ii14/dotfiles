local api, fn = vim.api, vim.fn
local cmd = api.nvim_command

local function open(args)
  assert(type(args) == 'table')
  assert(type(args.cwd) == 'string')
  assert(type(args.files) == 'table')

  local buf = nil

  if #args.files > 0 then
    local bufs = {}
    for _, arg in ipairs(fn.argv()) do
      bufs[assert(fn.bufnr(arg))] = true
    end

    local cwd = fn.getcwd()
    cmd('noautocmd cd '..args.cwd)

    for _, file in ipairs(args.files) do
      local bufnr = fn.bufnr(file)
      if bufnr == -1 or not bufs[bufnr] then
        cmd('argadd '..file)
      end
    end

    buf = assert(fn.bufnr(args.files[1]))
    cmd('noautocmd cd '..cwd)
  end

  if args.stdin then
    assert(type(args.stdin == 'table'))
    cmd('enew')
    api.nvim_buf_set_lines(0, 0, -1, false, args.stdin)
  elseif buf then
    cmd('b '..buf)
  else
    cmd('enew')
  end
end

return { open = open }
