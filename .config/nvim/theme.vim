set background=dark

let g:lightline = {}

colorscheme onedark
let g:lightline.colorscheme = 'onedark'

let g:lightline.active = {
  \ 'left'  : [['mode', 'paste'], ['fugitive', 'pro'], ['filename']],
  \ 'right' : [['lineinfo'], ['percent'], ['lsp', 'fileformat', 'fileencoding', 'filetype']],
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
  \ 'lsp'          : 'LightlineLsp',
  \ 'diagnostics'  : 'LightlineDiagnostics',
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
  if &ft ==# 'fern'
    return 'Fern'
  endif
  if &bt ==# 'quickfix'
    return get(b:, 'qf_isLoc', 1) ? 'Location' : 'QuickFix'
  endif
  return winwidth(0) < 50 ? '' : lightline#mode()
endfun

fun! LightlineFilename()
  if &ft ==# 'fern'
    " fern internals, can potentially break
    try
      return (len($HOME) > 1 && match(b:fern.root._path, $HOME) == 0)
        \ ? '~'.b:fern.root._path[len($HOME):]
        \ : b:fern.root._path
    catch
      return ''
    endtry
  endif

  if &bt ==# 'terminal'
    return '['.expand('%').'] '.b:term_title
  endif

  if &ft ==# 'scratch'
    return 'Scratch'
  endif

  if &ft ==# 'dap-repl'
    return 'Debugger'
  endif

  if &bt ==# 'quickfix'
    return get(b:, 'qf_isLoc', 1)
      \ ? getloclist(0, {'title':1}).title
      \ : getqflist({'title':1}).title
  endif

  let fname = expand('%:t')
  return
    \ (&ro ? ' ' : '') .
    \ (fname ==# '' ? '[No Name]' : fname) .
    \ (&mod ? ' +' : '')
endfun

fun! LightlineFileformat()
  return winwidth(0) > 70
    \ && &ft !=# 'fern'
    \ && &bt !=# 'quickfix'
    \ && &ff !=# 'unix' ? &ff : ''
endfun

fun! LightlineFileencoding()
  return winwidth(0) > 70
    \ && &ft !=# 'fern'
    \ && &bt !=# 'quickfix'
    \ && &fenc !=# 'utf-8' ? &fenc : ''
endfun

fun! LightlineFiletype()
  return winwidth(0) > 49 ? (&ft !=# '' ? &ft : 'no ft') : ''
endfun

fun! LightlineFugitive()
  return winwidth(0) > 70
    \ && &ft !=# 'fern'
    \ && &ft !=# 'qf'
    \ && exists('*FugitiveHead')
    \ ? FugitiveHead() : ''
endfun

fun! LightlineLsp()
  try
    return luaeval("require('lsp/util').get_client_name()")
  catch
    return ''
  endtry
endfun

fun! LightlineDiagnostics()
  if luaeval('vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    return ''
  endif
  let e = luaeval('vim.lsp.diagnostic.get_count(0, "Error")')
  let w = luaeval('vim.lsp.diagnostic.get_count(0, "Warning")')
  let h = luaeval('vim.lsp.diagnostic.get_count(0, "Hint")')
  let i = luaeval('vim.lsp.diagnostic.get_count(0, "Information")')
  let list = []
  if e > 0 | call add(list, 'E'.e) | endif
  if w > 0 | call add(list, 'W'.w) | endif
  if h > 0 | call add(list, 'H'.h) | endif
  if i > 0 | call add(list, 'i'.i) | endif
  return join(list, ' ')
endfun

fun! LightlinePro()
  if &ft ==# 'fern' || &ft ==# 'qf'
    return ''
  endif
  return winwidth(0) > 70 && exists('*pro#selected') ? pro#selected() : ''
endfun

aug VimrcTheme
  au!
  au BufWritePost,TextChanged,TextChangedI,WinClosed * call lightline#update()
aug end
