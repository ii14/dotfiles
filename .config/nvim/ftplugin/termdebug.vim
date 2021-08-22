tnoremap <buffer> <Esc> <C-\><C-N>
tnoremap <buffer><nowait> <C-W> <C-W>
autocmd TermClose <buffer> execute 'bdelete! '..expand('<abuf>')
