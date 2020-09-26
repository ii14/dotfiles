com! ToggleLineNumber call <SID>ToggleLineNumber()
fun! <SID>ToggleLineNumber() abort
  execute {
    \ '00': 'set relativenumber   | set number',
    \ '01': 'set norelativenumber | set number',
    \ '10': 'set norelativenumber | set nonumber',
    \ '11': 'set norelativenumber | set number' }[&number . &relativenumber]
endfun
