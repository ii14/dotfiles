" PLUGINS         $VIMCONFIG/plugins.lua
" LUA SETUP       $VIMCONFIG/setup.lua
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

" SETTINGS ///////////////////////////////////////////////////////////////////////////////
  " Visual -------------------------------------------------------------------------------
    set number relativenumber         " line numbers
    set nowrap                        " no text wrapping
    set colorcolumn=+1                " text width ruler
    set lazyredraw                    " don't redraw while executing macros
    set title titlelen=45             " set vim window title
    set titlestring=nvim:\ %F
    set shortmess+=I                  " no intro message
    set list                          " show non-printable characters
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
    set fillchars=diff:╱
    set synmaxcol=1500                " highlight only the first 1500 columns
    set pumblend=13                   " pseudo transparency for popup windows

  " Editing ------------------------------------------------------------------------------
    set textwidth=90
    set virtualedit=block             " move cursor anywhere in visual block mode
    set scrolloff=1 sidescrolloff=1   " keep near lines visible when scrolling
    set mouse=nvi                     " enable mouse, disable for command line
    set mousemodel=extend             " disable right click popup menu
    set splitbelow splitright         " new splits to the right and bottom
    set linebreak breakindent         " visual wrap on whitespace, follow indentation
    set diffopt+=iwhite               " ignore whitespace in diff
    set diffopt+=vertical             " start diff as a vertical split
    set nojoinspaces                  " join lines with one space instead of two
    set gdefault                      " use g flag by default in substitutions
    set backspace=indent,start        " no backspacing over eol
    set switchbuf+=useopen            " qf: jump to window with the buffer open
    set formatoptions+=/
    " set scrolljump=-50                " center window after jumps

  " Indentation and Folding --------------------------------------------------------------
    set expandtab                     " convert tabs to spaces
    set ts=8 sw=4 sts=-1              " tab width
    set shiftround                    " follow tab grid
    set smartindent                   " smarter auto indentation
    set cino+=:0,g0,l1,N-s,E-s        " c/cpp indentation
    set foldlevel=999                 " unfold everything by default
    set foldmethod=indent             " folding based on indentation

  " Search and Completion ----------------------------------------------------------------
    set ignorecase smartcase          " ignore case unless search starts with uppercase
    set inccommand=nosplit            " :substitute live preview
    set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
    set shortmess+=c                  " silent completion
    set pumheight=25                  " autocompletion popup height
    set completeopt+=noselect         " no auto-select in completion
    set completeopt+=menuone          " open popup when there is only one match
    set completeopt-=preview          " no preview window

  " Buffers ------------------------------------------------------------------------------
    set hidden                        " don't close buffers
    set undofile                      " persistent undo history
    set noswapfile                    " disable swap files

" vim: tw=90 ts=2 sts=2 sw=2 et
