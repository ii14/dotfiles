com! RenameFile call s:rename_file()
fun! s:rename_file()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exe ':saveas ' . new_name
    exe ':silent !rm ' . old_name
    exe ':bd ' . old_name
    redraw!
  endif
endfun
