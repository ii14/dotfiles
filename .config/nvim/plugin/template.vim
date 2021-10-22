let s:dir = $VIMCONFIG..'/templates'

command! -nargs=1 -complete=customlist,s:comp Template call s:run(<q-args>)

function! s:comp(ArgLead, CmdLine, CursorPos)
  try
    return filter(readdir(s:dir), 'stridx(v:val, a:ArgLead) == 0')
  catch
    return []
  endtry
endfunction

function! s:run(file)
  let l:file = s:dir..'/'..a:file
  if !filereadable(l:file)
    echohl ErrorMsg
    echomsg 'Template does not exist'
    echohl None
    return
  endif

  try
    let l:template = readfile(l:file)
  catch
    echohl ErrorMsg
    echomsg 'Failed to read template:' v:exception
    echohl None
    return
  endtry

  if line('$') == 1 && wordcount().words == 0
    call nvim_buf_set_lines(0, 0, -1, v:false, l:template)
  else
    let l:line = line('.')
    call nvim_buf_set_lines(0, l:line, l:line, v:false, l:template)
  endif
endfunction
