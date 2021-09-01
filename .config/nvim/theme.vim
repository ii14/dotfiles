set termguicolors
set background=dark

let g:lightline = {}

let g:onedark_terminal_italics = 1
colorscheme onedark

" TODO: move to lua
" lua require 'm.theme.statusline'.init()
" lua require 'm.theme.bufferline'.init()
" set showtabline=2
" finish

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
  return winwidth(0) < 50 ? '' : lightline#mode()
endfun

fun! LightlineFilename()
  if &filetype ==# 'fern'
    " fern internals, can potentially break
    try
      return fnamemodify(b:fern.root._path, ':~')
    catch
      return '[Fern]'
    endtry
  endif

  if &filetype ==# 'termdebug'
    return '[GDB]'
  endif

  if &buftype ==# 'terminal'
    return '[term:'.b:terminal_job_pid.'] '.b:term_title
  endif

  if &filetype ==# 'Trouble'
    return '[Trouble]'
  endif

  if &buftype ==# 'quickfix'
    return get(b:, 'qf_isLoc', 1)
      \ ? '[Location] '.getloclist(0, {'title':1}).title
      \ : '[Quickfix] '.getqflist({'title':1}).title
  endif

  let fname = expand('%:t')
  return
    \ (&readonly ? '[-] ' : '') .
    \ (fname ==# '' ? '[No Name]' : fname) .
    \ (&modified ? ' [+]' : '')
endfun

fun! LightlineFileformat()
  return winwidth(0) > 70
    \ && &fileformat !=# 'unix' ? &fileformat : ''
endfun

fun! LightlineFileencoding()
  return winwidth(0) > 70
    \ && &fileencoding !=# 'utf-8' ? &fileencoding : ''
endfun

fun! LightlineFiletype()
  return winwidth(0) > 49 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfun

fun! LightlineFugitive()
  return winwidth(0) > 70
    \ && &filetype !=# 'fern'
    \ && &filetype !=# 'qf'
    \ && exists('*FugitiveHead')
    \ ? FugitiveHead() : ''
endfun

fun! LightlineLsp()
  try
    return luaeval("require('m.lsp.util').get_client_name()")
  catch
    return ''
  endtry
endfun

fun! LightlinePro()
  if &filetype ==# 'fern' || &filetype ==# 'qf'
    return ''
  endif
  return winwidth(0) > 70 && exists('*pro#selected') ? pro#selected() : ''
endfun

aug VimrcTheme
  au!
  au BufWritePost,TextChanged,TextChangedI,WinClosed * call lightline#update()
aug end
