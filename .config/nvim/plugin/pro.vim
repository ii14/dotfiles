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

fun! s:Command(name, mods, bang) abort
  " Modifiers
  let l:verbose = v:false
  for l:mod in split(a:mods, ' ')
    if l:mod ==# 'verbose'
      let l:verbose = v:true
    elseif l:mod ==# 'silent'
    else
      echohl ErrorMsg
      echomsg 'Modifer "'.l:mod.'" not allowed'
      echohl None
      return
    endif
  endfor

  " Bang
  if a:name !=# ''
    let l:name = a:name
  elseif !a:bang
    let l:name = ''
  elseif s:Selected !=# ''
    let l:name = s:Selected
  else
    let l:name = get(g:, 'pro#default', '')
  endif

  " Validate
  if l:name !=# ''
    if !s:HasConfig(l:name)
      echohl ErrorMsg
      echomsg 'Config "'.l:name.'" does not exist'
      echohl None
      return
    endif
  endif

  " Verbose
  if l:verbose
    if l:name !=# ''
      call s:PrintConfig(l:name)
    else
      for l:name in sort(keys(get(g:, 'pro', {})))
        call s:PrintConfig(l:name)
      endfor
    endif
    return
  endif

  if l:name ==# ''
    echo s:Selected
  else
    call s:Select(l:name)
  endif
endfun

fun! s:Select(name) abort
  call s:LetDefault()
  let s:Selected = a:name
  if has_key(g:pro, '_')
    call s:LetConfig(g:pro, '_')
  endif
  call s:LetConfig(g:pro, a:name)
  silent doautocmd User ProUpdate
endfun

fun! s:HasConfig(name)
  return has_key(g:, 'pro') && a:name !=# '_' && has_key(g:pro, a:name)
endfun

fun! s:LetConfig(dict, key) abort
  let l:exceptions = []

  let l:config = get(a:dict, a:key)
  for l:lhs in keys(l:config)
    if index(s:VarsEmpty, l:lhs) == -1 || !has_key(s:VarsDefault, l:lhs)
      if exists(l:lhs)
        execute 'let s:VarsDefault[l:lhs] = '.l:lhs
      else
        call add(s:VarsEmpty, l:lhs)
      endif
    endif
    try
      execute 'let '.l:lhs.' = l:config[l:lhs]'
    catch
      call add(l:exceptions, [l:lhs, v:exception])
    endtry
  endfor

  if len(l:exceptions) > 0
    redraw
    echohl ErrorMsg
    echomsg 'Exception occurred in config "'.a:key.'":'
    for l:exception in l:exceptions
      echomsg '  In "'.l:exception[0].'":'
      echomsg '    '.l:exception[1]
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
  for l:lhs in keys(s:VarsDefault)
    execute 'let '.l:lhs.' = s:VarsDefault[l:lhs]'
  endfor
endfun

fun! s:PrintConfig(name) abort
  echohl Function
  echo a:name.(a:name ==# s:Selected ? ' *' : '')
  echohl None
  let l:config = get(get(g:, 'pro', {}), a:name, {})
  for l:lhs in sort(keys(l:config))
    echo '    '.l:lhs.' = '.(type(l:config[l:lhs]) == v:t_string
      \ ? l:config[l:lhs] : string(l:config[l:lhs]))
  endfor
endfun

fun! s:Completion(ArgLead, CmdLine, CursorPos)
  return filter(pro#configs(), 'v:val =~ ''\V\^''.a:ArgLead')
endfun

fun! s:SelectDefault()
  if s:Selected !=# ''
    augroup ProVimInit
      autocmd!
    augroup END
    return v:true
  endif

  if !has_key(g:, 'pro#default') || !s:HasConfig(g:pro#default)
    return v:false
  endif

  call s:Select(g:pro#default)
  augroup ProVimInit
    autocmd!
  augroup END
  return v:true
endfun

fun! s:Init()
  if !s:SelectDefault() && exists('##SourcePost')
    augroup ProVimInit
      autocmd SourcePost * call s:SelectDefault()
    augroup END
  endif
endfun

augroup ProVimInit
  autocmd!
  autocmd VimEnter * call s:Init()
augroup END

" vim: et sw=2 sts=2 tw=80 :
