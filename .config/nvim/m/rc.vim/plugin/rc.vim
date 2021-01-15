" Description: Wrapper around ~/.local/bin/rc script

if !executable('rc')
  finish
endif

command! -nargs=1 -complete=customlist,s:Comp Rc call s:Query(<q-args>)

fun! s:Comp(ArgLead, CmdLine, CursorPos)
  let d = sort(split(system('rc --list 2>/dev/null'), '\n'))
  call add(d, '--edit')
  return filter(d, 'v:val =~ "^' . a:ArgLead . '"')
endfun

fun! s:Query(arg)
  let res = system('rc --query "' . a:arg . '" 2>/dev/null')
  if res !=# ''
    execute 'edit ' . res
  else
    echomsg 'Invalid option'
  endif
endfun
