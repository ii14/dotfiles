" PLUGINS         $VIMCONFIG/plugins.lua
" LUA SETUP       $VIMCONFIG/setup.lua
" KEY MAPPINGS    $VIMCONFIG/keymaps.vim
" COMMANDS        $VIMCONFIG/commands.vim
" LSP CONFIG      $VIMCONFIG/lua/m/lsp.lua
" LSP BUFFER      $VIMCONFIG/lsp.vim
" TERMINAL        $VIMCONFIG/term.vim
" FZF             $VIMCONFIG/fzf.vim
" GREP            $VIMCONFIG/grep.vim
" COLORSCHEME     $VIMCONFIG/colors/onedark.lua
" SNIPPETS        $VIMCONFIG/lua/m/snippets.lua
" AUTOCOMMANDS    $VIMCONFIG/autocmd.vim

let $VIMDATA = stdpath('data')
let $VIMCACHE = stdpath('cache')
let $VIMCONFIG = stdpath('config')
let $VIMPLUGINS = $VIMDATA.'/neopm'

let g:mapleader = ' '
aug Vimrc | au! | aug end

if v:progname ==# 'vi' && !exists('g:upgraded')
  source $VIMCONFIG/minimal.vim
  finish
endif

call m#addopts(['NoLsp', 'NoCache'])
if exists('$VIMNOLSP')   | let g:options.NoLsp   = v:true | endif
if exists('$VIMNOCACHE') | let g:options.NoCache = v:true | endif

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

" PLUGINS ////////////////////////////////////////////////////////////////////////////////
  source $VIMCONFIG/plugins.lua
  source $VIMCONFIG/setup.lua
  source $VIMCONFIG/fzf.vim

  " Completion ---------------------------------------------------------------------------
    let g:compe = {'source': {
      \ 'path': v:true,
      \ 'calc': v:true,
      \ 'buffer': v:true,
      \ 'syncomp': v:true,
      \ }}
      " \ 'necosyntax': v:true,
      " \ 'luasnip': v:true,
    " LSP buffer local config in $VIMCONFIG/lsp.vim

  " indent-blankline ---------------------------------------------------------------------
    let g:indent_blankline_buftype_exclude = ['help', 'terminal']
    let g:indent_blankline_filetype_exclude = ['', 'man', 'lir', 'floggraph', 'fugitive', 'gitcommit']
    let g:indent_blankline_show_trailing_blankline_indent = v:false
    let g:indent_blankline_char = '¦'

  " exrc.vim -----------------------------------------------------------------------------
    let g:exrc#names = ['.exrc']
    aug Vimrc
      au BufWritePost .exrc ++nested silent ExrcTrust
      au VimEnter * ++once au Vimrc SourcePost .exrc silent Pro!
    aug end

  " autosplit ----------------------------------------------------------------------------
    let g:autosplit_ft = ['man', 'fugitive', 'gitcommit']
    let g:autosplit_bt = ['help']

  " undotree -----------------------------------------------------------------------------
    let g:undotree_DiffAutoOpen = 0
    let g:undotree_WindowLayout = 2
    let g:undotree_HelpLine = 0
    let g:undotree_ShortIndicators = 1

  " vimwiki ------------------------------------------------------------------------------
    let g:vimwiki_key_mappings = {'global': 0}
    let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

  " targets.vim --------------------------------------------------------------------------
    let g:targets_aiAI = 'aIAi'

  " termdebug ----------------------------------------------------------------------------
    let g:termdebug_wide = 1

  " Disable builtin plugins --------------------------------------------------------------
    let g:loaded_netrw = 1
    let g:loaded_netrwPlugin = 1
    let g:loaded_netrwSettings = 1
    let g:loaded_netrwFileHandlers = 1
    let g:loaded_tutor_mode_plugin = 1
    let g:loaded_2html_plugin = 1
    let g:loaded_spellfile_plugin = 1
    let g:loaded_tarPlugin = 1
    let g:loaded_zipPlugin = 1
    let g:loaded_gzip = 1

" SETTINGS ///////////////////////////////////////////////////////////////////////////////
  " Visual -------------------------------------------------------------------------------
    set number relativenumber                 " line numbers
    set nowrap                                " don't wrap text
    set colorcolumn=+1                        " text width ruler
    set lazyredraw                            " don't redraw while executing macros
    set title titlelen=45                     " set vim window title
    set titlestring=nvim:\ %F
    set shortmess+=I                          " no intro message
    set list                                  " show non-printable characters
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
    set fillchars=diff:╱
    set synmaxcol=1000                        " highlight only the first 1000 columns
    set pumblend=13 winblend=13               " pseudo transparency

  " Editing ------------------------------------------------------------------------------
    set textwidth=90
    set virtualedit=block                     " move cursor anywhere in visual block mode
    set scrolloff=1 sidescrolloff=1           " keep near lines visible when scrolling
    set mouse=nvi                             " mouse support
    set splitbelow splitright                 " sane splits
    set linebreak breakindent                 " visual wrap on whitespace, follow indentation
    set diffopt+=iwhite                       " ignore whitespace in diff
    set diffopt+=vertical                     " start diff as a vertical split
    set nojoinspaces                          " join lines with one space instead of two
    set gdefault                              " use g flag by default in substitutions
    set backspace=indent,start                " no backspacing over eol
    " set scrolljump=-50                        " center window after jumps

  " Indentation and Folding --------------------------------------------------------------
    set expandtab                             " convert tabs to spaces
    set tabstop=8 shiftwidth=4 softtabstop=-1 " tab width
    set shiftround                            " follow tab grid
    set smartindent                           " smarter auto indentation
    set cino+=:0,g0,l1,N-s,E-s                " c/cpp indentation
    set foldlevel=999                         " unfold everything by default
    set foldmethod=indent                     " folding based on indentation

  " Search and Autocompletion ------------------------------------------------------------
    set ignorecase smartcase                  " ignore case unless search starts with uppercase
    set inccommand=nosplit                    " :substitute live preview
    set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
    set shortmess+=c                          " silent completion
    set pumheight=25                          " autocompletion popup height
    set completeopt+=noselect                 " no auto-select in completion
    set completeopt+=menuone                  " open popup when there is only one match
    set completeopt-=preview                  " no preview window

  " Buffers ------------------------------------------------------------------------------
    set hidden                                " don't close buffers
    set undofile                              " persistent undo history
    set noswapfile                            " disable swap files

source $VIMCONFIG/keymaps.vim
source $VIMCONFIG/commands.vim
source $VIMCONFIG/grep.vim
source $VIMCONFIG/term.vim
source $VIMCONFIG/autocmd.vim

" vim: tw=90 ts=2 sts=2 sw=2 et
