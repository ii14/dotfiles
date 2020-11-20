let mapleader      = ' '
let maplocalleader = ' '
" filetype plugin on
" syntax on
set textwidth=90
set termguicolors

if !has('nvim') | let g:disable_lsp = 1 | endif

let g:disable_deoplete = 1
let g:deoplete_lazy_load = 1

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
    Plug 'junegunn/vim-peekaboo'
    " Plug 'bkad/CamelCaseMotion'

  " Visual -------------------------------------------------------------------------------
    Plug 'joshdick/onedark.vim'
    Plug 'edersonferreira/dalton-vim'
    Plug 'itchyny/lightline.vim'
    Plug 'mengelbrecht/lightline-bufferline'

    Plug 'Yggdroot/indentLine'
    Plug 'unblevable/quick-scope'

  " File management ----------------------------------------------------------------------
    Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
    Plug 'junegunn/fzf.vim'
    Plug 'lambdalisue/fern.vim', {'on': 'Fern'}
    Plug 'antoinemadec/FixCursorHold.nvim' " required by fern.vim

  " Autocompletion -----------------------------------------------------------------------
    if !exists('g:disable_lsp')
      Plug 'neovim/nvim-lspconfig'
    endif
    if !exists('g:disable_deoplete')
      Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
      Plug 'Shougo/neco-syntax'
      if !exists('g:disable_lsp')
        Plug 'Shougo/deoplete-lsp'
      endif
    else
      Plug 'nvim-lua/completion-nvim'
      " Plug 'steelsojka/completion-buffers' " slows down startup on large files
    endif

  " Development --------------------------------------------------------------------------
    Plug 'tpope/vim-fugitive'
    Plug 'rbong/vim-flog'
    Plug 'ii14/vim-dispatch'
    Plug 'cdelledonne/vim-cmake'
    Plug 'SirVer/ultisnips'

  " Syntax -------------------------------------------------------------------------------
    Plug 'sheerun/vim-polyglot'
    Plug 'fedorenchik/qt-support.vim'
    Plug 'PotatoesMaster/i3-vim-syntax'
    Plug 'norcalli/nvim-colorizer.lua'
    if !exists('g:disable_lsp')
      Plug 'jackguo380/vim-lsp-cxx-highlight'
    endif

  " Misc ---------------------------------------------------------------------------------
    Plug 'vimwiki/vimwiki'
    Plug 'metakirby5/codi.vim', {'on': 'Codi'}

    Plug '~/.config/nvim/qf.vim'

call plug#end()

let s:missing_plugs = len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
if s:missing_plugs
  let count_text = s:missing_plugs == 1
    \ ? '1 plugin is missing'
    \ : s:missing_plugs.' plugins are missing'
  let res = input(count_text.'. Install? [y/n]: ')
  if res ==? 'y' || res ==? 'yes'
    PlugInstall
  endif
endif

