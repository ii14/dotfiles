augroup m_autocmd
  autocmd!

" Return to last edit position -----------------------------------------------------------
  autocmd BufReadPost *
    \ if index(['gitcommit', 'fugitive'], &filetype) == -1 &&
    \   line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" Gutter and cursor line -----------------------------------------------------------------
  func! s:cursorline()
    return &bt !=# 'terminal' && !get(w:, 'diffview', v:false)
  endfunc
  autocmd WinEnter,BufWinEnter * if s:cursorline() | setl   cursorline | endif
  autocmd WinLeave             * if s:cursorline() | setl nocursorline | endif
  autocmd TermOpen    * setl nonumber norelativenumber nocursorline signcolumn=auto scrolloff=0
  autocmd CmdwinEnter * setl nonumber norelativenumber

" Highlight yanked text ------------------------------------------------------------------
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()

" Open quickfix window on grep -----------------------------------------------------------
  autocmd QuickFixCmdPost grep,grepadd,vimgrep,helpgrep
    \ call timer_start(10, {-> execute('cwindow')})
  autocmd QuickFixCmdPost lgrep,lgrepadd,lvimgrep,lhelpgrep
    \ call timer_start(10, {-> execute('lwindow')})

" Auto close quickfix, if it's the last buffer -------------------------------------------
  autocmd WinEnter * if winnr('$') == 1 && &buftype ==# 'quickfix' | q! | endif

" Workarounds ----------------------------------------------------------------------------
  " Fix wrong size on alacritty on i3 (https://github.com/neovim/neovim/issues/11330)
  autocmd VimEnter * call system('kill -s SIGWINCH $PPID')

augroup end

" vim: tw=90 ts=2 sts=2 sw=2 et
