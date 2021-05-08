" Description: Fill the rest of the line with specified character. Useful for headings
" Usage: :Hr [{character}]
"         Fill from the end of line up to text width with {character}.
"         If {character} is not specified, uses '-'.

command! -nargs=? Hr call s:Hr(<q-args>)

function! s:Hr(char)
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
