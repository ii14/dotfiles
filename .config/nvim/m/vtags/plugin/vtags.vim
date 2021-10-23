" Description: Tags for vim config

if exists('g:loaded_vtags')
  finish
endif
let g:loaded_vtags = 1

function! s:match() abort
  return (&filetype ==# 'vim' || &filetype == 'lua')
    \ && stridx(expand('%:p'), stdpath('config')) == 0
endfunction

command! -bar -nargs=* -complete=file Vtags call vtags#gen([<f-args>])
command! -bar VtagsJump call vtags#jump()

augroup vtags
  autocmd!
  autocmd Syntax vim,lua if s:match() | call vtags#syntax() | endif
  autocmd BufWritePost * if s:match() | Vtags | endif
augroup end
