" Description: Set tab width
" Usage: :[N]T[!] [N]
"     Set local tab width to [N]. If [N] is not given, the
"     default value of 4 is picked. [!] sets 'noexpandtab',
"     otherwise 'expandtab' is set.

command! -count=4 -bang T
  \ setl ts=<count> sts=<count> sw=<count> |
  \ exe 'setl '.('<bang>' ==# '' ? 'et' : 'noet')
