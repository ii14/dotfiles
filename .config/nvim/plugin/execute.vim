function! s:__execute__(line1, line2, arg) abort
  let l:src = substitute(join(getline(a:line1, a:line2), "\n"), '\n\s*\\', ' ', 'g')

  if a:arg ==# ''
    try
      call execute(l:src, '')
    catch
      echohl ErrorMsg
      echomsg 'Uncaught exception:' v:exception
      echohl None
    endtry
    return
  elseif a:arg =~# '\v^r%[eplace]!?$'
    let l:line1 = a:line1 - 1
    let l:line2 = a:line2
  elseif a:arg =~# '\v^a%[ppend]!?$'
    let l:line1 = a:line2
    let l:line2 = a:line2
  elseif a:arg =~# '\v^p%[repend]!?$'
    let l:line1 = a:line1 - 1
    let l:line2 = a:line1 - 1
  else
    echohl ErrorMsg
    echomsg 'Invalid argument:' a:arg
    echohl None
    return
  endif

  try
    let l:lines = split(execute(l:src, 'silent'), "\n")
  catch
    echohl ErrorMsg
    echomsg 'Uncaught exception:' v:exception
    echohl None
    return
  endtry

  if a:arg[-1:] ==# '!' |
    let l:lines = map(l:lines, '''" ''.v:val')
  endif

  call nvim_buf_set_lines(0, l:line1, l:line2, v:true, l:lines)
endfunction

com! -bar -nargs=? -range=% X call s:__execute__(<line1>, <line2>, <q-args>)
