com! QMake call s:run()

fun! s:format() abort
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

fun! s:run() abort
  if len(readdir(getcwd(), { n -> filereadable(n) && n =~ '.pro$' })) > 0
    exe '!'.s:format()
  else
    echom 'QMake: Project file not found'
  endif
endfun
