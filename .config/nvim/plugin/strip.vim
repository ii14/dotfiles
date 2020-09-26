if exists('g:loaded_strip')
  finish
endif
let g:loaded_strip = 1

let g:strip_blacklist = ['gitcommit', 'diff']

let s:strip_enabled = 2

com! StripTrailingWhitespaces call s:strip()
com! StripTrailingWhitespacesAuto let s:strip_enabled = 2
com! StripTrailingWhitespacesEnable let s:strip_enabled = 1
com! StripTrailingWhitespacesDisable let s:strip_enabled = 0

fun! s:strip()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

fun! s:strip_au()
  if s:strip_enabled == 1 || (s:strip_enabled == 2 && index(g:strip_blacklist, &ft) < 0)
    call s:strip()
  endif
endfun

aug au_strip | au!
  au BufWritePre * call s:strip_au()
aug end
