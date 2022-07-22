local api, fn = vim.api, vim.fn

local M = {}

--- Check if buffer is attached to any client
function M.is_attached(bufnr)
  local lsp = rawget(vim, 'lsp')
  if lsp then
    for _ in pairs(lsp.buf_get_clients(bufnr or 0)) do
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
  if bufnr == nil or bufnr == 0 then
    bufnr = api.nvim_get_current_buf()
  elseif type(bufnr) ~= 'number' then
    error('expected number')
  end

  local params = { uri = vim.uri_from_bufnr(bufnr) }
  vim.lsp.buf_request(bufnr, 'textDocument/switchSourceHeader', params, function(err, result)
    assert(not err, err)
    if result then
      api.nvim_command('edit ' .. vim.uri_to_fname(result))
    else
      local fname = api.nvim_buf_get_name(bufnr)
      local ext = fn.fnamemodify(fname, ':e')
      local alt = HEADER_TO_SOURCE[ext]
      if alt == nil then
        print('Corresponding file cannot be determined')
        return
      end
      result = fn.fnamemodify(fname, ':r') .. '.' .. alt
      print('Create source file? (Enter/y to confirm): '..fn.fnamemodify(result, ':.'))
      local c = fn.getchar()
      if c ~= 13 and c ~= 121 then
        return
      end
      api.nvim_command('edit ' .. result)
      api.nvim_buf_set_lines(0, 0, -1, false, {
        '#include "' .. fn.fnamemodify(fname, ':.') .. '"',
      })
    end
  end)
end

return M
