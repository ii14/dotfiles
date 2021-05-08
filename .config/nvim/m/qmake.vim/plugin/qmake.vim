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

" TODO: accept args in :QMake

command! -nargs=* QMake call s:Run(<q-args>)

fun! s:Format(args) abort
  let bin  = get(g:, 'qmake#bin', 'qmake')
  let dir  = get(g:, 'qmake#dir', '')
  let args = a:args !=# '' ? a:args : get(g:, 'qmake#args', '')
  let post = get(g:, 'qmake#post', '')

  let cmd =
    \ (dir !=# '' && dir !=# '.' ? 'mkdir -p '.dir.' && cd '.dir.' && ' : '')
    \ . bin
    \ . (args !=# '' ? ' '.args : '')
    \ . ' '.getcwd()
    \ . (post !=# '' ? ' && '.post : '')

  return cmd
endfun

fun! s:Run(args) abort
  if len(readdir(getcwd(), { n -> filereadable(n) && n =~ '.pro$' })) > 0
    " let runner = exists(':Dispatch') ? 'Dispatch ' : '!'
    " execute runner.s:Format(a:args)
    execute '!'.s:Format(a:args)
  else
    echomsg 'QMake: Project file not found'
  endif
endfun
