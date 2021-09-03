let $VIMDATA = stdpath('data')
let $VIMCACHE = stdpath('cache')
let $VIMCONFIG = stdpath('config')
let $VIMPLUGINS = $VIMDATA.'/plugged'

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
        au CursorMoved,CursorMovedI * lua require 'nvim-lightbulb'.update_lightbulb()
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
    hi link FernRootText     String
    hi link FernRootSymbol   String
    hi link FernMarkedLine   WarningMsg
    hi link FernMarkedText   WarningMsg
    hi link FernLeafSymbol   LineNr
    hi link FernBranchSymbol Comment
    aug Vimrc
      au BufEnter * ++nested call m#fern_hijack_directory()
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
    set scrolloff=1 sidescrolloff=3           " keep near lines visible when scrolling
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
    if executable('rg')
      set grepformat=%f:%l:%c:%m
      let &grepprg = 'rg --vimgrep' . (&smartcase ? ' --smart-case' : '')
    elseif executable('ag')
      set grepformat=%f:%l:%c:%m
      let &grepprg = 'ag --vimgrep' . (&smartcase ? ' --smart-case' : '')
    endif

" COMMANDS ///////////////////////////////////////////////////////////////////////////////
  " See $VIMCONFIG/plugin for more command definitions

  " :bd doesn't close window, :bq closes the window --------------------------------------
    com! -nargs=? -bang -complete=buffer Bq
      \ if <q-args> ==# '' && &bt ==# 'terminal' && get(b:, 'bbye_term_closed', 1) == 0
      \ | bd! | else | bd<bang> <args> | endif
    call Cabbrev('bq', 'Bq')
    call Cabbrev('bd', 'Bd')
    call Cabbrev('bw', 'Bw')

  " Shortcuts ----------------------------------------------------------------------------
    com! Wiki VimwikiIndex
    com! Vimrc edit $MYVIMRC

  " Use fzf for help and buffers ---------------------------------------------------------
    com! -nargs=? -complete=help H
      \ if <q-args> ==# '' | Helptags | else | h <args> | endif
    com! -nargs=? -bang -complete=buffer B
      \ if <q-args> ==# '' | Buffers | else | b<bang> <args> | endif
    call Cabbrev('h', 'H')
    call Cabbrev('b', 'B')

  " Grep populates quickfix, so make it silent -------------------------------------------
    call Cabbrev('gr',   'silent grep')
    call Cabbrev('gre',  'silent grep')
    call Cabbrev('grep', 'silent grep')

  " Some abbreviations -------------------------------------------------------------------
    call Cabbrev('git',  'Git')
    call Cabbrev('rg',   'Rg')
    call Cabbrev('man',  'Man')
    call Cabbrev('rc',   'Rc')
    call Cabbrev('hr',   'Hr')
    call Cabbrev('trim', 'Trim')
    call Cabbrev('fzf',  'Files')
    call Cabbrev('fern', 'Fern')
    call Cabbrev('vifm', 'Vifm')
    call Cabbrev('vres', 'vert res')

" AUTOCOMMANDS ///////////////////////////////////////////////////////////////////////////
  aug Vimrc

  " Return to last edit position ---------------------------------------------------------
    au BufReadPost *
      \ if &ft !=# 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

  " Cursor line highlighting -------------------------------------------------------------
    au VimEnter,WinEnter,BufWinEnter * if &bt !=# 'terminal' | setl cursorline | endif
    au WinLeave,TermEnter * if &bt !=# 'terminal' | setl nocursorline | endif

  " Terminal -----------------------------------------------------------------------------
    au TermOpen * setl nonumber norelativenumber nocursorline

  " Highlight yanked text ----------------------------------------------------------------
    au TextYankPost * silent! lua vim.highlight.on_yank()

  " Open quickfix window on grep ---------------------------------------------------------
    au QuickFixCmdPost grep,grepadd,vimgrep,helpgrep
      \ call timer_start(10, { -> execute('cwindow') })
    au QuickFixCmdPost lgrep,lgrepadd,lvimgrep,lhelpgrep
      \ call timer_start(10, { -> execute('lwindow') })

  " Auto close quickfix, if it's the last buffer -----------------------------------------
    au WinEnter * if winnr('$') == 1 && &bt ==# 'quickfix' | q! | endif

  " Workarounds --------------------------------------------------------------------------
    " Fix wrong size on alacritty on i3 (https://github.com/neovim/neovim/issues/11330)
    au VimEnter * silent exec "!kill -s SIGWINCH $PPID"

  aug end

