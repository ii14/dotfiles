" Description: Toggle line numbers

com! LineNumbersToggle call s:LineNumbersToggle()

fun! s:LineNumbersToggle() abort
  execute {
    \ '00': 'set relativenumber number',
    \ '01': 'set norelativenumber number',
    \ '10': 'set norelativenumber nonumber',
    \ '11': 'set norelativenumber number' }[&number . &relativenumber]
endfun
