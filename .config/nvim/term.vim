" Description: Brings vim terminal key bindings to neovim

function! s:TermEnter()
  if getbufvar(bufnr(), 'term_insert', 0)
    startinsert
    call setbufvar(bufnr(), 'term_insert', 0)
  endif
endfunction

function! <SID>TermExecute(cmd)
  let b:term_insert = 1
  execute a:cmd
endfunction

augroup Term
  autocmd!
  autocmd CmdlineLeave,WinEnter,BufWinEnter * call s:TermEnter()
  " Disable insert mode after terminal process terminates.
  " 'nomodifiable' doesn't work, but maybe there is a better way to do it?
  autocmd TermClose * ++nested stopinsert | au TermEnter <buffer> stopinsert
  autocmd FileType fzf tnoremap <nowait><buffer> <C-W> <C-W>
augroup end

tnoremap <silent> <C-W>.      <C-W>
tnoremap <silent> <C-W><C-\>  <C-\>
tnoremap <silent> <C-W>N      <C-\><C-N>
tnoremap <silent> <C-W>:      <C-\><C-N>:call <SID>TermExecute('call feedkeys(":")')<CR>
tnoremap <silent> <C-W><C-W>  <C-\><C-N>:call <SID>TermExecute('wincmd w')<CR>
tnoremap <silent> <C-W>h      <C-\><C-N>:call <SID>TermExecute('wincmd h')<CR>
tnoremap <silent> <C-W>j      <C-\><C-N>:call <SID>TermExecute('wincmd j')<CR>
tnoremap <silent> <C-W>k      <C-\><C-N>:call <SID>TermExecute('wincmd k')<CR>
tnoremap <silent> <C-W>l      <C-\><C-N>:call <SID>TermExecute('wincmd l')<CR>
tnoremap <silent> <C-W><C-H>  <C-\><C-N>:call <SID>TermExecute('wincmd h')<CR>
tnoremap <silent> <C-W><C-J>  <C-\><C-N>:call <SID>TermExecute('wincmd j')<CR>
tnoremap <silent> <C-W><C-K>  <C-\><C-N>:call <SID>TermExecute('wincmd k')<CR>
tnoremap <silent> <C-W><C-L>  <C-\><C-N>:call <SID>TermExecute('wincmd l')<CR>
tnoremap <silent> <C-W>gt     <C-\><C-N>:call <SID>TermExecute('tabn')<CR>
tnoremap <silent> <C-W>gT     <C-\><C-N>:call <SID>TermExecute('tabp')<CR>