" PLUGIN SETTINGS ////////////////////////////////////////////////////////////////////////
  " Theme --------------------------------------------------------------------------------
    source ~/.config/nvim/theme.vim

  " fzf ----------------------------------------------------------------------------------
    let $FZF_DEFAULT_OPTS =
      \ '--bind=ctrl-a:select-all,ctrl-u:page-up,ctrl-d:page-down,ctrl-space:toggle'
    let g:fzf_action = {'ctrl-s': 'split', 'ctrl-v': 'vsplit'}
    " let g:fzf_layout = {'down': '40%'}
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
    if !exists('g:disable_deoplete')
      if !exists('g:deoplete_lazy_load ')
        let g:deoplete#enable_at_startup = 1
      else
        let g:deoplete#enable_at_startup = 0
        aug Vimrc
          au InsertEnter * call deoplete#enable()
        aug end
      endif
    endif

  " completion-nvim ----------------------------------------------------------------------
    if exists('g:disable_deoplete')
      let g:completion_enable_auto_signature = 0
      let g:completion_trigger_on_delete = 1
      let g:completion_auto_change_source = 1
      let g:completion_matching_ignore_case = 1
      let g:completion_matching_strategy_list = ['exact', 'fuzzy', 'substring']
      let g:completion_enable_snippet = 'UltiSnips'
      let g:completion_chain_complete_list = {'default': [
        \   {'complete_items': ['path'], 'triggered_only': ['/']},
        \   {'complete_items': ['path', 'buffers']},
        \ ]}

      " imap <C-J> <Plug>(completion_next_source)
      " imap <C-K> <Plug>(completion_prev_source)

      aug Vimrc
        au BufEnter * lua require('lsp/completion').on_attach()
      aug end
    endif

  " nvim-lsp -----------------------------------------------------------------------------
    if !exists('g:disable_lsp')
      " called when lsp is attached to the current buffer
      if exists('g:disable_deoplete')
        fun! VimrcLspOnAttach()
          call s:init_maps_lsp()
          lua require('lsp/completion').on_attach_lsp()
          setl omnifunc=v:lua.vim.lsp.omnifunc
        endfun
      else
        fun! VimrcLspOnAttach()
          call s:init_maps_lsp()
          call deoplete#custom#buffer_option('sources', ['lsp'])
          setl omnifunc=v:lua.vim.lsp.omnifunc
        endfun
      endif

      " ~/.config/nvim/lua/lsp/init.lua
      lua require('lsp/init')
    endif

  " Fern ---------------------------------------------------------------------------------
    let g:loaded_netrw             = 1 " disable netrw
    let g:loaded_netrwPlugin       = 1
    let g:loaded_netrwSettings     = 1
    let g:loaded_netrwFileHandlers = 1
    let g:fern#disable_default_mappings = 1

  " Dispatch -----------------------------------------------------------------------------
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

  " peekaboo -----------------------------------------------------------------------------
    let g:peekaboo_window = 'vert bo 50 new'
    let g:peekaboo_compact = 0
    let g:peekaboo_delay = 500

  " vimwiki ------------------------------------------------------------------------------
    let g:vimwiki_key_mappings = {'global': 0}

" SETTINGS ///////////////////////////////////////////////////////////////////////////////
  " Visual -------------------------------------------------------------------------------
    set laststatus=2                          " show status line
    set number relativenumber                 " line numbers
    set colorcolumn=+1                        " text width ruler
    set lazyredraw                            " don't redraw while executing macros
    set title                                 " set vim window title
    " set notitle                               " nvim bug, crashes on :Helptags command
    set belloff=all                           " turn off bell
    set shortmess+=I                          " no intro message
    set noshowmode                            " redundant mode message
    set list                                  " show non-printable characters
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
    set synmaxcol=1000                        " highlight only the first 1000 columns
    if has('nvim-0.4') | set pumblend=17 | endif

  " Editing ------------------------------------------------------------------------------
    set encoding=utf-8
    set history=1000                          " command history size
    set backspace=indent,eol,start            " allow backspace over...
    set virtualedit=block                     " move cursor anywhere in visual block mode
    set scrolloff=1                           " keep near lines visible when scrolling
    " set confirm                               " display dialog instead of failing
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
    set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
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
    " set autochdir                             " change cwd to the current buffer

  " Grep ---------------------------------------------------------------------------------
    if executable('rg')
      set grepformat=%f:%l:%m
      let &grepprg = 'rg --vimgrep' . (&smartcase ? ' --smart-case' : '')
    elseif executable('ag')
      set grepformat=%f:%l:%m
      let &grepprg = 'ag --vimgrep' . (&smartcase ? ' --smart-case' : '')
    endif

  " Projects -----------------------------------------------------------------------------
    set exrc                                  " project specific vimrc
    set secure                                " dont allow au, shell and write in exrc

