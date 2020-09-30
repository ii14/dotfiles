" nnoremap <silent> <leader>q :QF<CR>

com! QF call <SID>QFOpen()

fun! <SID>QFOpen()
  try
    silent clist
  catch
    redraw
    echohl ErrorMsg
    echo 'quickfix: Empty'
    echohl None
    return
  endtry
  copen
endfun

fun! <SID>QFSetupBuffer()
  nnoremap <buffer><nowait> j j
  nnoremap <buffer><nowait> k k

  nnoremap <buffer><nowait><silent> q :q<CR>
  nnoremap <buffer><nowait><silent> <Esc> <C-W>p

  nnoremap <buffer><nowait><silent> o <CR><C-W>p
  nnoremap <buffer><nowait><silent> v :call <SID>QFVSplit()<CR>
  nnoremap <buffer><nowait><silent> s :call <SID>QFSplit()<CR>
  " TODO: tab

  nnoremap <buffer><nowait><silent> c :cc<CR><C-W>p
  nnoremap <buffer><nowait><silent> J :cnext<CR><C-W>p
  nnoremap <buffer><nowait><silent> n :cnext<CR><C-W>p
  nnoremap <buffer><nowait><silent> K :cprevious<CR><C-W>p
  nnoremap <buffer><nowait><silent> p :cprevious<CR><C-W>p
  nnoremap <buffer><nowait><silent> f :cfirst<CR><C-W>p
  nnoremap <buffer><nowait><silent> l :clast<CR><C-W>p

  let b:last_win = winnr('#')
  au WinEnter <buffer>
    \ if &ft ==? 'qf' |
    \   let b:last_win = winnr('#') |
    \ endif
  au WinClosed <buffer>
    \ if &ft ==? 'qf' |
    \   exe b:last_win.'wincmd w' |
    \ endif
endfun

fun! <SID>QFVSplit()
  let l = line('.')
  wincmd p
  wincmd v
  exe l.'cc'
endfun

fun! <SID>QFSplit()
  let l = line('.')
  wincmd p
  wincmd s
  exe l.'cc'
endfun

aug au_quickfix | au!
  au FileType qf call <SID>QFSetupBuffer()
aug end
