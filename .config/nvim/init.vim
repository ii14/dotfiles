" KEY MAPPINGS    $VIMCONFIG/keymaps.vim
" COMMANDS        $VIMCONFIG/commands.vim
" LSP CONFIG      $VIMCONFIG/lua/m/lsp.lua
" LSP BUFFER      $VIMCONFIG/lsp.vim
" TERMINAL        $VIMCONFIG/term.vim
" FZF             $VIMCONFIG/fzf.vim
" FERN            $VIMCONFIG/ftplugin/fern.vim
" GREP            $VIMCONFIG/grep.vim
" THEME           $VIMCONFIG/theme.vim
" COLORSCHEME     $VIMCONFIG/colors/onedark.vim.in
" SNIPPETS        $VIMCONFIG/lua/m/snippets.lua
" AUTOCOMMANDS    $VIMCONFIG/autocmd.vim

let $VIMDATA = stdpath('data')
let $VIMCACHE = stdpath('cache')
let $VIMCONFIG = stdpath('config')
let $VIMPLUGINS = $VIMDATA.'/plugged'

let g:mapleader = ' '
aug Vimrc | au! | aug end

let g:vimrc_minimal = v:progname ==# 'vi'
if g:vimrc_minimal
  source $VIMCONFIG/minimal.vim
  finish
endif

if exists('$VIMNOLSP')
  let g:disable_lsp = 1
endif

let g:enable_lua_theme = 1

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
  call plug#begin($VIMPLUGINS)

  " Editing ------------------------------------------------------------------------------
    Plug 'ii14/vim-surround'
    Plug 'numToStr/Comment.nvim'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-abolish'
    Plug 'wellle/targets.vim'
    Plug 'tommcdo/vim-exchange'
    Plug 'haya14busa/vim-asterisk'
    Plug 'romainl/vim-cool'
    Plug 'godlygeek/tabular'
    Plug 'ii14/vim-bbye'
    Plug 'mbbill/undotree'
    Plug 'wellle/visual-split.vim'

  " Visual -------------------------------------------------------------------------------
    if !exists('g:enable_lua_theme')
      Plug 'itchyny/lightline.vim'
      Plug 'mengelbrecht/lightline-bufferline'
    endif
    Plug 'lukas-reineke/indent-blankline.nvim'

  " File management ----------------------------------------------------------------------
    Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
    Plug 'junegunn/fzf.vim'
    Plug 'lambdalisue/fern.vim'
    Plug 'LumaKernel/fern-mapping-fzf.vim'
    Plug 'antoinemadec/FixCursorHold.nvim' " required by fern.vim
    Plug 'bogado/file-line'

  " Autocompletion -----------------------------------------------------------------------
    if !exists('g:disable_lsp')
      Plug 'neovim/nvim-lspconfig'
      Plug 'ii14/lsp-command'
      Plug 'nvim-lua/plenary.nvim'
      Plug 'jose-elias-alvarez/null-ls.nvim'
      Plug 'folke/trouble.nvim'
    endif
    Plug 'hrsh7th/nvim-compe'
    " Plug 'tamago324/compe-necosyntax'
    " Plug 'Shougo/neco-syntax'
    Plug 'L3MON4D3/LuaSnip'

  " Development --------------------------------------------------------------------------
    Plug 'tpope/vim-fugitive'
    Plug 'rbong/vim-flog'
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'tpope/vim-dispatch'
    Plug 'ii14/exrc.vim'
    Plug 'ii14/pro.vim'

  " Syntax -------------------------------------------------------------------------------
    Plug 'sheerun/vim-polyglot'
    Plug 'fedorenchik/qt-support.vim'
    Plug 'PotatoesMaster/i3-vim-syntax'
    Plug 'ii14/vim-rasi'
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'milisims/nvim-luaref'

  " Misc ---------------------------------------------------------------------------------
    Plug 'vimwiki/vimwiki', {'on': 'VimwikiIndex', 'for': ['vimwiki', 'markdown']}
    Plug 'kizza/actionmenu.nvim'

  " Performance --------------------------------------------------------------------------
    Plug 'tweekmonster/startuptime.vim'
    Plug 'lewis6991/impatient.nvim'
    Plug 'nathom/filetype.nvim'

  call plug#end()
  call m#check_missing_plugs()

" PLUGIN SETTINGS ////////////////////////////////////////////////////////////////////////
  if !exists('$VIMNOLUACACHE')
    lua pcall(require, 'impatient')
  endif
  lua require 'm.setup'

  if !exists('g:enable_lua_theme')
    source $VIMCONFIG/theme.vim
  endif
  source $VIMCONFIG/fzf.vim

  " Completion ---------------------------------------------------------------------------
    let g:compe = {'source': {
      \ 'path': v:true,
      \ 'calc': v:true,
      \ 'buffer': v:true,
      \ 'necosyntax': v:true,
      \ 'luasnip': v:true,
      \ }}
    " LSP buffer local config in $VIMCONFIG/lsp.vim

  " Fern ---------------------------------------------------------------------------------
    let g:fern#disable_default_mappings = 1
    let g:fern#drawer_width = 31
    let g:fern#renderer#default#collapsed_symbol = '> '
    let g:fern#renderer#default#expanded_symbol = 'v '
    let g:fern#renderer#default#leaf_symbol = '¦ '
    let g:fern#hide_cursor = 1
    aug Vimrc
      au BufEnter * ++nested call m#fern_hijack_directory()
    aug end

  " indent-blankline ---------------------------------------------------------------------
    let g:indent_blankline_buftype_exclude = ['help', 'terminal']
    let g:indent_blankline_filetype_exclude = ['man', 'fern', 'floggraph', 'fugitive', 'gitcommit']
    " let g:indent_blankline_show_first_indent_level = v:false
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

  " Indentation and Folding --------------------------------------------------------------
    set expandtab                             " convert tabs to spaces
    set shiftwidth=4 softtabstop=4 tabstop=8  " tab width
    set shiftround                            " follow tab grid
    set smartindent                           " smarter auto indentation
    set foldlevel=999                         " unfold everything by default
    set foldmethod=indent                     " folding based on indentation
    set cino+=:0,g0,l1,N-s,E-s                " c/cpp indentation

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
