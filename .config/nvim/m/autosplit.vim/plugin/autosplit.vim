" Open windows in vertical split, if there is enough space

let s:rules = get(g:, 'autosplit_rules', {})

let s:bts = get(s:rules, 'buftype', [])
let s:fts = get(s:rules, 'filetype', [])

fun! s:NewSplit()
  if (index(s:bts, &buftype) != -1 || index(s:fts, &filetype) != -1)
    let b = bufnr()
    let p = winnr('#')
    let v = winwidth(p) >= getwinvar(p, '&tw', 80) + getwinvar(winnr(), '&tw', 80)
    wincmd J
    wincmd p
    if v
      vsplit
    else
      split
    endif
    exe b . 'b'
    exe winnr('50j') . 'wincmd q'
  endif
endfun

augroup Autosplit
  autocmd!
  autocmd WinNew * autocmd BufEnter * ++once call s:NewSplit()
augroup END
