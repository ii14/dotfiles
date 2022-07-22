command! -bar -count=12 Dresize
  \ lua require 'm.drawer.win'.resize(<count>)
command! -bar -nargs=1 Dmove
  \ call luaeval('require"m.drawer.win".move(_A[1])', [<q-args>])
command! -nargs=+ -count=1 Tsend
  \ call luaeval('require"m.drawer.term".send(_A[1], _A[2])', [<count>, <q-args>])

nnoremap <silent> <F1> <cmd>lua require"m.drawer.term".term(1)<CR>
nnoremap <silent> <F2> <cmd>lua require"m.drawer.term".term(2)<CR>
nnoremap <silent> <F3> <cmd>lua require"m.drawer.term".term(3)<CR>
nnoremap <silent> <F4> <cmd>lua require"m.drawer.term".term(4)<CR>
nnoremap <silent> <F5> <cmd>lua require"m.drawer.qf".qf()<CR>

augroup m_drawer
  autocmd!
  autocmd BufWinEnter * lua require 'm.drawer.win'._bufwinenter()
augroup end
