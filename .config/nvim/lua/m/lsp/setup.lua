local M = {}

local initialized = false
local clients = {}
local buffers = {}

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

--- Initialize LSP modules
local function init()
  if initialized then return end
  initialized = true

  require('m.lsp.callbacks')
  require('m.lsp.lightbulb')
  require('fidget').setup{
    text = {
      spinner = 'dots_scrolling',
    },
  }
end

--- Update signcolumn
local function update_signcolumn()
  for _, win in ipairs(vim.fn.getwininfo()) do
    local attached = buffers[win.bufnr]
    if attached ~= nil then
      vim.api.nvim_win_call(vim.fn.win_getid(win.winnr, win.tabnr), function()
        vim.cmd('setlocal signcolumn'..(attached and '=yes' or '<'))
      end)
    end
  end
end

--- LSP on_init callback, register client
function M.on_init(client)
  clients[client.id] = {
    name = client.name,
    bufs = {},
  }
  init()
end

--- LSP on_attach callback
M.on_attach = vim.schedule_wrap(function(client, bufnr)
  if not clients[client.id] then
    clients[client.id] = {
      name = client.name,
      bufs = {},
    }
  end

  table.insert(clients[client.id].bufs, bufnr)
  buffers[bufnr] = true
  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd('setlocal signcolumn=yes')
  end)
  update_signcolumn()

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

  local util = require('m.lsp.util')
  for _, bufnr in ipairs(client.bufs) do
    if not util.is_attached(bufnr) then
      buffers[bufnr] = false
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd('setlocal signcolumn<')
      end)
    end
  end
  update_signcolumn()

  clients[id] = nil
end)

return setmetatable(M, {
  __index = function(_, k)
    local lspconfig = require('lspconfig')
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
