local api = vim.api
local util = vim.lsp.util
local callbacks = vim.lsp.callbacks

local find_qf_index = function(items)
  local fname = api.nvim_buf_get_name(api.nvim_get_current_buf())
  local linenr = api.nvim_win_get_cursor(0)[1]

  local found_file = false
  local idx = -1
  for index, value in ipairs(items) do
    if value.filename == fname then
      found_file = true
      if value.lnum == linenr then
        return index
      elseif value.lnum < linenr or idx == -1 then
        idx = index
      end
    elseif found_file then
      return idx
    end
  end
  return idx
end

local set_qflist = function(items)
  util.set_qflist(items)
  local qf_index = find_qf_index(items)
  if qf_index ~= -1 then
    local view = vim.fn.winsaveview()
    vim.cmd('cc ' .. qf_index)
    vim.fn.winrestview(view)
  end
end

-- select line under cursor on quickfix list
-- don't switch back from quickfix to previous window
callbacks['textDocument/references'] = function(_, _, result)
  if not result or vim.tbl_isempty(result) then
    print('LSP: No location found')
    return nil
  end
  set_qflist(util.locations_to_items(result))
  vim.cmd('copen')
end

local symbol_callback = function(_, _, result, _, bufnr)
  if not result or vim.tbl_isempty(result) then
    print('LSP: No symbol found')
    return nil
  end
  set_qflist(util.symbols_to_items(result, bufnr))
  vim.cmd('copen')
end

callbacks['textDocument/documentSymbol'] = symbol_callback
callbacks['workspace/symbol']            = symbol_callback

local location_callback = function(_, _, result)
  if result == nil or vim.tbl_isempty(result) then
    print('LSP: No location found')
    return nil
  end
  if vim.tbl_islist(result) then
    util.jump_to_location(result[1])
    if #result > 1 then
      set_qflist(util.locations_to_items(result))
      vim.cmd("copen")
    end
  else
    util.jump_to_location(result)
  end
end

callbacks['textDocument/declaration']    = location_callback
callbacks['textDocument/definition']     = location_callback
callbacks['textDocument/typeDefinition'] = location_callback
callbacks['textDocument/implementation'] = location_callback
