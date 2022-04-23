local c = vim.lsp.handlers

local M = {}


local function find_qf_index(items)
  local fname = vim.api.nvim_buf_get_name(0)
  local linenr = vim.api.nvim_win_get_cursor(0)[1]

  local found = false
  local idx = -1
  for i, v in ipairs(items) do
    if v.filename == fname then
      found = true
      if v.lnum == linenr then
        return i
      elseif v.lnum < linenr or idx == -1 then
        idx = i
      end
    elseif found then
      return idx
    end
  end
  return idx
end

local function set_qflist(result, ctx, config, title)
  local loclist = config and config.loclist or false

  if loclist then
    vim.fn.setloclist(0, {}, ' ', {
      title = title or 'Locations',
      items = result,
      context = ctx,
    })
  else
    vim.fn.setqflist({}, ' ', {
      title = title or 'Locations',
      items = result,
      context = ctx,
    })
  end

  local idx = find_qf_index(result)
  if idx == -1 then return end

  local view = vim.fn.winsaveview()
  vim.api.nvim_command((loclist and 'll' or 'cc')..idx)
  vim.fn.winrestview(view)
end


-- select line under cursor on quickfix list
c['textDocument/references'] = function(_, result, ctx, config)
  if not result or vim.tbl_isempty(result) then
    print('LSP: No references found')
  else
    local util = require('vim.lsp.util')
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    set_qflist(util.locations_to_items(result, client.offset_encoding), ctx, config, 'References')
    vim.api.nvim_command((config and config.loclist) and 'lopen' or 'botright copen')
  end
end


local function symbol_callback(_, result, ctx, config)
  if not result or vim.tbl_isempty(result) then
    print('LSP: No symbols found')
  else
    local util = require('vim.lsp.util')
    set_qflist(util.symbols_to_items(result, ctx.bufnr), ctx, config, 'Symbols')
    vim.api.nvim_command((config and config.loclist) and 'lopen' or 'botright copen')
  end
end

c['textDocument/documentSymbol'] = symbol_callback
c['workspace/symbol']            = symbol_callback


local function location_callback(_, result, ctx, config)
  if result == nil or vim.tbl_isempty(result) then
    print('LSP: No location found')
    return
  end

  local util = require('vim.lsp.util')
  local client = vim.lsp.get_client_by_id(ctx.client_id)

  if vim.tbl_islist(result) then
    util.jump_to_location(result[1], client.offset_encoding)
    if #result > 1 then
      set_qflist(util.locations_to_items(result, client.offset_encoding), ctx, config, 'Locations')
      vim.api.nvim_command((config and config.loclist) and 'lopen' or 'botright copen')
    end
  else
    util.jump_to_location(result, client.offset_encoding)
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
