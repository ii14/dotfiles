let $VIMDATA = stdpath('data')
let $VIMCACHE = stdpath('cache')
let $VIMCONFIG = stdpath('config')
let $VIMPLUGINS = $VIMDATA.'/plugged'

" KEY MAPPINGS    $VIMCONFIG/maps.vim
" COMMANDS        $VIMCONFIG/commands.vim
" LSP CONFIG      $VIMCONFIG/lua/m/lsp/init.lua
" LSP BUFFER      $VIMCONFIG/lsp.vim
" TERMINAL        $VIMCONFIG/term.vim
" FZF             $VIMCONFIG/fzf.vim
" FERN            $VIMCONFIG/ftplugin/fern.vim
" GREP            $VIMCONFIG/grep.vim
" THEME           $VIMCONFIG/theme.vim
" SNIPPETS        $VIMCONFIG/UltiSnips/

let mapleader = ' '
aug Vimrc | au! | aug end

if v:progname ==# 'vi'
  source $VIMCONFIG/minimal.vim
  finish
endif

if exists('$VIMNOLSP')
  let g:disable_lsp = 1
endif

lua require 'm.global'
source $VIMCONFIG/functions.vim

let g:bookmarks = [
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
  \ ['.', '.'],
  \ ]

" PLUGINS ////////////////////////////////////////////////////////////////////////////////
  call plug#begin($VIMPLUGINS)

  " Editing ------------------------------------------------------------------------------
    Plug 'ii14/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-abolish'
    Plug 'wellle/targets.vim'
    Plug 'tommcdo/vim-exchange'
    Plug 'haya14busa/vim-asterisk'
    Plug 'romainl/vim-cool'
    Plug 'godlygeek/tabular'
    Plug 'ii14/vim-bbye'
    Plug 'mbbill/undotree', {'on': ['UndotreeShow', 'UndotreeToggle']}
    Plug 'stefandtw/quickfix-reflector.vim'

  " Visual -------------------------------------------------------------------------------
    Plug 'ii14/onedark.nvim'
    Plug 'itchyny/lightline.vim'
    Plug 'mengelbrecht/lightline-bufferline'
    Plug 'lukas-reineke/indent-blankline.nvim'

  " File management ----------------------------------------------------------------------
    Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
    Plug 'junegunn/fzf.vim'
    Plug 'lambdalisue/fern.vim', {'on': 'Fern'}
    Plug 'LumaKernel/fern-mapping-fzf.vim', {'on': 'Fern'}
    Plug 'antoinemadec/FixCursorHold.nvim' " required by fern.vim
    Plug 'bogado/file-line'

  " Autocompletion -----------------------------------------------------------------------
    if !exists('g:disable_lsp')
      Plug 'neovim/nvim-lspconfig'
      Plug 'folke/trouble.nvim'
      Plug 'kosayoda/nvim-lightbulb'
      Plug 'ray-x/lsp_signature.nvim'
    endif
    Plug 'hrsh7th/nvim-compe'
    Plug 'tamago324/compe-necosyntax'
    Plug 'Shougo/neco-syntax'

  " Development --------------------------------------------------------------------------
    Plug 'tpope/vim-fugitive'
    Plug 'rbong/vim-flog'
    Plug 'tpope/vim-dispatch'
    Plug 'SirVer/ultisnips', {'for': ['c', 'cpp', 'make', 'css', 'html', 'lua']}
    Plug 'ii14/exrc.vim'
    Plug 'ii14/pro.vim'

  " Syntax -------------------------------------------------------------------------------
    Plug 'sheerun/vim-polyglot'
    Plug 'fedorenchik/qt-support.vim'
    Plug 'PotatoesMaster/i3-vim-syntax'
    Plug 'CantoroMC/vim-rasi'
    Plug 'norcalli/nvim-colorizer.lua'

  " Misc ---------------------------------------------------------------------------------
    Plug 'vimwiki/vimwiki'
    Plug 'vifm/vifm.vim', {'on': 'Vifm'}
    Plug 'tweekmonster/startuptime.vim'
    Plug 'lewis6991/impatient.nvim'
    Plug 'kizza/actionmenu.nvim'

  " Custom -------------------------------------------------------------------------------
    Plug $VIMCONFIG.'/m/qf.vim'
    Plug $VIMCONFIG.'/m/drawer.nvim'
    Plug $VIMCONFIG.'/m/termdebug'

  call plug#end()
  call PlugCheckMissing()

  lua require 'impatient'

