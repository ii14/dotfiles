com! ExrcEdit exe 'edit '.s:path()
com! ExrcReload call s:reload()

fun! s:path()
  return getcwd().'/.exrc'
endfun

fun! s:reload()
  let p = s:path()
  try
    exe 'source '.p
  catch
    redraw
    echohl ErrorMsg
    echom 'failed to load .exrc'
    echohl None
    return
  endtry
  redraw
  echo 'exrc reloaded: '.p
endfun

aug au_exrc | au!
  au BufWritePost .exrc if expand('%:p') ==# s:path() | call s:reload() | endif
aug end
