" Description: Renames current file

com! RenameFile call s:RenameFile()

fun! s:RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    execute ':saveas ' . new_name
    execute ':silent !rm ' . old_name
    execute ':bd ' . old_name
    redraw!
  endif
endfun
