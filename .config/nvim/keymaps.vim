" OVERRIDE DEFAULTS ----------------------------------------------------------------------
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
" Horizontal scrolling
let s:hscroll = 8
function! s:hscroll(t) abort
  if v:count | let s:hscroll = v:count | endif
  return "\<Esc>"..s:hscroll..a:t
endfunction
nno <expr> zh <SID>hscroll('zh')
nno <expr> zl <SID>hscroll('zl')

" WINDOWS --------------------------------------------------------------------------------
nno <C-H> <C-W>h
nno <C-J> <C-W>j
nno <C-K> <C-W>k
nno <C-L> <C-W>l
nmap <leader>w <C-W>

" BUFFERS --------------------------------------------------------------------------------
nno <silent> <C-N> :bn<CR>
nno <silent> <C-P> :bp<CR>
nno <silent> <C-B> :Buffers<CR>
nno <silent> <leader><leader> :Buffers<CR>

" FILES ----------------------------------------------------------------------------------
" fzf
nno <silent><expr> <leader>f (len(system('git rev-parse')) ? ':Files'
  \ : ':GFiles --exclude-standard --others --cached')."\<CR>"
nno <silent><expr> <leader>F ':Files '.m#bufdir()."\<CR>"
nno <C-F>     :lua require'm.menus'.bookmarks()<CR>
nno <leader>; :lua require'm.menus'.bookmarks()<CR>
nno <leader>h :History<CR>
" Fern
nno <silent><expr> -  ':Fern '.(expand('%') ==# '' ? '.' : '%:h -reveal=%:t').'<CR>'
nno <silent><expr> _  ':Fern . -drawer -toggle'.(expand('%')!=#''?' -reveal=%':'').'<CR>'
nno <silent><expr> g- ':Fern . -drawer'.(expand('%')!=#''?' -reveal=%':'').'<CR>'

" SEARCH AND REPLACE ---------------------------------------------------------------------
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

" MACROS ---------------------------------------------------------------------------------
no <expr> q reg_recording() is# '' ? '\<Nop>' : 'q'
nno <leader>q q

" QUICKFIX -------------------------------------------------------------------------------
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

" REGISTERS ------------------------------------------------------------------------------
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

" GIT ------------------------------------------------------------------------------------
nno <leader>gs :Git<CR>
nno <leader>gl :Flog<CR>
nno <leader>gb :Git blame<CR>
nno <leader>ga :Gwrite<CR>
nno <leader>gd :Gvdiffsplit!<CR>
nno <leader>g2 :diffget //2<CR>
nno <leader>g3 :diffget //3<CR>

" MISC -----------------------------------------------------------------------------------
nno <leader>v ggVG
nno <silent> <leader>r :call fzf#run(fzf#wrap({'source': pro#configs(), 'sink': 'Pro'}))<CR>
nno <leader>o :lua require'm.menus'.options()<CR>
xno <leader>t :Tabularize /
nno m= :Set makeprg<CR>

" LSP ------------------------------------------------------------------------------------
" LSP buffer local mappings in $VIMCONFIG/lsp.vim
nno <silent> <leader>ld :TroubleToggle<CR>
nno <buffer><silent> g? <cmd>lua vim.diagnostic.open_float(0, {scope='line'})<CR>
nno <buffer><silent> ]g <cmd>lua vim.diagnostic.goto_next{float=false}<CR>
nno <buffer><silent> [g <cmd>lua vim.diagnostic.goto_prev{float=false}<CR>
nno <buffer><silent> ]G <cmd>lua vim.diagnostic.goto_prev{float=false,cursor_position={0,0}}<CR>
nno <buffer><silent> [G <cmd>lua vim.diagnostic.goto_next{float=false,cursor_position={0,0}}<CR>

" TERMDEBUG ------------------------------------------------------------------------------
nno <leader>dr :Run<CR>
nno <leader>dS :Stop<CR>
nno <leader>ds :Step<CR>
nno <leader>do :Over<CR>
nno <leader>df :Finish<CR>
nno <leader>dc :Continue<CR>
nno <leader>db :Break<CR>
nno <leader>dB :Clear<CR>
nno <leader>de :Eval<CR>

" INSERT ---------------------------------------------------------------------------------
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
ino <silent> <C-R><C-D> <C-R>=m#bufdir()<CR>
ino <silent> <C-R><C-T> <C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR>
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
" Pairs
ino <C-G><CR> <CR><C-O>O
imap <C-G><C-O> ()<C-G>U<Left>
imap <C-G><C-B> {}<C-G>U<Left>
imap <C-G><C-A> <><C-G>U<Left>
imap <C-G><C-I> ""<C-G>U<Left>

" COMMAND --------------------------------------------------------------------------------
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
" Pairs
cmap <C-G><C-O> ()<Left>
cmap <C-G><C-B> {}<Left>
cmap <C-G><C-A> <><Left>
cmap <C-G><C-I> ""<Left>
cmap <C-G><C-G> \(\)<Left><Left>
cmap <C-G><C-W> \<\><Left><Left>
" Last command with bang
nno !: :<Up>!

" vim: tw=90 ts=2 sts=2 sw=2 et
