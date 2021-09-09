" Current buffer directory ---------------------------------------------------------------
function! m#bufdir()
  let d = expand('%:h')
  return (d ==# '' ? './' : d.'/')
endfunction

" Create a menu --------------------------------------------------------------------------
function! m#menu(cmd, opts) abort
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
endfunction

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
