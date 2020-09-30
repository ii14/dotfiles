local completion = require 'completion'
local util = require 'lsp/util'

local M = {}

M.on_attach_lsp = function()
  completion.on_attach({
    chain_complete_list = {
      default = {{ complete_items = {'lsp'} }}
    }
  })
end

M.on_attach_generic = function()
  completion.on_attach()
end

M.on_attach = function()
  if util.has_lsp() then
    M.on_attach_lsp()
  else
    M.on_attach_generic()
  end
end

return M
