let s:registers = map(str2list(
  \ '"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'),
  \ 'nr2char(v:val)')

function! Regedit(reg) abort
  if a:reg != ''
    let l:reg = a:reg
  else
    echo 'Select register...'
    let l:reg = getchar()
    redraw
    if l:reg == 0 || l:reg == 27 " C-C or ESC
      return
    endif
    let l:reg = nr2char(l:reg)
  endif

  if index(s:registers, l:reg) < 0
    echohl ErrorMsg
    echomsg 'Unknown register: '..l:reg
    echohl None
    return
  endif

  new
  wincmd J
  resize 1
  setl winfixheight
  setl winhighlight=SpecialKey:SpecialChar

  setl buftype=acwrite
  setl bufhidden=wipe
  setl nobuflisted
  setl noundofile
  setl nonumber norelativenumber
  setl nowrap nolist
  setl colorcolumn=

  const b:reg = '@'..l:reg
  call nvim_buf_set_name(0, b:reg)
  exec 'call nvim_buf_set_lines(0, 0, -1, v:false, ['..b:reg..'])'
  setl nomodified

  autocmd BufWriteCmd <buffer>
    \ exec 'let '..b:reg..' = nvim_buf_get_lines(0, 0, -1, v:false)[0]' |
    \ setl nomodified
endfunction

command! -nargs=? Regedit call Regedit(<q-args>)
