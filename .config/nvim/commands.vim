" See $VIMCONFIG/autoload/m/command.vim for command implementations
" See $VIMCONFIG/plugin/ for more command definitions

function! Cabbrev(lhs, rhs)
  exe printf("cnorea <expr>%s (getcmdtype()==#':'&&getcmdline()==#'%s')?'%s':'%s'",
    \ a:lhs, a:lhs, a:rhs, a:lhs)
endfunction

" :bd doesn't close window, :bq closes the window ----------------------------------------
command! -nargs=? -bang -complete=buffer Bq
  \ if <q-args> ==# '' && &bt ==# 'terminal' && get(b:, 'bbye_term_closed', 1) == 0
  \ | bd! | else | bd<bang> <args> | endif
call Cabbrev('bq', 'Bq')
call Cabbrev('bd', 'Bd')
call Cabbrev('bw', 'Bw')

" Use fzf for help and buffers -----------------------------------------------------------
command! -nargs=? -complete=help H
  \ if <q-args> ==# '' | Helptags | else | h <args> | endif
command! -nargs=? -bang -complete=buffer B
  \ if <q-args> ==# '' | Buffers | else | b<bang> <args> | endif
call Cabbrev('h', 'H')
call Cabbrev('b', 'B')

" Set tab width. 4 by default, ! is noet -------------------------------------------------
command! -count=4 -bang T
  \ setl ts=<count> sts=<count> sw=<count> |
  \ exe 'setl '.('<bang>' ==# '' ? 'et' : 'noet')

" Fill the rest of the line with character -----------------------------------------------
command! -nargs=? Hr call m#command#hr(<q-args>)
call Cabbrev('hr', 'Hr')

" :redir to a new buffer -----------------------------------------------------------------
command! -nargs=+ -complete=command Redir call m#command#redir(<q-args>)

" :set with prompt -----------------------------------------------------------------------
command! -nargs=1 -complete=option Set call m#command#set(<q-args>)

" Rename current file --------------------------------------------------------------------
command! RenameFile call m#command#rename_file()

" xdg-open -------------------------------------------------------------------------------
command! -nargs=? -complete=file Open call m#command#open(<q-args>)
call Cabbrev('open', 'Open')

" ctags ----------------------------------------------------------------------------------
if executable('ctags')
  command! Ctags !ctags -R .
endif
if executable('qmltags') " https://github.com/pylipp/qtilities
  command! Qmltags !qmltags
endif

" Lightweight git blame ------------------------------------------------------------------
command! -nargs=? -range GB
  \ echo join(systemlist("git -C " . shellescape(expand('%:p:h'))
  \ .. " blame -L <line1>,<line2> <args> -- " . expand('%:t')), "\n")

" Shortcuts ------------------------------------------------------------------------------
command! Wiki VimwikiIndex
command! Vimrc edit $MYVIMRC

" Lowercase commands ---------------------------------------------------------------------
call Cabbrev('git',  'Git')
call Cabbrev('rg',   'Rg')
call Cabbrev('man',  'Man')
call Cabbrev('rc',   'Rc')
call Cabbrev('rcd',  'Rcd')
call Cabbrev('trim', 'Trim')
call Cabbrev('fzf',  'Files')
call Cabbrev('fern', 'Fern')
call Cabbrev('vres', 'vert res')

" Synstack -------------------------------------------------------------------------------
command! Synstack
  \ echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), ' > ')

" Fix typos ------------------------------------------------------------------------------
command! -bang Q q<bang>
command! -bang Qa qa<bang>
command! -bang QA qa<bang>

" Lazy loaded termdebug ------------------------------------------------------------------
if !exists(':Termdebug')
  command! -nargs=* -complete=file -bang Termdebug
    \ packadd termdebug | Termdebug<bang> <args>
  command! -nargs=+ -complete=file -bang TermdebugCommand
    \ packadd termdebug | TermdebugCommand<bang> <args>
  autocmd SourcePre $VIMRUNTIME/pack/dist/opt/termdebug/plugin/termdebug.vim ++once
    \ delcommand Termdebug | delcommand TermdebugCommand
endif

" Scratch buffer -------------------------------------------------------------------------
command! -nargs=? -bar -complete=filetype Scratch call s:Scratch(<q-args>)
function! s:Scratch(filetype)
  new
  setl buftype=nofile
  if !empty(a:filetype)
    let &l:filetype = a:filetype
  endif
  call nvim_buf_set_name(0, '[Scratch]')
  resize 15
endfunction
call Cabbrev('scra', 'Scratch')
call Cabbrev('scrat', 'Scratch')
call Cabbrev('scratc', 'Scratch')
call Cabbrev('scratch', 'Scratch')

" vim: tw=90 ts=2 sts=2 sw=2 et
