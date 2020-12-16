com! -nargs=1 -complete=option Set call <SID>Set(<q-args>)

fun! <SID>Set(option)
  if !exists('&' . a:option)
    echomsg 'Unknown option: ' . a:option
    return
  endif
  exe 'let x = &' . a:option
  let x = input(a:option . '=', x)
  if x !=# ''
    exe 'let &' . a:option . ' = x'
  else
    redraw
  endif
endfun!
