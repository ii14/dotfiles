fun! s:error(msg)
  echohl ErrorMsg
  echo a:msg
  echohl None
endfun

fun! s:hasqf()
  try
    silent clist
    return v:true
  catch
    return v:false
  endtry
endfun

fun! s:qfvisible()
  return !empty(filter(getwininfo(), {_, win -> win.tabnr == tabpagenr() && win.quickfix && !win.loclist}))
endfun

fun! qf#open()
  if s:hasqf()
    copen
  else
    redraw
    call s:error('quickfix: Empty')
  endif
endfun

fun! qf#show()
  if s:hasqf()
    copen
    wincmd p
  else
    redraw
    call s:error('quickfix: Empty')
  endif
endfun

fun! qf#toggle()
  if s:qfvisible()
    cclose
  else
    call qf#show()
  endif
endfun

fun! qf#cvsplit()
  let l = line('.')
  wincmd p
  wincmd v
  exe l.'cc'
endfun

fun! qf#csplit()
  let l = line('.')
  wincmd p
  wincmd s
  exe l.'cc'
endfun

fun! qf#ctabsplit()
  let l = line('.')
  wincmd p
  tab split
  exe l.'cc'
endfun

fun! qf#lvsplit()
  let l = line('.')
  wincmd p
  wincmd v
  exe l.'ll'
endfun

fun! qf#lsplit()
  let l = line('.')
  wincmd p
  wincmd s
  exe l.'ll'
endfun

fun! qf#ltabsplit()
  let l = line('.')
  wincmd p
  tab split
  exe l.'ll'
endfun

fun! qf#textfunc(info)
  if a:info.quickfix
    let items = getqflist({'id': a:info.id, 'items': 1}).items
  else
    let items = getloclist(0, {'id': a:info.id, 'items': 1}).items
  endif
  let l = []
  for idx in range(a:info.start_idx - 1, a:info.end_idx - 1)
    let item = items[idx]
    let line = ''
    if item.bufnr
      let line .= fnamemodify(bufname(item.bufnr), ':p:.')
    endif
    let line .= ':'
    if item.lnum != 0
      let line .= (item.lnum)
    endif
    let line .= ':'
    if item.col != 0
      let line .= (item.col)
    endif
    let line .= ': '.(item.text)
    call add(l, line)
  endfor
  return l
endfun