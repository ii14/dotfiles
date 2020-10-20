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
  nnoremap <buffer><nowait><silent> s :call qf#split()<CR>
  nnoremap <buffer><nowait><silent> v :call qf#vsplit()<CR>
  nnoremap <buffer><nowait><silent> t :call qf#tabsplit()<CR>

  nnoremap <buffer><nowait><silent> c :cc<CR><C-W>p
  nnoremap <buffer><nowait><silent> J :cnext<CR><C-W>p
  nnoremap <buffer><nowait><silent> n :cnext<CR><C-W>p
  nnoremap <buffer><nowait><silent> K :cprevious<CR><C-W>p
  nnoremap <buffer><nowait><silent> p :cprevious<CR><C-W>p
  nnoremap <buffer><nowait><silent> F :cfirst<CR><C-W>p
  nnoremap <buffer><nowait><silent> L :clast<CR><C-W>p
  nnoremap <buffer><nowait><silent> d :cclose<CR>

  let b:last_win = winnr('#')
  au WinEnter <buffer> ++nested
    \ if &ft ==# 'qf' |
    \   let b:last_win = winnr('#') |
    \ endif
  au WinClosed <buffer> ++nested
    \ if &ft ==# 'qf' |
    \   exe b:last_win.'wincmd w' |
    \ endif

  " wincmd J with quickfix is broken on the latest builds
  " issue: https://github.com/neovim/neovim/issues/13104
  " last working build: https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable/+build/20133359
  wincmd J
endfun

fun! qf#vsplit()
  let l = line('.')
  wincmd p
  wincmd v
  exe l.'cc'
endfun

fun! qf#split()
  let l = line('.')
  wincmd p
  wincmd s
  exe l.'cc'
endfun

fun! qf#tabsplit()
  let l = line('.')
  wincmd p
  tab split
  exe l.'cc'
endfun

aug au_quickfix | au!
  au FileType qf call qf#init()
aug end
