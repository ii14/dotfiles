if exists('g:loaded_m_grep')
  finish
endif
let g:loaded_m_grep = 1

augroup m_grep
  autocmd!
augroup end

if executable('rg')
  let s:grepprg = 'rg'
elseif executable('ag')
  let s:grepprg = 'ag'
endif

if exists('s:grepprg')
  set grepformat=%f:%l:%c:%m,%f:%l:%m

  function! s:formatgrepprg()
    let l:cmd = s:grepprg .. ' --vimgrep'
    if &ignorecase
      if &smartcase
        let l:cmd .= ' --smart-case'
      else
        let l:cmd .= ' --ignore-case'
      endif
    else
      let l:cmd .= ' --case-sensitive'
    endif
    return l:cmd
  endfunction

  let &grepprg = s:formatgrepprg()
  augroup m_grep
    autocmd OptionSet smartcase,ignorecase let &grepprg = s:formatgrepprg()
  augroup end
endif

function! s:grep(args)
  return system(join([&grepprg] + [expandcmd(escape(a:args, '\'))], ' '))
endfunction

command! -nargs=+ -complete=file Grep  cgetexpr s:grep(<q-args>)
command! -nargs=+ -complete=file LGrep lgetexpr s:grep(<q-args>)

call m#cabbrev('gr',    'Grep')
call m#cabbrev('gre',   'Grep')
call m#cabbrev('grep',  'Grep')
call m#cabbrev('lgr',   'LGrep')
call m#cabbrev('lgre',  'LGrep')
call m#cabbrev('lgrep', 'LGrep')

augroup m_grep
  autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd QuickFixCmdPost lgetexpr lwindow
augroup end
