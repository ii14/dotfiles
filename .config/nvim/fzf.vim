let $FZF_DEFAULT_OPTS =
  \ '--bind=ctrl-a:select-all,ctrl-u:page-up,ctrl-d:page-down,ctrl-space:toggle'

let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-t': 'tab split',
  \ }

let g:fzf_layout = {
  \ 'window': {'width': 0.9, 'height': 0.6, 'border': 'sharp'},
  \ }

let g:fzf_colors = {
  \ 'fg'      : ['fg', 'Normal'],
  \ 'bg'      : ['bg', 'Normal'],
  \ 'hl'      : ['fg', 'Comment'],
  \ 'fg+'     : ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+'     : ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+'     : ['fg', 'Statement'],
  \ 'info'    : ['fg', 'PreProc'],
  \ 'border'  : ['fg', 'LineNr'],
  \ 'prompt'  : ['fg', 'Function'],
  \ 'pointer' : ['fg', 'Exception'],
  \ 'marker'  : ['fg', 'Keyword'],
  \ 'spinner' : ['fg', 'Label'],
  \ 'header'  : ['fg', 'Comment'],
  \ }