" PLUGIN SETTINGS ////////////////////////////////////////////////////////////////////////
  source $VIMCONFIG/theme.vim
  " TODO: move highlights elsewhere
  hi NormalDarker guibg=#21252C guifg=#ABB2BF
  source $VIMCONFIG/fzf.vim
  source $VIMCONFIG/term.vim

  " Completion ---------------------------------------------------------------------------
    let g:compe = {'source': {
      \ 'path': v:true,
      \ 'calc': v:true,
      \ 'buffer': v:true,
      \ 'necosyntax': v:true,
      \ 'ultisnips': v:true,
      \ }}
    " LSP buffer local config in $VIMCONFIG/lsp.vim

  " LSP ----------------------------------------------------------------------------------
    if !exists('g:disable_lsp')
      " $VIMCONFIG/lua/m/lsp/init.lua
      lua require 'm.lsp'

      aug Vimrc
        au User LspAttach source $VIMCONFIG/lsp.vim
        au CursorMoved * lua require 'nvim-lightbulb'.update_lightbulb()
        au BufWinEnter * call s:lsp_update_signcolumn()
      aug end

      fun! s:lsp_update_signcolumn()
        if exists('b:lsp_attached')
          if b:lsp_attached
            setl signcolumn=yes
          else
            setl signcolumn=auto
            unlet! b:lsp_attached
          endif
        endif
      endfun
    endif

  " Fern ---------------------------------------------------------------------------------
    let g:loaded_netrw = 1
    let g:loaded_netrwPlugin = 1
    let g:loaded_netrwSettings = 1
    let g:loaded_netrwFileHandlers = 1
    let g:fern#disable_default_mappings = 1
    let g:fern#drawer_width = 32
    let g:fern#renderer#default#collapsed_symbol = '> '
    let g:fern#renderer#default#expanded_symbol = 'v '
    let g:fern#renderer#default#leaf_symbol = '¦ '
    let g:fern#hide_cursor = 1

    hi link FernRootText     String
    hi link FernRootSymbol   String
    hi link FernMarkedLine   WarningMsg
    hi link FernMarkedText   WarningMsg
    hi link FernLeafSymbol   LineNr
    hi link FernBranchSymbol Comment

    fun! s:fern_hijack_directory() abort
      let l:path = expand('%:p')
      if isdirectory(l:path)
        let l:bufnr = bufnr()
        execute printf('keepjumps keepalt Fern %s', fnameescape(l:path))
        execute printf('bwipeout %d', l:bufnr)
      endif
    endfun

    aug Vimrc
      au BufEnter * ++nested call s:fern_hijack_directory()
    aug end

  " indent-blankline ---------------------------------------------------------------------
    let g:indent_blankline_buftype_exclude = ['help', 'terminal']
    let g:indent_blankline_filetype_exclude = ['man', 'fern', 'floggraph']
    let g:indent_blankline_show_first_indent_level = v:false
    let g:indent_blankline_show_trailing_blankline_indent = v:false
    let g:indent_blankline_char = '¦'

    hi IndentBlanklineChar guifg=#4B5263 gui=nocombine
    hi link IndentBlanklineSpaceChar          IndentBlanklineChar
    hi link IndentBlanklineSpaceCharBlankline IndentBlanklineChar

  " exrc.vim -----------------------------------------------------------------------------
    let g:exrc#names = ['.exrc']
    aug Vimrc
      au BufWritePost .exrc ++nested silent ExrcTrust
      au SourcePost .exrc silent Pro!
    aug end

  " autosplit.vim ------------------------------------------------------------------------
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

  " quickfix-reflector.vim ---------------------------------------------------------------
    let g:qf_modifiable = 0

