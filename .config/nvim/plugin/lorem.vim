let s:options = [
  \ 'allcaps',
  \ 'bq',
  \ 'code',
  \ 'decorate',
  \ 'dl',
  \ 'headers',
  \ 'link',
  \ 'long',
  \ 'medium',
  \ 'ol',
  \ 'plaintext',
  \ 'prude',
  \ 'short',
  \ 'ul',
  \ 'verylong',
  \ ]

fun s:comp(ArgLead, CmdLine, CursorPos)
  return filter(copy(s:options), 'stridx(v:val, a:ArgLead) == 0')
endfun

fun! s:run(args) abort
  if a:args !~# '\v^[a-z0-9 ]*$'
    echohl ErrorMsg
    echomsg 'Lorem: invalid arguments'
    echohl None
    return
  endif
  let res = systemlist('curl https://loripsum.net/api/'.join(split(a:args), '/').' 2>/dev/null')
  if v:shell_error != 0
    echohl ErrorMsg
    echomsg 'Lorem: curl failed with code '.v:shell_error
    echohl None
    return
  endif
  call append(line('.'), res)
endfun

com! -bar -nargs=* -complete=customlist,s:comp Lorem call s:run(<q-args>)
