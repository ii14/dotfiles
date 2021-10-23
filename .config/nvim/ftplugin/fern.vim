" FERN BUFFER //////////////////////////////*buffer-fern*/////////////////////////////////

setl nonumber norelativenumber
setl textwidth=0

nmap <buffer><nowait> -     <Plug>(fern-action-leave)
nmap <buffer><nowait> <BS>  <Plug>(fern-action-leave)
nmap <buffer><nowait> <CR>  <Plug>(fern-action-open-or-enter)
nmap <buffer><nowait> l     <Plug>(fern-action-open-or-expand)
nmap <buffer><nowait> h     <Plug>(fern-action-collapse)
nmap <buffer><nowait> e     <Plug>(fern-action-open)
nmap <buffer><nowait> E     <Plug>(fern-action-open:side)
nmap <buffer><nowait> s     <Plug>(fern-action-open:split)
nmap <buffer><nowait> v     <Plug>(fern-action-open:vsplit)
nmap <buffer><nowait> w     <Plug>(fern-action-open:select)

nmap <buffer><nowait> m     <Plug>(fern-action-mark:toggle)j
nmap <buffer><nowait> gm    <Plug>(fern-action-mark:toggle)
vmap <buffer><nowait> m     <Plug>(fern-action-mark:toggle)
nmap <buffer><nowait> gc    <Plug>(fern-action-mark:clear)

nmap <buffer><nowait> gn    <Plug>(fern-action-new-path)
nmap <buffer><nowait> gr    <Plug>(fern-action-rename)
nmap <buffer><nowait> gy    <Plug>(fern-action-clipboard-copy)
nmap <buffer><nowait> gd    <Plug>(fern-action-clipboard-move)
nmap <buffer><nowait> gp    <Plug>(fern-action-clipboard-paste)
nmap <buffer><nowait> gd    <Plug>(fern-action-trash)

nmap <buffer><nowait> y     <Plug>(fern-action-yank:path)

nmap <buffer> <Plug>(fern-action-cd) <Plug>(fern-action-cd:root)

nmap <buffer><nowait> !     <Plug>(fern-action-hidden:toggle)
nmap <buffer><nowait> gi    <Plug>(fern-action-include)
nmap <buffer><nowait> ge    <Plug>(fern-action-exclude)

nmap <buffer><nowait> r     <Plug>(fern-action-reload)
nmap <buffer><nowait> <C-C> <Plug>(fern-action-cancel)

nmap <buffer><nowait> ff    <Plug>(fern-action-fzf-files)
nmap <buffer><nowait> fd    <Plug>(fern-action-fzf-dirs)
nmap <buffer><nowait> fa    <Plug>(fern-action-fzf-both)

nno  <buffer><nowait> ? ?
nmap <buffer><nowait> g? <Plug>(fern-action-help)

nno <buffer><nowait><silent> q :call <SID>fern_close()<CR>
function! s:fern_close()
  if fern#internal#drawer#is_drawer()
    close
  else
    let bufnr = bufnr()
    Bdelete!
    exe 'bwipeout' bufnr
  endif
endfunction

nno <buffer> <C-H> <C-W>h
nno <buffer> <C-L> <C-W>l
nno <buffer> <C-K> <C-W>k
nno <buffer> <C-J> <C-W>j

" vim: tw=90 ts=2 sts=2 sw=2 et
