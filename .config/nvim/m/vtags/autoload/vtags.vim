function! vtags#syntax() abort
  syn match vtagsJump  /|[A-Za-z0-9_-]\+|/hs=s+1,he=e-1   contained containedin=.*Comment.*
  syn match vtagsEntry /\*[A-Za-z0-9_-]\+\*/hs=s+1,he=e-1 contained containedin=.*Comment.*
  hi link vtagsJump  Identifier
  hi link vtagsEntry String
endfunction

function! vtags#gen(args) abort
  let l:args = [
    \ get(g:, 'vtags_ctags_bin', 'ctags'),
    \ '--langdef=vimrc',
    \ '--langmap=vimrc:.vim.lua',
    \ '--excmd=number',
    \ '--regex-vimrc=/\*\([A-Za-z0-9_-]\+\)\*/\1/b',
    \ '--languages=vimrc',
    \ '-f', stdpath('config')..'/tags',
    \ ]

  if empty(a:args)
    call extend(l:args, ['-R', stdpath('config')])
  else
    " TODO: remove old entries
    call add(l:args, '-a')
    call extend(l:args, flatten(map(a:args, 'glob(v:val, v:false, v:true)')))
  endif

  let l:res = system(l:args)
  if v:shell_error != 0
    echohl ErrorMsg
    echomsg 'vtags: ctags returned '..v:shell_error..':'
    echomsg l:res
    echohl None
  endif
endfunction

function! s:get_cword() abort
  let l:iskeyword = &l:iskeyword
  noautocmd setlocal iskeyword=@,48-57,_,-,192-255
  let l:cword = expand('<cword>')
  noautocmd let &l:iskeyword = l:iskeyword
  return l:cword
endfunction

function! s:match() abort
  if &filetype !=# 'vim' && &filetype !=# 'lua'
    return v:false
  endif

  if stridx(expand('%:p'), stdpath('config')) != 0
    return v:false
  endif

  for l:item in map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    if l:item ==# 'vtagsJump' || l:item ==# 'vtagsEntry'
      return v:true
    endif
  endfor

  return v:false
endfunction

function! vtags#can_jump() abort
  return s:match() && !empty(taglist('\C\V'..s:get_cword()))
endfunction

function! vtags#jump() abort
  if !s:match()
    return v:false
  endif

  let l:cword = s:get_cword()
  if empty(l:cword)
    return v:false
  endif

  try
    execute 'tag' l:cword
    " let l:col = stridx(getline('.'), '*'..l:cword..'*')
    " if l:col != -1
    "   call cursor(line('.'), l:col + 2)
    " endif
    norm! ^
    return v:true
  catch
  endtry

  return v:false
endfunction

" function! s:sort_tags(a, b) abort
"   return a:a.filename ==# a:b.filename ? a:a.cmd > a:b.cmd : a:a.filename > a:b.filename
" endfunction

" function! vtags#toc() abort
"   let l:tags = sort(taglist('.'), function('s:sort_tags'))
"   let l:last = ''
"   let l:start = stdpath('config')..'/init.d'
"   for l:tag in l:tags
"     if stridx(l:tag.filename, l:start) != 0
"       continue
"     endif
"     if l:last !=# l:tag.filename
"       let l:last = l:tag.filename
"       echo l:tag.name
"     else
"       echo '  '..l:tag.name
"     endif
"   endfor
" endfunction