" COMMANDS ///////////////////////////////////////////////////////////////////////////////
  " Set tab width ------------------------------------------------------------------------
    com! -nargs=1 T setl ts=<args> sts=<args> sw=<args>

  " Go to the current buffer directory ---------------------------------------------------
    com! D cd %:h

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

  " Toggle mouse -------------------------------------------------------------------------
    com! MouseToggle if &mouse ==# '' | set mouse=a | else | set mouse= | endif

  " Makeprg prompt -----------------------------------------------------------------------
    com! Makeprg call <SID>Makeprg()
    fun! <SID>Makeprg()
      let x = input('makeprg=', &makeprg)
      redraw
      if x !=# ''
        let &makeprg = x
        echo x
      endif
    endfun

  " LSP ----------------------------------------------------------------------------------
    if !exists('g:disable_lsp')
      com! LspStop
        \ lua require('lsp/util').stop_clients()

      com! -nargs=? LspFind
        \ exe 'lua vim.lsp.buf.workspace_symbol('
        \ . (<q-args> == '' ? '' : "'".<q-args>."'") . ')'

      com! -range=0 LspFormat
        \ exe 'lua vim.lsp.buf.' . (<count> ? 'range_formatting()' : 'formatting()')

      com! LspAction
        \ lua vim.lsp.buf.code_action()
    endif

  " Fill the rest of line with specified character ---------------------------------------
    com! -nargs=? Fill call <SID>Fill(<q-args>)
    fun! <SID>Fill(char)
      if strlen(a:char) > 1
        echom 'expected zero or one character'
        return
      endif
      let fill = a:char ==# '' ? '-' : a:char[0]
      norm! $
      let ch = getline('.')[col('.') - 1]
      if ch !=# fill && ch !=# ' '
        exe 'norm! a '
      endif
      let w = &tw - col('.')
      if w > 0
        exe 'norm! '.w.'A'.fill
      endif
    endfun

  " Abbreviations ------------------------------------------------------------------------
    fun! Cabbrev(lhs, rhs)
      exe "cnoreabbrev <expr> " . a:lhs .
        \ " (getcmdtype() ==# ':' && getcmdline() ==# '" . a:lhs .
        \ "') ? '" . a:rhs . "' : '" . a:lhs . "'"
    endfun

    call Cabbrev('h',         'H')
    call Cabbrev('git',       'Git')
    call Cabbrev('rg',        'Rg')
    call Cabbrev('ag',        'Ag')
    call Cabbrev('gr',        'silent grep')
    call Cabbrev('gre',       'silent grep')
    call Cabbrev('grep',      'silent grep')

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
    au FileType yaml,ruby,lua setl ts=2 sts=2 sw=2

  " make autowrite -----------------------------------------------------------------------
    au QuickFixCmdPre make update

  " Autocompile --------------------------------------------------------------------------
    au BufWritePost *.ts,*.scss silent make

  " Open quickfix window on grep ---------------------------------------------------------
    au QuickFixCmdPost grep call timer_start(10, { -> execute('cwindow') })
    au QuickFixCmdPost lgrep call timer_start(10, { -> execute('lwindow') })

  " Auto close quickfix, if it's the last buffer -----------------------------------------
    au WinEnter * if winnr('$') == 1 && &bt ==? "quickfix" | q | endif

  " Open directories in fern -------------------------------------------------------------
    au BufEnter * ++nested call s:fern_hijack_directory()
    fun! s:fern_hijack_directory() abort
      let path = expand('%:p')
      if !isdirectory(path) | return | endif
      bwipeout %
      exe printf('Fern %s', fnameescape(path))
    endfun

  " Open help in vertical split, if there is enough space --------------------------------
    au WinNew * au BufEnter * ++once call <SID>NewSplit()
    fun! <SID>NewSplit()
      if (&bt ==# 'help' || &ft ==# 'man' || &ft ==# 'fugitive' || &ft ==# 'gitcommit')
        let b = bufnr()
        let p = winnr('#')
        let v = winwidth(p) >= getwinvar(p, '&tw', 80) + getwinvar(winnr(), '&tw', 80)
        wincmd J
        wincmd p
        if v | vsplit | else | split | endif
        exe b.'b'
        exe winnr('50j').'wincmd q'
      endif
    endfun

aug end

" KEY MAPPINGS ///////////////////////////////////////////////////////////////////////////
  " Override defaults --------------------------------------------------------------------
    nno 0 ^
    nno ^ 0
    nno Y y$
    nno j gj
    vno j gj
    nno k gk
    vno k gk
    vno . :norm .<CR>
    nno gV `[v`]
    nno S i<CR><ESC>^mwgk:silent! s/\v +$//<CR>:noh<CR>`w
    nno <C-E> 3<C-E>
    nno <C-Y> 3<C-Y>
    no Q <Nop>
    nno q: :

  " Windows ------------------------------------------------------------------------------
    nno <C-H> <C-W>h
    nno <C-J> <C-W>j
    nno <C-K> <C-W>k
    nno <C-L> <C-W>l
    nno <leader>w <C-W>

  " Buffers ------------------------------------------------------------------------------
    nno <silent> <C-N> :bn<CR>
    nno <silent> <C-P> :bp<CR>
    nno <leader>d :Bdelete<CR>
    nno <leader>D :Bdelete!<CR>
    nno <leader>b :Buffers<CR>

  " Files --------------------------------------------------------------------------------
    fun! <SID>FILES()
      return (len(system('git rev-parse'))
        \ ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<CR>"
    endfun
    nno <silent><expr> <leader>f <SID>FILES()
    nno <leader>F :Files <C-R>=expand('%:h')<CR><CR>
    nno <leader>h :History<CR>
    nno <silent> - :Fern %:h -reveal=%<CR>
    nno <silent> _ :Fern . -drawer -toggle -reveal=%<CR>
    nno <silent> g- :Fern . -drawer -reveal=%<CR>

  " Search and Replace -------------------------------------------------------------------
    nno <leader>/ :Lines<CR>
    nno <leader>? :BLines<CR>
    nno <leader>s :%s//g<Left><Left>
    vno <leader>s :s//g<Left><Left>
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

  " Macros -------------------------------------------------------------------------------
    no q <Nop>
    no <expr> q reg_recording() is# '' ? '\<Nop>' : 'q'
    nno <leader>q q

  " Quickfix -----------------------------------------------------------------------------
    nno <silent> qq :call qf#open()<CR>
    nno <silent> qo :call qf#show()<CR>
    nno <silent> qg :call qf#toggle()<CR>
    nno <silent> qd :cclose<CR>

    nno <silent> qn :cnext<CR>
    nno <silent> qp :cprevious<CR>
    nno <silent> ql :clast<CR>
    nno <silent> qf :cfirst<CR>
    nno <silent> qc :cc<CR>

  " Misc ---------------------------------------------------------------------------------
    vno <leader>t :Tabularize /
    vno <leader>n :norm!<Space>
    nno <leader>v ggVG

  " Clipboard ----------------------------------------------------------------------------
    nno <leader>p "+p
    vno <leader>p "+p
    nno <leader>P "+P
    vno <leader>P "+P
    nno <leader>y "+y
    vno <leader>y "+y
    nno <leader>Y "+y$

  " Make ---------------------------------------------------------------------------------
    nno m<CR>    :up<CR>:Make<CR>
    nno m<Space> :up<CR>:Make<Space>
    nno m!       :up<CR>:Make!<CR>

  " Git ----------------------------------------------------------------------------------
    nno <leader>gs :Git<CR>
    nno <leader>gl :Flog<CR>
    nno <leader>gb :Git blame<CR>
    nno <leader>ga :Gwrite<CR>
    nno <leader>gd :Gvdiffsplit!<CR>
    nno <leader>g2 :diffget //2<CR>
    nno <leader>g3 :diffget //3<CR>

  " Options ------------------------------------------------------------------------------
    nno <leader>ow :set wrap!<CR>
    nno <leader>oi :IndentLinesToggle<CR>
    nno <leader>on :LineNumbersToggle<CR>
    nno <leader>oc :ColorizerToggle<CR>
    nno <leader>om :MouseToggle<CR>

  " Command ------------------------------------------------------------------------------
    cno <C-J> <Down>
    cno <C-K> <Up>
    cno %% <C-R>=expand('%:h').'/'<CR>

  " LSP ----------------------------------------------------------------------------------
    fun! s:init_maps_lsp()
      nno <buffer><silent> <C-]> <cmd>lua vim.lsp.buf.definition()<CR>
      nno <buffer><silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
      nno <buffer><silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
      nno <buffer><silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
      ino <buffer><silent> <C-K> <cmd>lua vim.lsp.buf.signature_help()<CR>
      nno <buffer><silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
      nno <buffer><silent> g]    <cmd>lua vim.lsp.buf.references()<CR>
      nno <buffer><silent> gR    <cmd>lua vim.lsp.buf.rename()<CR>
      nno <buffer><silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
      nno <buffer><silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
      nno <buffer><silent> g?    <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>

      " nno <buffer><silent> gww   <cmd>lua vim.lsp.buf.formatting()<CR>
      " nno <buffer><silent> gqq   <cmd>lua vim.lsp.buf.formatting()<CR>
      " vno <buffer><silent> gw    <cmd>lua vim.lsp.buf.range_formatting()<CR>
      " vno <buffer><silent> gq    <cmd>lua vim.lsp.buf.range_formatting()<CR>

      nno <buffer><silent> <leader>ls :LspFind<CR>
      nno <buffer><silent> <leader>lf :LspFormat<CR>
      vno <buffer><silent> <leader>lf :LspFormat<CR>
      nno <buffer><silent> <leader>la :LspAction<CR>
    endfun

