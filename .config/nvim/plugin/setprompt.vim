" Description: Set option via prompt
" Usage: :Set {option}

command! -nargs=1 -complete=option Set call s:Set(<q-args>)

fun! s:Set(option)
  if !exists('&' . a:option)
    echomsg 'Unknown option: ' . a:option
    return
  endif
  execute 'let x = &' . a:option
  let x = input(a:option . '=', x)
  if x !=# ''
    execute 'let &' . a:option . ' = x'
  else
    redraw
  endif
endfun!