" SETTINGS ///////////////////////////////////////////////////////////////////////////////
  " Visual -------------------------------------------------------------------------------
    set number relativenumber                 " line numbers
    set nowrap                                " don't wrap text
    set colorcolumn=+1                        " text width ruler
    set lazyredraw                            " don't redraw while executing macros
    set title titlelen=45                     " set vim window title
    set titlestring=nvim:\ %F
    set shortmess+=I                          " no intro message
    set noshowmode                            " redundant mode message
    set list                                  " show non-printable characters
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
    set synmaxcol=1000                        " highlight only the first 1000 columns
    set pumblend=13 winblend=13               " pseudo transparency

  " Editing ------------------------------------------------------------------------------
    set textwidth=90
    set history=1000                          " command history size
    set virtualedit=block                     " move cursor anywhere in visual block mode
    set scrolloff=1 sidescrolloff=1           " keep near lines visible when scrolling
    set mouse=a                               " mouse support
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

  " Search and Autocompletion ------------------------------------------------------------
    set path+=**
    set ignorecase smartcase                  " ignore case unless search starts with uppercase
    set inccommand=nosplit                    " sed preview
    set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
    set shortmess+=c                          " silent completion
    set pumheight=25                          " autocompletion popup height
    set completeopt+=noselect                 " no auto-select in completion
    set completeopt+=menuone                  " open popup when there is only one match
    set completeopt-=preview                  " no preview window

  " Buffers ------------------------------------------------------------------------------
    set hidden                                " don't close buffers
    set noswapfile                            " disable swap files
    set undofile                              " persistent undo history
    set directory=$VIMCACHE/swap              " swap files
    set backupdir=$VIMCACHE/backup            " backup files
    set undodir=$VIMCACHE/undo                " undo files

  " Grep ---------------------------------------------------------------------------------
    source $VIMCONFIG/grep.vim

" COMMANDS ///////////////////////////////////////////////////////////////////////////////
  source $VIMCONFIG/commands.vim

" AUTOCOMMANDS ///////////////////////////////////////////////////////////////////////////
  aug Vimrc

  " Return to last edit position ---------------------------------------------------------
    au BufReadPost *
      \ if &ft !=# 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

  " Cursor line highlighting -------------------------------------------------------------
    au WinEnter,BufWinEnter * if &bt !=# 'terminal' | setl   cursorline | endif
    au WinLeave             * if &bt !=# 'terminal' | setl nocursorline | endif

  " Terminal -----------------------------------------------------------------------------
    au TermOpen * setl nonumber norelativenumber nocursorline signcolumn=auto

  " Highlight yanked text ----------------------------------------------------------------
    au TextYankPost * silent! lua vim.highlight.on_yank()

  " Open quickfix window on grep ---------------------------------------------------------
    au QuickFixCmdPost grep,grepadd,vimgrep,helpgrep
      \ call timer_start(10, {-> execute('cwindow')})
    au QuickFixCmdPost lgrep,lgrepadd,lvimgrep,lhelpgrep
      \ call timer_start(10, {-> execute('lwindow')})

  " Auto close quickfix, if it's the last buffer -----------------------------------------
    au WinEnter * if winnr('$') == 1 && &bt ==# 'quickfix' | q! | endif

  " Workarounds --------------------------------------------------------------------------
    " Fix wrong size on alacritty on i3 (https://github.com/neovim/neovim/issues/11330)
    au VimEnter * silent exec "!kill -s SIGWINCH $PPID"

  aug end

" KEY MAPPINGS ///////////////////////////////////////////////////////////////////////////
  source $VIMCONFIG/maps.vim

" vim:tw=90:ts=2:sts=2:sw=2:et:
