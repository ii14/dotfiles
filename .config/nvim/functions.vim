" Check missing plugins
fun! PlugCheckMissing()
  let missing_plugs = len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  if missing_plugs
    let count_text = missing_plugs == 1
      \ ? '1 plugin is missing'
      \ : missing_plugs.' plugins are missing'
    let res = input(count_text.'. Install? [y/n]: ')
    if res ==? 'y' || res ==? 'yes'
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
  exe "cnoreabbrev <expr> " . a:lhs .
    \ " (getcmdtype() ==# ':' && getcmdline() ==# '" . a:lhs .
    \ "') ? '" . a:rhs . "' : '" . a:lhs . "'"
endfun
