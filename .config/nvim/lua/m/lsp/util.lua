local M = {}

M.is_attached = function(bufnr)
  for _, _ in pairs(vim.lsp.buf_get_clients(bufnr or 0)) do
    return true
  end
  return false
end

M.get_client_name = function(bufnr)
  for _, client in pairs(vim.lsp.buf_get_clients(bufnr or 0)) do
    return client.name
  end
  return ''
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
