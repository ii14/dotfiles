if exists('g:loaded_autosplit')
  finish
endif
let g:loaded_autosplit = 1

" Description: Open windows in vertical split, if there is enough space

" NOTE: This might not work for every (n)vim version because of past bugs.
"
"       It's the third iteration, first one was based on `wincmd H/J/K/L`,
"       second on deleting the window and creating a new split, and now on
"       win_splitmove(), because only some time ago it was fixed.
"
"       I'm not sure which patch fixed it.

fun! Autosplit()
  let prev = winnr('#')
  " if prev is 0 it's probably new tab. invalid anyways
  if prev == 0 | return | endif

  let twprev = getwinvar(winnr(), '&textwidth', 80)
  let twcurr = getwinvar(prev,    '&textwidth', 80)

  " &textwidth in vim defaults to nothing, nvim defaults to zero
  if twprev == 0 | let twprev = 80 | endif
  if twcurr == 0 | let twcurr = 80 | endif

  " this check is not perfect, it doesn't take into account that
  " there already might be another vertical split and after :wincmd =
  " the space for next vertical split might be actually there.
  " maybe checking &columns and excluding splits with &winfixedwidth
  " would be better?
  let vert = winwidth(prev) >= twcurr + twprev

  call win_splitmove(win_getid(), win_getid(prev), {'vertical': vert})
endfun

let s:autocmd_inner = 'BufEnter * ++once ' . join([
  \ 'if (index(get(g:, "autosplit_bt", []), &buftype) != -1 ||',
  \ 'index(get(g:, "autosplit_ft", []), &filetype) != -1) |',
  \ 'call Autosplit() | endif',
  \ ])

fun! s:clear_augroup(aug)
  execute 'augroup' a:aug
    autocmd!
  augroup end
  execute 'augroup!' a:aug
endfun

fun! s:autocmd()
  let aug = 'autosplit_'.win_getid()
  execute 'augroup' aug
    autocmd!
    execute 'autocmd' aug s:autocmd_inner
  augroup end
  call timer_start(500, { -> s:clear_augroup(aug) })
endfun

augroup autosplit
  autocmd!
  autocmd WinNew * call s:autocmd()
augroup end
