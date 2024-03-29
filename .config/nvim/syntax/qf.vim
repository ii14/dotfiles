if exists('b:current_syntax')
  finish
endif

syn match qfFileName  "^[^|]*" nextgroup=qfSeparator
syn match qfSeparator "|" nextgroup=qfLineNr contained
syn match qfLineNr    "[^|]*" contained contains=qfError
syn match qfError     "error" contained
syn match qfEmpty     "^|| " conceal

hi def link qfFileName  Directory
hi def link qfLineNr    String
hi def link qfError     Error

setl conceallevel=2
setl concealcursor=nc

" fidget.nvim workaround
set winhighlight=

let b:current_syntax = 'qf'
