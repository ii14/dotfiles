if empty($NVIM_LISTEN_ADDRESS) || $NVIM_LISTEN_ADDRESS ==# v:servername
  finish
endif

set noloadplugins
set noswapfile
set noundofile
set nobackup
filetype off
syntax off

fun! s:enter() abort
  let r = jobstart(['nc', '-U', $NVIM_LISTEN_ADDRESS], {'rpc': v:true})
  let fs = argv()
  if empty(fs)
    call rpcrequest(r, 'nvim_command', 'enew')
  else
    let fs = map(fs, {_,v -> fnameescape(fnamemodify(v, ':p'))})
    call rpcrequest(r, 'nvim_command', 'argadd '..join(fs, ' '))
    call rpcrequest(r, 'nvim_command', 'edit '..fs[0])
  endif
  qa!
endfun

au VimEnter * call s:enter()
