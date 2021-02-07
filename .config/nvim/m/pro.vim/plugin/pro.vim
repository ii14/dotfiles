" pro.vim - Simple config management
" Maintainer:   ii14
" Version:      0.1.0

" TODO: cache original values before initializing
" TODO: recover when selected config was deleted
" TODO: add pro#hook - function executed after selecting config

if exists('g:loaded_pro')
  finish
endif
let g:loaded_pro = 1

" Public API -------------------------------------------------------------------

" Select config
command! -nargs=? -bar -bang -complete=customlist,s:Completion Pro
  \ call s:Command(<q-args>, <q-mods>, '<bang>')

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
  let l:config = a:config !=# '' ? a:config :
    \ a:bang ==# '!' ? s:Selected : ''
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
          echo '    ' . l:key . ' = ' . l:val[l:key]
        endfor
      endfor
    else
      echohl Function
      echo l:config . (l:config ==# s:Selected ? ' *' : '')
      echohl None
      let l:val = get(get(g:, 'pro', {}), l:config, {})
      for l:key in sort(keys(l:val))
        echo '    ' . l:key . ' = ' . l:val[l:key]
      endfor
    endif
    return
  endif

  if l:config ==# ''
    if !l:silent
      echo s:Selected
    endif
    return
  endif

  call s:Select(l:config)
  if !l:silent
    echo l:config
  endif
endfun

fun! s:Select(config) abort
  let l:has_default = has_key(g:pro, '_')

  if l:has_default
    call s:UnletConfig(g:pro, '_')
  endif

  if s:Selected !=# '' && has_key(g:pro, s:Selected)
    call s:UnletConfig(g:pro, s:Selected)
  endif

  let s:Selected = a:config

  if l:has_default
    call s:LetConfig(g:pro, '_')
  endif

  call s:LetConfig(g:pro, a:config)
endfun

fun! s:HasConfig(config)
  return has_key(g:, 'pro') && a:config !=# '_' && has_key(g:pro, a:config)
endfun

fun! s:LetConfig(dict, key) abort
  for [l:key, l:val] in items(get(a:dict, a:key))
    execute 'let ' . l:key . ' = l:val'
  endfor
endfun

fun! s:UnletConfig(dict, key) abort
  for key in keys(get(a:dict, a:key))
    try
      execute 'unlet ' . key
    catch
    endtry
  endfor
endfun

fun! s:Completion(ArgLead, CmdLine, CursorPos)
  return filter(pro#configs(), 'v:val =~ "^' . a:ArgLead . '"')
endfun

fun! s:Init()
  if s:Selected ==# '' && has_key(g:, 'pro#default')
    if s:HasConfig(g:pro#default)
      let s:Selected = g:pro#default
      if has_key(g:pro, '_')
        call s:LetConfig(g:pro, '_')
      endif
      call s:LetConfig(g:pro, g:pro#default)
    endif
  endif
endfun

" Autocommands -----------------------------------------------------------------

augroup ProVim
  autocmd!
  autocmd VimEnter * call s:Init() | autocmd ProVim SourcePost * call s:Init()
augroup END

" vim: et sw=2 sts=2 tw=80 :
