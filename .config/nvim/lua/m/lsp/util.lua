local api = vim.api
local lsp = vim.lsp
local lspconfig = require 'lspconfig'

local M = {}

M.map = function(type, key, value)
  vim.api.nvim_buf_set_keymap(0, type, key, value, {noremap = true, silent = true});
end

M.is_attached = function(bufnr)
  for _, _ in pairs(lsp.buf_get_clients(bufnr or 0)) do
    return true
  end
  return false
end

M.get_client_name = function(bufnr)
  for _, client in pairs(lsp.buf_get_clients(bufnr or 0)) do
    return client.name
  end
  return ''
end

local clients = {}

M.on_init = function(client)
  clients[client.id] = {}
end

M.on_exit = vim.schedule_wrap(function(_, _, id)
  for _, bufnr in pairs(clients[id]) do
    if not M.is_attached(bufnr) then
      api.nvim_buf_set_var(bufnr, 'lsp_attached', false)

      for _, win in pairs(vim.fn.getwininfo()) do
        if win.bufnr == bufnr then
          api.nvim_win_set_option(win.winid, 'signcolumn', 'auto')
        end
      end

      vim.g.lsp_event = { bufnr = bufnr }
      vim.cmd('doautocmd User LspDetach')
    end
  end
  clients[id] = nil
end)

M.on_attach = vim.schedule_wrap(function(client, bufnr)
  table.insert(clients[client.id], bufnr)
  api.nvim_buf_set_var(bufnr, 'lsp_attached', true)

  for _, win in pairs(vim.fn.getwininfo()) do
    if win.bufnr == bufnr then
      api.nvim_win_set_option(win.winid, 'signcolumn', 'yes')
    end
  end

  vim.g.lsp_event = { bufnr = bufnr }
  vim.cmd('doautocmd User LspAttach')

  require 'lsp_signature'.on_attach(client, bufnr)
end)

M.stop_clients = function()
  -- lsp.diagnostic.clear(api.nvim_get_current_buf())
  lsp.stop_client(lsp.get_active_clients())
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

local mt = {}
function mt:__index(k)
  return function(args)
    args.on_attach = wrap(M.on_attach, args.on_attach)
    args.on_init = wrap(M.on_init, args.on_init)
    args.on_exit = wrap(M.on_exit, args.on_exit)
    lspconfig[k].setup(args)
  end
end
M.m = setmetatable({}, mt)

return M
