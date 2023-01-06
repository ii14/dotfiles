" PLUGINS         $VIMCONFIG/plugins.lua
" LUA SETUP       $VIMCONFIG/setup.lua
" OPTIONS         $VIMCONFIG/options.lua
" KEY MAPPINGS    $VIMCONFIG/lua/m/keymaps.lua
" LSP CONFIG      $VIMCONFIG/lua/m/lsp.lua
" LSP BUFFER      $VIMCONFIG/lua/m/lsp/buf.lua
" COLORSCHEME     $VIMCONFIG/colors/onedark.lua
" SNIPPETS        $VIMCONFIG/lua/m/snippets
" COMMANDS        $VIMCONFIG/lua/m/cmd/init.lua
"                 $VIMCONFIG/plugin/commands.vim
" AUTOCOMMANDS    $VIMCONFIG/plugin/autocmds.vim
" TEMPLATES       $VIMCONFIG/templates

let $VIMDATA = stdpath('data')
let $VIMCACHE = stdpath('cache')
let $VIMCONFIG = stdpath('config')
let $VIMPLUGINS = $VIMDATA.'/neopm'

let g:mapleader = ' '

" use minimal config as vi or root
let g:is_root = luaeval('vim.loop.getuid()') == 0
if g:is_root || (v:progname ==# 'vi' && !exists('g:upgraded'))
  source $VIMCONFIG/minimal.vim
  finish
endif

" custom command line options
" +NoLsp    disable lsp client
" +NoCache  disable impatient.nvim
" +NoCmp    disable nvim-cmp
" +Ts       enable treesitter
call m#parseopts(['NoLsp', 'NoCache', 'NoCmp', 'Ts'])
if exists('$VIMNOLSP')   | let g:options.NoLsp   = v:true | endif
if exists('$VIMNOCACHE') | let g:options.NoCache = v:true | endif

let g:bookmarks = [
  \ ['w', '<working directory>', 'Files .'],
  \ ['f', '<buffer directory>', 'exe "Files "..m#bufdir()'],
  \ ['g', '<git files>', 'GFiles'],
  \ ['u', '<most recently used>', 'lua require("m.fzf").mru()'],
  \ ['l', '<runtime lua modules>', 'lua require("m.fzf").lua_modules()'],
  \ ['e', '/etc'],
  \ ['t', '$VIMRUNTIME'],
  \ ['p', '$VIMPLUGINS'],
  \ ['v', '$VIMCONFIG'],
  \ ['k', '~/vimwiki'],
  \ ['s', '~/.local/share'],
  \ ['b', '~/.local/bin'],
  \ ['c', '~/.config'],
  \ ['r', '~/repos'],
  \ ['m', '~/dev/mm'],
  \ ['d', '~/dev'],
  \ ['h', '~'],
  \ ]

source $VIMCONFIG/plugins.lua
if !g:options.NoCache
  lua require('impatient')
endif
source $VIMCONFIG/setup.lua
source $VIMCONFIG/options.vim

" vim: tw=90 ts=2 sts=2 sw=2 et
