" Check missing plugins
fun! PlugCheckMissing()
  let missing_plugs = len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  if missing_plugs
    let count_text = missing_plugs == 1
      \ ? '1 plugin is missing'
      \ : missing_plugs.' plugins are missing'
    let res = input(count_text.'. Install? [y/n]: ')
    if res =~? '\vy%[es]$'
      PlugInstall
    endif
  endif
endfun

" Current buffer directory
fun! BufDirectory()
  let d = expand('%:h')
  return (d ==# '' ? './' : d.'/')
endfun

" Command abbreviations
fun! Cabbrev(lhs, rhs)
  exe printf("cnorea <expr> %s (getcmdtype()==#':'&&getcmdline()==#'%s')?'%s':'%s'",
    \ a:lhs, a:lhs, a:rhs, a:lhs)
endfun

" Create a menu
fun! Menu(cmd, opts)
  let l:opts = a:opts
  let l:t = type(l:opts)
  if (l:t != v:t_dict && l:t != v:t_list) || empty(l:opts)
    echohl WarningMsg
    echo '  No options available'
    echohl None
    let l:opts = []
  else
    if l:t == v:t_dict
      let l:opts = items(l:opts)
    endif
    for [l:key, l:file] in l:opts
      call nvim_echo([
        \ [' [', 'LineNr'],
        \ [l:key,  'WarningMsg'],
        \ ['] ', 'LineNr'],
        \ [l:file, 'None'],
        \ ], v:false, {})
    endfor
  endif
  echo ':'.a:cmd

  let l:ch = getchar()
  redraw

  if l:ch == 0 || l:ch == 27 " Escape key
    return
  elseif l:ch == 13 " Enter key
    execute a:cmd
  elseif l:ch == 32 " Space key
    call feedkeys(':'.a:cmd.' ', 'n')
  else
    for [l:key, l:file] in l:opts
      if l:key ==# nr2char(l:ch)
        execute a:cmd.' '.l:file
        return
      endif
    endfor
    echohl ErrorMsg
    echomsg 'Option does not exist'
    echohl None
  endif
endfun
