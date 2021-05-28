let $VIMDATA = stdpath('data')
let $VIMCACHE = stdpath('cache')
let $VIMCONFIG = stdpath('config')
let $VIMPLUGINS = $VIMDATA.'/plugged'

if v:progname ==# 'vi'
  source $VIMCONFIG/minimal.vim
  finish
endif

" let g:disable_lsp = 1
let g:disable_dap = 1
let g:disable_ts = 1

let mapleader = ' '
aug Vimrc | au! | aug end
lua require 'm.global'
lua require 'm.fold'
source $VIMCONFIG/functions.vim
source $VIMCONFIG/term.vim

" PLUGINS ////////////////////////////////////////////////////////////////////////////////
  call plug#begin($VIMPLUGINS)

  " Editing ------------------------------------------------------------------------------
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-abolish'
    " Plug 'tpope/vim-unimpaired'
    Plug 'wellle/targets.vim'
    Plug 'haya14busa/vim-asterisk'
    Plug 'romainl/vim-cool'
    Plug 'godlygeek/tabular'
    Plug 'ii14/vim-bbye'
    Plug 'mbbill/undotree', {'on': ['UndotreeShow', 'UndotreeToggle']}

  " Visual -------------------------------------------------------------------------------
    if has('nvim-0.5.0')
      Plug 'ii14/onedark.nvim'
    else
      Plug 'joshdick/onedark.vim'
    endif
    Plug 'itchyny/lightline.vim'
    Plug 'mengelbrecht/lightline-bufferline'
    Plug 'Yggdroot/indentLine'
    " Plug 'lukas-reineke/indent-blankline.nvim', {'branch': 'lua'}

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
      " Plug 'gfanto/fzf-lsp.nvim'
      " Plug 'simrat39/symbols-outline.nvim'
    endif
    Plug 'hrsh7th/nvim-compe'
    " Plug '~/dev/vim/nvim-compe'
    Plug 'tamago324/compe-necosyntax'
    Plug 'Shougo/neco-syntax'

  " Development --------------------------------------------------------------------------
    Plug 'tpope/vim-fugitive'
    Plug 'rbong/vim-flog'
    Plug 'tpope/vim-dispatch'
    Plug 'SirVer/ultisnips', {'for': ['c', 'cpp', 'make', 'css', 'html', 'lua']}
    Plug 'ii14/exrc.vim'
    Plug 'ii14/pro.vim'
    if !exists('g:disable_dap')
      Plug 'mfussenegger/nvim-dap'
    endif
    " Plug 'junegunn/vader.vim'

  " Syntax -------------------------------------------------------------------------------
    Plug 'sheerun/vim-polyglot'
    Plug 'fedorenchik/qt-support.vim'
    Plug 'PotatoesMaster/i3-vim-syntax'
    Plug 'CantoroMC/vim-rasi'
    Plug 'norcalli/nvim-colorizer.lua'
    if !exists('g:disable_ts')
      Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
      Plug 'nvim-treesitter/playground'
      " Plug 'vigoux/architext.nvim'
    endif

  " Misc ---------------------------------------------------------------------------------
    Plug 'vimwiki/vimwiki'
    Plug 'vifm/vifm.vim', {'on': 'Vifm'}
    Plug 'devinceble/Tortoise-Typing'
    Plug 'tweekmonster/startuptime.vim'

  " Custom -------------------------------------------------------------------------------
    Plug $VIMCONFIG.'/m/rc.vim'
    Plug $VIMCONFIG.'/m/qf.vim'
    Plug $VIMCONFIG.'/m/qmake.vim'
    Plug $VIMCONFIG.'/m/autosplit.vim'

  call plug#end()
  call PlugCheckMissing()

