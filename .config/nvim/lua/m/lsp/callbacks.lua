local api = vim.api
local fn = vim.fn
local lsp = vim.lsp
local c = lsp.handlers
local util = lsp.util

local M = {}


local function find_qf_index(items)
  local fname = api.nvim_buf_get_name(0)
  local lnum = api.nvim_win_get_cursor(0)[1]

  local found = false
  local idx = -1
  for i, v in ipairs(items) do
    if v.filename == fname then
      found = true
      if v.lnum == lnum then
        return i
      elseif v.lnum < lnum or idx == -1 then
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
    fn.setloclist(0, {}, ' ', {
      title = title or 'Locations',
      items = result,
      context = ctx,
    })
  else
    fn.setqflist({}, ' ', {
      title = title or 'Locations',
      items = result,
      context = ctx,
    })
  end

  local idx = find_qf_index(result)
  if idx ~= -1 then
    local view = fn.winsaveview()
    api.nvim_command((loclist and 'll' or 'cc')..idx)
    fn.winrestview(view)
  end

  api.nvim_command((config and config.loclist) and 'lopen' or 'botright copen')
end

local function echow(msg)
  api.nvim_echo({{msg, 'WarningMsg'}}, false, {})
end


c['textDocument/references'] = function(_, result, ctx, config)
  if not result or vim.tbl_isempty(result) then
    echow('LSP: No references found')
  else
    local client = lsp.get_client_by_id(ctx.client_id)
    set_qflist(util.locations_to_items(result, client.offset_encoding), ctx, config, 'References')
  end
end

c['textDocument/documentSymbol'] = function(_, result, ctx, config)
  if not result or vim.tbl_isempty(result) then
    echow('LSP: No symbols found')
  else
    set_qflist(util.symbols_to_items(result, ctx.bufnr), ctx, config, 'Document symbols')
  end
end

c['workspace/symbol'] = function(_, result, ctx, config)
  if not result or vim.tbl_isempty(result) then
    echow('LSP: No symbols found')
  elseif #result == 1 then
    local client = lsp.get_client_by_id(ctx.client_id)
    util.jump_to_location(result[1].location, client.offset_encoding)
  else
    set_qflist(util.symbols_to_items(result, ctx.bufnr), ctx, config, 'Workspace symbols')
  end
end

local function location_callback(_, result, ctx, config)
  if result == nil or vim.tbl_isempty(result) then
    echow('LSP: No locations found')
  else
    local client = lsp.get_client_by_id(ctx.client_id)
    if vim.tbl_islist(result) then
      util.jump_to_location(result[1], client.offset_encoding)
      if #result > 1 then
        set_qflist(util.locations_to_items(result, client.offset_encoding), ctx, config, 'Locations')
      end
    else
      util.jump_to_location(result, client.offset_encoding)
    end
  end
end

c['textDocument/declaration']    = location_callback
c['textDocument/definition']     = location_callback
c['textDocument/typeDefinition'] = location_callback
c['textDocument/implementation'] = location_callback

c['$/progress'] = nil
c['window/workDoneProgress/create'] = nil


-- local last_actions
-- local last_on_choice

-- vim.ui.select = function(items, opts, on_choice)
--   last_actions = items
--   last_on_choice = on_choice

--   local choices = {}
--   for _, item in ipairs(items) do
--     local str = opts.format_item(item)
--     table.insert(choices, str)
--   end
--   fn['actionmenu#open'](choices, [[v:lua.require'm.lsp.callbacks'.select_callback]])
-- end

-- function M.select_callback(index, _)
--   index = index + 1
--   last_on_choice(last_actions[index], index)
-- end

function vim.ui.select(items, opts, on_choice)
  local choices = {}
  for i, item in ipairs(items) do
    choices[i] = opts.format_item(item)
  end

  local index = require('m.ui.ctxmenu')(choices)
  if index then
    on_choice(items[index], index)
  end
end


return M
