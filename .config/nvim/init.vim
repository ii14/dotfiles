let mapleader      = ' '
let maplocalleader = ' '
filetype plugin on
syntax on
set textwidth=90

if !has('nvim') | let s:disable_lsp = 1 | endif

let s:disable_deoplete = 1
let s:deoplete_lazy_load = 1

aug Vimrc | au! | aug end

" PLUGINS ////////////////////////////////////////////////////////////////////////////////
call plug#begin('~/.config/nvim/plugged')

  " Editing ------------------------------------------------------------------------------
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-repeat'
    Plug 'tommcdo/vim-exchange'
    Plug 'wellle/targets.vim'
    Plug 'haya14busa/vim-asterisk'
    Plug 'haya14busa/is.vim'
    Plug 'godlygeek/tabular'
    Plug 'moll/vim-bbye'
    " Plug 'bkad/CamelCaseMotion'

  " Visual -------------------------------------------------------------------------------
    Plug 'joshdick/onedark.vim'
    Plug 'edersonferreira/dalton-vim'
    Plug 'itchyny/lightline.vim'
    Plug 'mengelbrecht/lightline-bufferline'
    Plug 'Yggdroot/indentLine'
    Plug 'unblevable/quick-scope'

  " Search and Autocompletion ------------------------------------------------------------
    Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
    Plug 'junegunn/fzf.vim'
    if !exists('s:disable_lsp')
      Plug 'neovim/nvim-lspconfig'
    endif
    if !exists('s:disable_deoplete')
      Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
      Plug 'Shougo/neco-syntax'
      if !exists('s:disable_lsp')
        Plug 'Shougo/deoplete-lsp'
      endif
    else
      Plug 'nvim-lua/completion-nvim'
      Plug 'steelsojka/completion-buffers'
    endif

  " Development --------------------------------------------------------------------------
    Plug 'tpope/vim-fugitive'
    Plug 'rbong/vim-flog'
    Plug 'ii14/vim-dispatch'
    Plug 'cdelledonne/vim-cmake'
    Plug 'nacitar/a.vim'

  " Syntax -------------------------------------------------------------------------------
    Plug 'sheerun/vim-polyglot'
    Plug 'fedorenchik/qt-support.vim'
    Plug 'PotatoesMaster/i3-vim-syntax'
    if !exists('s:disable_lsp')
      Plug 'jackguo380/vim-lsp-cxx-highlight'
    endif

  " Misc ---------------------------------------------------------------------------------
    Plug 'vimwiki/vimwiki'
    Plug 'lambdalisue/fern.vim'
    Plug 'antoinemadec/FixCursorHold.nvim'
    Plug 'metakirby5/codi.vim', {'on': 'Codi'}

call plug#end()

