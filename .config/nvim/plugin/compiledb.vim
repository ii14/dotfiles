if !executable('compiledb')
  finish
endif

com! -nargs=? -complete=dir Compiledb call s:run(<q-args>)
fun! s:run(path)
  if a:path !=# ''
    let g:compiledb_path = a:path
    let cmd = 'Dispatch (cd ' . a:path . ' && compiledb -o '
      \ . getcwd() . '/compile_commands.json -n make)'
  elseif exists('g:compiledb_path')
    let cmd = 'Dispatch (cd ' . g:compiledb_path . ' && compiledb -o '
      \ . getcwd() . '/compile_commands.json -n make)'
  else
    let cmd = 'Dispatch (compiledb -n make)'
  endif

  if exists('g:compiledb_post')
    let cmd = cmd.' && '.g:compiledb_post
  endif

  exe cmd
endfun

com! -nargs=? -complete=dir CompiledbPath call s:path(<q-args>)
fun! s:path(path)
  if a:path !=# ''
    let g:compiledb_path = a:path
  else
    if exists('g:compiledb_path')
      echo g:compiledb_path
    else
      echo '.'
    endif
  endif
endfun

com! CompiledbEdit call s:edit()
fun! s:edit()
  let path = getcwd().'/compile_commands.json'
  if filereadable(path)
    exe 'edit ' . path
  else
    echo 'File ' . path . ' does not exist!'
  endif
endfun
