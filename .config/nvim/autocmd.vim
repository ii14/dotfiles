augroup VimrcAutocmd
  autocmd!

" Return to last edit position ---------------------------------------------------------
  au BufReadPost *
    \ if index(['gitcommit', 'fugitive'], &filetype) == -1 &&
    \   line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" Gutter and cursor line ---------------------------------------------------------------
  func! s:cursorline()
    return &bt !=# 'terminal' && !get(w:, 'diffview', v:false)
  endfunc
  au WinEnter,BufWinEnter * if s:cursorline() | setl   cursorline | endif
  au WinLeave             * if s:cursorline() | setl nocursorline | endif
  au TermOpen    * setl nonumber norelativenumber nocursorline signcolumn=auto
  au CmdwinEnter * setl nonumber norelativenumber

" Highlight yanked text ----------------------------------------------------------------
  au TextYankPost * silent! lua vim.highlight.on_yank()

" Open quickfix window on grep ---------------------------------------------------------
  au QuickFixCmdPost grep,grepadd,vimgrep,helpgrep
    \ call timer_start(10, {-> execute('cwindow')})
  au QuickFixCmdPost lgrep,lgrepadd,lvimgrep,lhelpgrep
    \ call timer_start(10, {-> execute('lwindow')})

" Auto close quickfix, if it's the last buffer -----------------------------------------
  au WinEnter * if winnr('$') == 1 && &buftype ==# 'quickfix' | q! | endif

" Workarounds --------------------------------------------------------------------------
  " Fix wrong size on alacritty on i3 (https://github.com/neovim/neovim/issues/11330)
  au VimEnter * silent exec "!kill -s SIGWINCH $PPID"

augroup end

" vim: tw=90 ts=2 sts=2 sw=2 et
