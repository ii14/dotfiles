" Custom command line options
let s:argv = deepcopy(v:argv)
let s:eoa = index(s:argv, '--')
if s:eoa > 0
  let s:argv = s:argv[:s:eoa - 1]
endif
unlet s:eoa

let g:options = {}
function! m#addopts(names)
  for l:name in a:names
    exec 'command' l:name 'exec'
    let g:options[l:name] = index(s:argv, '+'..l:name) > 0 ? v:true : v:false
  endfor
endfunction

autocmd VimEnter * ++once call s:cleanup()
function! s:cleanup()
  for l:name in keys(g:options)
    exec 'delcommand' l:name
  endfor
endfunction


" Lowercase command alias
function! m#cabbrev(lhs, rhs) abort
  exe printf("cnorea <expr>%s (getcmdtype()==#':'&&getcmdline()==#'%s')?'%s':'%s'",
    \ a:lhs, a:lhs, a:rhs, a:lhs)
endfunction


" Current buffer directory
function! m#bufdir() abort
  if &buftype ==# 'terminal' && has('linux')
    let d = luaeval('vim.loop.fs_readlink("/proc/".._A.."/cwd") or ""', b:terminal_job_pid)
    if d !=# '' | let d = fnamemodify(d, ':~:.') | endif
  else
    let d = expand('%:h')
  endif
  return (d ==# '' ? './' : d[-1:] ==# '/' ? d : d..'/')
endfunction
