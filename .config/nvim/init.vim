let $VIMDATA = stdpath('data')
let $VIMCACHE = stdpath('cache')
let $VIMCONFIG = stdpath('config')
let $VIMPLUGINS = $VIMDATA.'/plugged'

let mapleader = ' '
aug Vimrc | au! | aug end

if index(['vi', 'view'], v:progname) != -1
  source $VIMCONFIG/minimal.vim
  finish
endif

lua require 'm.global'
source $VIMCONFIG/functions.vim
source $VIMCONFIG/term.vim

let g:bookmarks = [
  \ ['V', '$VIMRUNTIME'],
  \ ['e', '/etc'],
  \ ['p', '$VIMPLUGINS'],
  \ ['v', '$VIMCONFIG'],
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
    Plug 'devinceble/Tortoise-Typing'
    Plug 'tweekmonster/startuptime.vim'

  " Custom -------------------------------------------------------------------------------
    Plug $VIMCONFIG.'/m/qf.vim'
    Plug $VIMCONFIG.'/m/drawer.nvim'
    Plug $VIMCONFIG.'/m/termdebug'

    " Plug '~/dev/vim/bufjump.vim'
    " nno <C-S> :call bufjump#select()<CR>

  call plug#end()
  call PlugCheckMissing()

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

  " LSP ----------------------------------------------------------------------------------
    if !exists('g:disable_lsp')
      let s:compe_lsp = {'source': {
        \ 'path': v:true,
        \ 'calc': v:true,
        \ 'nvim_lsp': v:true,
        \ 'ultisnips': v:true,
        \ }}

      aug Vimrc
        au User LspAttach call compe#setup(s:compe_lsp, 0)
        au User LspAttach call s:init_maps_lsp()
        au User LspAttach source $VIMCONFIG/lsp.vim
        au BufWinEnter * let &l:signcolumn = get(b:, 'lsp_attached', 0) ? 'yes' : 'auto'
      aug end

      " $VIMCONFIG/lua/m/lsp/init.lua
      lua require 'm.lsp'

      com! LspStopClient lua require 'm.lsp.util'.stop_clients()

      " nvim-lightbulb
      aug Vimrc
        au CursorMoved,CursorMovedI * lua require 'nvim-lightbulb'.update_lightbulb()
      aug end
    endif

  " Fern ---------------------------------------------------------------------------------
    let g:loaded_netrw             = 1 " disable netrw
    let g:loaded_netrwPlugin       = 1
    let g:loaded_netrwSettings     = 1
    let g:loaded_netrwFileHandlers = 1
    let g:fern#disable_default_mappings = 1

  " exrc.vim -----------------------------------------------------------------------------
    let g:exrc#names = ['.exrc']
    aug Vimrc
      au BufWritePost .exrc ++nested silent ExrcTrust
      au SourcePost .exrc silent Pro!
    aug end

  " autosplit.vim ------------------------------------------------------------------------
    let g:autosplit_ft = ['man', 'fugitive', 'gitcommit']
    let g:autosplit_bt = ['help']

  " indent-blankline ---------------------------------------------------------------------
    let g:indent_blankline_buftype_exclude = ['help', 'terminal']
    let g:indent_blankline_filetype_exclude = ['man', 'fern', 'floggraph']
    let g:indent_blankline_show_first_indent_level = v:false
    let g:indent_blankline_show_trailing_blankline_indent = v:false
    let g:indent_blankline_char = '¦'
    hi IndentBlanklineChar guifg=#4B5263 gui=nocombine
    hi link IndentBlanklineSpaceChar          IndentBlanklineChar
    hi link IndentBlanklineSpaceCharBlankline IndentBlanklineChar

  " undotree -----------------------------------------------------------------------------
    let g:undotree_DiffAutoOpen = 0
    let g:undotree_WindowLayout = 2
    let g:undotree_HelpLine = 0

  " vimwiki ------------------------------------------------------------------------------
    let g:vimwiki_key_mappings = {'global': 0}
    let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

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
    if index(g:plugs_order, 'vim-bbye') != -1
      com! -nargs=? -bang -complete=buffer Bq
        \ if <q-args> ==# '' && &bt ==# 'terminal' && get(b:, 'bbye_term_closed', 1) == 0
        \ | bd! | else | bd<bang> <args> | endif
      call Cabbrev('bq', 'Bq')
      call Cabbrev('bd', 'Bd')
      call Cabbrev('bw', 'Bw')
    endif

  " Shortcuts ----------------------------------------------------------------------------
    com! Wiki VimwikiIndex
    com! Vimrc edit $MYVIMRC

  " Use fzf for help and buffers ---------------------------------------------------------
    if index(g:plugs_order, 'fzf.vim') != -1
      com! -nargs=? -complete=help H
        \ if <q-args> ==# '' | Helptags | else | h <args> | endif
      com! -nargs=? -bang -complete=buffer B
        \ if <q-args> ==# '' | Buffers | else | b<bang> <args> | endif
      call Cabbrev('h', 'H')
      call Cabbrev('b', 'B')
    endif

  " Toggle mouse -------------------------------------------------------------------------
    com! MouseToggle let &mouse = (&mouse ==# '' ? 'a' : '')

  " Redir --------------------------------------------------------------------------------
    com! -nargs=+ -complete=command Redir call s:Redir(<q-args>)
    fun! s:Redir(cmd)
      new
      put=execute(a:cmd)
      1,2delete
      setl nomodified
      call Autosplit()
    endfun

  " xdg-open -----------------------------------------------------------------------------
    com! -nargs=? -complete=file Open call s:Open(<q-args>)
    fun! s:Open(file)
      let file = a:file ==# '' ? '%' : a:file
      let cmd = 'xdg-open ' . shellescape(expand(file))
      echo cmd
      call system(cmd)
    endfun

  " curl ---------------------------------------------------------------------------------
    com! -nargs=+ Curl call s:Curl(<q-args>)
    fun! s:Curl(url)
      let cmd = 'curl '.shellescape(a:url)
      echo cmd
      new
      exe 'read !'.cmd.' 2>/dev/null'
      0delete
      setl nomodified
      redraw
      call Autosplit()
    endfun

  " Grep populates quickfix, so make it silent -------------------------------------------
    call Cabbrev('gr',   'silent grep')
    call Cabbrev('gre',  'silent grep')
    call Cabbrev('grep', 'silent grep')

  " Some abbreviations -------------------------------------------------------------------
    call Cabbrev('git',  'Git')
    call Cabbrev('rg',   'Rg')
    call Cabbrev('ag',   'Ag')
    call Cabbrev('man',  'Man')
    call Cabbrev('rc',   'Rc')
    call Cabbrev('vifm', 'Vifm')
    call Cabbrev('hr',   'Hr')
    call Cabbrev('fzf',  'Files')
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

  " Highlight yanked text ----------------------------------------------------------------
    au TextYankPost * silent! lua vim.highlight.on_yank()

  " Terminal -----------------------------------------------------------------------------
    au TermOpen * setl nonumber norelativenumber nocursorline

  " Open quickfix window on grep ---------------------------------------------------------
    au QuickFixCmdPost grep,grepadd,vimgrep,helpgrep
      \ call timer_start(10, { -> execute('cwindow') })
    au QuickFixCmdPost lgrep,lgrepadd,lvimgrep,lhelpgrep
      \ call timer_start(10, { -> execute('lwindow') })

  " Auto close quickfix, if it's the last buffer -----------------------------------------
    au WinEnter * if winnr('$') == 1 && &bt ==# 'quickfix' | q! | endif

  " Open directories in fern -------------------------------------------------------------
    au BufEnter * ++nested call s:fern_hijack_directory()
    fun! s:fern_hijack_directory() abort
      let path = expand('%:p')
      if isdirectory(path)
        Bwipeout %
        exe printf('Fern %s', fnameescape(path))
      endif
    endfun

  " Workarounds --------------------------------------------------------------------------
    " Fix wrong size on alacritty on i3 (https://github.com/neovim/neovim/issues/11330)
    au VimEnter * silent exec "!kill -s SIGWINCH $PPID"

  aug end

" KEY MAPPINGS ///////////////////////////////////////////////////////////////////////////
  " Override defaults --------------------------------------------------------------------
    nno 0 ^
    nno ^ 0
    nno Y y$
    nno <expr> j v:count ? 'j' : 'gj'
    xno <expr> j v:count ? 'j' : 'gj'
    nno <expr> k v:count ? 'k' : 'gk'
    xno <expr> k v:count ? 'k' : 'gk'
    nno <expr> gj v:count ? 'gj' : 'j'
    xno <expr> gj v:count ? 'gj' : 'j'
    nno <expr> gk v:count ? 'gk' : 'k'
    xno <expr> gk v:count ? 'gk' : 'k'
    nno gV `[v`]
    xno < <gv
    xno > >gv
    nno S i<CR><ESC>k:sil! keepp s/\v +$//<CR>:noh<CR>j^
    nno q: :
    no Q <Nop>

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
    nno <silent><expr> <leader>f (len(system('git rev-parse')) ? ':Files'
      \ : ':GFiles --exclude-standard --others --cached')."\<CR>"
    nno <silent><expr> <leader>F ':Files '.BufDirectory()."\<CR>"
    nno <silent> ', :call Menu('Files', g:bookmarks)<CR>
    nno '; :Files<Space>
    nno <leader>h :History<CR>
    nno <leader>b :Buffers<CR>

    nno <silent><expr> - ':Fern '.(expand('%') ==# '' ? '.' : '%:h -reveal=%:t')."\<CR>"
    nno <silent> _ :Fern . -drawer -toggle -reveal=%<CR>
    nno <silent> g- :Fern . -drawer -reveal=%<CR>

  " Search and Replace -------------------------------------------------------------------
    nno <leader>/ :Lines<CR>
    nno <leader>? :BLines<CR>
    nno <leader>s :%s/
    xno <leader>s :s/
    nmap <leader>S :%S/
    xmap <leader>S :S/
    nmap <leader>c z*cgn
    xmap <leader>c z*cgn
    map *   <Plug>(asterisk-*)
    map g*  <Plug>(asterisk-g*)
    map #   <Plug>(asterisk-#)
    map g#  <Plug>(asterisk-g#)
    map z*  <Plug>(asterisk-z*)
    map gz* <Plug>(asterisk-gz*)
    map z#  <Plug>(asterisk-z#)
    map gz# <Plug>(asterisk-gz#)
    nno <silent> <leader><CR> :let @/ = ''<CR>

  " Macros -------------------------------------------------------------------------------
    no <expr> q reg_recording() is# '' ? '\<Nop>' : 'q'
    nno <leader>q q

  " Quickfix -----------------------------------------------------------------------------
    nno <silent> qq :call qf#open()<CR>
    nno <silent> qg :call qf#toggle()<CR>
    nno <silent> qo :call qf#show()<CR>
    nno <silent> qc :cclose<CR>

    nno <silent> [q :cprev<CR>
    nno <silent> ]q :cnext<CR>
    nno <silent> [Q :cfirst<CR>
    nno <silent> ]Q :clast<CR>
    nno <silent> [l :lprev<CR>
    nno <silent> ]l :lnext<CR>
    nno <silent> [L :lfirst<CR>
    nno <silent> ]L :llast<CR>

  " Misc ---------------------------------------------------------------------------------
    xno <leader>t :Tabularize /
    xno <leader>n :norm!<Space>
    nno <leader>v ggVG

  " Registers ----------------------------------------------------------------------------
    xno zp  pgvy
    xno zgp pgvy`]<Space>
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

  " Options ------------------------------------------------------------------------------
    nno <leader>ow :set wrap!<CR>
    nno <leader>oi :IndentBlanklineToggle<CR>
    nno <leader>on :LineNumbersToggle<CR>
    nno <leader>oc :ColorizerToggle<CR>
    nno <leader>om :MouseToggle<CR>
    nno <leader>os :set ignorecase!<CR>
    nno <silent> <leader>r :call fzf#run(fzf#wrap({'source': pro#configs(), 'sink': 'Pro'}))<CR>

  " Command ------------------------------------------------------------------------------
    cno <C-J> <Down>
    cno <C-K> <Up>
    cno <C-A> <Home>
    cno <C-B> <C-Left>
    cno <expr><C-F> getcmdline() !=# '' ? '<C-Right>' : '<C-F>'
    cno <C-R><C-D> <C-R>=BufDirectory()<CR>
    cno <C-X><C-A> <C-A>
    cno <C-R><C-K> <C-K>

  " Insert -------------------------------------------------------------------------------
    " Emacs
    ino <C-A> <Home>
    ino <C-E> <End>
    " TODO: shift/ctrl left/right suck, reimplement to work just like on the commandline
    ino <C-B> <S-Left>
    ino <C-F> <S-Right>

    " Completion
    ino <silent><expr> <C-X><C-X> compe#complete()
    ino <silent><expr> <CR>       compe#confirm('<CR>')
    ino <silent><expr> <C-E>      compe#close('<End>')

    " Snippets
    ino <C-G>o     ()<C-G>U<Left>
    ino <C-G><C-O> ()<C-G>U<Left>
    ino <C-G>b     {<CR>}<Esc>O
    ino <C-G><C-B> {<CR>}<Esc>O

  " LSP ----------------------------------------------------------------------------------
    fun! s:init_maps_lsp()
      nno <buffer><silent> <C-]> <cmd>lua vim.lsp.buf.definition()<CR>
      nno <buffer><silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
      nno <buffer><silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
      nno <buffer><silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
      ino <buffer><silent> <C-K> <cmd>lua vim.lsp.buf.signature_help()<CR>
      nno <buffer><silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
      nno <buffer><silent> g]    <cmd>lua vim.lsp.buf.references()<CR>
      " nno <buffer><silent> g]    <cmd>LspTroubleOpen lsp_references<CR>
      nno <buffer><silent> gR    <cmd>lua vim.lsp.buf.rename()<CR>
      nno <buffer><silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
      nno <buffer><silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
      nno <buffer><silent> g?    <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
      nno <buffer><silent> [d    <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
      nno <buffer><silent> ]d    <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
      nno <buffer><silent> [D    <cmd>lua vim.lsp.diagnostic.goto_next({cursor_position={0,0}})<CR>
      nno <buffer><silent> ]D    <cmd>lua vim.lsp.diagnostic.goto_prev({cursor_position={0,0}})<CR>

      " nno <buffer><silent> gww   <cmd>lua vim.lsp.buf.formatting()<CR>
      " nno <buffer><silent> gqq   <cmd>lua vim.lsp.buf.formatting()<CR>
      " xno <buffer><silent> gw    <cmd>lua vim.lsp.buf.range_formatting()<CR>
      " xno <buffer><silent> gq    <cmd>lua vim.lsp.buf.range_formatting()<CR>

      nno <buffer><silent> <leader>lS :LspStopClient<CR>
      nno <buffer><silent> <leader>ls :LspFind<CR>
      nno <buffer><silent> <leader>lf :LspFormat<CR>
      xno <buffer><silent> <leader>lf :LspFormat<CR>
      nno <buffer><silent> <leader>la :LspAction<CR>
      " nno <buffer><silent> <leader>ld :LspDiagnostics<CR>
    endfun
    nno <silent> <leader>ld :LspTroubleToggle<CR>

" vim:tw=90:ts=2:sts=2:sw=2:et:
