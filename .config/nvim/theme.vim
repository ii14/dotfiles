set termguicolors " true color
set noshowmode    " redundant mode message

let g:lightline = {}

" See $VIMCONFIG/colors/onedark.vim.in
if luaeval('require("m.util.preproc").ensure(vim.env.VIMCONFIG.."/colors/onedark.vim")')
  colorscheme onedark
  let g:lightline.colorscheme = 'onedark'
else
  echomsg 'Failed to load colorscheme'
endif

let g:lightline.active = {
  \ 'left'  : [['mode', 'paste'], ['fugitive', 'pro'], ['filename']],
  \ 'right' : [['lineinfo'], ['percent'], ['lsp', 'fileformat', 'fileencoding', 'filetype']],
  \ }

let g:lightline.inactive = {
  \ 'left': [['filename']],
  \ 'right': [[], [], ['lsp', 'fileformat', 'fileencoding', 'filetype']],
  \ }

let g:lightline.tabline = {
  \ 'left'  : [['buffers']],
  \ 'right' : [['tab']],
  \ }

let g:lightline.component = {
  \ 'percent' : '%{%!LightlineIsFernDrawer() ? "%3p%%" : ""%}',
  \ 'lineinfo': '%{%!LightlineIsFernDrawer() ? "%3l:%-2c" : ""%}',
  \ }

let g:lightline.component_function = {
  \ 'filename'     : 'LightlineFilename',
  \ 'fileformat'   : 'LightlineFileformat',
  \ 'fileencoding' : 'LightlineFileencoding',
  \ 'filetype'     : 'LightlineFiletype',
  \ 'fugitive'     : 'LightlineFugitive',
  \ 'lsp'          : 'LightlineLsp',
  \ 'pro'          : 'LightlinePro',
  \ 'tab'          : 'LightlineTab',
  \ 'gitsigns'     : 'LightlineGitsigns',
  \ }

let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline.component_raw    = {'buffers': 1}

let g:lightline.mode_map = {
  \ 'n'      : 'Normal',
  \ 'i'      : 'Insert',
  \ 'R'      : 'Replace',
  \ 'v'      : 'Visual',
  \ 'V'      : 'V-Line',
  \ "\<C-v>" : 'V-Block',
  \ 'c'      : 'Command',
  \ 's'      : 'Select',
  \ 'S'      : 'S-Line',
  \ "\<C-s>" : 'S-Block',
  \ 't'      : 'Terminal',
  \ }

set showtabline=2
let g:lightline#bufferline#unnamed   = '[No Name]'
let g:lightline#bufferline#clickable = 1
" let g:lightline#bufferline#min_buffer_count = 2

function! LightlineFilename()
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
    return '[Term] '.b:term_title
  endif

  if &filetype ==# 'Trouble'
    return '[Trouble]'
  endif

  if &buftype ==# 'quickfix'
    return get(b:, 'qf_isLoc', 1)
      \ ? '[Location] '..getloclist(0, {'title':1}).title
      \ : '[Quickfix] '..getqflist({'title':1}).title
  endif

  let fname = expand('%:t')
  return
    \ (&readonly ? '[-] ' : '') ..
    \ (fname ==# '' ? '[No Name]' : fname) ..
    \ (&modified ? ' [+]' : '')
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70
    \ && &fileformat !=# 'unix' ? &fileformat : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70
    \ && &fileencoding !=# 'utf-8' ? &fileencoding : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 49 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! s:gitsigns()
  if !has_key(b:, 'gitsigns_status_dict')
    return ''
  endif
  let d = b:gitsigns_status_dict
  let d = (get(d, 'added',   0) ? '+'..d.added   : '')
    \   ..(get(d, 'changed', 0) ? '~'..d.changed : '')
    \   ..(get(d, 'removed', 0) ? '-'..d.removed : '')
  return d !=# '' ? ' '..d : ''
endfunction

function! LightlineFugitive()
  return winwidth(0) > 70
    \ && &filetype !=# 'fern'
    \ && &filetype !=# 'qf'
    \ && exists('*FugitiveHead')
    \ ? FugitiveHead()..s:gitsigns() : ''
endfunction

function! LightlineGitsigns()
  return get(b:, 'gitsigns_status', '')
endfunction

function! LightlineLsp()
  return luaeval("require('m.lsp.util').get_client_names()")
endfunction

function! LightlinePro()
  if &filetype ==# 'fern' || &filetype ==# 'qf'
    return ''
  endif
  return winwidth(0) > 70 && exists('*pro#selected') ? pro#selected() : ''
endfunction

function! LightlineIsFernDrawer()
  try
    return &filetype ==# 'fern' && fern#internal#drawer#is_drawer()
  catch
    return v:false
  endtry
endfunction

function! LightlineTab()
  return (tabpagenr('$') <= 1) ? '' : (tabpagenr() .. '/' .. tabpagenr('$'))
endfunction

augroup VimrcTheme
  autocmd!
  autocmd BufWritePost,TextChanged,TextChangedI,WinClosed * call lightline#update()
augroup end
