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

" :redir to a new buffer -----------------------------------------------------------------
function! m#command#redir(cmd)
  let flags = &gdefault ? '' : 'g'
  let lines = split(substitute(nvim_exec(a:cmd, v:true), '\r\n\?', '\n', flags), "\n")

  if empty(lines)
    echohl ErrorMsg
    echomsg 'No output'
    echohl None
    return
  endif

  new
  call nvim_buf_set_lines(0, 0, -1, v:false, lines)
  setl nomodified
  call Autosplit()
endfunction

" xdg-open -------------------------------------------------------------------------------
function! m#command#open(file)
  let file = a:file ==# '' ? '%' : a:file
  let cmd = 'xdg-open ' . shellescape(expand(file))
  echo cmd
  call system(cmd)
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
