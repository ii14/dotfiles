" OVERRIDE DEFAULTS //////////////////////////////////////////////////////////////////////
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

" WINDOWS ////////////////////////////////////////////////////////////////////////////////
nno <C-H> <C-W>h
nno <C-J> <C-W>j
nno <C-K> <C-W>k
nno <C-L> <C-W>l
nno <leader>w <C-W>

" BUFFERS ////////////////////////////////////////////////////////////////////////////////
nno <silent> <C-N> :bn<CR>
nno <silent> <C-P> :bp<CR>

" FILES //////////////////////////////////////////////////////////////////////////////////
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

" SEARCH AND REPLACE /////////////////////////////////////////////////////////////////////
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

" MACROS /////////////////////////////////////////////////////////////////////////////////
no <expr> q reg_recording() is# '' ? '\<Nop>' : 'q'
nno <leader>q q

" QUICKFIX ///////////////////////////////////////////////////////////////////////////////
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

" REGISTERS //////////////////////////////////////////////////////////////////////////////
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

" MAKE ///////////////////////////////////////////////////////////////////////////////////
nno m<CR>    :up<CR>:Make<CR>
nno m<Space> :up<CR>:Make<Space>
nno m!       :up<CR>:Make!<CR>
nno m=       :Set makeprg<CR>

" GIT ////////////////////////////////////////////////////////////////////////////////////
nno <leader>gs :Git<CR>
nno <leader>gl :Flog<CR>
nno <leader>gb :Git blame<CR>
nno <leader>ga :Gwrite<CR>
nno <leader>gd :Gvdiffsplit!<CR>
nno <leader>g2 :diffget //2<CR>
nno <leader>g3 :diffget //3<CR>

" MISC ///////////////////////////////////////////////////////////////////////////////////
nno <silent> <leader>r :call fzf#run(fzf#wrap({'source': pro#configs(), 'sink': 'Pro'}))<CR>
xno <leader>t :Tabularize /
nno <leader>v ggVG

" LSP ////////////////////////////////////////////////////////////////////////////////////
" LSP buffer local mappings in $VIMCONFIG/lsp.vim
nno <silent> <leader>ld :LspTroubleToggle<CR>

" TERMDEBUG //////////////////////////////////////////////////////////////////////////////
nno <leader>dr :Run<CR>
nno <leader>dS :Stop<CR>
nno <leader>ds :Step<CR>
nno <leader>do :Over<CR>
nno <leader>df :Finish<CR>
nno <leader>dc :Continue<CR>
nno <leader>db :Break<CR>
nno <leader>dB :Clear<CR>
nno <leader>de :Eval<CR>

" INSERT /////////////////////////////////////////////////////////////////////////////////
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

" COMMAND ////////////////////////////////////////////////////////////////////////////////
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

" OPTIONS ////////////////////////////////////////////////////////////////////////////////
nno <leader>ow :set wrap!<bar>set wrap?<CR>
nno <leader>oW :set wrapscan!<bar>set wrapscan?<CR>
nno <leader>os :set ignorecase!<bar>set ignorecase?<CR>
nno <leader>om :let &mouse = (&mouse ==# '' ? 'a' : '')<bar>set mouse?<CR>
nno <leader>on :call m#command#toggle_line_numbers()<CR>
nno <leader>oi :IndentBlanklineToggle<CR>
nno <leader>oc :ColorizerToggle<CR>
