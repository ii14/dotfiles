command! -bar -count=12 Dresize call luaeval('require"drawer".resize(_A[1])', [<count>])
command! -bar -nargs=1  Dmove   call luaeval('require"drawer".move(_A[1])', [<q-args>])
command! -nargs=+ -count=1 Tsend call luaeval('require"drawer.term".send(_A[1], _A[2])', [<count>, <q-args>])

nnoremap <silent> <F1> <cmd>lua require"drawer".term(1)<CR>
nnoremap <silent> <F2> <cmd>lua require"drawer".term(2)<CR>
nnoremap <silent> <F3> <cmd>lua require"drawer".term(3)<CR>
nnoremap <silent> <F4> <cmd>lua require"drawer".term(4)<CR>
nnoremap <silent> <F5> <cmd>lua require"drawer".qf()<CR>

augroup Drawer
  autocmd!
  autocmd BufWinEnter * lua require"drawer"._bufwinenter()
augroup end
