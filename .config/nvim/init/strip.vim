let g:strip_blacklist = ['gitcommit', 'diff']

let s:strip_enabled = 2

com! StripTrailingWhitespaces call <SID>StripTrailingWhitespaces()
com! StripTrailingWhitespacesAuto let s:strip_enabled = 2
com! StripTrailingWhitespacesEnable let s:strip_enabled = 1
com! StripTrailingWhitespacesDisable let s:strip_enabled = 0

fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

fun! <SID>AuStripTrailingWhitespaces()
  if s:strip_enabled == 1 || (s:strip_enabled == 2 && index(g:strip_blacklist, &ft) < 0)
    call <SID>StripTrailingWhitespaces()
  endif
endfun

aug au_strip | au!
  au BufWritePre * call <SID>AuStripTrailingWhitespaces()
aug end
