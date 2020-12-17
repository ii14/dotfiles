" Description: Strip trailing whitespaces

" Usage:
"
"     :StripTrailingWhitespaces
"         Strip trailing whitespaces
"
"     :StripTrailingWhitespacesAuto
"         Enable automatic stripping on save
"
"     :StripTrailingWhitespacesEnable
"         Force automatic stripping on save
"
"     :StripTrailingWhitespacesDisable
"         Disable automatic stripping on save

" Configuration:
"
"     g:strip_blacklist
"         Disable automatic stripping on save for these filetypes.
"         Default: ['gitcommit', 'diff']

if exists('g:loaded_strip')
  finish
endif
let g:loaded_strip = 1

let s:blacklist = get(g:, 'strip_blacklist', ['gitcommit', 'diff'])
let s:mode = 2

command! StripTrailingWhitespaces call s:Strip()
command! StripTrailingWhitespacesAuto let s:mode = 2
command! StripTrailingWhitespacesEnable let s:mode = 1
command! StripTrailingWhitespacesDisable let s:mode = 0

fun! s:Strip()
  let v = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(v)
endfun

fun! s:StripAu()
  if s:mode == 1 || (s:mode == 2 && index(s:blacklist, &ft) < 0)
    call s:Strip()
  endif
endfun

augroup StripAu
  autocmd!
  autocmd BufWritePre * call s:StripAu()
augroup END
