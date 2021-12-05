function! m#util#cabbrev(lhs, rhs) abort
  exe printf("cnorea <expr>%s (getcmdtype()==#':'&&getcmdline()==#'%s')?'%s':'%s'",
    \ a:lhs, a:lhs, a:rhs, a:lhs)
endfunction

function! m#util#check_missing_plugs() abort
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

function! m#util#fern_hijack_directory() abort
  let l:path = expand('%:p')
  if isdirectory(l:path)
    let l:bufnr = bufnr()
    execute printf('keepjumps keepalt Fern %s', fnameescape(l:path))
    execute printf('bwipeout %d', l:bufnr)
  endif
endfunction
