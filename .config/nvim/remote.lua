local socket = vim.env.NVIM
if socket == nil or socket == vim.v.servername then
  return
end

local api, fn, opt, cmd = vim.api, vim.fn, vim.opt, vim.cmd

opt.loadplugins = false
opt.swapfile = false
opt.undofile = false
opt.backup = false
cmd([[
  filetype off
  syntax off
]])

local stdin = nil
api.nvim_create_autocmd('StdinReadPost', {
  callback = function()
    stdin = api.nvim_buf_get_lines(0, 0, -1, false)
  end,
})

api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local chan = fn.sockconnect('pipe', socket, { rpc = true })
    vim.rpcrequest(chan, 'nvim_exec_lua', [[require"m.remote".open(...)]], {{
      cwd = fn.getcwd(),
      files = fn.argv(),
      stdin = stdin,
    }})
    fn.chanclose(chan)
    cmd('qa!')
  end,
})
