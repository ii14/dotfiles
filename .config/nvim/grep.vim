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

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr s:grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr s:grep(<f-args>)

call Cabbrev('gr',    'Grep')
call Cabbrev('gre',   'Grep')
call Cabbrev('grep',  'Grep')
call Cabbrev('lgr',   'LGrep')
call Cabbrev('lgre',  'LGrep')
call Cabbrev('lgrep', 'LGrep')

augroup VimrcGrep
  autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd QuickFixCmdPost lgetexpr lwindow
augroup end
