let mapleader      = ' '
let maplocalleader = ' '
filetype plugin on
syntax on
set textwidth=100

if !executable('fzf')
  let s:disable_fzf = 1
endif

if !has('nvim')
  let s:disable_lsp = 1
endif

" PLUGINS //////////////////////////////////////////////////////////////////////////////////////////
call plug#begin('~/.config/nvim/plugged')

  " Editing ----------------------------------------------------------------------------------------
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-repeat'
    Plug 'tommcdo/vim-exchange'
    Plug 'godlygeek/tabular'
    Plug 'moll/vim-bbye'
    " Plug 'bkad/CamelCaseMotion'

  " Visual -----------------------------------------------------------------------------------------
    Plug 'joshdick/onedark.vim'
    Plug 'itchyny/lightline.vim'
    Plug 'mengelbrecht/lightline-bufferline'
    Plug 'Yggdroot/indentLine'
    Plug 'unblevable/quick-scope'

  " Search and Autocompletion ----------------------------------------------------------------------
    if !exists('s:disable_fzf')
      Plug 'junegunn/fzf'
      Plug 'junegunn/fzf.vim'
    endif
    Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
    Plug 'Shougo/neco-syntax'
    if !exists('s:disable_lsp')
      Plug 'neovim/nvim-lspconfig'
      Plug 'Shougo/deoplete-lsp'
    else
      Plug 'deoplete-plugins/deoplete-clang'
    endif
    " Plug 'jackguo380/vim-lsp-cxx-highlight'

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
    Plug 'metakirby5/codi.vim', {'on': 'Codi'}

call plug#end()

source ~/.config/nvim/init/strip.vim
source ~/.config/nvim/init/quickfix.vim

" PLUGIN SETTINGS //////////////////////////////////////////////////////////////////////////////////
  " Theme ------------------------------------------------------------------------------------------
    set termguicolors
    set background=dark
    colorscheme onedark

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
    let g:lightline#bufferline#min_buffer_count = 2

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

    aug au_lightline | au!
      au BufWritePost,TextChanged,TextChangedI,WinClosed * call lightline#update()
    aug end

  " fzf --------------------------------------------------------------------------------------------
    if !exists('s:disable_fzf')
      let $FZF_DEFAULT_OPTS =
        \ '--bind=ctrl-a:select-all,ctrl-u:page-up,ctrl-d:page-down,ctrl-space:toggle'
      let g:fzf_action = {'ctrl-s': 'split', 'ctrl-v': 'vsplit'}
    endif

  " Deoplete ---------------------------------------------------------------------------------------
    let g:deoplete#enable_at_startup = 1
    if !exists('s:disable_lsp')
      call deoplete#custom#option('ignore_sources', {
        \   'c'       : ['around', 'buffer', 'syntax'],
        \   'cpp'     : ['around', 'buffer', 'syntax'],
        \   'python'  : ['around', 'buffer', 'syntax'],
        \ })
    else
      let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-10/lib/libclang.so.1'
      let g:deoplete#sources#clang#clang_header  = '/usr/lib/clang/10/include'
    endif

  " nvim-lsp ---------------------------------------------------------------------------------------
    if !exists('s:disable_lsp')
      " ~/.config/nvim/lua/vimrc_lsp.lua
      lua require 'vimrc_lsp'

      sign define LspDiagnosticsErrorSign text=\ E
      sign define LspDiagnosticsWarningSign text=\ W
      sign define LspDiagnosticsInformationSign text=\ i

      hi! link LspDiagnosticsError ErrorMsg
      hi! link LspDiagnosticsWarning WarningMsg
      hi! link LspDiagnosticsUnderline Underlined
    endif

  " Dispatch ---------------------------------------------------------------------------------------
    let g:dispatch_no_maps = 1
    let g:dispatch_keep_focus = 1

  " IndentLine -------------------------------------------------------------------------------------
    let g:vim_json_syntax_conceal = 0
    let g:indentLine_bufTypeExclude = ['help', 'terminal']
    aug au_indentline | au! | au FileType json IndentLinesDisable | aug end

  " quick-scope ------------------------------------------------------------------------------------
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
    let g:qs_max_chars=150
    let g:qs_buftype_blacklist = ['terminal', 'nofile']

  " vimwiki ----------------------------------------------------------------------------------------
    let g:vimwiki_key_mappings = {'global': 0}

  " netrw ------------------------------------------------------------------------------------------
    let g:loaded_netrw       = 1
    let g:loaded_netrwPlugin = 1

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
    hi! link QuickFixLine PMenuSel

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

  " fzf helptags -----------------------------------------------------------------------------------
    if !exists('s:disable_fzf')
      com! H Helptags
    endif

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

  " Enable Build EAR -------------------------------------------------------------------------------
    if executable('bear')
      com! Bear set makeprg=bear\ make
    endif

  " Codi python scratchpad -------------------------------------------------------------------------
    com! Py call <SID>Py()
    fun! <SID>Py()
      enew
      Codi python
      setl nonumber norelativenumber
      nnoremap <buffer><nowait> q :bd!<CR>:redraw!<CR>
      startinsert
    endfun

" AUTOCOMMANDS /////////////////////////////////////////////////////////////////////////////////////
aug au_vimrc | au!

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
    au TermOpen * setl nonumber norelativenumber | startinsert
    au BufWinEnter,WinEnter term://* startinsert
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
    au FileType cpp ia <buffer> <silent> #i #include

  " Quickfix ---------------------------------------------------------------------------------------
    au WinEnter * if winnr('$') == 1 && &buftype ==? "quickfix" | q | endif

aug end

" KEY MAPPINGS /////////////////////////////////////////////////////////////////////////////////////
  " Defaults ---------------------------------------------------------------------------------------
    nnoremap 0 ^
    nnoremap ^ 0
    nnoremap Y y$
    nnoremap j gj
    vnoremap j gj
    nnoremap k gk
    vnoremap k gk
    vnoremap < <gv
    vnoremap > >gv
    nnoremap x "_x
    noremap + "+
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
    if !exists('s:disable_fzf')
      nnoremap <leader>b :Buffers<CR>
      nnoremap <leader>f :Files<CR>
      nnoremap <leader>F :Files <C-R>=expand('%:h')<CR><CR>
    else
      nnoremap <leader>b :ls<CR>:b
    endif

  " Search and Replace -----------------------------------------------------------------------------
    if !exists('s:disable_fzf')
      nnoremap <leader>/ :Lines<CR>
      nnoremap <leader>? :BLines<CR>
    else
      nnoremap <leader>/ :vimgrep // ##<Left><Left><Left><Left>
      nnoremap <leader>? :vimgrep // %<Left><Left><Left>
    endif
    nnoremap <leader>s :%s//g<Left><Left>
    vnoremap <leader>s :s//g<Left><Left>
    nnoremap <leader>h :set hls<CR>:let @/="<C-R><C-W>"<CR>
    nnoremap <leader>c :set hls<CR>:let @/="<C-R><C-W>"<CR>cgn
    vnoremap <leader>h "hy:set hls<CR>:let @/="<C-R>h"<CR>
    vnoremap <leader>c "hy:set hls<CR>:let @/="<C-R>h"<CR>cgn
    nnoremap <silent> <CR> :Noh<CR>

  " Make -------------------------------------------------------------------------------------------
    nnoremap m<CR> :up<CR>:Make<CR>
    nnoremap m<Space> :up<CR>:Make<Space>
    nnoremap m! :up<CR>:Make!<CR>

  " LSP --------------------------------------------------------------------------------------------
    if !exists('s:disable_lsp')
      nnoremap <silent> ,d <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <silent> ,f <cmd>lua vim.lsp.buf.references()<CR>
      nnoremap <silent> ,s <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
      nnoremap <silent> ,r <cmd>lua vim.lsp.buf.rename()<CR>
      nnoremap <silent> ,h <cmd>lua vim.lsp.buf.hover()<CR>
      nnoremap <silent> ,e <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
    endif
    nnoremap <silent> ,a :A<CR>

  " Git --------------------------------------------------------------------------------------------
    nnoremap <leader>gs :G<CR>
    nnoremap <leader>gl :Flog<CR>

  " Misc -------------------------------------------------------------------------------------------
    nnoremap <leader>a ggVG
    vnoremap <leader>t :Tabularize<Space>
    nnoremap <leader>ew :VimwikiIndex<CR>
    nnoremap <leader>ev :edit $MYVIMRC<CR>

  " Command ----------------------------------------------------------------------------------------
    cnoremap <C-J> <Down>
    cnoremap <C-K> <Up>
    cnoremap %% <C-R>=expand('%:h').'/'<CR>

  " Terminal ---------------------------------------------------------------------------------------
    tnoremap <C-W> <C-\><C-N><C-W>
    tnoremap <C-N> <C-\><C-N>:bn<CR>
    tnoremap <C-P> <C-\><C-N>:bp<CR>
    tnoremap <C-\> <C-\><C-N>
