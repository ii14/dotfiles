" Current buffer directory ---------------------------------------------------------------
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

" lua includeexpr ------------------------------------------------------------------------
function! m#lua_include(fname) abort
  let module = substitute(a:fname, '\.', '/', 'g')
  let paths = nvim_list_runtime_paths()
  for template in paths
    let template .= '/lua/'
    let chk1 = template .. module .. '.lua'
    let chk2 = template .. module .. '/init.lua'
    if filereadable(chk1)
      return chk1
    elseif filereadable(chk2)
      return chk2
    endif
  endfor
  return a:fname
endfunction

" LSP - Update tab -----------------------------------------------------------------------
fun! m#lsp_update_tab() abort
  let l:tabnr = tabpagenr()
  for l:win in getwininfo()
    if l:win.tabnr == l:tabnr
      let l:attached = getbufvar(l:win.bufnr, 'lsp_attached', 0)
      if type(l:attached) == v:t_bool
        call setbufvar(l:win.bufnr, '&signcolumn', l:attached ? 'yes' : 'auto')
      endif
    endif
  endfor
endfun