" PLUGIN SETTINGS ////////////////////////////////////////////////////////////////////////
  " Theme --------------------------------------------------------------------------------
    source $VIMCONFIG/theme.vim

  " fzf ----------------------------------------------------------------------------------
    source $VIMCONFIG/fzf.vim

  " Completion ---------------------------------------------------------------------------
    let g:compe = {'source': {
      \ 'path': v:true,
      \ 'calc': v:true,
      \ 'buffer': v:true,
      \ 'necosyntax': v:true,
      \ 'ultisnips': v:true,
      \ }}

    ino <silent><expr> <C-Space> compe#complete()
    ino <silent><expr> <CR>      compe#confirm('<CR>')
    ino <silent><expr> <C-E>     compe#close('<C-E>')

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
        au BufWinEnter * let &l:signcolumn = get(b:, 'lsp_attached', 0) ? 'yes' : 'auto'
      aug end

      " ~/.config/nvim/lua/m/lsp/init.lua
      lua require 'm.lsp'

      " nvim-lightbulb
      aug Vimrc
        au CursorMoved,CursorMovedI * lua require 'nvim-lightbulb'.update_lightbulb()
      aug end
    endif

  " DAP ----------------------------------------------------------------------------------
    if !exists('g:disable_dap')
      lua require 'm.debug'
      com! -complete=file -nargs=* DebugC
        \ lua require 'm.debug'.start_c_debugger({<f-args>}, 'gdb')
    endif

  " Treesitter ---------------------------------------------------------------------------
    if !exists('g:disable_ts')
      lua require'nvim-treesitter.configs'.setup {
        \ highlight = { enable = true },
        \ incremental_selection = { enable = true },
        \ textobjects = { enable = true },
        \ }
    endif

  " Fern ---------------------------------------------------------------------------------
    let g:loaded_netrw             = 1 " disable netrw
    let g:loaded_netrwPlugin       = 1
    let g:loaded_netrwSettings     = 1
    let g:loaded_netrwFileHandlers = 1
    let g:fern#disable_default_mappings = 1

  " exrc.vim -----------------------------------------------------------------------------
    let exrc#names = ['.exrc']
    aug Vimrc
      au BufWritePost .exrc ++nested ExrcTrust
      au SourcePost .exrc silent Pro!
    aug end

  " autosplit.vim ------------------------------------------------------------------------
    let g:autosplit_ft = ['man', 'fugitive', 'gitcommit']
    let g:autosplit_bt = ['help']

  " IndentLine ---------------------------------------------------------------------------
    let g:indentLine_bufTypeExclude = ['help', 'terminal']
    let g:indentLine_fileTypeExclude = ['man', 'fern', 'floggraph']
    let g:indentLine_color_gui = '#4b5263'
    let g:vim_json_syntax_conceal = 0
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_conceal_code_blocks = 0
    au Vimrc TermOpen * ++nested IndentLinesDisable

    " com! IndentLinesDisable IndentBlanklineDisable
    " let g:indent_blankline_char = '¦'
    " let g:indent_blankline_char_highlight = 'Comment'
    " let g:indent_blankline_show_first_indent_level = v:false
    " let g:indent_blankline_show_trailing_blankline_indent = v:false

  " undotree -----------------------------------------------------------------------------
    let g:undotree_DiffAutoOpen = 0
    let g:undotree_WindowLayout = 2
    let g:undotree_HelpLine = 0

  " vimwiki ------------------------------------------------------------------------------
    let g:vimwiki_key_mappings = {'global': 0}

" SETTINGS ///////////////////////////////////////////////////////////////////////////////
  " Visual -------------------------------------------------------------------------------
    set number relativenumber                 " line numbers
    set nowrap
    set colorcolumn=+1                        " text width ruler
    set lazyredraw                            " don't redraw while executing macros
    set title titlelen=45                     " set vim window title
    set titlestring=nvim:\ %F
    set shortmess+=I                          " no intro message
    set noshowmode                            " redundant mode message
    set list                                  " show non-printable characters
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
    set synmaxcol=1000                        " highlight only the first 1000 columns
    set pumblend=10 winblend=10               " pseudo transparency

  " Editing ------------------------------------------------------------------------------
    set textwidth=90
    set history=1000                          " command history size
    set virtualedit=block                     " move cursor anywhere in visual block mode
    set scrolloff=1                           " keep near lines visible when scrolling
    set mouse=a                               " mouse support
    set splitbelow splitright                 " sane splits
    set linebreak breakindent                 " visual wrap on whitespace, follow indentation
    set diffopt+=iwhite                       " ignore whitespace in diff
    set diffopt+=vertical                     " start diff as a vertical split

  " Indentation and Folding --------------------------------------------------------------
    set expandtab                             " convert tabs to spaces
    set shiftwidth=4 tabstop=4 softtabstop=4  " tab width
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
      set grepformat=%f:%l:%m
      let &grepprg = 'rg --vimgrep' . (&smartcase ? ' --smart-case' : '')
    elseif executable('ag')
      set grepformat=%f:%l:%m
      let &grepprg = 'ag --vimgrep' . (&smartcase ? ' --smart-case' : '')
    endif

" COMMANDS ///////////////////////////////////////////////////////////////////////////////
  " See ~/.config/nvim/plugin for more command definitions

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

  " Set option prompt --------------------------------------------------------------------
    com! Makeprg Set makeprg

  " LSP ----------------------------------------------------------------------------------
    if !exists('g:disable_lsp')
      com! LspStopClient lua require 'm.lsp.util'.stop_clients()
      com! LspAction lua vim.lsp.buf.code_action()
      com! LspDiagnostics lua vim.lsp.diagnostic.set_loclist()

      com! -nargs=? LspFind
        \ call luaeval('vim.lsp.buf.workspace_symbol(_A)',
        \ <q-args> is# '' ? v:null : <q-args>)

      com! -range=0 LspFormat
        \ exe 'lua vim.lsp.buf.'.(<count> ? 'range_formatting()' : 'formatting()')
    endif

  " Redir --------------------------------------------------------------------------------
    com! -nargs=+ -complete=command Redir call s:Redir(<q-args>)
    fun! s:Redir(cmd)
      new
      put=execute(a:cmd)
      1,2delete
      setl nomodified
      call autosplit#autopos()
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
      call autosplit#autopos()
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
    au VimEnter,WinEnter,BufWinEnter,TermLeave * setl cursorline
    au WinLeave,TermEnter * setl nocursorline

  " Highlight yanked text ----------------------------------------------------------------
    au TextYankPost * silent! lua vim.highlight.on_yank()

  " Terminal -----------------------------------------------------------------------------
    au TermOpen * setl nonumber norelativenumber

  " Open quickfix window on grep ---------------------------------------------------------
    au QuickFixCmdPost  grep call timer_start(10, { -> execute('cwindow') })
    au QuickFixCmdPost lgrep call timer_start(10, { -> execute('lwindow') })

  " Auto close quickfix, if it's the last buffer -----------------------------------------
    au WinEnter * if winnr('$') == 1 && &bt ==# 'quickfix' | q | endif

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
    " Fix user command string highlighting (https://github.com/vim/vim/issues/6587)
    au Syntax vim syn match vimUsrCmd '^\s*\zs\u\%(\w*\)\@>(\@!'

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
    nno gj j
    vno gj j
    nno gk k
    vno gk k
    vno . :norm .<CR>
    nno gV `[v`]
    vno < <gv
    vno > >gv
    nno S i<CR><ESC>gk:sil! keepp s/\v +$//<CR>:noh<CR>gj^
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

  " Files --------------------------------------------------------------------------------
    let g:places = {
      \ '.': '.',
      \ 'V': '$VIMRUNTIME',
      \ 'c': '~/.config',
      \ 'd': '~/dev',
      \ 'e': '/etc',
      \ 'm': '~/dev/mm',
      \ 'p': '$VIMPLUGINS',
      \ 'r': '~/repos',
      \ 'v': '$VIMCONFIG',
      \ }

    nno <silent><expr> <leader>f (len(system('git rev-parse')) ? ':Files'
      \ : ':GFiles --exclude-standard --others --cached')."\<CR>"
    nno <silent><expr> <leader>F ':Files '.BufDirectory()."\<CR>"
    nno <silent> ', :call Menu('Files', g:places)<CR>
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
    vno <leader>s :s/
    nmap <leader>S :%S/
    vmap <leader>S :S/
    nmap <leader>c z*cgn
    vmap <leader>c z*cgn
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
    no q <Nop>
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
    vno <leader>t :Tabularize /
    vno <leader>n :norm!<Space>
    nno <leader>v ggVG

  " Registers ----------------------------------------------------------------------------
    vno zp  pgvy
    vno zgp pgvy`]<Space>
    nno <leader>y  "+y
    nno <leader>Y  "+y$
    nno <leader>p  "+p
    nno <leader>P  "+P
    nno <leader>gp "+gp
    nno <leader>gP "+gP
    vno <leader>y  "+y
    vno <leader>p  "+p
    vno <leader>P  "+P
    vno <leader>gp "+gp
    vno <leader>gP "+gP

  " Make ---------------------------------------------------------------------------------
    nno m<CR>    :up<CR>:Make<CR>
    nno m<Space> :up<CR>:Make<Space>
    nno m!       :up<CR>:Make!<CR>
    nno m=       :Makeprg<CR>

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
    nno <silent> <leader>r :call fzf#run(fzf#wrap(
      \ {'source': pro#configs(), 'sink': 'Pro'}))<CR>

  " Command ------------------------------------------------------------------------------
    cno <C-J> <Down>
    cno <C-K> <Up>
    cno <C-A> <Home>
    cno <C-B> <C-Left>
    cno <expr><C-F> getcmdline() !=# '' ? '<C-Right>' : '<C-F>'
    cno <expr><C-R><C-D> BufDirectory()
    cno <C-X><C-A> <C-A>
    cno <C-R><C-K> <C-K>

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

      " nno <buffer><silent> gww   <cmd>lua vim.lsp.buf.formatting()<CR>
      " nno <buffer><silent> gqq   <cmd>lua vim.lsp.buf.formatting()<CR>
      " vno <buffer><silent> gw    <cmd>lua vim.lsp.buf.range_formatting()<CR>
      " vno <buffer><silent> gq    <cmd>lua vim.lsp.buf.range_formatting()<CR>

      nno <buffer><silent> <leader>lS :LspStopClient<CR>
      nno <buffer><silent> <leader>ls :LspFind<CR>
      nno <buffer><silent> <leader>lf :LspFormat<CR>
      vno <buffer><silent> <leader>lf :LspFormat<CR>
      nno <buffer><silent> <leader>la :LspAction<CR>
      " nno <buffer><silent> <leader>ld :LspDiagnostics<CR>
    endfun
    nno <silent> <leader>ld :LspTroubleToggle<CR>

  " DAP ----------------------------------------------------------------------------------
    if !exists('g:disable_dap')
      nno <leader>d<Space>    :DebugC<Space>
      nno <leader>d<CR>       :DebugC<CR>
      nno <silent> <leader>dc :lua require'dap'.continue()<CR>
      nno <silent> <leader>dn :lua require'dap'.step_over()<CR>
      nno <silent> <leader>di :lua require'dap'.step_into()<CR>
      nno <silent> <leader>do :lua require'dap'.step_out()<CR>
      nno <silent> <leader>db :lua require'dap'.toggle_breakpoint()<CR>
      nno <silent> <leader>dr :lua require'dap'.repl.open()<CR>
      nno <silent> <leader>dl :lua require'dap'.repl.run_last()<CR>
    endif

" vim:tw=90:ts=2:sts=2:sw=2:et:
