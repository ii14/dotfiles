" See $VIMCONFIG/autoload/m/command.vim for command implementations
" See $VIMCONFIG/plugin/ for more command definitions

" :bd doesn't close window, :bq closes the window ----------------------------------------
command! -nargs=? -bang -complete=buffer Bq
  \ if <q-args> ==# '' && &bt ==# 'terminal' && get(b:, 'bbye_term_closed', 1) == 0
  \ | bd! | else | bd<bang> <args> | endif
call m#util#cabbrev('bq', 'Bq')
call m#util#cabbrev('bd', 'Bd')
call m#util#cabbrev('bw', 'Bw')

" Use fzf for help and buffers -----------------------------------------------------------
command! -nargs=? -complete=help H
  \ if <q-args> ==# '' | Helptags | else | h <args> | endif
command! -nargs=? -bang -complete=buffer B
  \ if <q-args> ==# '' | Buffers | else | b<bang> <args> | endif
call m#util#cabbrev('h', 'H')
call m#util#cabbrev('b', 'B')

" Set tab width. 4 by default, ! is noet -------------------------------------------------
command! -count=4 -bang T
  \ setl ts=<count> sts=<count> sw=<count> |
  \ exe 'setl '.('<bang>' ==# '' ? 'et' : 'noet')

" Fill the rest of the line with character -----------------------------------------------
command! -nargs=? Hr call m#command#hr(<q-args>)
call m#util#cabbrev('hr', 'Hr')

" :redir to a new buffer -----------------------------------------------------------------
command! -nargs=+ -complete=command Redir call m#command#redir(<q-args>)

" :set with prompt -----------------------------------------------------------------------
command! -nargs=1 -complete=option Set call m#command#set(<q-args>)

" Rename current file --------------------------------------------------------------------
command! RenameFile call m#command#rename_file()

" xdg-open -------------------------------------------------------------------------------
command! -nargs=? -complete=file Open call m#command#open(<q-args>)
call m#util#cabbrev('open', 'Open')

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
call m#util#cabbrev('git',  'Git')
call m#util#cabbrev('rg',   'Rg')
call m#util#cabbrev('man',  'Man')
call m#util#cabbrev('rc',   'Rc')
call m#util#cabbrev('rcd',  'Rcd')
call m#util#cabbrev('trim', 'Trim')
call m#util#cabbrev('fzf',  'Files')
call m#util#cabbrev('fern', 'Fern')
call m#util#cabbrev('vres', 'vert res')

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

" Lazy loaded cfilter --------------------------------------------------------------------
if !exists("loaded_cfilter")
  command! -nargs=+ -bang Cfilter packadd cfilter | Cfilter<bang> <args>
  command! -nargs=+ -bang Lfilter packadd cfilter | Lfilter<bang> <args>
  autocmd SourcePre $VIMRUNTIME/pack/dist/opt/cfilter/plugin/cfilter.vim ++once
    \ delcommand Cfilter | delcommand Lfilter
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
call m#util#cabbrev('scra', 'Scratch')
call m#util#cabbrev('scrat', 'Scratch')
call m#util#cabbrev('scratc', 'Scratch')
call m#util#cabbrev('scratch', 'Scratch')

" vim: tw=90 ts=2 sts=2 sw=2 et
