if executable('compiledb')
  com! -nargs=? -complete=dir Compiledb call s:compiledb(<q-args>)
  fun! s:compiledb(path)
    if a:path != ''
      exe 'Dispatch cd '.a:path.' && compiledb -o '.getcwd().'/compile_commands.json -n make'
    else
      Dispatch compiledb -n make
    endif
  endfun
endif
