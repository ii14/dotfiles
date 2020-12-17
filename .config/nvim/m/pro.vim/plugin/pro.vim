" Description: Simple project config management
" Usage:
" Use with vim's 'exrc' feature or with 'ii14/exrc.vim' plugin.
" Example of a local .exrc file:
"
"     let g:pro#configs = {}
"
"     " Default config. All configs inherit from '_'.
"     let g:pro#configs['_'] = {
"       \ '$MY_ENV_VAR': 'my_value'
"       \ }
"
"     let g:pro#configs['release'] = {
"       \ '&makeprg'     : 'make -j -C build/release',
"       \ 'g:qmake#dir'  : 'build/release',
"       \ }
"
"     let g:pro#configs['debug'] = {
"       \ '&makeprg'     : 'make -j -C build/debug',
"       \ 'g:qmake#dir'  : 'build/debug',
"       \ 'g:qmake#args' : 'CONFIG+=debug',
"       \ }
"
"     let g:pro#configs['test'] = {
"       \ '&makeprg'     : 'make -j -C build/test-release;'
"       \                . './build/test/test',
"       \ 'g:qmake#dir'  : 'build/test,
"       \ 'g:qmake#args' : 'CONFIG+=test',
"       \ }
"
"     " Set which config is selected by default.
"     let g:pro#config = 'debug'
"
" Switch between project configurations with :Pro {config} or :FZFPro
" The plugin is still in progress, but it works.

command! -nargs=1 -complete=customlist,s:CompConfigs Pro call s:SelectConfig(<q-args>)

command! FZFPro call fzf#run(fzf#wrap({'source': s:CompFzf(), 'sink': 'Pro'}))

let s:selected_config = ''

fun! pro#selected() abort
  return get(s:, 'selected_config', '')
endfun

fun! s:SelectConfig(config) abort
  if !has_key(g:, 'pro#configs') || a:config ==# '_' || !has_key(g:pro#configs, a:config)
    echomsg 'Selected config does not exist'
    return
  endif

  let l:has_default = has_key(g:pro#configs, '_')

  if l:has_default
    call s:UnletConfig(g:pro#configs, '_')
  endif

  if s:selected_config !=# '' && has_key(g:pro#configs, s:selected_config)
    call s:UnletConfig(g:pro#configs, s:selected_config)
  endif

  let s:selected_config = a:config

  if l:has_default
    call s:LetConfig(g:pro#configs, '_')
  endif

  call s:LetConfig(g:pro#configs, a:config)

  redraw
  echo 'Selected config: ' . a:config
endfun

fun! s:LetConfig(dict, key) abort
  for [l:key, l:val] in items(get(a:dict, a:key))
    execute 'let ' . l:key . ' = l:val'
  endfor
endfun

" TODO: cache original values before initializing
fun! s:UnletConfig(dict, key) abort
  for key in keys(get(a:dict, a:key))
    try | execute 'unlet ' . key | catch | | endtry
  endfor
endfun

fun! s:CompConfigs(ArgLead, CmdLine, CursorPos)
  try
    let d = copy(g:pro#configs)
    try | call remove(d, '_') | catch | | endtry
    return sort(filter(keys(d), 'v:val =~ "^' . a:ArgLead . '"'))
  catch
    return []
  endtry
endfun

fun! s:CompFzf()
  try
    let d = copy(g:pro#configs)
    try | call remove(d, '_') | catch | | endtry
    return sort(keys(d))
  catch
    return []
  endtry
endfun

fun! s:Init()
  if s:selected_config ==# ''
    if has_key(g:, 'pro#config') && has_key(get(g:, 'pro#configs', {}), g:pro#config)
      let s:selected_config = g:pro#config
      if has_key(g:pro#configs, '_')
        call s:LetConfig(g:pro#configs, '_')
      endif
      call s:LetConfig(g:pro#configs, g:pro#config)
    endif
  endif
endfun

augroup ProVim
  autocmd!
  autocmd VimEnter * call s:Init() | autocmd ProVim SourcePost * call s:Init()
augroup END
