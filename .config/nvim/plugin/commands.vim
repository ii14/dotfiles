" See $VIMCONFIG/lua/m/cmd/init.lua and $VIMCONFIG/plugin/ for more command definitions

" Use fzf for help and buffers -----------------------------------------------------------
command! -nargs=? -complete=help H
  \ if <q-args> ==# '' | Helptags | else | h <args> | endif
command! -count=0 -nargs=? -bang -complete=buffer B
  \ if <q-args> ==# '' && <count> == 0 | Buffers |
  \ elseif <count> | <count>b<bang> |
  \ else | b<bang> <args> | endif
call m#cabbrev('h', 'H')
call m#cabbrev('b', 'B')

" Set tab width. 4 by default, ! is noet -------------------------------------------------
command! -count=4 -bang T
  \ setl ts=<count> sw=<count> sts=-1 |
  \ exe 'setl '.('<bang>' ==# '' ? 'et' : 'noet')

" ctags ----------------------------------------------------------------------------------
if executable('ctags')
  command! Ctags !ctags -R .
endif
" if executable('qmltags') " https://github.com/pylipp/qtilities
"   command! Qmltags !qmltags
" endif

" Lightweight git blame ------------------------------------------------------------------
command! -nargs=? -range GB
  \ call s:PrintLines(systemlist("git -C " . shellescape(expand('%:p:h'))
  \ .. " blame -L <line1>,<line2> <args> -- " . expand('%:t')))
function! s:PrintLines(list)
  for item in a:list
    echomsg item
  endfor
endfunction

" Shortcuts ------------------------------------------------------------------------------
command! Wiki VimwikiIndex
command! Vimrc edit $MYVIMRC

" Lowercase commands ---------------------------------------------------------------------
call m#cabbrev('git',  'Git')
call m#cabbrev('rg',   'Rg')
call m#cabbrev('man',  'Man')
call m#cabbrev('rc',   'Rc')
call m#cabbrev('rcd',  'Rcd')
call m#cabbrev('trim', 'Trim')
call m#cabbrev('fzf',  'Files')

call m#cabbrev('tsp',  'tab split')
call m#cabbrev('vres', 'vert res')
call m#cabbrev('mc',   'mes clear')

" Synstack -------------------------------------------------------------------------------
command! Synstack
  \ echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), ' > ')

" Fix typos ------------------------------------------------------------------------------
command! -bang -bar W  w<bang>
command! -bang -bar Q  q<bang>
command! -bang -bar Qa qa<bang>
command! -bang -bar QA qa<bang>

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

" vim: tw=90 ts=2 sts=2 sw=2 et
