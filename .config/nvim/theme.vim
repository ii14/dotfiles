set background=dark
colorscheme onedark

let g:lightline = {}

let g:lightline.colorscheme = 'onedark'

" let g:lightline.separator    = {'left': '', 'right': ''}
" let g:lightline.subseparator = {'left': '', 'right': ''}

let g:lightline.active = {
  \ 'left'  : [['mode', 'paste'], ['fugitive', 'pro', 'readonly', 'filename']],
  \ 'right' : [['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype']],
  \ }

let g:lightline.tabline = {
  \ 'left'  : [['buffers']],
  \ 'right' : [[]],
  \ }

let g:lightline.component_function = {
  \ 'mode'         : 'LightlineMode',
  \ 'filename'     : 'LightlineFilename',
  \ 'fileformat'   : 'LightlineFileformat',
  \ 'fileencoding' : 'LightlineFileencoding',
  \ 'filetype'     : 'LightlineFiletype',
  \ 'fugitive'     : 'LightlineFugitive',
  \ 'pro'          : 'LightlinePro',
  \ }

let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline.component_raw    = {'buffers': 1}

set showtabline=2
let g:lightline#bufferline#unnamed   = '[No Name]'
let g:lightline#bufferline#clickable = 1
" let g:lightline#bufferline#min_buffer_count = 2

fun! LightlineMode()
  if &ft ==# 'fern' | return 'Fern' | endif
  if &bt ==# 'quickfix' | return get(b:, 'qf_isLoc', 1) ? 'Location' : 'QuickFix' | endif
  return winwidth(0) < 50 ? '' : lightline#mode()
endfun

fun! LightlineFilename()
  " fern internals, can potentially break
  if &ft ==# 'fern' | try | return b:fern.root._path | catch | return '' | endtry | endif
  if &ft ==# 'scratch' | return 'Scratch' | endif
  if &bt ==# 'quickfix' | return getqflist({'title':1}).title | endif
  let fname = expand('%:t')
  return fname ==# '' ? '[No Name]' : &mod ? fname.' +' : fname
endfun

fun! LightlineFileformat()
  if &ft ==# 'fern' || &bt ==# 'quickfix' | return '' | endif
  return winwidth(0) > 70 && &ff !=# 'unix' ? &ff : ''
endfun

fun! LightlineFileencoding()
  if &ft ==# 'fern' || &bt ==# 'quickfix' | return '' | endif
  return winwidth(0) > 70 && &fenc !=# 'utf-8' ? &fenc : ''
endfun

fun! LightlineFiletype()
  return winwidth(0) > 49 ? (&ft !=# '' ? &ft : 'no ft') : ''
endfun

fun! LightlineFugitive()
  if &ft ==# 'fern' || &ft ==# 'qf' | return '' | endif
  return winwidth(0) > 70 && exists('*FugitiveHead') ? FugitiveHead() : ''
endfun

fun! LightlinePro()
  if &ft ==# 'fern' || &ft ==# 'qf' | return '' | endif
  return winwidth(0) > 70 && exists('*pro#selected') ? pro#selected() : ''
endfun

aug au_theme | au!
  au BufWritePost,TextChanged,TextChangedI,WinClosed * call lightline#update()
aug end
