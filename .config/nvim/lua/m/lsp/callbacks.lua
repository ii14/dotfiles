local c = vim.lsp.handlers

local M = {}

local function find_qf_index(items)
  local fname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local linenr = vim.api.nvim_win_get_cursor(0)[1]

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

local function set_qflist(items)
  vim.lsp.util.set_qflist(items)
  local qf_index = find_qf_index(items)
  if qf_index ~= -1 then
    local view = vim.fn.winsaveview()
    vim.cmd('cc ' .. qf_index)
    vim.fn.winrestview(view)
  end
end

-- select line under cursor on quickfix list
-- don't switch back from quickfix to previous window
c['textDocument/references'] = function(_, result)
  if not result or vim.tbl_isempty(result) then
    print('LSP: No references found')
    return nil
  end
  set_qflist(vim.lsp.util.locations_to_items(result))
  vim.cmd('copen')
end

local function symbol_callback(entity)
  return function(_, result, context)
    if not result or vim.tbl_isempty(result) then
      print('LSP: No '..entity..' found')
      return nil
    end
    set_qflist(vim.lsp.util.symbols_to_items(result, context.bufnr))
    vim.cmd('copen')
  end
end

c['textDocument/documentSymbol'] = symbol_callback('document symbols')
c['workspace/symbol']            = symbol_callback('symbols')

local function location_callback(_, result)
  if result == nil or vim.tbl_isempty(result) then
    print('LSP: No location found')
    return nil
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.jump_to_location(result[1])
    if #result > 1 then
      set_qflist(vim.lsp.util.locations_to_items(result))
      vim.cmd("copen")
    end
  else
    vim.lsp.util.jump_to_location(result)
  end
end

c['textDocument/declaration']    = location_callback
c['textDocument/definition']     = location_callback
c['textDocument/typeDefinition'] = location_callback
c['textDocument/implementation'] = location_callback

local last_actions
local last_on_choice

vim.ui.select = function(items, opts, on_choice)
  last_actions = items
  last_on_choice = on_choice

  local choices = {}
  for _, item in ipairs(items) do
    local str = opts.format_item(item)
    table.insert(choices, str)
  end
  vim.fn['actionmenu#open'](choices, [[v:lua.require'm.lsp.callbacks'.select_callback]])
end

function M.select_callback(index, _)
  index = index + 1
  last_on_choice(last_actions[index], index)
end

return M
