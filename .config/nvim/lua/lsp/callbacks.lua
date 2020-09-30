local api = vim.api
local util = vim.lsp.util
local callbacks = vim.lsp.callbacks
local log = vim.lsp.log

local find_qf_index = function(items)
  local fname = api.nvim_buf_get_name(api.nvim_get_current_buf())
  local linenr = api.nvim_win_get_cursor(0)[1]
  for index, value in ipairs(items) do
    if value.lnum == linenr and value.filename == fname then
      return index
    end
  end
  return -1
end

-- select line under cursor on quickfix list
-- don't switch back from quickfix to previous window
callbacks['textDocument/references'] = function(_, _, result)
  if not result then return end
  local items = util.locations_to_items(result)
  util.set_qflist(items)
  local qf_index = find_qf_index(items)

  if qf_index ~= -1 then
    api.nvim_command('cc ' .. qf_index)
  end
  api.nvim_command('copen')
end

local symbol_callback = function(_, _, result, _, bufnr)
  if not result or vim.tbl_isempty(result) then return end
  util.set_qflist(util.symbols_to_items(result, bufnr))
  api.nvim_command("copen")
end

callbacks['textDocument/documentSymbol'] = symbol_callback
callbacks['workspace/symbol']            = symbol_callback

local location_callback = function(_, method, result)
  if result == nil or vim.tbl_isempty(result) then
  local _ = log.info() and log.info(method, 'No location found')
  return nil
  end
  if vim.tbl_islist(result) then
    util.jump_to_location(result[1])
    if #result > 1 then
      util.set_qflist(util.locations_to_items(result))
      api.nvim_command("copen")
    end
  else
    util.jump_to_location(result)
  end
end

callbacks['textDocument/declaration']    = location_callback
callbacks['textDocument/definition']     = location_callback
callbacks['textDocument/typeDefinition'] = location_callback
callbacks['textDocument/implementation'] = location_callback
