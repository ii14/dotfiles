local M = {}

--- Check if buffer is attached to any client
function M.is_attached(bufnr)
  local lsp = rawget(vim, 'lsp')
  if lsp then
    for _, _ in pairs(lsp.buf_get_clients(bufnr or 0)) do
      return true
    end
  end
  return false
end

--- Get client name as string
function M.get_client_name(bufnr)
  local lsp = rawget(vim, 'lsp')
  if lsp then
    for _, client in pairs(lsp.buf_get_clients(bufnr or 0)) do
      return client.name
    end
  end
  return ''
end

--- Get comma separated client names
function M.get_client_names(bufnr)
  local lsp = rawget(vim, 'lsp')
  if not lsp then return '' end
  local t = {}
  for _, client in pairs(lsp.buf_get_clients(bufnr or 0)) do
    table.insert(t, client.name)
  end
  return table.concat(t, ',')
end

local HEADER_TO_SOURCE = {
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

--- clangd: Switch between header and source file
function M.switch_source_header(bufnr)
  bufnr = require('lspconfig/util').validate_bufnr(bufnr)
  local params = { uri = vim.uri_from_bufnr(bufnr) }
  vim.lsp.buf_request(bufnr, 'textDocument/switchSourceHeader', params, function(err, result)
    if err then error(tostring(err)) end
    if result then
      vim.api.nvim_command('edit ' .. vim.uri_to_fname(result))
    else
      local fname = vim.api.nvim_buf_get_name(bufnr)
      local ext = vim.fn.fnamemodify(fname, ':e')
      local alt = HEADER_TO_SOURCE[ext]
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

return M
