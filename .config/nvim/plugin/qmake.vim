" Description: Run qmake
" Usage:
"   :QMake[!] [args]  - with ! overrides default arguments.
" Configuration:
"   All variables have a global (g:) and tab-local variant (t:).
"     g:qmake_bin     - Path to qmake binary. Default: 'qmake'
"     g:qmake_dir     - Build directory.
"     g:qmake_args    - Default arguments.
"     g:qmake_post    - Post hook.

command! -bar -bang -nargs=* QMake call s:run(<q-args>, <bang>0)

function! s:error(msg)
  echohl ErrorMsg
  echomsg 'QMake:' a:msg
  echohl None
endfunction

function! s:get(name, ...) abort
  if has_key(t:, a:name)
    return get(t:, a:name)
  elseif has_key(g:, a:name)
    return get(g:, a:name)
  else
    return a:0 ? a:1 : ''
  endif
endfunction

function! s:run(args, bang) abort
  if empty(readdir(getcwd(), { n -> filereadable(n) && n =~? '\M.pro$' }))
    call s:error('project file not found')
    return
  endif

  let l:dir = s:get('qmake_dir')
  if l:dir !=# '' && l:dir !=# '.'
    if !mkdir(l:dir, 'p')
      call s:error('could not create build directory: '..l:dir)
      return
    endif
  endif

  let l:cmd = [s:get('qmake_bin', 'qmake')]
  if !a:bang
    call add(l:cmd, s:get('qmake_args'))
  endif
  call add(l:cmd, a:args)
  call add(l:cmd, getcwd())
  let l:cmd = '!'..join(l:cmd)
  echomsg l:cmd
  execute l:cmd
  if v:shell_error != 0
    call s:error('qmake failed with code '..v:shell_error)
    return
  endif

  let l:post = s:get('qmake_post')
  if l:post !=# ''
    echomsg l:post
    execute l:post
  endif
endfunction
