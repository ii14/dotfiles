" no plugins
set noloadplugins

" no syntax. enable with ':syn on' if necessary
filetype off
syntax off

" theme
set termguicolors
colorscheme onedark

" Visual
" set number relativenumber                 " line numbers
" set nowrap                                " don't wrap text
" set colorcolumn=+1                        " text width ruler
set lazyredraw                            " don't redraw while executing macros
set title titlelen=45                     " set vim window title
set titlestring=nvim:\ %F
set shortmess+=I                          " no intro message
set list                                  " show non-printable characters
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set synmaxcol=1000                        " highlight only the first 1000 columns
" set pumblend=13 winblend=13               " pseudo transparency

" Editing
" set textwidth=90
set virtualedit=block                     " move cursor anywhere in visual block mode
set scrolloff=1 sidescrolloff=1           " keep near lines visible when scrolling
set mouse=nvi                             " mouse support
set splitbelow splitright                 " sane splits
set linebreak breakindent                 " visual wrap on whitespace, follow indentation
set diffopt+=iwhite                       " ignore whitespace in diff
set diffopt+=vertical                     " start diff as a vertical split
set nojoinspaces                          " join lines with one space instead of two
set gdefault                              " use g flag by default in substitutions

" Indentation and Folding
set expandtab                             " convert tabs to spaces
set shiftwidth=4 softtabstop=4 tabstop=8  " tab width
set shiftround                            " follow tab grid
set smartindent                           " smarter auto indentation
set foldlevel=999                         " unfold everything by default
set foldmethod=indent                     " folding based on indentation
set cino+=:0,g0,l1,N-s,E-s                " c/cpp indentation

" Search and Autocompletion
set ignorecase smartcase                  " ignore case unless search starts with uppercase
set inccommand=nosplit                    " sed preview
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set shortmess+=c                          " silent completion
set pumheight=25                          " autocompletion popup height
set completeopt+=noselect                 " no auto-select in completion
set completeopt+=menuone                  " open popup when there is only one match
set completeopt-=preview                  " no preview window

" Buffers
set hidden                                " don't close buffers
set undofile                              " persistent undo history
set noswapfile                            " disable swap files

" Grep
if executable('rg')
  set grepformat=%f:%l:%c:%m,%f:%l:%m
  let &grepprg = 'rg --vimgrep' . (&smartcase ? ' --smart-case' : '')
elseif executable('ag')
  set grepformat=%f:%l:%c:%m,%f:%l:%m
  let &grepprg = 'ag --vimgrep' . (&smartcase ? ' --smart-case' : '')
endif


" OVERRIDE DEFAULTS
" Swap 0 and ^
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
" Get rid of annoying stuff
nno q: :
nno Q <Nop>

" WINDOWS
nno <C-H> <C-W>h
nno <C-J> <C-W>j
nno <C-K> <C-W>k
nno <C-L> <C-W>l
nmap <leader>w <C-W>

" BUFFERS
nno <silent> <C-N> :bn<CR>
nno <silent> <C-P> :bp<CR>
nno <leader><leader> :ls<CR>:b

" QUICKFIX
nno <silent> [q :cprev<CR>
nno <silent> ]q :cnext<CR>
nno <silent> [Q :cfirst<CR>
nno <silent> ]Q :clast<CR>
nno <silent> [l :lprev<CR>
nno <silent> ]l :lnext<CR>
nno <silent> [L :lfirst<CR>
nno <silent> ]L :llast<CR>

" REGISTERS
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

" COMMAND
cno <expr> <C-P> wildmenumode() ? '<C-P>' : '<Up>'
cno <expr> <C-N> wildmenumode() ? '<C-N>' : '<Down>'
