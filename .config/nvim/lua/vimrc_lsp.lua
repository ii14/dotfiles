local nvim_lsp = require 'nvim_lsp'
local root_pattern = nvim_lsp.util.root_pattern

local api = vim.api
local util = require 'vim.lsp.util'
local callbacks = vim.lsp.callbacks
local log = require 'vim.lsp.log'


local on_attach = function()
  api.nvim_command('call VimrcLspOnAttach()')
end

-- C/C++
nvim_lsp.ccls.setup{
  on_attach = on_attach;
  init_options = {
    highlight = { lsRanges = true };
  };
  root_dir = root_pattern("compile_commands.json");
}

-- Python
nvim_lsp.pyls.setup{
  on_attach = on_attach;
  settings = {
    pyls = {
      plugins = {
        mccabe = { enabled = false };
      }
    }
  }
}

-- Golang
nvim_lsp.gopls.setup{
  on_attach = on_attach;
}


-- don't switch back from quickfix to previous window
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
