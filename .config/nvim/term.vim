augroup Term
  autocmd!
  " Disable insert mode after terminal process terminates.
  " 'nomodifiable' doesn't work, but maybe there is a better way to do it?
  autocmd TermClose * ++nested stopinsert | au Term TermEnter <buffer> stopinsert
augroup end

tnoremap <S-PageUp>   <C-\><C-N><C-B>
tnoremap <S-PageDown> <C-\><C-N><C-F>


" Vim terminal key bindings --------------------------------------------------------------

function! s:TermEnter(_)
  if getbufvar(bufnr(), 'term_insert', 0)
    startinsert
    call setbufvar(bufnr(), 'term_insert', 0)
  endif
endfunction

function! <SID>TermExec(cmd)
  let b:term_insert = 1
  execute a:cmd
endfunction

augroup Term
  autocmd CmdlineLeave,WinEnter,BufWinEnter * call timer_start(0, function('s:TermEnter'), {})
  autocmd FileType fzf tnoremap <nowait><buffer> <C-W> <C-W>
augroup end

tnoremap <silent> <C-W>.      <C-W>
tnoremap <silent> <C-W><C-.>  <C-W>
tnoremap <silent> <C-W><C-\>  <C-\>
tnoremap <silent> <C-W>N      <C-\><C-N>
tnoremap <silent> <C-W>:      <C-\><C-N>:call <SID>TermExec('call feedkeys(":")')<CR>
tnoremap <silent> <C-W><C-W>  <cmd>call <SID>TermExec('wincmd w')<CR>
tnoremap <silent> <C-W>h      <cmd>call <SID>TermExec('wincmd h')<CR>
tnoremap <silent> <C-W>j      <cmd>call <SID>TermExec('wincmd j')<CR>
tnoremap <silent> <C-W>k      <cmd>call <SID>TermExec('wincmd k')<CR>
tnoremap <silent> <C-W>l      <cmd>call <SID>TermExec('wincmd l')<CR>
tnoremap <silent> <C-W><C-H>  <cmd>call <SID>TermExec('wincmd h')<CR>
tnoremap <silent> <C-W><C-J>  <cmd>call <SID>TermExec('wincmd j')<CR>
tnoremap <silent> <C-W><C-K>  <cmd>call <SID>TermExec('wincmd k')<CR>
tnoremap <silent> <C-W><C-L>  <cmd>call <SID>TermExec('wincmd l')<CR>
tnoremap <silent> <C-W>gt     <cmd>call <SID>TermExec('tabn')<CR>
tnoremap <silent> <C-W>gT     <cmd>call <SID>TermExec('tabp')<CR>
tnoremap <expr>   <C-W><C-R>  '<C-\><C-N>"'.nr2char(getchar()).'pi'


" Quick terminal window ------------------------------------------------------------------

let s:terms = {}
let s:tabs = {}
let s:height = 12

function! s:GetWindow() abort
  let tabnr = tabpagenr()
  if !has_key(s:tabs, tabnr)
    vsplit
    wincmd J
    execute 'resize '.s:height
    setl winfixheight
    let s:tabs[tabnr] = win_getid()
    return 0
  elseif s:tabs[tabnr] != win_getid()
    call win_gotoid(s:tabs[tabnr])
    return 0
  else
    return 1
  endif
endfunction

function! s:GetTerm(termid) abort
  if !has_key(s:terms, a:termid)
    enew
    call termopen(&shell, {'env': {'TITLE': 'Term '.a:termid}})
    let b:term_title = 'Term '.a:termid
    tnoremap <buffer><silent> <F1> <cmd>call <SID>NewTerm(1)<CR>
    tnoremap <buffer><silent> <F2> <cmd>call <SID>NewTerm(2)<CR>
    tnoremap <buffer><silent> <F3> <cmd>call <SID>NewTerm(3)<CR>
    tnoremap <buffer><silent> <F4> <cmd>call <SID>NewTerm(4)<CR>
    execute 'autocmd TermClose <buffer> ++nested call s:TermClose('.a:termid.')'
    setl nobuflisted
    setl signcolumn=no
    let s:terms[a:termid] = bufnr()

    " fixes invisible cursor bug
    stopinsert
    call timer_start(0, { -> execute('startinsert') })
    return 0
  else
    let bufnr = s:terms[a:termid]
    if bufnr != bufnr()
      execute bufnr.'buffer'

      " fixes invisible cursor bug
      stopinsert
      call timer_start(0, { -> execute('startinsert') })
      return 0
    else
      return 1
    endif
  endif
endfunction

function! s:TermClose(termid)
  if has_key(s:terms, a:termid)
    try
      execute s:terms[a:termid].'bdelete!'
    catch
    endtry
    unlet s:terms[a:termid]
  endif
endfunction

function! s:WinClosed(winid)
  for tabnr in keys(s:tabs)
    if s:tabs[tabnr] == a:winid
      unlet s:tabs[tabnr]
    endif
  endfor
endfunction

function! s:TabClosed(tabnr)
  if has_key(s:tabs, a:tabnr)
    unlet s:tabs[a:tabnr]
  endif
endfunction

function! <SID>NewTerm(termid) abort
  let a = s:GetWindow()
  let b = s:GetTerm(a:termid)
  if a == 1 && b == 1
    quit
  endif
endfunction

augroup Term
  autocmd WinClosed * call s:WinClosed(expand('<afile>'))
  autocmd TabClosed * call s:TabClosed(expand('<afile>'))
augroup end

command! -count=12 Tresize call s:TermResize(<count>)
function! s:TermResize(height)
  let s:height = a:height
  let tabnr = tabpagenr()
  if has_key(s:tabs, tabnr)
    let winid = win_getid()
    call win_gotoid(s:tabs[tabnr])
    execute 'resize '.s:height
    call win_gotoid(winid)
  endif
endfunction

nnoremap <silent> <F1> :call <SID>NewTerm(1)<CR>
nnoremap <silent> <F2> :call <SID>NewTerm(2)<CR>
nnoremap <silent> <F3> :call <SID>NewTerm(3)<CR>
nnoremap <silent> <F4> :call <SID>NewTerm(4)<CR>
