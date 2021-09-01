command! -nargs=+ -complete=command Redir call s:Redir(<q-args>)

function! s:Redir(cmd)
  let flags = &gdefault ? '' : 'g'
  let lines = split(substitute(nvim_exec(a:cmd, v:true), '\r\n\?', '\n', flags), "\n")

  if empty(lines)
    echohl ErrorMsg
    echomsg 'No output'
    echohl None
    return
  endif

  new
  call nvim_buf_set_lines(0, 0, -1, v:false, lines)
  setl nomodified
  call Autosplit()
endfunction
