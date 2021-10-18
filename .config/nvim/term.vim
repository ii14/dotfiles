augroup VimrcTerm
  autocmd!
  " Disable insert mode after terminal process terminates.
  " 'nomodifiable' doesn't work, but maybe there is a better way to do it?
  autocmd TermClose * ++nested stopinsert | au VimrcTerm TermEnter <buffer> stopinsert
  autocmd TermOpen * let b:term_forward_esc = 1
augroup end

" Forward escape key ---------------------------------------------------------------------
let g:term_forward_esc = ['n\?vim\%(.\.\*\)\?', 'fzf']
tnoremap <nowait><silent><expr> <Esc> m#term#should_forward_esc() ? '<Esc>' : '<C-\><C-N>'
tnoremap <C-\><Esc> <Esc>
tnoremap <C-\><C-C> <Nop>

" Scroll ---------------------------------------------------------------------------------
tnoremap <S-PageUp>   <C-\><C-N><C-B>
tnoremap <S-PageDown> <C-\><C-N><C-F>

" vim: tw=90 ts=2 sts=2 sw=2 et
