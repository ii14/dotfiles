" LSP BUFFER LOCAL SETTINGS

" Key mappings ---------------------------------------------------------------------------
nno <buffer><silent> g? <cmd>lua vim.diagnostic.open_float(0, {scope='line'})<CR>
nno <buffer><silent> ]d <cmd>lua vim.diagnostic.goto_next{float=false}<CR>
nno <buffer><silent> [d <cmd>lua vim.diagnostic.goto_prev{float=false}<CR>
nno <buffer><silent> ]D <cmd>lua vim.diagnostic.goto_prev{float=false,cursor_position={0,0}}<CR>
nno <buffer><silent> [D <cmd>lua vim.diagnostic.goto_next{float=false,cursor_position={0,0}}<CR>

nno <buffer><silent> <leader>lS :Lsp stop<CR>

nno <buffer><silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
ino <buffer><silent> <C-K> <cmd>lua vim.lsp.buf.signature_help()<CR>
nno <buffer><silent> <C-]> <cmd>lua vim.lsp.buf.definition()<CR>
nno <buffer><silent> go    <cmd>lua vim.lsp.buf.type_definition()<CR>
nno <buffer><silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nno <buffer><silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nno <buffer><silent> g]    <cmd>lua vim.lsp.buf.references()<CR>
nno <buffer><silent> gR    <cmd>lua vim.lsp.buf.rename()<CR>
nno <buffer><silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nno <buffer><silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

nno <buffer><silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>
xno <buffer><silent> ga    <cmd>lua vim.lsp.buf.range_code_action()<CR>

xno <buffer><silent> gw    <cmd>lua vim.lsp.buf.range_formatting()<CR>
xno <buffer><silent> gq    <cmd>lua vim.lsp.buf.range_formatting()<CR>

if g:lsp_event.client_name ==# 'clangd'
  nno <buffer><silent> <leader>a :ClangdSwitchSourceHeader<CR>
endif

setl tagfunc=v:lua.vim.lsp.tagfunc
setl omnifunc=v:lua.vim.lsp.omnifunc
setl formatexpr=v:lua.vim.lsp.formatexpr()

" end completion on '({'
ino <buffer><silent> ( <cmd>lua require 'compe'._close()<CR>(
ino <buffer><silent> { <cmd>lua require 'compe'._close()<CR>{

" Completion -----------------------------------------------------------------------------
let s:compe = {'source': {
  \ 'path': v:true,
  \ 'calc': v:true,
  \ 'nvim_lsp': v:true,
  \ }}
  " \ 'luasnip': v:true,

call compe#setup(s:compe, 0)

" vim: tw=90 ts=2 sts=2 sw=2 et
