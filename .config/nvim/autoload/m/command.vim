" :set with prompt -----------------------------------------------------------------------
function! m#command#set(option)
  if !exists('&' . a:option)
    echomsg 'Unknown option: ' . a:option
    return
  endif
  execute 'let x = &' . a:option
  let x = input(a:option . '=', x)
  if x !=# ''
    execute 'let &' . a:option . ' = x'
  else
    redraw
  endif
endfunction

" Fill the rest of the line with character -----------------------------------------------
function! m#command#hr(char)
  if strlen(a:char) > 1
    echohl ErrorMsg
    echo 'Expected zero or one character'
    echohl None
    return
  endif

  let tw = getbufvar(bufnr(), '&tw', 80)
  let char = a:char ==# '' ? '-' : a:char[0]

  if match(getline('.'), '\v^\s*$') == 0
    call setline('.', '')
    execute 'normal! '.tw.'A'.char
    return
  endif

  normal! $
  if col('.') >= tw
    return
  endif

  let ch = getline('.')[col('.') - 1]
  if ch !=# char && ch !=# ' '
    execute 'normal! a '
  endif

  let w = tw - col('.')
  if w > 0
    execute 'normal! '.w.'A'.char
  endif
endfunction

" Rename current file --------------------------------------------------------------------
function! m#command#rename_file()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    execute 'saveas ' . new_name
    execute 'silent !rm ' . old_name
    execute 'bd ' . old_name
    redraw!
  endif
endfunction

" xdg-open -------------------------------------------------------------------------------
function! m#command#open(file)
  let file = a:file ==# '' ? expand('%') : expand(a:file)
  call system(['xdg-open', file])
endfunction

" Toggle line numbers --------------------------------------------------------------------
function! m#command#toggle_line_numbers() abort
  execute {
    \ '00': 'set relativenumber number',
    \ '01': 'set norelativenumber number',
    \ '10': 'set norelativenumber nonumber',
    \ '11': 'set norelativenumber number' }[&number . &relativenumber]
  echo printf('%snumber %srelativenumber',
    \ (&number ? '  ' : 'no'),
    \ (&relativenumber ? '  ' : 'no'))
endfunction
