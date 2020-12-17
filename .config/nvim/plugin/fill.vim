" Description: Fill the rest of the line with specified character. Useful for headings
"
" Usage:
"
"     :Fill {character}
"         Fill from the end of line up to text width with {character}.
"         If {character} is not specified, uses '-'.

" TODO: if the line is empty, don't add space on the beginning

command! -nargs=? Fill call s:Fill(<q-args>)

fun! s:Fill(char)
  if strlen(a:char) > 1
    echo 'expected zero or one character'
    return
  endif
  let fill = a:char ==# '' ? '-' : a:char[0]
  normal! $
  let ch = getline('.')[col('.') - 1]
  if ch !=# fill && ch !=# ' '
    execute 'norm! a '
  endif
  let w = &tw - col('.')
  if w > 0
    execute 'norm! '.w.'A'.fill
  endif
endfun

