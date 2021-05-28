" Description: Open windows in vertical split, if there is enough space

fun! autosplit#autopos()
  let wid = win_getid()
  let bufnr = bufnr()
  let prev = winnr('#')
  let vert = winwidth(prev) >= getwinvar(prev, '&tw', 80) + getwinvar(winnr(), '&tw', 80)

  wincmd p
  execute printf('%s +%db', (vert ? 'vsplit' : 'split'), bufnr)
  execute printf('%dwincmd q', win_id2win(wid))
endfun

fun! s:autocmd()
  if (index(get(g:, 'autosplit_bt', []), &buftype) != -1 ||
    \ index(get(g:, 'autosplit_ft', []), &filetype) != -1)
    call autosplit#autopos()
  endif
endfun

augroup autosplit
  autocmd!
  autocmd WinNew * autocmd autosplit BufEnter * ++once call s:autocmd()
augroup end
