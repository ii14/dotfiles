" OVERRIDE DEFAULTS ----------------------------------------------------------------------
" Swap 0 and ^
nno 0 ^
nno ^ 0
" Yank to the end of the line
nno Y y$
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

" Reverse {j,k} and {gj,gk}, unless count is given
nno <expr> j v:count ? 'j' : 'gj'
xno <expr> j v:count ? 'j' : 'gj'
nno <expr> k v:count ? 'k' : 'gk'
xno <expr> k v:count ? 'k' : 'gk'
nno <expr> gj v:count ? 'gj' : 'j'
xno <expr> gj v:count ? 'gj' : 'j'
nno <expr> gk v:count ? 'gk' : 'k'
xno <expr> gk v:count ? 'gk' : 'k'

" Horizontal scrolling
let s:hscroll = 12
function! s:hscroll(t) abort
  if v:count
    let s:hscroll = v:count
    return a:t
  endif
  return s:hscroll..a:t
endfunction
nno <expr> zh <SID>hscroll('zh')
xno <expr> zh <SID>hscroll('zh')
nno <expr> zl <SID>hscroll('zl')
xno <expr> zl <SID>hscroll('zl')

" Vertical scrolling
let s:vscroll = 3
function! s:vscroll(t) abort
  if v:count
    let s:vscroll = v:count
    return a:t
  endif
  return s:vscroll..a:t
endfunction
nno <expr> <C-E> <SID>vscroll('<C-E>')
xno <expr> <C-E> <SID>vscroll('<C-E>')
nno <expr> <C-Y> <SID>vscroll('<C-Y>')
xno <expr> <C-Y> <SID>vscroll('<C-Y>')

" n/N always moves in one direction, center the screen afterwards
function s:centercb(_)
  if s:topline != winsaveview().topline
    norm! zz
    let s:topline = winsaveview().topline
  endif
endfunction
function s:center()
  let s:topline = winsaveview().topline
  call timer_start(0, function('s:centercb'))
endfunction
nno <Plug>(center) <cmd>call <SID>center()<CR>
nno <expr><silent> n '<Plug>(center)'..v:count1..'Nn'[v:searchforward]
nno <expr><silent> N '<Plug>(center)'..v:count1..'nN'[v:searchforward]

" WINDOWS --------------------------------------------------------------------------------
nno <C-H> <C-W>h
nno <C-J> <C-W>j
nno <C-K> <C-W>k
nno <C-L> <C-W>l
nno <C-W>t     <cmd>tab split<CR>
nno <C-W><C-T> <cmd>tab split<CR>
nmap <leader>w <C-W>

" BUFFERS --------------------------------------------------------------------------------
nno <C-N>      <cmd>lua require('m.ui.buf').next()<CR>
nno <C-P>      <cmd>lua require('m.ui.buf').prev()<CR>
nno <C-G><C-N> <cmd>lua require('m.ui.buf').move_right()<CR>
nno <C-G><C-P> <cmd>lua require('m.ui.buf').move_left()<CR>
nno <C-G><C-G> <C-G>
nno <C-B> <cmd>Buffers<CR>

" FILES ----------------------------------------------------------------------------------
" fzf
nno <C-F> :lua require'm.ui.menus'.bookmarks()<CR>
nno <silent><expr> <leader>f (len(system('git rev-parse')) ? ':Files'
  \ : ':GFiles --exclude-standard --others --cached')."\<CR>"
nno <silent><expr> <leader>F ':Files '.m#bufdir()."\<CR>"
" lir
nno <silent> - <cmd>execute 'edit' m#bufdir()[:-2]<CR>

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
nno <leader><CR> <cmd>let @/ = ''<CR>

" MACROS ---------------------------------------------------------------------------------
no <expr> q reg_recording() is# '' ? '\<Nop>' : 'q'
nno <leader>q q
nno qr q
nno qe :Regedit<CR>

" QUICKFIX -------------------------------------------------------------------------------
nno qq <cmd>call m#qf#open()<CR>
nno qt <cmd>call m#qf#toggle()<CR>
nno qo <cmd>call m#qf#show()<CR>
nno qc <cmd>cclose<CR>
" Unimpaired mappings
nno [q <cmd>cprev<CR>
nno ]q <cmd>cnext<CR>
nno [Q <cmd>cfirst<CR>
nno ]Q <cmd>clast<CR>
nno [l <cmd>lprev<CR>
nno ]l <cmd>lnext<CR>
nno [L <cmd>lfirst<CR>
nno ]L <cmd>llast<CR>

