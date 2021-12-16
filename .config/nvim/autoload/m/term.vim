if exists('*nvim_get_proc')
  function! s:find_proc_in_tree(rootpid, names, accum) abort
    if a:accum > 9
      return v:false
    endif
    let p = nvim_get_proc(a:rootpid)
    if !empty(p)
      for name in a:names
        if match(p.name, name) >= 0
          return v:true
        endif
      endfor
    endif
    for c in nvim_get_proc_children(a:rootpid)[:9]
      if s:find_proc_in_tree(c, a:names, 1 + a:accum)
        return v:true
      endif
    endfor
    return v:false
  endfunction

  function! m#term#find_proc_in_tree(rootpid, names) abort
    let names = map(a:names, {_,name -> '\V\c\^'..name..'\$'})
    return s:find_proc_in_tree(a:rootpid, names, 0)
  endfunction
else
  function! m#term#find_proc_in_tree(rootpid, names) abort
    return v:false
  endfunction
endif

function! m#term#should_forward_esc() abort
  return !get(b:, 'term_forward_esc', 1) ||
    \ m#term#find_proc_in_tree(b:terminal_job_pid, get(g:, 'term_forward_esc', []))
endfun
