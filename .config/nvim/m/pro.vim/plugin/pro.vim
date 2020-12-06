com! -nargs=1 -complete=customlist,s:comp_configs Pro call s:select_config(<q-args>)

com! FZFPro call fzf#run(fzf#wrap({'source': s:fzf_pro(), 'sink': 'Pro'}))

fun! pro#selected() abort
  return get(s:, 'selected_config', '')
endfun

fun! s:select_config(config) abort
  if !has_key(g:, 'pro#configs') || a:config ==# '_' || !has_key(g:pro#configs, a:config)
    echom 'Selected config does not exist'
    return
  endif

  let has_default = has_key(g:pro#configs, '_')

  if has_default
    call s:unlet_config(g:pro#configs, '_')
  endif

  if s:selected_config !=# '' && has_key(g:pro#configs, s:selected_config)
    call s:unlet_config(g:pro#configs, s:selected_config)
  endif

  let s:selected_config = a:config

  if has_default
    call s:let_config(g:pro#configs, '_')
  endif

  call s:let_config(g:pro#configs, a:config)

  redraw
  echo 'Selected config: ' . a:config
endfun

fun! s:let_config(dict, key) abort
  for [key, val] in items(get(a:dict, a:key))
    exe 'let ' . key . ' = "' . escape(val, '\"') . '"'
  endfor
endfun

fun! s:unlet_config(dict, key) abort
  for key in keys(get(a:dict, a:key))
    try | exe 'unlet ' . key | catch | | endtry
  endfor
endfun

fun! s:comp_configs(ArgLead, CmdLine, CursorPos)
  try
    let d = copy(g:pro#configs)
    try | call remove(d, '_') | catch | | endtry
    return sort(filter(keys(d), 'v:val =~ "^' . a:ArgLead . '"'))
  catch
    return []
  endtry
endfun

fun! s:fzf_pro()
  try
    let d = copy(g:pro#configs)
    try | call remove(d, '_') | catch | | endtry
    return sort(keys(d))
  catch
    return []
  endtry
endfun

if has_key(g:, 'pro#config') && has_key(g:pro#configs, g:pro#config)
  let s:selected_config = g:pro#config
  if has_key(g:pro#configs, '_')
    call s:let_config(g:pro#configs, '_')
  endif
  call s:let_config(g:pro#configs, g:pro#config)
else
  let s:selected_config = ''
endif
