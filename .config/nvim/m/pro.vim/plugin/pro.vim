" pro.vim - Simple config management
" Maintainer:   ii14
" Version:      0.1.0

if exists('g:loaded_pro')
  finish
endif
let g:loaded_pro = 1

" Public API -------------------------------------------------------------------

" Select config
command! -nargs=? -bar -bang -complete=customlist,s:Completion Pro
  \ call s:Command(<q-args>, <q-mods>, <bang>0)

" Get selected config name
fun! pro#selected()
  return s:Selected
endfun

" Get list of config names
fun! pro#configs()
  try
    let d = copy(g:pro)
    try
      call remove(d, '_')
    catch
    endtry
    return sort(keys(d))
  catch
    return []
  endtry
endfun

" Private ----------------------------------------------------------------------

let s:Selected = ''
let s:VarsDefault = {}
let s:VarsEmpty = []

fun! s:Command(config, mods, bang) abort
  " Modifiers
  let l:silent = v:false
  let l:verbose = v:false
  for l:mod in split(a:mods, ' ')
    if l:mod ==# 'verbose'
      let l:verbose = v:true
    elseif l:mod ==# 'silent'
      let l:silent = v:true
    else
      echohl ErrorMsg
      echomsg 'Modifer "'.l:mod.'" not allowed'
      echohl None
      return
    endif
  endfor

  " Bang
  let l:config = a:config !=# '' ? a:config : a:bang ? s:Selected : ''
  if l:config !=# ''
    if !s:HasConfig(l:config)
      echohl ErrorMsg
      echomsg 'Config "'.l:config.'" does not exist'
      echohl None
      return
    endif
  endif

  " Verbose
  if l:verbose
    if l:config ==# ''
      let l:configs = get(g:, 'pro', {})
      for l:name in sort(keys(l:configs))
        call s:PrintConfig(l:name)
      endfor
    else
      call s:PrintConfig(l:config)
    endif
    return
  endif

  if l:config ==# ''
    echo s:Selected
  else
    call s:Select(l:config)
  endif
endfun

fun! s:Select(config) abort
  call s:LetDefault()
  let s:Selected = a:config
  if has_key(g:pro, '_')
    call s:LetConfig(g:pro, '_')
  endif
  call s:LetConfig(g:pro, a:config)
  doautocmd User ProUpdate
endfun

fun! s:HasConfig(config)
  return has_key(g:, 'pro') && a:config !=# '_' && has_key(g:pro, a:config)
endfun

fun! s:LetConfig(dict, key) abort
  let exceptions = []

  for [l:lhs, l:rhs] in items(get(a:dict, a:key))
    if index(s:VarsEmpty, l:lhs) == -1 || !has_key(s:VarsDefault, l:lhs)
      if exists(l:lhs)
        execute 'let s:VarsDefault[l:lhs] = '.l:lhs
      else
        call add(s:VarsEmpty, l:lhs)
      endif
    endif
    try
      execute 'let '.l:lhs.' = l:rhs'
    catch
      call add(exceptions, [l:lhs, v:exception])
    endtry
  endfor

  if len(exceptions) > 0
    redraw
    echohl ErrorMsg
    echomsg 'Exception occurred in config "'.a:key.'":'
    for exception in exceptions
      echomsg '  In "'.exception[0].'":'
      echomsg '    '.exception[1]
    endfor
    echohl None
  endif
endfun

fun! s:LetDefault() abort
  for l:lhs in s:VarsEmpty
    try
      execute 'unlet '.l:lhs
    catch
    endtry
  endfor
  for [l:lhs, l:rhs] in items(s:VarsDefault)
    execute 'let '.l:lhs.' = l:rhs'
  endfor
endfun

fun! s:Completion(ArgLead, CmdLine, CursorPos)
  return filter(pro#configs(), 'v:val =~ ''\V\^''.a:ArgLead')
endfun

fun! s:PrintConfig(config) abort
  echohl Function
  echo a:config.(a:config ==# s:Selected ? ' *' : '')
  echohl None
  let l:val = get(get(g:, 'pro', {}), a:config, {})
  for l:lhs in sort(keys(l:val))
    let l:rhs = l:val[l:lhs]
    echo '    '.l:lhs.' = '.(type(l:rhs) == v:t_string ? l:rhs : string(l:rhs))
  endfor
endfun

fun! s:Init()
  if s:Selected ==# '' && s:HasConfig(get(g:, 'pro#default', '_'))
    call s:Select(g:pro#default)
  endif
endfun

" Autocommands -----------------------------------------------------------------

augroup ProVim
  autocmd!
  autocmd VimEnter * call s:Init() | autocmd ProVim SourcePost * call s:Init()
augroup END

" vim: et sw=2 sts=2 tw=80 :
