" Description: Run qmake
" Usage: :QMake
" Configuration:
"
"     g:qmake#bin
"         Path to qmake binary.
"         Default: 'qmake'
"
"     g:qmake#dir
"         Build directory.
"
"     g:qmake#args
"         QMake arguments.
"
"     g:qmake#post
"         Post hook.

command! QMake call s:Run()

fun! s:Format() abort
  let bin  = get(g:, 'qmake#bin',  'qmake')
  let dir  = get(g:, 'qmake#dir',  '')
  let args = get(g:, 'qmake#args', '')
  let post = get(g:, 'qmake#post', '')

  let cmd =
    \ (dir !=# '' && dir !=# '.' ? 'mkdir -p '.dir.' && cd '.dir.' && ' : '')
    \ . bin
    \ . (args !=# '' ? ' '.args : '')
    \ . ' '.getcwd()
    \ . (post !=# '' ? ' && '.post : '')

  return cmd
endfun

fun! s:Run() abort
  if len(readdir(getcwd(), { n -> filereadable(n) && n =~ '.pro$' })) > 0
    execute '!'.s:Format()
  else
    echomsg 'QMake: Project file not found'
  endif
endfun
