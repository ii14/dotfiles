" Description: Wrapper around ~/.local/bin/rc script

if !executable('rc')
  finish
endif

command! -nargs=1 -complete=customlist,s:comp1 Rc  call s:rc(<q-args>)
command! -nargs=1 -complete=customlist,s:comp2 Rcd call s:rcd(<q-args>)

function! s:comp1(ArgLead, CmdLine, CursorPos)
  let d = sort(split(system('rc --list 2>/dev/null'), '\n'))
  call add(d, '--edit')
  return filter(d, 'stridx(v:val, a:ArgLead) == 0')
endfunction

function! s:comp2(ArgLead, CmdLine, CursorPos)
  let d = sort(split(system('rc --list 2>/dev/null'), '\n'))
  return filter(d, 'stridx(v:val, a:ArgLead) == 0')
endfunction

function! s:rc(arg)
  let res = system(printf('rc --query %s 2>/dev/null', shellescape(a:arg)))
  if res ==# ''
    echomsg 'Rc: Invalid option'
    return
  endif
  execute 'edit' res
endfunction

function! s:rcd(arg)
  let res = system(printf('rc --query %s 2>/dev/null', shellescape(a:arg)))
  if res ==# ''
    echomsg 'Rcd: Invalid option'
    return
  endif
  execute 'cd' fnamemodify(res, ':h')
  pwd
endfunction
