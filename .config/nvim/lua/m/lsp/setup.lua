local clients = {}

local function doevent(name, data)
  vim.g.lsp_event = data
  vim.cmd('doautocmd User '..name)
end

local function wrap(a, b)
  if b then
    return function(...)
      a(...)
      b(...)
    end
  else
    return a
  end
end


local on_init = function(client)
  clients[client.id] = {
    name = client.name,
    bufs = {},
  }
end

local on_attach = vim.schedule_wrap(function(client, bufnr)
  require 'm.lsp.callbacks'
  require 'm.lsp.lightbulb'

  if not clients[client.id] then
    clients[client.id] = {
      name = client.name,
      bufs = {},
    }
  end

  table.insert(clients[client.id].bufs, bufnr)
  vim.api.nvim_buf_set_var(bufnr, 'lsp_attached', true)
  vim.fn.setbufvar(bufnr, '&signcolumn', 'yes')
  doevent('LspAttach', {
    event = 'attach',
    bufnr = bufnr,
    client_id = client.id,
    client_name = client.name,
  })
end)

local on_exit = vim.schedule_wrap(function(_, _, id)
  local client = clients[id]
  if not client then return end

  local util = require 'm.lsp.util'
  for _, bufnr in ipairs(client.bufs) do
    if not util.is_attached(bufnr) then
      vim.api.nvim_buf_set_var(bufnr, 'lsp_attached', false)
      vim.fn.setbufvar(bufnr, '&signcolumn', 'auto')
      doevent('LspDetach', {
        event = 'detach',
        bufnr = bufnr,
        client_id = id,
        client_name = client.name,
      })
    end
  end
  clients[id] = nil
end)


local setup = setmetatable({}, {
  __index = function(_, k)
    local lspconfig = require 'lspconfig'
    if lspconfig[k] == nil then
      error('config does not exist: '..k)
    end
    return function(args)
      args.on_attach = wrap(on_attach, args.on_attach)
      args.on_init = wrap(on_init, args.on_init)
      args.on_exit = wrap(on_exit, args.on_exit)
      lspconfig[k].setup(args)
    end
  end
})

return setup
