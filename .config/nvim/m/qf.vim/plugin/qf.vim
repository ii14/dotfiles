com! QF call qf#open()

fun! qf#open()
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

fun! qf#show()
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
  wincmd p
endfun

fun! qf#toggle()
  for i in range(1, winnr('$'))
    let b = winbufnr(i)
    if getbufvar(b, '&buftype') ==# 'quickfix'
      cclose
      return
    endif
  endfor

  call qf#show()
endfun

fun! qf#init()
  " override j -> gj and k -> gk mappings
  nnoremap <buffer><nowait> j j
  nnoremap <buffer><nowait> k k

  nnoremap <buffer><nowait><silent> q :q<CR>
  nnoremap <buffer><nowait><silent> <Esc> <C-W>p

  nnoremap <buffer><nowait><silent> o <CR><C-W>p

  let b:last_win = winnr('#')
  au WinEnter <buffer> ++nested
    \ if &ft ==# 'qf' |
    \   let b:last_win = winnr('#') |
    \ endif
  au WinClosed <buffer> ++nested
    \ if &ft ==# 'qf' |
    \   exe b:last_win.'wincmd w' |
    \ endif

  let l:loc_len = len(getloclist(0))
  let b:qf_isLoc = l:loc_len > 0
  if !b:qf_isLoc
    wincmd J
    let l:qf_len = len(getqflist())
    if l:qf_len < 10 && match(getqflist({'title':1}).title, '^:Dispatch') == -1
      exe 'resize ' . l:qf_len
    endif
    nnoremap <buffer><nowait><silent> s :call qf#csplit()<CR>
    nnoremap <buffer><nowait><silent> v :call qf#cvsplit()<CR>
    nnoremap <buffer><nowait><silent> t :call qf#ctabsplit()<CR>
  else
    if l:loc_len < 10 && match(getloclist(0, {'title':1}).title, '^:Dispatch') == -1
      exe 'resize ' . l:loc_len
    endif
    nnoremap <buffer><nowait><silent> s :call qf#lsplit()<CR>
    nnoremap <buffer><nowait><silent> v :call qf#lvsplit()<CR>
    nnoremap <buffer><nowait><silent> t :call qf#ltabsplit()<CR>
  endif
endfun

fun! qf#cvsplit()
  let l = line('.')
  wincmd p
  wincmd v
  exe l.'cc'
endfun

fun! qf#csplit()
  let l = line('.')
  wincmd p
  wincmd s
  exe l.'cc'
endfun

fun! qf#ctabsplit()
  let l = line('.')
  wincmd p
  tab split
  exe l.'cc'
endfun

fun! qf#lvsplit()
  let l = line('.')
  wincmd p
  wincmd v
  exe l.'ll'
endfun

fun! qf#lsplit()
  let l = line('.')
  wincmd p
  wincmd s
  exe l.'ll'
endfun

fun! qf#ltabsplit()
  let l = line('.')
  wincmd p
  tab split
  exe l.'ll'
endfun

aug au_quickfix | au!
  au FileType qf call qf#init()
aug end
