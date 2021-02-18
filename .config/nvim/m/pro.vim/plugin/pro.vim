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
      echomsg 'Modifer "' . l:mod . '" not allowed'
      echohl None
      return
    endif
  endfor

  " Bang
  let l:config = a:config !=# '' ? a:config : a:bang ? s:Selected : ''
  if l:config !=# ''
    if !s:HasConfig(l:config)
      echohl ErrorMsg
      echomsg 'Config "' . l:config . '" does not exist'
      echohl None
      return
    endif
  endif

  " Verbose
  if l:verbose
    if l:config ==# ''
      let l:configs = get(g:, 'pro', {})
      for l:name in sort(keys(l:configs))
        echohl Function
        echo l:name . (l:name ==# s:Selected ? ' *' : '')
        echohl None
        let l:val = l:configs[l:name]
        for l:key in sort(keys(l:val))
          let l:rhs = l:val[l:key]
          echo '    ' . l:key . ' = ' .
            \ (type(l:rhs) == v:t_string ? l:rhs : string(l:rhs))
        endfor
      endfor
    else
      echohl Function
      echo l:config . (l:config ==# s:Selected ? ' *' : '')
      echohl None
      let l:val = get(get(g:, 'pro', {}), l:config, {})
      for l:key in sort(keys(l:val))
        let l:rhs = l:val[l:key]
        echo '    ' . l:key . ' = ' .
          \ (type(l:rhs) == v:t_string ? l:rhs : string(l:rhs))
      endfor
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
  call s:CallHook()
endfun

fun! s:HasConfig(config)
  return has_key(g:, 'pro') && a:config !=# '_' && has_key(g:pro, a:config)
endfun

fun! s:LetConfig(dict, key) abort
  for [l:key, l:val] in items(get(a:dict, a:key))
    if index(s:VarsEmpty, l:key) == -1 || !has_key(s:VarsDefault, l:key)
      if exists(l:key)
        execute 'let s:VarsDefault[l:key] = ' . l:key
      else
        call add(s:VarsEmpty, l:key)
      endif
    endif
    execute 'let ' . l:key . ' = l:val'
  endfor
endfun

fun! s:LetDefault() abort
  for l:key in s:VarsEmpty
    try
      execute 'unlet ' . l:key
    catch
    endtry
  endfor
  for [l:key, l:val] in items(s:VarsDefault)
    execute 'let ' . l:key . ' = l:val'
  endfor
endfun

fun! s:CallHook() abort
  if !has_key(g:, 'pro#hook')
    return
  endif

  " if get(s:, 'InHook', v:false)
  "   echohl ErrorMsg
  "   echomsg 'Recursion in g:pro#hook is not allowed'
  "   echohl None
  "   return
  " endif

  let s:InHook = v:true
  echomsg expand('<sfile>')

  try
    if type(g:pro#hook) == v:t_string
      execute g:pro#hook
    elseif type(g:pro#hook) == v:t_list
      execute join(g:pro#hook, "\n")
    else
      throw 'Invalid g:pro#hook type'
    endif
  catch
    let l:exception = v:exception
  endtry

  let s:InHook = v:false
  if has_key(l:, 'exception')
    throw l:exception
  endif
endfun

fun! s:Completion(ArgLead, CmdLine, CursorPos)
  return filter(pro#configs(), 'v:val =~ "^' . a:ArgLead . '"')
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
