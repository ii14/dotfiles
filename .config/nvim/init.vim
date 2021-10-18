" KEY MAPPINGS    $VIMCONFIG/maps.vim
" COMMANDS        $VIMCONFIG/commands.vim
" LSP CONFIG      $VIMCONFIG/lua/m/lsp/init.lua
" LSP BUFFER      $VIMCONFIG/lsp.vim
" TERMINAL        $VIMCONFIG/term.vim
" FZF             $VIMCONFIG/fzf.vim
" FERN            $VIMCONFIG/ftplugin/fern.vim
" GREP            $VIMCONFIG/grep.vim
" THEME           $VIMCONFIG/theme.vim
" HIGHLIGHTING    $VIMCONFIG/after/plugin/color.vim
" SNIPPETS        $VIMCONFIG/UltiSnips/

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
    " Plug 'tpope/vim-commentary'
    Plug 'numToStr/Comment.nvim'
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
      Plug 'nvim-lua/plenary.nvim'
      Plug 'jose-elias-alvarez/null-ls.nvim'
      Plug 'folke/trouble.nvim'
      Plug 'kosayoda/nvim-lightbulb'
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
    Plug 'milisims/nvim-luaref'

  " Misc ---------------------------------------------------------------------------------
    Plug 'vimwiki/vimwiki'
    Plug 'kizza/actionmenu.nvim'

  " Custom -------------------------------------------------------------------------------
    Plug $VIMCONFIG..'/m/qf.vim'
    Plug $VIMCONFIG..'/m/drawer.nvim'
    Plug $VIMCONFIG..'/m/termdebug'

  " Performance --------------------------------------------------------------------------
    Plug 'tweekmonster/startuptime.vim'
    Plug 'lewis6991/impatient.nvim'
    Plug 'nathom/filetype.nvim'
    let g:did_load_filetypes = 1

  call plug#end()

  " Check missing plugins
  let s:missing_plugs = len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  if s:missing_plugs
    if input((s:missing_plugs == 1
      \ ? '1 plugin is missing'
      \ : s:missing_plugs..' plugins are missing')..'. Install? [y/n]: ')
      \ =~? '\v\cy%[es]$'
      PlugInstall
    endif
  endif
  unlet! s:missing_plugs

  lua require 'impatient'
  lua require 'm.global'

" PLUGIN SETTINGS ////////////////////////////////////////////////////////////////////////
  source $VIMCONFIG/theme.vim
  source $VIMCONFIG/fzf.vim

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
      lua require 'm.lsp'
      aug Vimrc
        au User LspAttach source $VIMCONFIG/lsp.vim
        au CursorMoved * lua require 'nvim-lightbulb'.update_lightbulb()
        au TabEnter * call m#lsp_update_tab()
      aug end
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

  " UltiSnips ----------------------------------------------------------------------------
    let g:UltiSnipsJumpForwardTrigger  = "\<C-F>"
    let g:UltiSnipsJumpBackwardTrigger = "\<C-B>"

  " indent-blankline ---------------------------------------------------------------------
    let g:indent_blankline_buftype_exclude = ['help', 'terminal']
    let g:indent_blankline_filetype_exclude = ['man', 'fern', 'floggraph', 'fugitive', 'gitcommit']
    let g:indent_blankline_show_first_indent_level = v:false
    let g:indent_blankline_show_trailing_blankline_indent = v:false
    let g:indent_blankline_char = '¦'

  " comment.nvim -------------------------------------------------------------------------
    lua require 'Comment'.setup{ ignore = '^$' }

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
    set path+=**
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

  source $VIMCONFIG/commands.vim
  source $VIMCONFIG/grep.vim
  source $VIMCONFIG/term.vim
  source $VIMCONFIG/maps.vim

" AUTOCOMMANDS ///////////////////////////////////////////////////////////////////////////
  aug Vimrc

  " Return to last edit position ---------------------------------------------------------
    au BufReadPost *
      \ if index(['gitcommit', 'fugitive'], &filetype) == -1 &&
      \   line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

  " Gutter and cursor line ---------------------------------------------------------------
    au WinEnter,BufWinEnter * if &bt !=# 'terminal' | setl   cursorline | endif
    au WinLeave             * if &bt !=# 'terminal' | setl nocursorline | endif
    au TermOpen * setl nonumber norelativenumber nocursorline signcolumn=auto
    au CmdwinEnter * setl nonumber norelativenumber

  " Highlight yanked text ----------------------------------------------------------------
    au TextYankPost * silent! lua vim.highlight.on_yank()

  " Open quickfix window on grep ---------------------------------------------------------
    au QuickFixCmdPost grep,grepadd,vimgrep,helpgrep
      \ call timer_start(10, {-> execute('cwindow')})
    au QuickFixCmdPost lgrep,lgrepadd,lvimgrep,lhelpgrep
      \ call timer_start(10, {-> execute('lwindow')})

  " Auto close quickfix, if it's the last buffer -----------------------------------------
    au WinEnter * if winnr('$') == 1 && &buftype ==# 'quickfix' | q! | endif

  " Workarounds --------------------------------------------------------------------------
    " Fix wrong size on alacritty on i3 (https://github.com/neovim/neovim/issues/11330)
    au VimEnter * silent exec "!kill -s SIGWINCH $PPID"

  aug end

" vim: tw=90 ts=2 sts=2 sw=2 et
