nnoremap <silent><unique> <leader>q :QF<CR>

com! QF call <SID>QFOpen()

fun! <SID>QFOpen()
  try
    silent clist
  catch
    redraw
    echom 'quickfix: Empty'
    return
  endtry
  copen
endfun

fun! <SID>QFSetupBuffer()
  nnoremap <buffer><nowait> j j
  nnoremap <buffer><nowait> k k
  nnoremap <buffer><nowait><silent> q :q<CR>
  nnoremap <buffer><nowait><silent> <Esc> :q<CR>
  nnoremap <buffer><nowait><silent> <leader>q :q<CR>
  nnoremap <buffer><nowait><silent> <CR> :call <SID>QFSelect()<CR>
  nnoremap <buffer><nowait><silent> c :call <SID>QFExec('cc')<CR>
  nnoremap <buffer><nowait><silent> ] :call <SID>QFExec('cnext')<CR>
  nnoremap <buffer><nowait><silent> [ :call <SID>QFExec('cprevious')<CR>
endfun

fun! <SID>QFExec(arg)
  try
    let w = winnr()
    silent exe a:arg
    norm! zz
    exe w . 'wincmd w'
    norm! zt
  catch
  endtry
endfun

fun! <SID>QFSelect()
  let w = winnr()
  norm! <CR>
  exe w . 'wincmd q'
  norm! zz
endfun

aug au_quickfix | au!
  au FileType qf call <SID>QFSetupBuffer()
aug end
