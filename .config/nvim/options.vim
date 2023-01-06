" Visual ---------------------------------------------------------------------------------
set number relativenumber         " line numbers
set nowrap                        " no text wrapping
set colorcolumn=+1                " text width ruler
set lazyredraw                    " don't redraw while executing macros
set title titlelen=45             " set vim window title
set titlestring=nvim:\ %F
set shortmess+=I                  " no intro message
set list                          " show non-printable characters
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set fillchars=diff:╱
set synmaxcol=1500                " highlight only the first 1500 columns
set pumblend=13                   " pseudo transparency for popup windows

" Editing --------------------------------------------------------------------------------
set textwidth=90
set virtualedit=block             " move cursor anywhere in visual block mode
set scrolloff=1 sidescrolloff=1   " keep near lines visible when scrolling
set mouse=nvi                     " enable mouse, disable for command line
set mousemodel=extend             " disable right click popup menu
set splitbelow splitright         " new splits to the right and bottom
set linebreak breakindent         " visual wrap on whitespace, follow indentation
set diffopt+=iwhite               " ignore whitespace in diff
set diffopt+=vertical             " start diff as a vertical split
set nojoinspaces                  " join lines with one space instead of two
set gdefault                      " use g flag by default in substitutions
set backspace=indent,start        " no backspacing over eol
set switchbuf+=useopen            " qf: jump to window with the buffer open
set formatoptions+=/
" set scrolljump=-50                " center window after jumps

" Indentation and Folding ----------------------------------------------------------------
set expandtab                     " convert tabs to spaces
set ts=8 sw=4 sts=-1              " tab width
set shiftround                    " follow tab grid
set smartindent                   " smarter auto indentation
set cino+=:0,g0,l1,N-s,E-s        " c/cpp indentation
set foldlevel=999                 " unfold everything by default
set foldmethod=indent             " folding based on indentation

" Search and Completion ------------------------------------------------------------------
set ignorecase smartcase          " ignore case unless search starts with uppercase
set inccommand=nosplit            " :substitute live preview
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set shortmess+=c                  " silent completion
set pumheight=25                  " autocompletion popup height
set completeopt+=noselect         " no auto-select in completion
set completeopt+=menuone          " open popup when there is only one match
set completeopt-=preview          " no preview window

" Buffers --------------------------------------------------------------------------------
set hidden                        " don't close buffers
set undofile                      " persistent undo history
set noswapfile                    " disable swap files

if luaeval('vim.secure ~= nil')   " actually secure exrc
  set exrc
endif
