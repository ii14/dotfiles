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
  nnoremap <buffer><nowait><silent> J :call <SID>QFExec('cnext')<CR>
  nnoremap <buffer><nowait><silent> ] :call <SID>QFExec('cnext')<CR>
  nnoremap <buffer><nowait><silent> K :call <SID>QFExec('cprevious')<CR>
  nnoremap <buffer><nowait><silent> [ :call <SID>QFExec('cprevious')<CR>

  let b:last_win = winnr('#')
  au WinEnter  <buffer> if &ft ==? 'qf' | let b:last_win = winnr('#') | endif
  au WinClosed <buffer> if &ft ==? 'qf' | exe b:last_win.'wincmd w' | endif
endfun

fun! <SID>QFExec(arg)
  try
    let w = winnr()
    silent exe a:arg
    norm! zz
    exe w . 'wincmd w'
    norm! zz
  catch
  endtry
endfun

fun! <SID>QFSelect()
  let w = winnr()
  .cc
  exe w . 'wincmd q'
  norm! zz
endfun

aug au_quickfix | au!
  au FileType qf call <SID>QFSetupBuffer()
aug end
