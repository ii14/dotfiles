let $FZF_DEFAULT_OPTS =
  \ '--bind=ctrl-a:select-all,ctrl-u:page-up,ctrl-d:page-down,ctrl-space:toggle --pointer=" "'

let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-t': 'tab split',
  \ }

" let g:fzf_layout = {
"   \ 'window': {'width': 0.9, 'height': 0.8, 'border': 'sharp'},
"   \ }
let g:fzf_layout = {
  \ 'window': {'width': 1, 'height': 0.45, 'yoffset': 1, 'border': 'none'}
  \ }

let g:fzf_preview_window = ['right:50%:hidden', '?']

let g:fzf_colors = {
  \ 'fg'      : ['fg', 'Normal'],
  \ 'bg'      : ['bg', 'Normal'],
  \ 'bg+'     : ['bg', 'Visual'],
  \ 'hl'      : ['fg', 'ErrorMsg'],
  \ 'hl+'     : ['fg', 'ErrorMsg'],
  \ 'gutter'  : ['bg', 'Normal'],
  \ 'info'    : ['fg', 'Comment'],
  \ 'border'  : ['fg', 'LineNr'],
  \ 'prompt'  : ['fg', 'Function'],
  \ 'pointer' : ['fg', 'Exception'],
  \ 'marker'  : ['fg', 'WarningMsg'],
  \ 'spinner' : ['fg', 'WarningMsg'],
  \ 'header'  : ['fg', 'Comment'],
  \ }
