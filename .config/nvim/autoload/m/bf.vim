function! s:forward(line, pos) abort
  if a:line ==# '' || a:pos < 0 || a:pos >= len(a:line)
    return -1
  endif
  let l:pos = a:pos
  if a:line[l:pos] =~ '\s'
    let l:pos = match(a:line, '\S', l:pos)
    if l:pos < 0
      return -1
    endif
  endif
  let l:pos = match(a:line, (a:line[l:pos] =~ '\w' ? '\W' : '\%(\w\|\s\)'), l:pos)
  return l:pos < 0 ? len(a:line) : l:pos
endfunction

function! s:backward(line, pos) abort
  let l:len = len(a:line)
  let l:line = list2str(reverse(str2list(a:line)))
  let l:pos = l:len - a:pos
  let l:res = s:forward(l:line, l:pos)
  return l:res < 0 ? -1 : l:len - l:res
endfunction

function! m#bf#iforward() abort
  let l:pos = getpos('.')
  let l:res = s:forward(getline('.'), l:pos[2] - 1)
  if l:res >= 0
    let l:pos[2] = l:res + 1
    call setpos('.', l:pos)
  else
    let l:lnum = line('.')
    if l:lnum < line('$')
      let l:res = s:forward(getline(l:lnum + 1), 0)
      let l:pos[1] += 1
      let l:pos[2] = l:res >= 0 ? l:res + 1 : 1
    else
      let l:pos[2] = len(getline('.')) + 1
    endif
    call setpos('.', l:pos)
  endif
  return ''
endfunction

function! m#bf#ibackward() abort
  let l:pos = getpos('.')
  let l:res = s:backward(getline('.'), l:pos[2] - 1)
  if l:res >= 0
    let l:pos[2] = l:res + 1
    call setpos('.', l:pos)
  else
    let l:lnum = line('.')
    if l:lnum > 1
      let l:line = getline(l:lnum - 1)
      let l:res = s:backward(l:line, len(l:line))
      let l:pos[1] -= 1
      let l:pos[2] = l:res >= 0 ? l:res + 1 : 1
    else
      let l:pos[2] = 1
    endif
    call setpos('.', l:pos)
  endif
  return ''
endfunction

function! m#bf#cforward() abort
  let l:line = getcmdline()
  let l:res = s:forward(l:line, getcmdpos() - 1)
  call setcmdpos(l:res >= 0 ? l:res + 1 : len(l:line) + 1)
  return ''
endfunction

function! m#bf#cbackward() abort
  let l:line = getcmdline()
  let l:res = s:backward(l:line, getcmdpos() - 1)
  call setcmdpos(l:res >= 0 ? l:res + 1 : 1)
  return ''
endfunction
