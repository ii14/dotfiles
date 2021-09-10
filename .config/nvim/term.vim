augroup VimrcTerm
  autocmd!
  " Disable insert mode after terminal process terminates.
  " 'nomodifiable' doesn't work, but maybe there is a better way to do it?
  autocmd TermClose * ++nested stopinsert | au VimrcTerm TermEnter <buffer> stopinsert
augroup end

tnoremap <S-PageUp>   <C-\><C-N><C-B>
tnoremap <S-PageDown> <C-\><C-N><C-F>

" Vim terminal key bindings --------------------------------------------------------------
function! s:TermEnter(_)
  if getbufvar(bufnr(), 'term_insert', 0)
    startinsert
    call setbufvar(bufnr(), 'term_insert', 0)
  endif
endfunction

function! s:TermExec(cmd)
  let b:term_insert = 1
  execute a:cmd
endfunction

augroup VimrcTerm
  autocmd CmdlineLeave,WinEnter,BufWinEnter * call timer_start(0, function('s:TermEnter'), {})
augroup end

tnoremap <silent> <C-W>.      <C-W>
tnoremap <silent> <C-W><C-.>  <C-W>
tnoremap <silent> <C-W><C-\>  <C-\>
tnoremap <silent> <C-W>N      <C-\><C-N>
tnoremap <silent> <C-W>:      <C-\><C-N>:call <SID>TermExec('call feedkeys(":")')<CR>

tnoremap <silent> <C-W>q      <cmd>call <SID>TermExec('wincmd q')<CR>
tnoremap <silent> <C-W><C-Q>  <cmd>call <SID>TermExec('wincmd q')<CR>
tnoremap <silent> <C-W>c      <cmd>call <SID>TermExec('wincmd c')<CR>
tnoremap <silent> <C-W>o      <cmd>call <SID>TermExec('wincmd o')<CR>
tnoremap <silent> <C-W><C-O>  <cmd>call <SID>TermExec('wincmd o')<CR>

tnoremap <silent> <C-W>w      <cmd>call <SID>TermExec('wincmd w')<CR>
tnoremap <silent> <C-W><C-W>  <cmd>call <SID>TermExec('wincmd w')<CR>
tnoremap <silent> <C-W>W      <cmd>call <SID>TermExec('wincmd W')<CR>
tnoremap <silent> <C-W>p      <cmd>call <SID>TermExec('wincmd p')<CR>
tnoremap <silent> <C-W><C-P>  <cmd>call <SID>TermExec('wincmd p')<CR>

tnoremap <silent> <C-W>h      <cmd>call <SID>TermExec('wincmd h')<CR>
tnoremap <silent> <C-W><C-H>  <cmd>call <SID>TermExec('wincmd h')<CR>
tnoremap <silent> <C-W>H      <cmd>call <SID>TermExec('wincmd H')<CR>
tnoremap <silent> <C-W>j      <cmd>call <SID>TermExec('wincmd j')<CR>
tnoremap <silent> <C-W><C-J>  <cmd>call <SID>TermExec('wincmd j')<CR>
tnoremap <silent> <C-W>J      <cmd>call <SID>TermExec('wincmd J')<CR>
tnoremap <silent> <C-W>k      <cmd>call <SID>TermExec('wincmd k')<CR>
tnoremap <silent> <C-W><C-K>  <cmd>call <SID>TermExec('wincmd k')<CR>
tnoremap <silent> <C-W>K      <cmd>call <SID>TermExec('wincmd K')<CR>
tnoremap <silent> <C-W>l      <cmd>call <SID>TermExec('wincmd l')<CR>
tnoremap <silent> <C-W><C-L>  <cmd>call <SID>TermExec('wincmd l')<CR>
tnoremap <silent> <C-W>L      <cmd>call <SID>TermExec('wincmd L')<CR>

tnoremap <silent> <C-W>=      <cmd>call <SID>TermExec('wincmd =')<CR>

tnoremap <silent> <C-W>gt     <cmd>call <SID>TermExec('tabn')<CR>
tnoremap <silent> <C-W>gT     <cmd>call <SID>TermExec('tabp')<CR>

" TODO: fix
tnoremap <expr>   <C-W><C-R>  '<C-\><C-N>"'.nr2char(getchar()).'pi'
