" PLUGINS //////////////////////////////////*plugins*/////////////////////////////////////

call plug#begin($VIMPLUGINS)

" Editing ----------------------------------*plugins-editing*-----------------------------
  Plug 'ii14/vim-surround'
  Plug 'numToStr/Comment.nvim' " |plugin-comment|
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-abolish'
  Plug 'wellle/targets.vim' " |plugin-targets|
  Plug 'tommcdo/vim-exchange'
  Plug 'haya14busa/vim-asterisk' " |keymap-asterisk|
  Plug 'romainl/vim-cool'
  Plug 'godlygeek/tabular' " |tabular|
  Plug 'ii14/vim-bbye'
  Plug 'mbbill/undotree', {'on': ['UndotreeShow', 'UndotreeToggle']} " |plugin-undotree|
  Plug 'stefandtw/quickfix-reflector.vim' " |plugin-quickfix-reflector|

" Visual -----------------------------------*plugins-visual*------------------------------
  Plug 'ii14/onedark.nvim' " |theme|
  Plug 'itchyny/lightline.vim'
  Plug 'mengelbrecht/lightline-bufferline'
  Plug 'lukas-reineke/indent-blankline.nvim'

" File management --------------------------*plugins-files*-------------------------------
  Plug 'junegunn/fzf', {'do': { -> fzf#install() }} " |plugin-fzf| |keymap-fzf|
  Plug 'junegunn/fzf.vim'
  Plug 'lambdalisue/fern.vim', {'on': 'Fern'} " |plugin-fern| |buffer-fern| |keymap-fern|
  Plug 'LumaKernel/fern-mapping-fzf.vim', {'on': 'Fern'}
  Plug 'antoinemadec/FixCursorHold.nvim' " required by fern.vim
  Plug 'bogado/file-line'

" Completion -------------------------------*plugins-completion*--------------------------
  if !exists('g:disable_lsp') " |plugin-lsp| |lsp| |buffer-lsp|
    Plug 'neovim/nvim-lspconfig' " |lsp-servers|
    Plug 'nvim-lua/plenary.nvim'
    Plug 'jose-elias-alvarez/null-ls.nvim' " |lsp-null-ls|
    Plug 'folke/trouble.nvim' " |lsp-trouble|
    Plug 'kosayoda/nvim-lightbulb'
  endif
  Plug 'hrsh7th/nvim-compe' " |plugin-completion|
  Plug 'tamago324/compe-necosyntax'
  Plug 'Shougo/neco-syntax'
  Plug 'L3MON4D3/LuaSnip' " |plugin-snippets|

" Development ------------------------------*plugins-dev*---------------------------------
  Plug 'tpope/vim-fugitive' " |keymap-git|
  Plug 'rbong/vim-flog'
  Plug 'tpope/vim-dispatch'
  Plug 'ii14/exrc.vim' " |plugin-exrc|
  Plug 'ii14/pro.vim'

" Syntax -----------------------------------*plugins-syntax*------------------------------
  Plug 'sheerun/vim-polyglot'
  Plug 'fedorenchik/qt-support.vim'
  Plug 'PotatoesMaster/i3-vim-syntax'
  Plug 'CantoroMC/vim-rasi'
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'milisims/nvim-luaref'

" Misc -------------------------------------*plugins-dev*---------------------------------
  Plug 'vimwiki/vimwiki' " |plugin-vimwiki|
  Plug 'kizza/actionmenu.nvim'

" Custom -----------------------------------*plugins-custom*------------------------------
  Plug $VIMCONFIG..'/m/qf.vim'
  Plug $VIMCONFIG..'/m/drawer.nvim'
  Plug $VIMCONFIG..'/m/termdebug' " |plugin-termdebug| |keymap-termdebug|
  Plug $VIMCONFIG..'/m/vtags'

" Performance ------------------------------*plugins-perf*--------------------------------
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

" After ------------------------------------*plugins-after*-------------------------------
lua require 'impatient'
lua require 'm.global'

" vim: tw=90 ts=2 sts=2 sw=2 et
