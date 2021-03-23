" Description: Strip trailing whitespaces

" Usage:
"     :Strip
"         Strip trailing whitespaces
"     :Strip auto
"         Enable automatic stripping on save
"     :Strip enable
"         Force automatic stripping on save
"     :Strip disable
"         Disable automatic stripping on save

" Configuration:
"     g:strip_blacklist
"         Disable automatic stripping on save for these filetypes.
"         Default: ['gitcommit', 'diff']

if exists('g:loaded_strip')
  finish
endif
let g:loaded_strip = 1

let s:blacklist = get(g:, 'strip_blacklist', ['gitcommit', 'diff'])
let s:mode = 2

command! -nargs=? -complete=customlist,s:Completion Strip call s:Command(<q-args>)

fun! s:Command(arg)
  if a:arg ==# ''
    call s:Strip()
  elseif a:arg =~? '^a\%[uto]$'
    let s:mode = 2
  elseif a:arg =~? '^e\%[nable]$'
    let s:mode = 1
  elseif a:arg =~? '^d\%[isable]$'
    let s:mode = 0
  elseif a:arg ==# '?'
    echo s:mode == 2 ? 'auto' : s:mode == 1 ? 'enable' : 'disable'
  else
    echomsg 'invalid argument'
  endif
endfun

fun! s:Completion(ArgLead, CmdLine, CursorPos)
  return filter(
    \ ['auto', 'enable', 'disable'],
    \ 'v:val =~ ''\V\^''.a:ArgLead')
endfun

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
