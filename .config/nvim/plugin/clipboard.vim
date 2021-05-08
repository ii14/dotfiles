let s:Registers = map(str2list(
  \ '"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'),
  \ 'nr2char(v:val)')

fun! s:Complete(A,L,P)
  return s:Registers
endfun

fun! s:Run(mode, reg)
  let reg = a:reg ==# '' ? '"' : a:reg
  if index(s:Registers, reg) < 0
    echo 'Unknown register: '.reg
  elseif a:mode == 0
    exe 'let @'.reg.'=@+'
    echo 'Copied clipboard to register '.reg
  else
    exe 'let @+=@'.reg
    echo 'Copied register '.reg.' to clipboard'
  endif
endfun

com! -nargs=? -complete=customlist,s:Complete Cget call s:Run(0, <q-args>)
com! -nargs=? -complete=customlist,s:Complete Cset call s:Run(1, <q-args>)
