" Description: Generate compile_commands.json for C++ language servers
"
" Usage:
"
"     :Compiledb {directory}
"         Uses g:compiledb_path if {directory} is not specified.
"
" Configuration:
"
"     g:compiledb_path
"         Path to makefile directory.
"         Default: '.'
"
"     g:compiledb_post
"         Post hook.
"
" Dependencies:
"
"     - compiledb (installed via pip)
"     - tpope/dispatch.vim

" TODO: fallback to :make

if !executable('compiledb')
  finish
endif

command! -nargs=? -complete=dir Compiledb call s:Run(<q-args>)

fun! s:Run(path)
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

  execute cmd
endfun
