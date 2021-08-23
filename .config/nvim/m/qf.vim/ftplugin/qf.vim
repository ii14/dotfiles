if exists('b:qf_isLoc') || getwininfo(win_getid())[0].quickfix != 1
  finish
endif

let b:qf_isLoc = getwininfo(win_getid())[0].loclist == 1

setl nonumber norelativenumber
setl nowrap
setl scrolloff=0
setl nobuflisted
setl textwidth=0

nno <buffer><nowait> j j
nno <buffer><nowait> k k
nno <buffer><nowait><silent> q :close<CR>
nno <buffer><nowait><silent> o <CR><C-W>p

if !b:qf_isLoc
  wincmd J
  nno <buffer><nowait><silent> <C-S> :call qf#csplit()<CR>
  nno <buffer><nowait><silent> <C-V> :call qf#cvsplit()<CR>
  nno <buffer><nowait><silent> <C-T> :call qf#ctabsplit()<CR>
else
  nno <buffer><nowait><silent> <C-S> :call qf#lsplit()<CR>
  nno <buffer><nowait><silent> <C-V> :call qf#lvsplit()<CR>
  nno <buffer><nowait><silent> <C-T> :call qf#ltabsplit()<CR>
endif

let b:qf_lastWin = winnr('#')
aug Quickfix
  au WinEnter <buffer> ++nested
    \ if &ft ==# 'qf' |
    \   let b:qf_lastWin = winnr('#') |
    \ endif
  au WinClosed <buffer> ++nested
    \ if &ft ==# 'qf' |
    \   exe b:qf_lastWin.'wincmd w' |
    \ endif
aug end
