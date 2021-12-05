augroup VimrcGrep
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
    let l:cmd = s:grepprg . ' --vimgrep'
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
  augroup VimrcGrep
    autocmd OptionSet smartcase,ignorecase let &grepprg = s:formatgrepprg()
  augroup end
endif

function! s:grep(...)
  return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file -bar Grep  cgetexpr s:grep(<f-args>)
command! -nargs=+ -complete=file -bar LGrep lgetexpr s:grep(<f-args>)

call m#util#cabbrev('gr',    'Grep')
call m#util#cabbrev('gre',   'Grep')
call m#util#cabbrev('grep',  'Grep')
call m#util#cabbrev('lgr',   'LGrep')
call m#util#cabbrev('lgre',  'LGrep')
call m#util#cabbrev('lgrep', 'LGrep')

augroup VimrcGrep
  autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd QuickFixCmdPost lgetexpr lwindow
augroup end
