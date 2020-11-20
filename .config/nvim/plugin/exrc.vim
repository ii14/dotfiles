com! ExrcEdit exe 'edit '.s:path()
com! ExrcReload call s:reload()

fun! s:path()
  return getcwd().'/.exrc'
endfun

fun! s:reload()
  let p = s:path()
  if filereadable(p)
    exe 'source '.p
    redraw
    echo 'exrc reloaded: '.p
  else
    redraw
    echohl ErrorMsg
    echo '.exrc not found'
    echohl None
  endif
endfun

aug au_exrc | au!
  au BufWritePost .exrc if expand('%:p') ==# s:path() | call s:reload() | endif
aug end
