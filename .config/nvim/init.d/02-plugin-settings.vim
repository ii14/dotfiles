" PLUGIN SETTINGS //////////////////////////*plugin-settings*/////////////////////////////

" Completion -------------------------------*plugin-completion*---------------------------
  let g:compe = {'source': {
    \ 'path': v:true,
    \ 'calc': v:true,
    \ 'buffer': v:true,
    \ 'necosyntax': v:true,
    \ 'luasnip': v:true,
    \ }}
  " |buffer-lsp-completion| LSP buffer config

" LSP --------------------------------------*plugin-lsp*----------------------------------
  " |lsp-servers| Language servers
  " |buffer-lsp|  LSP buffer config

  if !exists('g:disable_lsp')
    lua require 'm.lsp'
    aug Vimrc
      au User LspAttach source $VIMCONFIG/lsp.vim
      au CursorMoved * lua require 'nvim-lightbulb'.update_lightbulb()
      au TabEnter * call m#lsp_update_tab()
    aug end
  endif

" Snippets ---------------------------------*plugin-snippets*-----------------------------
  lua require 'm.snippets'

" fzf --------------------------------------*plugin-fzf*----------------------------------
  " |keymap-fzf| Key mappings

  let $FZF_DEFAULT_OPTS = join([
    \ '--bind=ctrl-a:select-all,ctrl-u:page-up,ctrl-d:page-down,ctrl-space:toggle',
    \ '--pointer=" "',
    \ '--marker="*"',
    \ ], ' ')

  let g:fzf_action = {
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit',
    \ 'ctrl-t': 'tab split',
    \ }

  let g:fzf_layout = {
    \ 'window': {'width': 1, 'height': 0.45, 'yoffset': 1, 'border': 'none'}
    \ }

  let g:fzf_preview_window = ['right:50%:hidden', '?']

  let g:fzf_colors = {
    \ 'fg'      : ['fg', 'Normal'],
    \ 'bg'      : ['bg', 'Normal'],
    \ 'bg+'     : ['bg', 'Visual'],
    \ 'hl'      : ['fg', 'Identifier'],
    \ 'hl+'     : ['fg', 'Identifier'],
    \ 'gutter'  : ['bg', 'Normal'],
    \ 'info'    : ['fg', 'Comment'],
    \ 'border'  : ['fg', 'LineNr'],
    \ 'prompt'  : ['fg', 'Function'],
    \ 'pointer' : ['fg', 'Exception'],
    \ 'marker'  : ['fg', 'WarningMsg'],
    \ 'spinner' : ['fg', 'WarningMsg'],
    \ 'header'  : ['fg', 'Comment'],
    \ }

" Fern -------------------------------------*plugin-fern*---------------------------------
  " |keymap-fern| Key mappings
  " |buffer-fern| Buffer settings

  let g:loaded_netrw = 1
  let g:loaded_netrwPlugin = 1
  let g:loaded_netrwSettings = 1
  let g:loaded_netrwFileHandlers = 1
  let g:fern#disable_default_mappings = 1
  let g:fern#drawer_width = 32
  let g:fern#renderer#default#collapsed_symbol = '> '
  let g:fern#renderer#default#expanded_symbol = 'v '
  let g:fern#renderer#default#leaf_symbol = '¦ '
  let g:fern#hide_cursor = 1

  fun! s:fern_hijack_directory() abort
    let l:path = expand('%:p')
    if isdirectory(l:path)
      let l:bufnr = bufnr()
      execute printf('keepjumps keepalt Fern %s', fnameescape(l:path))
      execute printf('bwipeout %d', l:bufnr)
    endif
  endfun

  aug Vimrc
    au BufEnter * ++nested call s:fern_hijack_directory()
  aug end

" indent-blankline -------------------------*plugin-indent-blankline*---------------------
  let g:indent_blankline_buftype_exclude = ['help', 'terminal']
  let g:indent_blankline_filetype_exclude = ['man', 'fern', 'floggraph', 'fugitive', 'gitcommit']
  let g:indent_blankline_show_first_indent_level = v:false
  let g:indent_blankline_show_trailing_blankline_indent = v:false
  let g:indent_blankline_char = '¦'

" comment.nvim -----------------------------*plugin-comment*------------------------------
  lua require 'Comment'.setup{ ignore = '^$' }

" exrc.vim ---------------------------------*plugin-exrc*---------------------------------
  let g:exrc#names = ['.exrc']
  aug Vimrc
    au BufWritePost .exrc ++nested silent ExrcTrust
    au SourcePost .exrc silent Pro!
  aug end

" autosplit.vim ----------------------------*plugin-autosplit*----------------------------
  let g:autosplit_ft = ['man', 'fugitive', 'gitcommit']
  let g:autosplit_bt = ['help']

" undotree ---------------------------------*plugin-undotree*-----------------------------
  let g:undotree_DiffAutoOpen = 0
  let g:undotree_WindowLayout = 2
  let g:undotree_HelpLine = 0

" vimwiki ----------------------------------*plugin-vimwiki*------------------------------
  let g:vimwiki_key_mappings = {'global': 0}
  let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" targets.vim ------------------------------*plugin-targets*------------------------------
  let g:targets_aiAI = 'aIAi'

" termdebug --------------------------------*plugin-termdebug*----------------------------
  " |keymap-termdebug| Key mappings
  let g:termdebug_wide = 1

" quickfix-reflector.vim -------------------*plugin-quickfix-reflector*-------------------
  let g:qf_modifiable = 0

" vim: tw=90 ts=2 sts=2 sw=2 et
