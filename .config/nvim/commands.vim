" See $VIMCONFIG/autoload/m/command.vim for command implementations
" See $VIMCONFIG/plugin/ for more command definitions

" :bd doesn't close window, :bq closes the window ----------------------------------------
command! -nargs=? -bang -complete=buffer Bq
  \ if <q-args> ==# '' && &bt ==# 'terminal' && get(b:, 'bbye_term_closed', 1) == 0
  \ | bd! | else | bd<bang> <args> | endif
call m#cabbrev('bq', 'Bq')
call m#cabbrev('bd', 'Bd')
call m#cabbrev('bw', 'Bw')

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

" Fill the rest of the line with character -----------------------------------------------
command! -nargs=? Hr call luaeval('require "m.misc".hr(_A)', <q-args>)
call m#cabbrev('hr', 'Hr')

" :redir to a new buffer -----------------------------------------------------------------
command! -nargs=+ -complete=command Redir
  \ call luaeval('require "m.misc".redir(_A)', <q-args>)

" :set with prompt -----------------------------------------------------------------------
command! -nargs=1 -complete=option Set
  \ call luaeval('require "m.misc".set(_A)', <q-args>)

" Rename current file --------------------------------------------------------------------
command! RenameFile lua require "m.misc".rename_file()

" compiledb ------------------------------------------------------------------------------
command! -nargs=? -complete=dir Compiledb
  \ call luaeval('require "m.compiledb".run(_A)', <q-args>)

" xdg-open -------------------------------------------------------------------------------
function s:OpenComp(A,L,P)
  return getcompletion(a:A, 'file', 1)
endfunction
command! -nargs=? -complete=customlist,s:OpenComp Open
  \ call luaeval('require "m.misc".open(_A)', <q-args>)
call m#cabbrev('open', 'Open')

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
call m#cabbrev('vres', 'vert res')

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
call m#cabbrev('scra', 'Scratch')
call m#cabbrev('scrat', 'Scratch')
call m#cabbrev('scratc', 'Scratch')
call m#cabbrev('scratch', 'Scratch')

" vim: tw=90 ts=2 sts=2 sw=2 et
