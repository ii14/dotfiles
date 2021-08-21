" Description: Trim trailing whitespaces

" Usage:
"     :Trim
"         Trim trailing whitespaces
"     :Trim auto
"         Enable automatic trimming on save
"     :Trim enable
"         Force automatic trimming on save
"     :Trim disable
"         Disable automatic trimming on save

" Configuration:
"     g:trim_blacklist
"         Disable automatic trimming on save for these filetypes.
"         Default: ['gitcommit', 'diff']

if exists('g:loaded_trim')
  finish
endif
let g:loaded_trim = 1

let s:blacklist = get(g:, 'trim_blacklist', ['gitcommit', 'diff'])
let s:mode = 2

command! -nargs=? -complete=customlist,s:Completion Trim call s:Command(<q-args>)

fun! s:Command(arg)
  if a:arg ==# ''
    call s:Trim()
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
    \ 'stridx(v:val, a:ArgLead) == 0')
endfun

fun! s:Trim()
    let v = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(v)
endfun

fun! s:TrimAu()
  if &modifiable && (s:mode == 1 || (s:mode == 2 && index(s:blacklist, &ft) < 0))
    call s:Trim()
  endif
endfun

augroup TrimAu
  autocmd!
  autocmd BufWritePre * call s:TrimAu()
augroup END
