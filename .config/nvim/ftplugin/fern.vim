setl nonumber norelativenumber

nmap <buffer><nowait> -     <Plug>(fern-action-leave)
nmap <buffer><nowait> <BS>  <Plug>(fern-action-leave)
nmap <buffer><nowait> <CR>  <Plug>(fern-open-or-enter)
nmap <buffer><nowait> h     <Plug>(fern-action-collapse)
nmap <buffer><nowait> l     <Plug>(fern-open-or-expand)
nmap <buffer><nowait> e     <Plug>(fern-action-open)
nmap <buffer><nowait> E     <Plug>(fern-action-open:side)

nmap <buffer><nowait> m     <Plug>(fern-action-mark:toggle)j
vmap <buffer><nowait> m     <Plug>(fern-action-mark:toggle)
nmap <buffer><nowait> N     <Plug>(fern-action-new-path)
nmap <buffer><nowait> R     <Plug>(fern-action-rename)
nmap <buffer><nowait> C     <Plug>(fern-action-clipboard-copy)
nmap <buffer><nowait> M     <Plug>(fern-action-clipboard-move)
nmap <buffer><nowait> P     <Plug>(fern-action-clipboard-paste)
nmap <buffer><nowait> D     <Plug>(fern-action-trash)

nmap <buffer><nowait> !     <Plug>(fern-action-hidden-toggle)
nmap <buffer><nowait> fi    <Plug>(fern-action-include)
nmap <buffer><nowait> fe    <Plug>(fern-action-exclude)

nmap <buffer><nowait> <F5>  <Plug>(fern-action-reload)
nmap <buffer><nowait> <C-C> <Plug>(fern-action-cancel)

nnoremap <buffer><nowait> q :Bdelete!<CR>

nnoremap <buffer> <C-H> <C-W>h
nnoremap <buffer> <C-L> <C-W>l
nnoremap <buffer> <C-K> <C-W>k
nnoremap <buffer> <C-J> <C-W>j
