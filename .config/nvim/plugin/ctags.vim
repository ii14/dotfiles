" Description: Generate ctags

if executable('ctags')
  command! Ctags !ctags -R .
endif

" https://github.com/pylipp/qtilities
if executable('qmltags')
  command! Qmltags !qmltags
endif
