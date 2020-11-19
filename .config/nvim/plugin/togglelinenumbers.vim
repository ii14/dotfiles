com! LineNumbersToggle call s:line_numbers_toggle()
fun! s:line_numbers_toggle() abort
  execute {
    \ '00': 'set relativenumber number',
    \ '01': 'set norelativenumber number',
    \ '10': 'set norelativenumber nonumber',
    \ '11': 'set norelativenumber number' }[&number . &relativenumber]
endfun