" PLUGIN SETTINGS ////////////////////////////////////////////////////////////////////////
  " Theme --------------------------------------------------------------------------------
    " ~/.config/nvim/plugin/theme.vim

  " fzf ----------------------------------------------------------------------------------
    let $FZF_DEFAULT_OPTS =
      \ '--bind=ctrl-a:select-all,ctrl-u:page-up,ctrl-d:page-down,ctrl-space:toggle'
    let g:fzf_action = {'ctrl-s': 'split', 'ctrl-v': 'vsplit'}
    let g:fzf_layout = {'down': '40%'}
    let g:fzf_colors = {
      \ 'fg'      : ['fg', 'Normal'],
      \ 'bg'      : ['bg', 'Normal'],
      \ 'hl'      : ['fg', 'Comment'],
      \ 'fg+'     : ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+'     : ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+'     : ['fg', 'Statement'],
      \ 'info'    : ['fg', 'PreProc'],
      \ 'border'  : ['fg', 'Ignore'],
      \ 'prompt'  : ['fg', 'Function'],
      \ 'pointer' : ['fg', 'Exception'],
      \ 'marker'  : ['fg', 'Keyword'],
      \ 'spinner' : ['fg', 'Label'],
      \ 'header'  : ['fg', 'Comment']
      \ }

  " Deoplete -----------------------------------------------------------------------------
    if !exists('s:disable_deoplete')
      if !exists('s:deoplete_lazy_load ')
        let g:deoplete#enable_at_startup = 1
      else
        let g:deoplete#enable_at_startup = 0
        aug Vimrc
          au InsertEnter * call deoplete#enable()
        aug end
      endif
    endif

  " completion-nvim ----------------------------------------------------------------------
    if exists('s:disable_deoplete')
      let g:completion_enable_auto_signature = 0
      let g:completion_trigger_on_delete = 1
      let g:completion_auto_change_source = 1
      let g:completion_matching_ignore_case = 1
      let g:completion_matching_strategy_list = ['exact', 'fuzzy', 'substring']
      let g:completion_chain_complete_list = {'default': [
        \   {'complete_items': ['path'], 'triggered_only': ['/']},
        \   {'complete_items': ['path', 'buffers']},
        \ ]}

      imap <C-J> <Plug>(completion_next_source)
      imap <C-K> <Plug>(completion_prev_source)

      aug Vimrc
        au BufEnter * lua require 'lsp/buf'.on_attach()
      aug end
    endif

  " nvim-lsp -----------------------------------------------------------------------------
    if !exists('s:disable_lsp')
      " called when lsp is attached to the current buffer
      if exists('s:disable_deoplete')
        fun! VimrcLspOnAttach()
          call s:init_maps_lsp()
          lua require 'lsp/buf'.attach_completion_lsp()
        endfun
      else
        fun! VimrcLspOnAttach()
          call s:init_maps_lsp()
          call deoplete#custom#buffer_option('sources', ['lsp'])
        endfun
      endif

      " ~/.config/nvim/lua/lsp/init.lua
      lua require 'lsp/init'
    endif

  " Fern ---------------------------------------------------------------------------------
    let g:loaded_netrw             = 1 " disable netrw
    let g:loaded_netrwPlugin       = 1
    let g:loaded_netrwSettings     = 1
    let g:loaded_netrwFileHandlers = 1
    let g:fern#disable_default_mappings = 1

  " Dispatch -----------------------------------------------------------------------------
    let g:dispatch_no_maps    = 1
    let g:dispatch_keep_focus = 1 " dispatch fork - keeps focus on failed build

  " IndentLine ---------------------------------------------------------------------------
    let g:indentLine_bufTypeExclude = ['help', 'terminal']
    let g:vim_json_syntax_conceal = 0
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_conceal_code_blocks = 0

  " quick-scope --------------------------------------------------------------------------
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
    let g:qs_max_chars = 150
    let g:qs_buftype_blacklist = ['terminal', 'nofile']

  " vimwiki ------------------------------------------------------------------------------
    let g:vimwiki_key_mappings = {'global': 0}

" SETTINGS ///////////////////////////////////////////////////////////////////////////////
  " Visual -------------------------------------------------------------------------------
    set termguicolors
    set laststatus=2                          " show status line
    set number relativenumber                 " line numbers
    set colorcolumn=+1                        " text width ruler
    set lazyredraw                            " don't redraw while executing macros
    set title                                 " set vim window title
    set belloff=all                           " turn off bell
    set shortmess+=I                          " no intro message
    set noshowmode                            " redundant mode message
    set list                                  " show non-printable characters
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
    set synmaxcol=500                         " highlight only the first 500 columns

  " Editing ------------------------------------------------------------------------------
    set encoding=utf-8
    set history=1000                          " command history size
    set backspace=indent,eol,start            " allow backspace over...
    set virtualedit=block                     " move cursor anywhere in visual block mode
    set scrolloff=1                           " keep near lines visible when scrolling
    set confirm                               " display dialog instead of failing
    set mouse=a                               " mouse support
    set splitbelow splitright                 " sane splits
    set wrap linebreak breakindent            " visual wrap, on whitespace, follow indentation
    set diffopt+=iwhite,vertical

  " Indentation and Folding --------------------------------------------------------------
    set expandtab                             " convert tabs to spaces
    set shiftwidth=4 tabstop=4 softtabstop=4  " tab width
    set smarttab shiftround                   " follow tab grid
    set autoindent smartindent                " follow previous indentation, auto indent blocks
    set foldmethod=indent foldlevel=999       " folding based on indentation

  " Search and Autocompletion ------------------------------------------------------------
    set path+=**
    set hlsearch incsearch                    " search highlighting, incremental
    set ignorecase smartcase                  " ignore case unless search starts with uppercase
    set inccommand=nosplit                    " sed preview
    set wildmenu                              " command completion
    set shortmess+=c                          " silent completion
    set pumheight=25                          " autocompletion popup height
    set completeopt+=noselect,menuone
    set completeopt-=preview

  " Buffers ------------------------------------------------------------------------------
    set hidden                                " don't close buffers
    set autoread                              " update buffer if changed outside of vim
    set noswapfile                            " disable swap files
    set undofile                              " persistent undo history
    set directory=~/.cache/nvim/swap          " swap files
    set backupdir=~/.cache/nvim/backup        " backup files
    set undodir=~/.cache/nvim/undo            " undo files
    "set autochdir                             " change cwd to the current buffer

  " Grep ---------------------------------------------------------------------------------
    if executable('rg')
      set grepformat=%f:%l:%m
      let &grepprg = 'rg --vimgrep' . (&smartcase ? ' --smart-case' : '')
    elseif executable('ag')
      set grepformat=%f:%l:%m
      let &grepprg = 'ag --vimgrep' . (&smartcase ? ' --smart-case' : '')
    endif

" COMMANDS ///////////////////////////////////////////////////////////////////////////////
  " Set tab width ------------------------------------------------------------------------
    com! -nargs=1 T setl ts=<args> sts=<args> sw=<args>

  " Go to the current buffer directory ---------------------------------------------------
    com! D exe 'cd '.expand('%:h')

  " Shortcuts ----------------------------------------------------------------------------
    com! Wiki VimwikiIndex
    com! Vimrc edit $MYVIMRC

  " Help ---------------------------------------------------------------------------------
    com! -nargs=? -complete=help H if <q-args> == '' | Helptags | else | h <args> | endif

  " Update ctags -------------------------------------------------------------------------
    if executable('ctags')
      com! MakeTags !ctags -R .
    endif

  " Redir --------------------------------------------------------------------------------
    com! -nargs=1 -complete=command Redir
      \ execute "tabnew | pu=execute(\'" . <q-args> . "\') | setl nomodified"

  " LSP ----------------------------------------------------------------------------------
    if !exists('s:disable_lsp')
      com! LspStop
        \ setl signcolumn=auto |
        \ lua vim.lsp.stop_client(vim.lsp.get_active_clients())

      com! -nargs=? LspFind
        \ exe 'lua vim.lsp.buf.workspace_symbol('
        \ . (<q-args> == '' ? '' : "'".<q-args>."'") . ')'

      com! -range=0 LspFormat
        \ exe 'lua vim.lsp.buf.' . (<count> ? 'range_formatting()' : 'formatting()')

      com! LspAction
        \ lua vim.lsp.buf.code_action()
    endif

" AUTOCOMMANDS ///////////////////////////////////////////////////////////////////////////
aug Vimrc
  " Return to last edit position ---------------------------------------------------------
    au BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

  " Cursor line highlighting -------------------------------------------------------------
    au VimEnter,WinEnter,BufWinEnter * setl cursorline
    au WinLeave * setl nocursorline

  " Terminal -----------------------------------------------------------------------------
    au TermOpen * setl nonumber norelativenumber
    au BufLeave term://* stopinsert

  " Tab widths ---------------------------------------------------------------------------
    au FileType yaml,ruby setl ts=2 sts=2 sw=2

  " make autowrite -----------------------------------------------------------------------
    au QuickFixCmdPre make update

  " Autocompile --------------------------------------------------------------------------
    au BufWritePost *.ts,*.scss silent make

  " Auto close quickfix, if it's the last buffer -----------------------------------------
    au WinEnter * if winnr('$') == 1 && &bt ==? "quickfix" | q | endif

  " Open help in vertical split, if there is enough space --------------------------------
    au WinNew * au BufEnter * ++once
      \ if (&bt ==? 'help' || &ft ==? 'man' || &ft ==? 'fugitive')
      \ && winwidth(0) >= 180 | wincmd L | endif

  " Open directories in fern -------------------------------------------------------------
    au BufEnter * ++nested call s:fern_hijack_directory()
    fun! s:fern_hijack_directory() abort
      let path = expand('%:p')
      if !isdirectory(path) | return | endif
      bwipeout %
      exe printf('Fern %s', fnameescape(path))
    endfun

aug end