" REGISTERS ------------------------------------------------------------------------------
" Paste and keep register
xno <silent> zp  :call <SID>zp()<CR>
xno <silent> zgp :call <SID>zp()<CR>`]<Space>
function! s:zp() abort
  let l:reg = getreginfo('"')
  normal! gvp
  call setreg('"', l:reg)
endfunction
" Yank and leave the cursor just after the new text
nno <expr> gy  GY()
xno <expr> gy  GY()
nno <expr> gY  GY()..'$'
nno <expr> gyy GY()..'_'
function! GY(type = '') abort
  if a:type == ''
    set opfunc=GY
    return 'g@'
  endif
  let c = get({'line': "'[V']", 'char': "`[v`]", 'block': '`[\<C-V>`]'}, a:type, '')
  execute printf("normal! %s\"%sy`]\<Space>", c, v:register)
endfunction
" System clipboard
nno  <leader>y  "+y
nno  <leader>Y  "+y$
nmap <leader>gy "+gy
nmap <leader>gY "+gy$
nno  <leader>p  "+p
nno  <leader>P  "+P
nno  <leader>gp "+gp
nno  <leader>gP "+gP
xno  <leader>y  "+y
xmap <leader>gy "+gy
xno  <leader>p  "+p
xno  <leader>P  "+P
xno  <leader>gp "+gp
xno  <leader>gP "+gP

" TEXT OBJECTS ---------------------------------------------------------------------------
xno <silent> ii :<C-U>exe luaeval('require"m.textobj".inner_indent()')<CR>
ono <silent> ii :<C-U>exe luaeval('require"m.textobj".inner_indent()')<CR>
xno <silent> ai :<C-U>exe luaeval('require"m.textobj".outer_indent()')<CR>
ono <silent> ai :<C-U>exe luaeval('require"m.textobj".outer_indent()')<CR>

" GIT ------------------------------------------------------------------------------------
nno <leader>gs :Git<CR>
nno <leader>gl :Flog<CR>
nno <leader>gb :Git blame<CR>
nno <leader>ga :Gwrite<CR>
nno <leader>gd :DiffviewOpen<CR>
nno <leader>gh :DiffviewFileHistory<CR>
nno <leader>g2 :diffget //2<CR>
nno <leader>g3 :diffget //3<CR>

" MISC -----------------------------------------------------------------------------------
nno <leader>v ggVG
nno <leader>r <cmd>call fzf#run(fzf#wrap({'source': pro#configs(), 'sink': 'Pro'}))<CR>
nno <leader>o :lua require'm.ui.menus'.options()<CR>
xno <leader>t :Align<Space>
nno <leader>n :norm<Space>
xno <leader>n :norm<Space>
nno <leader>N :norm!<Space>
xno <leader>N :norm!<Space>
nno m= :Set makeprg<CR>
nno zI <cmd>IndentBlanklineRefresh<CR>

" LSP ------------------------------------------------------------------------------------
" LSP buffer local mappings in $VIMCONFIG/lsp.vim
nno <leader>ld <cmd>TroubleToggle<CR>
nno g? <cmd>lua vim.diagnostic.open_float(0, {scope='line'})<CR>
nno ]g <cmd>lua vim.diagnostic.goto_next{float=false}<CR>
nno [g <cmd>lua vim.diagnostic.goto_prev{float=false}<CR>
nno ]G <cmd>lua vim.diagnostic.goto_prev{float=false,cursor_position={0,0}}<CR>
nno [G <cmd>lua vim.diagnostic.goto_next{float=false,cursor_position={0,0}}<CR>

" TERMDEBUG ------------------------------------------------------------------------------
nno <leader>dr :Run<CR>
nno <leader>dS :Stop<CR>
nno <leader>ds :Step<CR>
nno <leader>dn :Over<CR>
nno <leader>df :Finish<CR>
nno <leader>dc :Continue<CR>
nno <leader>db :Break<CR>
nno <leader>dB :Clear<CR>
nno <leader>de :Eval<CR>

" INSERT ---------------------------------------------------------------------------------
" Emacs
ino <C-A> <C-O>^
" ino <C-E> <End>
ino <C-F> <cmd>call m#bf#iforward()<CR>
ino <C-B> <cmd>call m#bf#ibackward()<CR>
" Insert stuff
ino <silent> <C-R><C-D> <C-R>=m#bufdir()<CR>
ino <silent> <C-R><C-T> <C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR>
" Completion
ino <expr> <C-X><C-X> compe#complete()
" ino <expr> <CR>       compe#confirm('<CR>')
ino <expr> <CR>       <SID>i_cr()
function! s:i_cr() abort
  let l:res = compe#confirm("\<CR>")
  if l:res !=# "\<CR>"
    let l:res .= "\<CR>"
  endif
  return l:res
endfunction
ino <expr> <C-Y>      compe#confirm('<C-Y>')
" ino <expr> <C-E>      compe#close('<End>')
ino <silent><expr> <C-E>      <SID>i_ctrl_e()
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
cno <C-F> <C-R>=m#bf#cforward()<CR>
cno <C-B> <C-R>=m#bf#cbackward()<CR>
cno <C-D> <Del>
cno <C-O> <C-F>
cno <C-X><C-A> <C-A>
" Insert stuff
cno <C-R><C-D> <C-R>=m#bufdir()<CR>
cno <C-R><C-T> <C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR>
" Remap c_CTRL-{G,T} to free up CTRL-G mapping
cno <C-G><C-N> <C-G>
cno <C-G><C-P> <C-T>
" Pairs
cmap <C-G><C-O> ()<Left>
cmap <C-G><C-B> {}<Left>
cmap <C-G><C-A> <><Left>
cmap <C-G><C-I> ""<Left>
cmap <C-G><C-G> \(\)<Left><Left>
cmap <C-G><C-W> \<\><Left><Left>
" Lua expression
cno <expr> = getcmdtype() == ':' && getcmdline() == '' ? 'lua=' : '='
nno <leader>= :lua=

" Last command with bang
nno <expr> !: histget('cmd')[-1:] !=# '!' ? ':<Up>!' : ':<Up>'
nno <expr> @! len(@:) ? @:[-1:] ==# '!' ? '@:' : '<cmd>exe @:.."!"<CR>' : '<cmd>echoe "E30: No previous command line"<CR>'

" vim: tw=90 ts=2 sts=2 sw=2 et
