" Description: Open windows in vertical split, if there is enough space

" NOTE: This might not work for every (n)vim version because of past bugs.
"
"       It's the third iteration, first one was based on `wincmd H/J/K/L`,
"       second on deleting the window and creating a new split, and now on
"       win_splitmove(), because only some time ago it was fixed.
"
"       I'm not sure which patch fixed it.

if exists('g:autosplit_loaded')
  finish
endif
let g:autosplit_loaded = 1

let s:textwidth = get(g:, 'autosplit_textwidth', 80)
let s:wininfo = []
let s:timer = 0

fun! Autosplit() abort
  let prev = winnr('#')
  " if prev is 0 it's probably new tab. invalid anyways
  if prev == 0 | return | endif

  let twprev = getwinvar(winnr(), '&textwidth', s:textwidth)
  let twcurr = getwinvar(prev,    '&textwidth', s:textwidth)

  " &textwidth in vim defaults to nothing, nvim defaults to zero
  if twprev == 0 | let twprev = s:textwidth | endif
  if twcurr == 0 | let twcurr = s:textwidth | endif

  " this check is not perfect, it doesn't take into account that
  " there already might be another vertical split and after :wincmd =
  " the space for next vertical split might be actually there.
  " maybe checking &columns and excluding splits with &winfixedwidth
  " would be better?
  let vert = winwidth(prev) >= twcurr + twprev

  call win_splitmove(win_getid(), win_getid(prev), {'vertical': vert})
  wincmd =
endfun

fun! s:winnew() abort
  let winid = win_getid()
  let tabnr = tabpagenr()
  " win_splitmove() triggers WinNew event.
  " confirm that we are actually in a new window.
  for win in s:wininfo
    if win.winid == winid && win.tabnr == tabnr
      let s:wininfo = getwininfo()
      return
    endif
  endfor
  let s:wininfo = getwininfo()

  if s:timer != 0 | call timer_stop(s:timer) | endif

  augroup autosplit_bufenter
    autocmd!
    autocmd BufEnter * ++once
      \ if (index(get(g:, "autosplit_bt", []), &buftype) != -1 ||
      \     index(get(g:, "autosplit_ft", []), &filetype) != -1) |
      \   call Autosplit() |
      \ endif
  augroup end

  " if we didn't hit BufEnter right away, this is just a normal :split
  " or :vsplit. clear the autocmd so it won't unexpectedly move the split
  " in the future when we change the buffer with :bn or :bp.
  let s:timer = timer_start(100,
    \ {-> execute('augroup autosplit_bufenter | autocmd! | augroup end')})
endfun

augroup autosplit_winnew
  autocmd!
  autocmd WinNew * call s:winnew()
augroup end
