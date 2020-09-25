local M = {}

local has_lsp = function()
  for _ in pairs(vim.lsp.buf_get_clients()) do
    return true
  end
  return false
end

M.attach_completion_lsp = function()
  require'completion'.on_attach({
    chain_complete_list = {
      default = {{complete_items = {'lsp'}}}
    }
  })
end

M.attach_completion_generic = function()
  require'completion'.on_attach()
end

M.on_attach = function()
  if has_lsp() then
    M.attach_completion_lsp()
  else
    M.attach_completion_generic()
  end
end

return M
