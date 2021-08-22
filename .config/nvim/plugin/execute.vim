function! s:_execute_(line1, line2, arg)
  let src = substitute(join(getline(a:line1, a:line2), "\n"), '\n\s*\\', ' ', 'g')

  if a:arg ==# ''
    try
      call execute(src, '')
    catch
      echohl ErrorMsg
      echomsg 'Uncaught exception:' v:exception
      echohl None
    endtry
    return
  elseif a:arg =~# '\v^r%[eplace]!?$'
    let line1 = a:line1 - 1
    let line2 = a:line2
  elseif a:arg =~# '\v^a%[ppend]!?$'
    let line1 = a:line2
    let line2 = a:line2
  elseif a:arg =~# '\v^p%[repend]!?$'
    let line1 = a:line1 - 1
    let line2 = a:line1 - 1
  else
    echohl ErrorMsg
    echomsg 'Invalid argument:' a:arg
    echohl None
    return
  endif

  try
    let lines = split(execute(src, 'silent'), "\n")
  catch
    echohl ErrorMsg
    echomsg 'Uncaught exception:' v:exception
    echohl None
    return
  endtry
  if a:arg[-1:] !=# '!' |
    let lines = map(lines, '''" ''.v:val')
  endif
  call nvim_buf_set_lines(0, line1, line2, v:true, lines)
endfunction

com! -bar -nargs=? -range X call s:_execute_(<line1>, <line2>, <q-args>)
