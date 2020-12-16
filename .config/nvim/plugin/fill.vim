" Fill the rest of the line with specified character. Useful for headings

com! -nargs=? Fill call <SID>Fill(<q-args>)

fun! <SID>Fill(char)
  if strlen(a:char) > 1
    echom 'expected zero or one character'
    return
  endif
  let fill = a:char ==# '' ? '-' : a:char[0]
  norm! $
  let ch = getline('.')[col('.') - 1]
  if ch !=# fill && ch !=# ' '
    exe 'norm! a '
  endif
  let w = &tw - col('.')
  if w > 0
    exe 'norm! '.w.'A'.fill
  endif
endfun

