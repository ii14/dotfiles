local nvim_lsp = require 'nvim_lsp'

nvim_lsp.ccls.setup{
  init_options = {
    highlight = { lsRanges=true; }
  }
}

nvim_lsp.pyls.setup{
  settings = {
    pyls = {
      plugins = {
        mccabe      = { enabled = false; };
        pycodestyle = { enabled = true; };
        yapf        = { enabled = true; };
      }
    }
  }
}

-- don't switch back from quickfix to previous window
local util = require 'vim.lsp.util'
local api = vim.api
local callbacks = vim.lsp.callbacks
local log = require 'vim.lsp.log'

callbacks['textDocument/references'] = function(_, _, result)
  if not result then return end
  util.set_qflist(util.locations_to_items(result))
  api.nvim_command("copen")
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

-- vim:ft=lua
