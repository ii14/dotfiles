" Lowercase command alias
function! m#cabbrev(lhs, rhs) abort
  exe printf("cnorea <expr>%s (getcmdtype()==#':'&&getcmdline()==#'%s')?'%s':'%s'",
    \ a:lhs, a:lhs, a:rhs, a:lhs)
endfunction

" Check missing plugins
function! m#check_missing_plugs() abort
  let l:missing_plugs = len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  if l:missing_plugs
    if input((l:missing_plugs == 1
      \ ? '1 plugin is missing'
      \ : l:missing_plugs..' plugins are missing')..'. Install? [y/n]: ')
      \ =~? '\v\cy%[es]$'
      PlugInstall
    endif
  endif
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

" Open directories in fern
function! m#fern_hijack_directory() abort
  let l:path = expand('%:p')
  if isdirectory(l:path)
    let l:bufnr = bufnr()
    execute printf('keepjumps keepalt Fern %s', fnameescape(l:path))
    execute printf('bwipeout %d', l:bufnr)
  endif
endfunction

" LSP - Update tab
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
