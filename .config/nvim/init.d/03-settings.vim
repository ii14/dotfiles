" SETTINGS /////////////////////////////////*settings*////////////////////////////////////

" Visual -----------------------------------*settings-visual*-----------------------------
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

" Editing ----------------------------------*settings-editing*----------------------------
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

" Indentation and Folding ------------------*settings-indent-fold*------------------------
  set expandtab                             " convert tabs to spaces
  set shiftwidth=4 softtabstop=4 tabstop=8  " tab width
  set shiftround                            " follow tab grid
  set smartindent                           " smarter auto indentation
  set foldlevel=999                         " unfold everything by default
  set foldmethod=indent                     " folding based on indentation
  set cino+=:0,g0,l1,N-s,E-s                " c/cpp indentation

" Search and Completion --------------------*settings-search-completion*------------------
  set path+=**
  set ignorecase smartcase                  " ignore case unless search starts with uppercase
  set inccommand=nosplit                    " :substitute live preview
  set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
  set shortmess+=c                          " silent completion
  set pumheight=25                          " autocompletion popup height
  set completeopt+=noselect                 " no auto-select in completion
  set completeopt+=menuone                  " open popup when there is only one match
  set completeopt-=preview                  " no preview window

" Buffers ----------------------------------*settings-buffer*-----------------------------
  set hidden                                " don't close buffers
  set undofile                              " persistent undo history
  set noswapfile                            " disable swap files

" vim: tw=90 ts=2 sts=2 sw=2 et
