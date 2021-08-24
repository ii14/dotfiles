local api = vim.api
local lsp = vim.lsp
local lspconfig = require 'lspconfig'
local util = require 'lspconfig/util'

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

local on_init = function(client)
  clients[client.id] = {}
end

local on_exit = vim.schedule_wrap(function(_, _, id)
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

local on_attach = vim.schedule_wrap(function(client, bufnr)
  table.insert(clients[client.id], bufnr)
  api.nvim_buf_set_var(bufnr, 'lsp_attached', true)

  for _, win in pairs(vim.fn.getwininfo()) do
    if win.bufnr == bufnr then
      api.nvim_win_set_option(win.winid, 'signcolumn', 'yes')
    end
  end

  vim.g.lsp_event = { bufnr = bufnr }
  vim.cmd('doautocmd User LspAttach')
end)

M.stop_clients = function()
  -- lsp.diagnostic.clear(api.nvim_get_current_buf())
  lsp.stop_client(lsp.get_active_clients())
end

local header_to_source = {
  ['h']   = 'c',
  ['H']   = 'C',
  ['hh']  = 'cc',
  ['HH']  = 'CC',
  ['hpp'] = 'cpp',
  ['HPP'] = 'CPP',
  ['hxx'] = 'cxx',
  ['HXX'] = 'CXX',
  ['h++'] = 'c++',
  ['H++'] = 'C++',
}

function M.switch_source_header(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local params = { uri = vim.uri_from_bufnr(bufnr) }
  vim.lsp.buf_request(bufnr, 'textDocument/switchSourceHeader', params, function(err, _, result)
    if err then error(tostring(err)) end
    if result then
      vim.api.nvim_command('edit ' .. vim.uri_to_fname(result))
    else
      local fname = vim.api.nvim_buf_get_name(bufnr)
      local ext = vim.fn.fnamemodify(fname, ':e')
      local alt = header_to_source[ext]
      if alt == nil then
        print('Corresponding file cannot be determined')
        return
      end
      result = vim.fn.fnamemodify(fname, ':r') .. '.' .. alt
      print('Create source file? (Enter/y to confirm): '..vim.fn.fnamemodify(result, ':.'))
      local c = vim.fn.getchar()
      if c ~= 13 and c ~= 121 then
        return
      end
      vim.api.nvim_command('edit ' .. result)
      vim.api.nvim_buf_set_lines(0, 0, -1, false, {
        '#include "' .. vim.fn.fnamemodify(fname, ':.') .. '"',
      })
    end
  end)
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
M.setup = setmetatable({}, mt)

return M
