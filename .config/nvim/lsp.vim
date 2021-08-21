" lsp buffer local settings

com! -bar -buffer LspDiagnostics
  \ lua vim.lsp.diagnostic.set_loclist()

" TODO: add proper range handling

com! -bar -buffer -range=0 LspAction
  \ exe 'lua vim.lsp.buf.'.(<count> ? 'range_code_action()' : 'code_action()')

com! -bar -buffer -nargs=? LspFind
  \ call luaeval('vim.lsp.buf.workspace_symbol(_A)', <q-args> is# '' ? v:null : <q-args>)

com! -bar -buffer -range=0 LspFormat
  \ exe 'lua vim.lsp.buf.'.(<count> ? 'range_formatting()' : 'formatting()')
