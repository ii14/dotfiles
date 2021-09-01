command! -nargs=? -complete=file Open call s:Open(<q-args>)

function! s:Open(file)
  let file = a:file ==# '' ? '%' : a:file
  let cmd = 'xdg-open ' . shellescape(expand(file))
  echo cmd
  call system(cmd)
endfunction
