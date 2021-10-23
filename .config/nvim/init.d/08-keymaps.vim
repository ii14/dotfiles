" KEY MAPPINGS /////////////////////////////*keymap*//////////////////////////////////////

" OVERRIDE DEFAULTS ------------------------*keymap-overrides*----------------------------
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

" WINDOWS ----------------------------------*keymap-windows*------------------------------
nno <C-H> <C-W>h
nno <C-J> <C-W>j
nno <C-K> <C-W>k
nno <C-L> <C-W>l
nmap <leader>w <C-W>

" BUFFERS ----------------------------------*keymap-buffers*------------------------------
nno <silent> <C-N> :bn<CR>
nno <silent> <C-P> :bp<CR>

" FILES ------------------------------------*keymap-files*--------------------------------
" *keymap-fzf*
nno <silent><expr> <leader>f (len(system('git rev-parse')) ? ':Files'
  \ : ':GFiles --exclude-standard --others --cached')."\<CR>"
nno <silent><expr> <leader>F ':Files '.m#bufdir()."\<CR>"
nno <leader>; :lua require'm.menus'.bookmarks()<CR>
nno <leader>h :History<CR>
nno <leader><leader> :Buffers<CR>
nno <leader>t :Tags<CR>
" *keymap-fern*
nno <silent><expr> -  ':Fern '.(expand('%') ==# '' ? '.' : '%:h -reveal=%:t').'<CR>'
nno <silent><expr> _  ':Fern . -drawer -toggle'.(expand('%')!=#''?' -reveal=%':'').'<CR>'
nno <silent><expr> g- ':Fern . -drawer'.(expand('%')!=#''?' -reveal=%':'').'<CR>'

" SEARCH AND REPLACE -----------------------*keymap-search-replace*-----------------------
" *keymap-asterisk*
map *   <Plug>(asterisk-*)
map g*  <Plug>(asterisk-g*)
map #   <Plug>(asterisk-#)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)
nmap c*        z*cgn
nmap <leader>c z*cgn
xmap <leader>c z*cgn
nno <silent> <leader><CR> :let @/ = ''<CR>

" MACROS -----------------------------------*keymap-macros*-------------------------------
no <expr> q reg_recording() is# '' ? '\<Nop>' : 'q'
nno <leader>q q

" QUICKFIX ---------------------------------*keymap-quickfix*-----------------------------
nno <silent> qq :call qf#open()<CR>
nno <silent> qt :call qf#toggle()<CR>
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

" REGISTERS --------------------------------*keymap-registers*----------------------------
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

" GIT --------------------------------------*keymap-git*----------------------------------
nno <leader>gs :Git<CR>
nno <leader>gl :Flog<CR>
nno <leader>gb :Git blame<CR>
nno <leader>ga :Gwrite<CR>
nno <leader>gd :Gvdiffsplit!<CR>
nno <leader>g2 :diffget //2<CR>
nno <leader>g3 :diffget //3<CR>

" MISC -------------------------------------*keymap-misc*---------------------------------
nno <leader>v ggVG
nno <silent> <leader>r :call fzf#run(fzf#wrap({'source': pro#configs(), 'sink': 'Pro'}))<CR>
nno <leader>o :lua require'm.menus'.options()<CR>
xno <leader>t :Tabularize /
nno m= :Set makeprg<CR>
nno <expr><silent> <C-]> vtags#can_jump() ? '<cmd>VtagsJump<CR>' : '<C-]>'

" LSP --------------------------------------*keymap-lsp*----------------------------------
" |buffer-lsp-keymap| LSP buffer config
nno <silent> <leader>ld :TroubleToggle<CR>

" TERMDEBUG --------------------------------*keymap-termdebug*----------------------------
nno <leader>dr :Run<CR>
nno <leader>dS :Stop<CR>
nno <leader>ds :Step<CR>
nno <leader>do :Over<CR>
nno <leader>df :Finish<CR>
nno <leader>dc :Continue<CR>
nno <leader>db :Break<CR>
nno <leader>dB :Clear<CR>
nno <leader>de :Eval<CR>

" INSERT -----------------------------------*keymap-insert*-------------------------------
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
" Insert stuff
ino <C-R><C-D> <C-R>=m#bufdir()<CR>
ino <C-R><C-T> <C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR>
" Completion
ino <expr> <C-X><C-X> compe#complete()
ino <expr> <CR>       compe#confirm('<CR>')
ino <expr> <C-Y>      compe#confirm('<C-Y>')
" ino <expr> <C-E>      compe#close('<End>')
ino <expr> <C-E>      <SID>i_ctrl_e()
function! s:i_ctrl_e() abort
  if mode()[0] ==# 'i' && pumvisible()
    if complete_info(['selected']).selected != -1
      return "\<C-e>\<C-r>=luaeval('require\"compe\"._close()')\<CR>"
    else
      return "\<C-e>\<C-r>=luaeval('require\"compe\"._close()')\<CR>\<End>"
    endif
  endif
  return "\<End>"
endfunction
" Snippets
ino <C-G><CR> <CR><C-O>O
imap <C-G>o     ()<C-G>U<Left>
imap <C-G><C-O> ()<C-G>U<Left>
imap <C-G>b     {}<C-G>U<Left>
imap <C-G><C-B> {}<C-G>U<Left>
imap <C-G>a     <><C-G>U<Left>
imap <C-G><C-A> <><C-G>U<Left>
imap <C-G>i     ""<C-G>U<Left>
imap <C-G><C-I> ""<C-G>U<Left>

" COMMAND ----------------------------------*keymap-command*------------------------------
cno <expr> <C-P> wildmenumode() ? '<C-P>' : '<Up>'
cno <expr> <C-N> wildmenumode() ? '<C-N>' : '<Down>'
" Emacs
cno <C-A> <Home>
cno <expr> <C-F> getcmdline() !=# '' ? '<C-R>=m#bf#cforward()<CR>' : '<C-F>'
cno <C-B> <C-R>=m#bf#cbackward()<CR>
" Insert stuff
cno <C-R><C-D> <C-R>=m#bufdir()<CR>
cno <C-R><C-T> <C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR>
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
cmap <C-G>g     \(\)<Left><Left>
cmap <C-G><C-G> \(\)<Left><Left>
cmap <C-G>w     \<\><Left><Left>
cmap <C-G><C-W> \<\><Left><Left>
" Last command with bang
nno !: :<Up>!

" vim: tw=90 ts=2 sts=2 sw=2 et
