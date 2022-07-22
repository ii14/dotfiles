setlocal nonumber norelativenumber
setlocal nowrap
setlocal scrolloff=0
setlocal nobuflisted
setlocal textwidth=0

if exists('b:qf_isLoc') || getwininfo(win_getid())[0].quickfix != 1
  finish
endif
let b:qf_isLoc = getwininfo(win_getid())[0].loclist == 1

nnoremap <buffer><nowait> j j
nnoremap <buffer><nowait> k k
nnoremap <buffer><nowait><silent> q :close<CR>
nnoremap <buffer><nowait><silent> o <CR><C-W>p

if !b:qf_isLoc
  wincmd J
  nnoremap <buffer><nowait><silent> <C-S> :call m#qf#cexec('wincmd s')<CR>
  nnoremap <buffer><nowait><silent> <C-V> :call m#qf#cexec('wincmd v')<CR>
  nnoremap <buffer><nowait><silent> <C-T> :call m#qf#cexec('tab split')<CR>
else
  nnoremap <buffer><nowait><silent> <C-S> :call m#qf#lexec('wincmd s')<CR>
  nnoremap <buffer><nowait><silent> <C-V> :call m#qf#lexec('wincmd v')<CR>
  nnoremap <buffer><nowait><silent> <C-T> :call m#qf#lexec('tab split')<CR>
endif

let b:qf_lastWin = winnr('#')
augroup m_qf
  autocmd WinEnter <buffer> ++nested
    \ if &ft ==# 'qf' |
    \   let b:qf_lastWin = winnr('#') |
    \ endif
  autocmd WinClosed <buffer> ++nested
    \ if &ft ==# 'qf' |
    \   exe b:qf_lastWin.'wincmd w' |
    \ endif
augroup end
