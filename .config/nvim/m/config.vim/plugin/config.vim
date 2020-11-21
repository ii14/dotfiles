com! -nargs=1 -complete=customlist,s:comp Config call s:query(<q-args>)

fun! s:comp(ArgLead, CmdLine, CursorPos)
  let d = sort(split(system('config --list 2>/dev/null'), '\n'))
  call add(d, '--edit')
  return filter(d, 'v:val =~ "^' . a:ArgLead . '"')
endfun

fun! s:query(arg)
  let f = system('config --query "' . a:arg . '" 2>/dev/null')
  if f !=# ''
    exe 'edit ' . f
  else
    echom 'Invalid option'
  endif
endfun
