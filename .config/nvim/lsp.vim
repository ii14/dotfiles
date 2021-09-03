" LSP BUFFER LOCAL SETTINGS

" Completion -----------------------------------------------------------------------------
let s:compe = {'source': {
  \ 'path': v:true,
  \ 'calc': v:true,
  \ 'nvim_lsp': v:true,
  \ 'ultisnips': v:true,
  \ }}

call compe#setup(s:compe, 0)

" Key mappings ---------------------------------------------------------------------------
nno <buffer><silent> <C-]> :lua vim.lsp.buf.definition()<CR>
nno <buffer><silent> K     :lua vim.lsp.buf.hover()<CR>
nno <buffer><silent> gd    :lua vim.lsp.buf.declaration()<CR>
nno <buffer><silent> gD    :lua vim.lsp.buf.implementation()<CR>
" handled by lsp_signature:
" ino <buffer><silent> <C-K> <cmd>lua vim.lsp.buf.signature_help()<CR>
nno <buffer><silent> 1gD   :lua vim.lsp.buf.type_definition()<CR>
nno <buffer><silent> g]    :lua vim.lsp.buf.references()<CR>
nno <buffer><silent> gR    :lua vim.lsp.buf.rename()<CR>
nno <buffer><silent> g0    :lua vim.lsp.buf.document_symbol()<CR>
nno <buffer><silent> gW    :lua vim.lsp.buf.workspace_symbol()<CR>
nno <buffer><silent> g?    :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

nno <buffer><silent> ]d    :lua vim.lsp.diagnostic.goto_next()<CR>
nno <buffer><silent> [d    :lua vim.lsp.diagnostic.goto_prev()<CR>
nno <buffer><silent> ]D    :lua vim.lsp.diagnostic.goto_prev({cursor_position={0,0}})<CR>
nno <buffer><silent> [D    :lua vim.lsp.diagnostic.goto_next({cursor_position={0,0}})<CR>

nno <buffer><silent> <leader>lS :LspStop<CR>
nno <buffer><silent> <leader>ls :LspFind<CR>
nno <buffer><silent> <leader>lf :LspFormat<CR>
xno <buffer><silent> <leader>lf :LspFormat<CR>
nno <buffer><silent> <leader>la :LspAction<CR>
" nno <buffer><silent> <leader>ld :LspDiagnostics<CR>

" close completion on '({' and let lsp_signature take over:
ino <buffer><silent> ( <cmd>lua require 'compe'._close()<CR>(
ino <buffer><silent> { <cmd>lua require 'compe'._close()<CR>{

" Commands -------------------------------------------------------------------------------
com! -bar -buffer LspDiagnostics
  \ lua vim.lsp.diagnostic.set_loclist()
" TODO: add proper range handling
com! -bar -buffer -range=0 LspAction
  \ exe 'lua vim.lsp.buf.'.(<count> ? 'range_code_action()' : 'code_action()')
com! -bar -buffer -range=0 LspFormat
  \ exe 'lua vim.lsp.buf.'.(<count> ? 'range_formatting()' : 'formatting()')
com! -bar -buffer -nargs=? LspFind
  \ call luaeval('vim.lsp.buf.workspace_symbol(_A)', <q-args> is# '' ? v:null : <q-args>)