" KEY MAPPINGS ///////////////////////////////////////////////////////////////////////////
  " Override defaults --------------------------------------------------------------------
    nno 0 ^
    nno ^ 0
    " Yank to the end of the line
    nno Y y$
    " Reverse {j,k} and {gj,gk}, unless count is given
    nno <expr> j v:count ? 'j' : 'gj'
    xno <expr> j v:count ? 'j' : 'gj'
    nno <expr> k v:count ? 'k' : 'gk'
    xno <expr> k v:count ? 'k' : 'gk'
    nno <expr> gj v:count ? 'gj' : 'j'
    xno <expr> gj v:count ? 'gj' : 'j'
    nno <expr> gk v:count ? 'gk' : 'k'
    xno <expr> gk v:count ? 'gk' : 'k'
    " Select last yanked or modified text
    nno gV `[v`]
    " Don't leave visual mode when changing indentation
    xno < <gv
    xno > >gv
    " Split line, opposite of J
    nno S i<CR><ESC>k:sil! keepp s/\v +$//<CR>:noh<CR>j^
    nno q: :
    nno Q <Nop>

  " Windows ------------------------------------------------------------------------------
    nno <C-H> <C-W>h
    nno <C-J> <C-W>j
    nno <C-K> <C-W>k
    nno <C-L> <C-W>l
    nno <leader>w <C-W>

  " Buffers ------------------------------------------------------------------------------
    nno <silent> <C-N> :bn<CR>
    nno <silent> <C-P> :bp<CR>

  " Files --------------------------------------------------------------------------------
    " fzf
    nno <silent><expr> <leader>f (len(system('git rev-parse')) ? ':Files'
      \ : ':GFiles --exclude-standard --others --cached')."\<CR>"
    nno <silent><expr> <leader>F ':Files '.m#bufdir()."\<CR>"
    nno '; :call m#menu('Files', g:bookmarks)<CR>
    nno <leader>h :History<CR>
    nno <leader><leader> :Buffers<CR>
    " Fern
    nno <silent><expr> - ':Fern '.(expand('%') ==# '' ? '.' : '%:h -reveal=%:t')."\<CR>"
    nno <silent> _ :Fern . -drawer -toggle -reveal=%<CR>
    nno <silent> g- :Fern . -drawer -reveal=%<CR>

  " Search and Replace -------------------------------------------------------------------
    nno n nzz
    nno N Nzz
    map *   <Plug>(asterisk-*)
    map g*  <Plug>(asterisk-g*)
    map #   <Plug>(asterisk-#)
    map g#  <Plug>(asterisk-g#)
    map z*  <Plug>(asterisk-z*)
    map gz* <Plug>(asterisk-gz*)
    map z#  <Plug>(asterisk-z#)
    map gz# <Plug>(asterisk-gz#)
    nmap <leader>c z*cgn
    xmap <leader>c z*cgn
    nno <silent> <leader><CR> :let @/ = ''<CR>

  " Macros -------------------------------------------------------------------------------
    no <expr> q reg_recording() is# '' ? '\<Nop>' : 'q'
    nno <leader>q q

  " Quickfix -----------------------------------------------------------------------------
    nno <silent> qq :call qf#open()<CR>
    nno <silent> qg :call qf#toggle()<CR>
    nno <silent> qo :call qf#show()<CR>
    nno <silent> qc :cclose<CR>
    " Unimpaired mappings
    nno <silent> [q :cprev<CR>
    nno <silent> ]q :cnext<CR>
    nno <silent> [Q :cfirst<CR>
    nno <silent> ]Q :clast<CR>
    nno <silent> [l :lprev<CR>
    nno <silent> ]l :lnext<CR>
    nno <silent> [L :lfirst<CR>
    nno <silent> ]L :llast<CR>

  " Registers ----------------------------------------------------------------------------
    " Paste and keep register in visual mode
    xno zp  pgvy
    xno zgp pgvy`]<Space>
    " System clipboard
    nno <leader>y  "+y
    nno <leader>Y  "+y$
    nno <leader>p  "+p
    nno <leader>P  "+P
    nno <leader>gp "+gp
    nno <leader>gP "+gP
    xno <leader>y  "+y
    xno <leader>p  "+p
    xno <leader>P  "+P
    xno <leader>gp "+gp
    xno <leader>gP "+gP

  " Make ---------------------------------------------------------------------------------
    nno m<CR>    :up<CR>:Make<CR>
    nno m<Space> :up<CR>:Make<Space>
    nno m!       :up<CR>:Make!<CR>
    nno m=       :Set makeprg<CR>

  " Git ----------------------------------------------------------------------------------
    nno <leader>gs :Git<CR>
    nno <leader>gl :Flog<CR>
    nno <leader>gb :Git blame<CR>
    nno <leader>ga :Gwrite<CR>
    nno <leader>gd :Gvdiffsplit!<CR>
    nno <leader>g2 :diffget //2<CR>
    nno <leader>g3 :diffget //3<CR>

  " Misc ---------------------------------------------------------------------------------
    nno <silent> <leader>r :call fzf#run(fzf#wrap({'source': pro#configs(), 'sink': 'Pro'}))<CR>
    xno <leader>t :Tabularize /
    nno <leader>v ggVG

  " LSP ----------------------------------------------------------------------------------
    " LSP buffer local mappings in $VIMCONFIG/lsp.vim
    nno <silent> <leader>ld :LspTroubleToggle<CR>

  " Termdebug ----------------------------------------------------------------------------
    nno <leader>dr :Run<CR>
    nno <leader>dS :Stop<CR>
    nno <leader>ds :Step<CR>
    nno <leader>do :Over<CR>
    nno <leader>df :Finish<CR>
    nno <leader>dc :Continue<CR>
    nno <leader>db :Break<CR>
    nno <leader>dB :Clear<CR>
    nno <leader>de :Eval<CR>

  " Insert -------------------------------------------------------------------------------
    " Emacs
    ino <C-A> <Home>
    ino <C-E> <End>
    ino <C-F> <cmd>call m#bf#iforward()<CR>
    ino <C-B> <cmd>call m#bf#ibackward()<CR>
    " Complete i_CTRL-G_{H,J,K,L} mappings
    ino <C-G>h     <Left>
    ino <C-G><C-H> <Left>
    ino <C-G>l     <Right>
    ino <C-G><C-L> <Right>
    " Completion
    ino <expr> <C-X><C-X> compe#complete()
    ino <expr> <CR>       compe#confirm('<CR>')
    ino <expr> <C-Y>      compe#confirm('<C-Y>')
    ino <expr> <C-E>      compe#close('<End>')
    " Snippets
    imap <C-G>o     ()<C-G>U<Left>
    imap <C-G><C-O> ()<C-G>U<Left>
    imap <C-G>b     {<CR>}<Esc>O
    imap <C-G><C-B> {<CR>}<Esc>O
    imap <C-G>a     <><C-G>U<Left>
    imap <C-G><C-A> <><C-G>U<Left>
    imap <C-G>i     ""<C-G>U<Left>
    imap <C-G><C-I> ""<C-G>U<Left>

  " Command ------------------------------------------------------------------------------
    cno <expr> <C-P> wildmenumode() ? '<C-P>' : '<Up>'
    cno <expr> <C-N> wildmenumode() ? '<C-N>' : '<Down>'
    cno <expr> <C-K> wildmenumode() ? '<C-P>' : '<Up>'
    cno <expr> <C-J> wildmenumode() ? '<C-N>' : '<Down>'
    " Emacs
    cno <C-A> <Home>
    cno <expr> <C-F> getcmdline() !=# '' ? '<C-R>=m#bf#cforward()<CR>' : '<C-F>'
    cno <C-B> <C-R>=m#bf#cbackward()<CR>
    " Insert stuff
    cno <C-R><C-D> <C-R>=m#bufdir()<CR>
    cno <C-R><C-K> <C-K>
    cno <C-X><C-A> <C-A>
    " Remap c_CTRL-{G,T} to free up CTRL-G mapping
    cno <C-G>n     <C-G>
    cno <C-G><C-N> <C-G>
    cno <C-G>p     <C-T>
    cno <C-G><C-P> <C-T>
    " Move one character left and right, consistent with insert mode
    cno <C-G>h     <Left>
    cno <C-G><C-H> <Left>
    cno <C-G>l     <Right>
    cno <C-G><C-L> <Right>
    " Snippets
    cmap <C-G>o     ()<Left>
    cmap <C-G><C-O> ()<Left>
    cmap <C-G>b     {}<Left>
    cmap <C-G><C-B> {}<Left>
    cmap <C-G>a     <><Left>
    cmap <C-G><C-A> <><Left>
    cmap <C-G>i     ""<Left>
    cmap <C-G><C-I> ""<Left>

  " Options ------------------------------------------------------------------------------
    nno <leader>ow :set wrap!<bar>set wrap?<CR>
    nno <leader>oW :set wrapscan!<bar>set wrapscan?<CR>
    nno <leader>os :set ignorecase!<bar>set ignorecase?<CR>
    nno <leader>om :let &mouse = (&mouse ==# '' ? 'a' : '')<bar>set mouse?<CR>
    nno <leader>oi :IndentBlanklineToggle<CR>
    nno <leader>on :LineNumbersToggle<CR>
    nno <leader>oc :ColorizerToggle<CR>

" vim:tw=90:ts=2:sts=2:sw=2:et:
