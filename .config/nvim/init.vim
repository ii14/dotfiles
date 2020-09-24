let mapleader      = ' '
let maplocalleader = ' '
filetype plugin on
syntax on
set textwidth=100

if !has('nvim') | let s:disable_lsp = 1 | endif

let s:disable_deoplete = 1
let s:deoplete_lazy_load = 1

aug Vimrc | au! | aug end

" PLUGINS //////////////////////////////////////////////////////////////////////////////////////////
call plug#begin('~/.config/nvim/plugged')

  " Editing ----------------------------------------------------------------------------------------
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-repeat'
    Plug 'tommcdo/vim-exchange'
    Plug 'haya14busa/vim-asterisk'
    Plug 'godlygeek/tabular'
    Plug 'moll/vim-bbye'
    " Plug 'bkad/CamelCaseMotion'

  " Visual -----------------------------------------------------------------------------------------
    Plug 'joshdick/onedark.vim'
    Plug 'edersonferreira/dalton-vim'
    Plug 'itchyny/lightline.vim'
    Plug 'mengelbrecht/lightline-bufferline'
    Plug 'Yggdroot/indentLine'
    Plug 'unblevable/quick-scope'

  " Search and Autocompletion ----------------------------------------------------------------------
    Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
    Plug 'junegunn/fzf.vim'
    if !exists('s:disable_lsp')
      Plug 'neovim/nvim-lspconfig'
      Plug 'jackguo380/vim-lsp-cxx-highlight'
    endif
    if !exists('s:disable_deoplete')
      Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
      Plug 'Shougo/neco-syntax'
      if !exists('s:disable_lsp')
        Plug 'Shougo/deoplete-lsp'
      else
        Plug 'deoplete-plugins/deoplete-clang'
      endif
    else
      Plug 'nvim-lua/completion-nvim'
      Plug 'steelsojka/completion-buffers'
    endif

  " Development ------------------------------------------------------------------------------------
    Plug 'tpope/vim-fugitive'
    Plug 'rbong/vim-flog'
    Plug 'ii14/vim-dispatch'
    Plug 'cdelledonne/vim-cmake'
    Plug 'nacitar/a.vim'
    Plug 'sheerun/vim-polyglot'
    Plug 'fedorenchik/qt-support.vim'
    Plug 'PotatoesMaster/i3-vim-syntax'

  " Misc -------------------------------------------------------------------------------------------
    Plug 'vimwiki/vimwiki'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'lambdalisue/fern.vim'
    Plug 'antoinemadec/FixCursorHold.nvim'
    Plug 'metakirby5/codi.vim', {'on': 'Codi'}

call plug#end()

source ~/.config/nvim/init/strip.vim
source ~/.config/nvim/init/quickfix.vim
source ~/.config/nvim/init/qmake.vim

" PLUGIN SETTINGS //////////////////////////////////////////////////////////////////////////////////
  " Theme ------------------------------------------------------------------------------------------
    set termguicolors
    set background=dark
    colorscheme onedark
    " colorscheme dalton

  " Lightline --------------------------------------------------------------------------------------
    let g:lightline = {}
    let g:lightline.colorscheme = 'onedark'
    let g:lightline.active = {
      \   'left'  : [['mode', 'paste'], ['fugitive', 'readonly', 'filename']],
      \   'right' : [['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype']],
      \ }
    let g:lightline.tabline = {
      \   'left'  : [['buffers']],
      \   'right' : [[]],
      \ }
    let g:lightline.component_function = {
      \   'mode'       : 'LightlineMode',
      \   'filename'   : 'LightlineFilename',
      \   'fileformat' : 'LightlineFileformat',
      \   'filetype'   : 'LightlineFiletype',
      \   'fugitive'   : 'LightlineFugitive',
      \ }
    let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
    let g:lightline.component_type   = {'buffers': 'tabsel'}
    let g:lightline.component_raw    = {'buffers': 1}

    set showtabline=2
    let g:lightline#bufferline#unnamed          = '[No Name]'
    let g:lightline#bufferline#clickable        = 1
    " let g:lightline#bufferline#min_buffer_count = 2

    fun! LightlineMode()
      return winwidth(0) < 60 ? '' : lightline#mode()
    endfun

    fun! LightlineFilename()
      if &ft == 'qf' | return '[QuickFix]' | endif
      let fname = expand('%:t')
      return fname ==# '' ? '[No Name]' : &mod ? fname.' +' : fname
    endfun

    fun! LightlineFileformat()
      return winwidth(0) > 70 ? &ff : ''
    endfun

    fun! LightlineFiletype()
      return winwidth(0) > 70 ? (&ft !=# '' ? &ft : 'no ft') : ''
    endfun

    fun! LightlineFugitive()
      return winwidth(0) > 70 && &ft != 'qf' && exists('*FugitiveHead') ? FugitiveHead() : ''
    endfun

    aug Vimrc
      au BufWritePost,TextChanged,TextChangedI,WinClosed * call lightline#update()
    aug end

  " fzf --------------------------------------------------------------------------------------------
    let $FZF_DEFAULT_OPTS =
      \ '--bind=ctrl-a:select-all,ctrl-u:page-up,ctrl-d:page-down,ctrl-space:toggle'
    let g:fzf_action = {'ctrl-s': 'split', 'ctrl-v': 'vsplit'}
    let g:fzf_layout = {'down': '40%'}

  " Deoplete ---------------------------------------------------------------------------------------
    if !exists('s:disable_deoplete')
      if !exists('s:deoplete_lazy_load ')
        let g:deoplete#enable_at_startup = 1
      else
        let g:deoplete#enable_at_startup = 0
        aug Vimrc
          au InsertEnter * call deoplete#enable()
        aug end
      endif
      if exists('s:disable_lsp')
        let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-10/lib/libclang.so.1'
        let g:deoplete#sources#clang#clang_header  = '/usr/lib/clang/10/include'
      endif
    endif

  " completion-nvim --------------------------------------------------------------------------------
    if exists('s:disable_deoplete')
      let g:completion_enable_auto_signature = 0
      let g:completion_trigger_on_delete = 1
      let g:completion_auto_change_source = 1
      let g:completion_matching_ignore_case = 1
      let g:completion_matching_strategy_list = ['exact', 'fuzzy', 'substring']
      " let g:completion_chain_complete_list = {'default': [{'complete_items': ['buffers', 'path']}]}
      let g:completion_chain_complete_list = {'default': [{'complete_items': ['lsp']}]}

      imap <C-J> <Plug>(completion_next_source)
      imap <C-K> <Plug>(completion_prev_source)

      aug Vimrc
        au BufEnter * lua require'completion'.on_attach()
      aug end
    endif

  " nvim-lsp ---------------------------------------------------------------------------------------
    if !exists('s:disable_lsp')
      fun! VimrcLspOnAttach() " called when lsp is attached to the current buffer
        setl signcolumn=yes
        call s:vimrc_lsp_maps()
        if !exists('s:disable_deoplete')
          call deoplete#custom#buffer_option('sources', ['lsp'])
        else
          setl omnifunc=v:lua.vim.lsp.omnifunc
          lua require'completion'.on_attach({
            \   chain_complete_list = {
            \     default = {{complete_items = {'lsp'}}}
            \   }
            \ })
        endif
      endfun

      " ~/.config/nvim/lua/vimrc_lsp.lua
      lua require 'vimrc_lsp'
    endif

  " Fern -------------------------------------------------------------------------------------------
    let g:loaded_netrw       = 1 " disable netrw
    let g:loaded_netrwPlugin = 1
    let g:fern#disable_default_mappings = 1
    aug Vimrc
      au FileType fern call s:vimrc_fern_maps()
    aug end

  " Dispatch ---------------------------------------------------------------------------------------
    let g:dispatch_no_maps = 1
    let g:dispatch_keep_focus = 1

  " IndentLine -------------------------------------------------------------------------------------
    let g:vim_json_syntax_conceal = 0
    let g:indentLine_bufTypeExclude = ['help', 'terminal']
    aug Vimrc
      au FileType json IndentLinesDisable
    aug end

  " quick-scope ------------------------------------------------------------------------------------
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
    let g:qs_max_chars=150
    let g:qs_buftype_blacklist = ['terminal', 'nofile']

  " vimwiki ----------------------------------------------------------------------------------------
    let g:vimwiki_key_mappings = {'global': 0}

" SETTINGS /////////////////////////////////////////////////////////////////////////////////////////
  " Visual -----------------------------------------------------------------------------------------
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

  " Editing ----------------------------------------------------------------------------------------
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

  " Indentation and Folding ------------------------------------------------------------------------
    set expandtab                             " convert tabs to spaces
    set shiftwidth=4 tabstop=4 softtabstop=4  " tab width
    set smarttab shiftround                   " follow tab grid
    set autoindent smartindent                " follow previous indentation, auto indent blocks
    set foldmethod=indent foldlevel=999       " folding based on indentation

  " Search and Autocompletion ----------------------------------------------------------------------
    set path+=**
    set hlsearch incsearch                    " search highlighting, incremental
    set ignorecase smartcase                  " ignore case unless search starts with uppercase
    set inccommand=nosplit                    " sed preview
    set wildmenu                              " command completion
    set shortmess+=c                          " silent completion
    set pumheight=25                          " autocompletion popup height
    set completeopt+=noselect,menuone
    set completeopt-=preview

  " Buffers ----------------------------------------------------------------------------------------
    set hidden                                " don't close buffers
    set autoread                              " update buffer if changed outside of vim
    set noswapfile                            " disable swap files
    set undofile                              " persistent undo history
    set directory=~/.cache/nvim/swap          " swap files
    set backupdir=~/.cache/nvim/backup        " backup files
    set undodir=~/.cache/nvim/undo            " undo files
    "set autochdir                             " change cwd to the current buffer

  " Grep -------------------------------------------------------------------------------------------
    if executable('rg')
      set grepformat=%f:%l:%m
      let &grepprg = 'rg --vimgrep' . (&smartcase ? ' --smart-case' : '')
    elseif executable('ag')
      set grepformat=%f:%l:%m
      let &grepprg = 'ag --vimgrep' . (&smartcase ? ' --smart-case' : '')
    endif

" COMMANDS /////////////////////////////////////////////////////////////////////////////////////////
  " Clear search highlighting ----------------------------------------------------------------------
    com! Noh let @/ = ""

  " Set tab width ----------------------------------------------------------------------------------
    com! -nargs=1 T setl ts=<args> sts=<args> sw=<args>

  " Go to the current buffer directory -------------------------------------------------------------
    com! D exe 'cd '.expand('%:h')

  " Shortcuts --------------------------------------------------------------------------------------
    com! Wiki VimwikiIndex
    com! Vimrc edit $MYVIMRC

  " fzf helptags -----------------------------------------------------------------------------------
    com! H Helptags

  " Rename file ------------------------------------------------------------------------------------
    com! RenameFile call <SID>RenameFile()
    fun! <SID>RenameFile()
      let old_name = expand('%')
      let new_name = input('New file name: ', expand('%'))
      if new_name != '' && new_name != old_name
        exe ':saveas ' . new_name
        exe ':silent !rm ' . old_name
        exe ':bd ' . old_name
        redraw!
      endif
    endfun

  " Update ctags -----------------------------------------------------------------------------------
    if executable('ctags')
      com! MakeTags !ctags -R .
    endif

  " compilation_database.json ----------------------------------------------------------------------
    if executable('compiledb')
      com! Compiledb Dispatch compiledb -n make
    elseif executable('bear')
      com! Compiledb Dispatch bear -a make
    endif

  " Redir ------------------------------------------------------------------------------------------
    com! -nargs=1 -complete=command Redir
      \ execute "tabnew | pu=execute(\'" . <q-args> . "\') | setl nomodified"

" AUTOCOMMANDS /////////////////////////////////////////////////////////////////////////////////////
aug Vimrc

  " Return to last edit position -------------------------------------------------------------------
    au BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

  " make autowrite ---------------------------------------------------------------------------------
    au QuickFixCmdPre make update

  " Cursor line highlighting -----------------------------------------------------------------------
    au VimEnter,WinEnter,BufWinEnter * setl cursorline
    au WinLeave * setl nocursorline

  " Terminal ---------------------------------------------------------------------------------------
    au TermOpen * setl nonumber norelativenumber
    au BufLeave term://* stopinsert

  " Tab widths -------------------------------------------------------------------------------------
    au FileType make
      \ setl ts=8 sts=8 sw=8 noet
    au FileType html,css,scss,yaml,vim,ruby
      \ setl ts=2 sts=2 sw=2

  " Autocompile ------------------------------------------------------------------------------------
    au FileType typescript
      \ setl makeprg=deno\ bundle\ -c\ tsconfig.json\ %\ %:r.js
    au FileType scss
      \ setl makeprg=sassc\ %\ %:r.css
    au BufWritePost *.ts,*.scss silent make

  " Abbreviations ----------------------------------------------------------------------------------
    au FileType c,cpp ia <buffer> <silent> #i #include

  " C/C++ single line comments ---------------------------------------------------------------------
    au FileType c,cpp set commentstring=//%s

  " Quickfix ---------------------------------------------------------------------------------------
    au WinEnter * if winnr('$') == 1 && &buftype ==? "quickfix" | q | endif

aug end

" KEY MAPPINGS /////////////////////////////////////////////////////////////////////////////////////
  " Override defaults ------------------------------------------------------------------------------
    nnoremap 0 ^
    nnoremap ^ 0
    nnoremap Y y$
    nnoremap j gj
    vnoremap j gj
    nnoremap k gk
    vnoremap k gk
    noremap Q q
    noremap q <Nop>
    nnoremap <C-E> 3<C-E>
    nnoremap <C-Y> 3<C-Y>
    vnoremap . :norm .<CR>
    noremap q: :q

  " Windows ----------------------------------------------------------------------------------------
    nnoremap <C-H> <C-W>h
    nnoremap <C-J> <C-W>j
    nnoremap <C-K> <C-W>k
    nnoremap <C-L> <C-W>l
    nnoremap <leader>w <C-W>

  " Buffers ----------------------------------------------------------------------------------------
    nnoremap <C-N> :bn<CR>
    nnoremap <C-P> :bp<CR>
    nnoremap <leader>d :Bdelete<CR>
    nnoremap <leader>D :Bdelete!<CR>
    nnoremap <leader>b :Buffers<CR>
    " nnoremap <leader>f :Files<CR>
    nnoremap <expr> <leader>f (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<CR>"
    nnoremap <leader>F :Files <C-R>=expand('%:h')<CR><CR>

  " Search and Replace -----------------------------------------------------------------------------
    nnoremap <leader>/ :Lines<CR>
    nnoremap <leader>? :BLines<CR>
    nnoremap <leader>s :%s//g<Left><Left>
    vnoremap <leader>s :s//g<Left><Left>
    nmap <leader>h <Plug>(asterisk-z*)
    vmap <leader>h <Plug>(asterisk-z*)
    nmap <leader>c <Plug>(asterisk-z*)cgn
    vmap <leader>c <Plug>(asterisk-z*)cgn
    nnoremap <silent> <CR> :Noh<CR>

  " Misc -------------------------------------------------------------------------------------------
    vnoremap <leader>t :Tabularize /
    vnoremap <leader>n :norm!<Space>
    nnoremap <leader>a :A<CR>
    nnoremap <leader>H :Helptags<CR>
    nnoremap <leader>A ggVG
    nnoremap <leader>ow :set wrap!<CR>
    nnoremap <leader>oi :IndentLinesToggle<CR>

  " Clipboard --------------------------------------------------------------------------------------
    nnoremap <leader>p "+p
    vnoremap <leader>p "+p
    nnoremap <leader>P "+P
    vnoremap <leader>P "+P
    nnoremap <leader>y "+y
    vnoremap <leader>y "+y
    nnoremap <leader>Y "+y$

  " Make -------------------------------------------------------------------------------------------
    nnoremap m<CR> :up<CR>:Make<CR>
    nnoremap m<Space> :up<CR>:Make<Space>
    nnoremap m! :up<CR>:Make!<CR>
    nnoremap m? :set makeprg?<CR>
    nnoremap `<CR> :Dispatch<CR>
    nnoremap `<Space> :Dispatch<Space>
    nnoremap `! :Dispatch!<CR>
    nnoremap `? :FocusDispatch<CR>

  " Git --------------------------------------------------------------------------------------------
    nnoremap <leader>gs :G<CR>
    nnoremap <leader>gl :Flog<CR>

  " Command ----------------------------------------------------------------------------------------
    cnoremap <C-J> <Down>
    cnoremap <C-K> <Up>
    cnoremap %% <C-R>=expand('%:h').'/'<CR>

  " Terminal ---------------------------------------------------------------------------------------
    tnoremap <C-W> <C-\><C-N><C-W>
    tnoremap <C-N> <C-\><C-N>:bn<CR>
    tnoremap <C-P> <C-\><C-N>:bp<CR>
    tnoremap <C-\> <C-\><C-N>
    tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

  " LSP --------------------------------------------------------------------------------------------
    fun! s:vimrc_lsp_maps()
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

      " old
      nnoremap <buffer><silent> ,d <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <buffer><silent> ,f <cmd>lua vim.lsp.buf.references()<CR>
      nnoremap <buffer><silent> ,r <cmd>lua vim.lsp.buf.rename()<CR>
      nnoremap <buffer><silent> ,e <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
    endfun

  " Fern -------------------------------------------------------------------------------------------
    nnoremap - :Fern %:h<CR>
    fun! s:vimrc_fern_maps() abort
      nmap <buffer><nowait> - <Plug>(fern-action-leave)
      nmap <buffer><nowait> <BS> <Plug>(fern-action-leave)
      nmap <buffer><nowait> <CR> <Plug>(fern-open-or-enter)
      nmap <buffer><nowait> h <Plug>(fern-action-collapse)
      nmap <buffer><nowait> l <Plug>(fern-open-or-expand)
      nmap <buffer><nowait> e <Plug>(fern-action-open)
      nmap <buffer><nowait> E <Plug>(fern-action-open:side)

      nmap <buffer><nowait> m <Plug>(fern-action-mark:toggle)j
      vmap <buffer><nowait> m <Plug>(fern-action-mark:toggle)
      nmap <buffer><nowait> N <Plug>(fern-action-new-path)
      nmap <buffer><nowait> R <Plug>(fern-action-rename)
      nmap <buffer><nowait> C <Plug>(fern-action-clipboard-copy)
      nmap <buffer><nowait> M <Plug>(fern-action-clipboard-move)
      nmap <buffer><nowait> P <Plug>(fern-action-clipboard-paste)
      nmap <buffer><nowait> D <Plug>(fern-action-trash)

      nmap <buffer><nowait> ! <Plug>(fern-action-hidden-toggle)
      nmap <buffer><nowait> fi <Plug>(fern-action-include)
      nmap <buffer><nowait> fe <Plug>(fern-action-exclude)

      nmap <buffer><nowait> <F5> <Plug>(fern-action-reload)
      nmap <buffer><nowait> <C-C> <Plug>(fern-action-cancel)

      nnoremap <buffer><nowait> q :Bdelete!<CR>

      nnoremap <buffer> <C-H> <C-W>h
      nnoremap <buffer> <C-L> <C-W>l
      nnoremap <buffer> <C-K> <C-W>k
      nnoremap <buffer> <C-J> <C-W>j
    endfun

" HIGHLIGHT ////////////////////////////////////////////////////////////////////////////////////////
  " quickfix ---------------------------------------------------------------------------------------
    hi! link QuickFixLine PMenuSel

  " LSP --------------------------------------------------------------------------------------------
    if !exists('s:disable_lsp')
      sign define LspDiagnosticsErrorSign text=\ E
      sign define LspDiagnosticsWarningSign text=\ W
      sign define LspDiagnosticsInformationSign text=\ i

      hi! link LspDiagnosticsError ErrorMsg
      hi! link LspDiagnosticsWarning WarningMsg
      hi! link LspDiagnosticsInformation Function
      hi! link LspDiagnosticsUnderline Underlined

      " vim-lsp-cxx-highlight
      hi! link LspCxxHlSymUnknown          Normal
      hi! link LspCxxHlSymTypeParameter    Structure
      hi! link LspCxxHlSymFunction         Function
      hi! link LspCxxHlSymMethod           Function
      hi! link LspCxxHlSymStaticMethod     Function
      hi! link LspCxxHlSymConstructor      Function
      hi! link LspCxxHlSymEnumMember       Constant
      hi! link LspCxxHlSymMacro            Macro
      hi! link LspCxxHlSymNamespace        Keyword
      hi! link LspCxxHlSymVariable         Normal
      hi! link LspCxxHlSymParameter        Normal
      hi! link LspCxxHlSymField            Normal
      hi! LspCxxHlSymField     ctermfg=145 guifg=#ABB2BF cterm=bold gui=bold
      hi! LspCxxHlSymClass     ctermfg=180 guifg=#E5C07B cterm=bold gui=bold
      hi! LspCxxHlSymStruct    ctermfg=180 guifg=#E5C07B cterm=bold gui=bold
      hi! LspCxxHlSymEnum      ctermfg=180 guifg=#E5C07B cterm=bold gui=bold
      hi! LspCxxHlSymTypeAlias ctermfg=180 guifg=#E5C07B cterm=bold gui=bold
    endif
