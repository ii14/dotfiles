" INIT /////////////////////////////////////*init*////////////////////////////////////////

" Index ------------------------------------*index*---------------------------------------
" |plugins|           PLUGINS
" |plugin-settings|   PLUGIN SETTINGS
" |settings|          SETTINGS
" |commands|          COMMANDS
" |theme|             THEME
" |grep|              GREP
" |terminal|          TERMINAL EMULATOR
" |keymap|            KEY MAPPINGS
" |autocmds|          AUTOCOMMANDS

" Environment ------------------------------*env*-----------------------------------------
let $VIMDATA = stdpath('data')
let $VIMCACHE = stdpath('cache')
let $VIMCONFIG = stdpath('config')
let $VIMPLUGINS = $VIMDATA.'/plugged'

let g:mapleader = ' '
aug Vimrc | au! | aug end

if v:progname ==# 'vi'
  source $VIMCONFIG/minimal.vim
  finish
endif

if exists('$VIMNOLSP')
  let g:disable_lsp = 1
endif

" Bookmarked directories -------------------*bookmarks*-----------------------------------
let g:bookmarks = [
  \ ['w', '<working directory>', 'Files .'],
  \ ['f', '<buffer directory>', 'exe "Files "..m#bufdir()'],
  \ ['g', '<git files>', 'GFiles'],
  \ ['V', '$VIMRUNTIME'],
  \ ['e', '/etc'],
  \ ['p', '$VIMPLUGINS'],
  \ ['v', '$VIMCONFIG'],
  \ ['s', '~/.local/share'],
  \ ['b', '~/.local/bin'],
  \ ['c', '~/.config'],
  \ ['r', '~/repos'],
  \ ['m', '~/dev/mm'],
  \ ['d', '~/dev'],
  \ ['h', '~'],
  \ ]


let s:dir = $VIMCONFIG..'/init.d'
for file in readdir(s:dir)
  let file = s:dir..'/'..file
  if filereadable(file)
    execute 'source' file
  endif
endfor

" vim: tw=90 ts=2 sts=2 sw=2 et
