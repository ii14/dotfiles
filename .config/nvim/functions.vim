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
  let opts = a:opts
  if type(opts) != v:t_dict || empty(opts)
    echohl WarningMsg
    echo '  No options available'
    echohl None
    let opts = {}
  else
    if has('nvim')
      for [key, file] in items(opts)
        call nvim_echo([
          \ [' [', 'LineNr'],
          \ [key,  'ErrorMsg'],
          \ ['] ', 'LineNr'],
          \ [file, 'None'],
          \ ], v:false, {})
      endfor
    else
      for [key, file] in items(opts)
        echo ' [' . key . '] ' . file
      endfor
    endif
  endif
  echo ':'.a:cmd

  let ch = getchar()
  redraw

  if ch == 0 || ch == 27 " Escape key
    return
  elseif ch == 13 " Enter key
    execute a:cmd
  elseif ch == 32 " Space key
    call feedkeys(':'.a:cmd.' ', 'n')
  elseif has_key(opts, nr2char(ch))
    execute a:cmd.' '.opts[nr2char(ch)]
  else
    echohl ErrorMsg
    echomsg 'Option does not exist'
    echohl None
  endif
endfun
