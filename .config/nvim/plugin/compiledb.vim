" Description: Generate compile_commands.json for C++ language servers
"
" Usage:
"
"     :Compiledb[!] [{directory}]
"         Uses g:compiledb_path if {directory} is not specified.
"         If ! is provided, saves {directory} to g:compiledb_path
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
"     - jq (optional)

if !executable('compiledb')
  finish
endif

command! -bang -nargs=? -complete=dir Compiledb call s:Run(<q-args>, <bang>0)

let s:has_jq = executable('jq')

" TODO: async?
fun! s:Run(path, bang) abort
  let output = getcwd().'/compile_commands.json'

  if a:path !=# ''
    if a:bang
      let g:compiledb_path = a:path
    endif
    let cmd = '(cd '.a:path.' && compiledb -o '.output.' -n make)'
  elseif exists('g:compiledb_path')
    let cmd = '(cd '.g:compiledb_path.' && compiledb -o '.output.' -n make)'
  else
    let cmd = '(compiledb -o '.output.' -n make)'
  endif

  if exists('g:compiledb_post')
    let cmd = cmd.' && '.g:compiledb_post
  endif

  echohl WarningMsg
  echomsg 'Compiledb: '.cmd
  echohl None

  let res = system(cmd)
  if v:shell_error != 0
    throw 'Compiledb: compiledb failed with code '.v:shell_error.': '.res
  endif

  if s:has_jq
    let res = system(['jq', '.|length', output])
    if v:shell_error != 0
      throw 'Compiledb: jq failed with code '.v:shell_error.': '.res
    endif

    let rules = matchstr(res, '\V\d\+')
    if rules ==# ''
      throw 'Compiledb: jq failed to parse output: '.res
    endif

    redraw
    echohl Function
    echomsg 'Compiledb: compile_commands.json generated '.rules.' rules'
    echohl None
  else
    redraw
    echohl Function
    echomsg 'Compiledb: compile_commands.json generated'
    echohl None
  endif
endfun


finish
" TODO: everything below is work in progress. filtering files from output

fun! s:Match(line, inc, exc) abort
  for g in a:inc
    if a:line !~ g
      return v:false
    endif
  endfor
  for g in a:exc
    if a:line =~ g
      return v:false
    endif
  endfor
  return v:true
endfun

fun! s:Filter(path) abort
  if !has_key(g:, 'compiledb_filt')
    return
  endif

  let t = type(g:compiledb_filt)
  if t == v:t_string
    let filt = [g:compiledb_filt]
  elseif t == v:t_list
    let filt = g:compiledb_filt
  else
    echomsg 'Invalid g:compiledb_filt type'
    return
  endif

  let inc = []
  let exc = []
  for f in filt
    if f[0] ==# '!'
      call add(exc, glob2regpat(f[1:]))
    else
      call add(inc, glob2regpat(f))
    endif
  endfor

  let res = system(['jq', '-r', '.[].file', a:path])
  if v:shell_error != 0
    echomsg 'jq failed'
    return
  endif

  let idxs = []
  let i = 0
  for line in split(res, '\n')
    if s:Match(line, inc, exc)
      call add(idxs, i)
    endif
    let i += 1
  endfor

  let res = system(['jq', '.['.join(idxs, ',').']', a:path])
  if v:shell_error != 0
    echomsg 'jq failed'
    return
  endif
  echo res
endfun
