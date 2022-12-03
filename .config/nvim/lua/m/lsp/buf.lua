-- LSP BUFFER LOCAL SETTINGS

return function()
  require('m.keymaps').lsp(vim.g.lsp_event.client_name)

  vim.opt_local.tagfunc    = 'v:lua.vim.lsp.tagfunc'
  vim.opt_local.omnifunc   = 'v:lua.vim.lsp.omnifunc'
  vim.opt_local.formatexpr = 'v:lua.vim.lsp.formatexpr()'

  if not vim.g.options.NoCmp then
    require('cmp').setup.buffer({
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
      },
    })
  end
end