" KEY MAPPINGS ///////////////////////////////////////////////////////////////////////////
  " Override defaults --------------------------------------------------------------------
    nnoremap 0 ^
    nnoremap ^ 0
    nnoremap Y y$
    nnoremap j gj
    vnoremap j gj
    nnoremap k gk
    vnoremap k gk
    vnoremap . :norm .<CR>
    nnoremap gV `[v`]
    nnoremap S i<CR><ESC>^mwgk:silent! s/\v +$//<CR>:noh<CR>`w
    nnoremap <C-E> 3<C-E>
    nnoremap <C-Y> 3<C-Y>

    noremap q <Nop>
    noremap Q q
    noremap q: :q

  " Windows ------------------------------------------------------------------------------
    nnoremap <C-H> <C-W>h
    nnoremap <C-J> <C-W>j
    nnoremap <C-K> <C-W>k
    nnoremap <C-L> <C-W>l
    nnoremap <leader>w <C-W>

  " Buffers ------------------------------------------------------------------------------
    nnoremap <C-N> :bn<CR>
    nnoremap <C-P> :bp<CR>
    nnoremap <leader>d :Bdelete<CR>
    nnoremap <leader>D :Bdelete!<CR>
    nnoremap <leader>b :Buffers<CR>

  " Files --------------------------------------------------------------------------------
    nnoremap <expr> <leader>f (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<CR>"
    nnoremap <leader>F :Files <C-R>=expand('%:h')<CR><CR>
    nnoremap <silent> - :Fern %:h -reveal=%<CR>
    nnoremap <silent> _ :Fern . -drawer -toggle -reveal=%<CR>

  " Search and Replace -------------------------------------------------------------------
    nnoremap <leader>/ :Lines<CR>
    nnoremap <leader>? :BLines<CR>
    nnoremap <leader>s :%s//g<Left><Left>
    vnoremap <leader>s :s//g<Left><Left>
    nmap <leader>h z*
    vmap <leader>h z*
    nmap <leader>c z*cgn
    vmap <leader>c z*cgn
    map *   <Plug>(asterisk-*)<Plug>(is-nohl-1)
    map #   <Plug>(asterisk-#)<Plug>(is-nohl-1)
    map g*  <Plug>(asterisk-g*)<Plug>(is-nohl-1)
    map g#  <Plug>(asterisk-g#)<Plug>(is-nohl-1)
    map z*  <Plug>(asterisk-z*)<Plug>(is-nohl-1)
    map gz* <Plug>(asterisk-gz*)<Plug>(is-nohl-1)
    map z#  <Plug>(asterisk-z#)<Plug>(is-nohl-1)
    map gz# <Plug>(asterisk-gz#)<Plug>(is-nohl-1)

  " Misc ---------------------------------------------------------------------------------
    vnoremap <leader>t :Tabularize /
    vnoremap <leader>n :norm!<Space>
    nnoremap <leader>a :A<CR>
    nnoremap <leader>H :Helptags<CR>
    nnoremap <leader>v ggVG

  " Clipboard ----------------------------------------------------------------------------
    nnoremap <leader>p "+p
    vnoremap <leader>p "+p
    nnoremap <leader>P "+P
    vnoremap <leader>P "+P
    nnoremap <leader>y "+y
    vnoremap <leader>y "+y
    nnoremap <leader>Y "+y$

  " Make ---------------------------------------------------------------------------------
    nnoremap m<CR>    :up<CR>:Make<CR>
    nnoremap m<Space> :up<CR>:Make<Space>
    nnoremap m!       :up<CR>:Make!<CR>
    nnoremap m?       :set makeprg?<CR>
    nnoremap `<CR>    :Dispatch<CR>
    nnoremap `<Space> :Dispatch<Space>
    nnoremap `!       :Dispatch!<CR>
    nnoremap `?       :FocusDispatch<CR>

  " Git ----------------------------------------------------------------------------------
    nnoremap <leader>gs :G<CR>
    nnoremap <leader>gl :Flog<CR>
    " nnoremap <silent> <leader>gd :Gvdiffsplit!<CR>
    " nnoremap <silent> <leader>gh :diffget //2<CR>
    " nnoremap <silent> <leader>gl :diffget //3<CR>

  " Options ------------------------------------------------------------------------------
    nnoremap <leader>ow :set wrap!<CR>
    nnoremap <leader>oi :IndentLinesToggle<CR>
    nnoremap <leader>on :LineNumbersToggle<CR>

  " Command ------------------------------------------------------------------------------
    cnoremap <C-J> <Down>
    cnoremap <C-K> <Up>
    cnoremap %% <C-R>=expand('%:h').'/'<CR>

  " Terminal -----------------------------------------------------------------------------
    tnoremap <C-W> <C-\><C-N><C-W>
    tnoremap <C-N> <C-\><C-N>:bn<CR>
    tnoremap <C-P> <C-\><C-N>:bp<CR>
    tnoremap <C-\> <C-\><C-N>
    tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

  " LSP ----------------------------------------------------------------------------------
    fun! s:init_maps_lsp()
      nnoremap <buffer><silent> <C-]> <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <buffer><silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
      nnoremap <buffer><silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
      nnoremap <buffer><silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
      inoremap <buffer><silent> <C-K> <cmd>lua vim.lsp.buf.signature_help()<CR>
      nnoremap <buffer><silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
      nnoremap <buffer><silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
      nnoremap <buffer><silent> gR    <cmd>lua vim.lsp.buf.rename()<CR>
      nnoremap <buffer><silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
      nnoremap <buffer><silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
      nnoremap <buffer><silent> g?    <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
    endfun
