" Lowercase command alias
function! m#cabbrev(lhs, rhs) abort
  exe printf("cnorea <expr>%s (getcmdtype()==#':'&&getcmdline()==#'%s')?'%s':'%s'",
    \ a:lhs, a:lhs, a:rhs, a:lhs)
endfunction

" Current buffer directory
if executable('pwdx')
  function! m#bufdir() abort
    if &buftype ==# 'terminal'
      try
        let d = systemlist(['pwdx', b:terminal_job_pid])
        if v:shell_error != 0 | return './' | endif
        let d = fnamemodify(matchlist(d[0], '\v^\d+: (.+)$')[1], ':~:.')
        return (d ==# '' ? './' : d[-1:] ==# '/' ? d : d..'/')
      catch
        return './'
      endtry
    else
      let d = expand('%:h')
    endif
    return (d ==# '' ? './' : d..'/')
  endfunction
else
  function! m#bufdir() abort
    let d = expand('%:h')
    return (d ==# '' ? './' : d..'/')
  endfunction
endif
