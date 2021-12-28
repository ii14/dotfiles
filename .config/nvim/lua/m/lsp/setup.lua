local M = {}

local clients = {}
local bufs = {}

--- Combine callback functions
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

--- Update signcolumns for current tab
function M._update_tab()
  local tabnr = vim.api.nvim_get_current_tabpage()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.tabnr == tabnr then
      local attached = bufs[win.bufnr]
      if attached ~= nil then
        vim.fn.setwinvar(win.winnr, '&signcolumn', attached and 'yes' or 'auto')
      end
    end
  end
end

--- LSP on_init callback, register client
M.on_init = function(client)
  clients[client.id] = {
    name = client.name,
    bufs = {},
  }
end

--- LSP on_attach callback
M.on_attach = vim.schedule_wrap(function(client, bufnr)
  require 'm.lsp.callbacks'
  require 'm.lsp.lightbulb'

  if not clients[client.id] then
    clients[client.id] = {
      name = client.name,
      bufs = {},
    }
  end

  table.insert(clients[client.id].bufs, bufnr)
  bufs[bufnr] = true
  vim.fn.setbufvar(bufnr, '&signcolumn', 'yes')
  M._update_tab()

  vim.g.lsp_event = {
    event = 'attach',
    bufnr = bufnr,
    client_id = client.id,
    client_name = client.name,
  }

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd('source '..vim.env.VIMCONFIG..'/lsp.vim')
  end)
end)

--- LSP on_exit callback
M.on_exit = vim.schedule_wrap(function(_, _, id)
  local client = clients[id]
  if not client then return end

  local util = require 'm.lsp.util'
  for _, bufnr in ipairs(client.bufs) do
    if not util.is_attached(bufnr) then
      bufs[bufnr] = false
      vim.fn.setbufvar(bufnr, '&signcolumn', 'auto')
    end
  end
  M._update_tab()

  clients[id] = nil
end)

vim.cmd([[
  augroup VimrcLsp
    autocmd!
    autocmd TabEnter * lua require 'm.lsp.setup'._update_tab()
  augroup end
]])

return setmetatable(M, {
  __index = function(_, k)
    local lspconfig = require 'lspconfig'
    if lspconfig[k] == nil then
      error('config does not exist: '..k)
    end
    return function(config)
      config.on_attach = wrap(M.on_attach, config.on_attach)
      config.on_init = wrap(M.on_init, config.on_init)
      config.on_exit = wrap(M.on_exit, config.on_exit)
      lspconfig[k].setup(config)
    end
  end
})
