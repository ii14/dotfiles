if executable('compiledb')
  let s:qmake_post = 'compiledb -n make &>/dev/null'
elseif executable('bear')
  let s:qmake_post = 'bear -a make &>/dev/null'
else
  let s:qmake_post = ''
endif

let s:qmake_flags = 'CONFIG+=debug'

com! QMake      call <SID>QMake()
com! QMakeFlags call <SID>QMakeFlags()

fun! <SID>QMake()
  let m = &l:makeprg
  let &l:makeprg = <SID>QMakeFormat()
  Make
  let &l:makeprg = m
endfun

fun! <SID>QMakeFlags()
  let s:qmake_flags = input('QMake flags: ', s:qmake_flags)
  redraw
  echom <SID>QMakeFormat()
endfun

fun! <SID>QMakeFormat()
  let c = 'qmake'
  if s:qmake_flags != ''
    let c = c.' '.s:qmake_flags
  endif
  if s:qmake_post != ''
    let c = c.' && '.s:qmake_post
  endif
  return c
endfun


" work in progress:
" let g:qmake#configs = {
"   \   '_': {
"   \     'make': '-j3',
"   \   },
"   \
"   \   'debug': {
"   \     'qmake': 'CONFIG+=debug',
"   \   },
"   \
"   \   'test': {
"   \     'qmake': 'CONFIG+=debug CONFIG+=test',
"   \     'post': './build/test',
"   \   },
"   \ }

" com! -nargs=? -complete=customlist,s:comp QMake call s:set_config(<q-args>)

" let s:selected_config = ''
" let s:qmake_makeprg = 'qmake'

" fun! s:set_config(config)
"   if a:config == 'none'
"     let s:selected_config = ''
"   elseif a:config != ''
"     if !has_key(g:qmake#configs, a:config)
"       echom 'Selected config does not exist'
"       return
"     endif
"     let s:selected_config = a:config
"   endif
"   call s:build_config()
" endfun

" fun! s:build_config()
"   let c = copy(get(g:qmake#configs, '_', {}))
"   let s = get(g:qmake#configs, s:selected_config, {})
"   let c.qmake = s:concat(get(c, 'qmake', ''), get(s, 'qmake', ''))
"   let c.make  = s:concat(get(c, 'make', ''), get(s, 'make', ''))
"   let c.post  = s:concat(get(c, 'post', ''), get(s, 'post', ''))
"   call s:build_makeprg(c)
" endfun

" fun! s:build_makeprg(config)
"   let qmake = get(a:config, 'qmake', '')
"   let make  = get(a:config, 'make',  '')
"   let post  = get(a:config, 'post',  '')

"   let c = 'qmake'
"   if qmake != '' | let c = c.' '.qmake | endif
"   if s:qmake_gendb_cmd  != '' | let c = c.' && '.s:qmake_gendb_cmd  | endif
"   let c = c.' && make'
"   if make != '' | let c = c.' '.make | endif
"   if post != '' | let c = c.' && '.post | endif

"   echom c
"   let s:qmake_makerg = c
"   if &ft ==? 'qmake'
"     exe 'setl makeprg='.substitute(c, "\\ ", "\\\\ ", "g")
"   endif
" endfun

" aug au_qmake | au!
"   au BufEnter *.pro
"     \ call s:set_config() |
"     \ exe 'setl makeprg='.substitute(s:qmake_makeprg, "\\ ", "\\\\ ", "g")
" aug end

" fun! s:comp(A,L,P)
"   let l = keys(g:qmake#configs)
"   return insert(l, 'none')
" endfun

" fun! s:concat(a, b)
"   if a:a != ''
"     if a:b != ''
"       return a:a.' '.a:b
"     else
"       return a:a
"     endif
"   else
"     if a:b != ''
"       return a:b
"     else
"       return ''
"     endif
"   endif
" endfun
