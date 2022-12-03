setl nonumber norelativenumber
setl textwidth=0 colorcolumn=

" setl conceallevel=2 concealcursor=nvic
" setl noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

let b:indent_blankline_enabled = v:false
lua local cmp = require('cmp')
  \ cmp.setup.buffer({
  \   enabled = false,
  \   mappings = cmp.config.disable,
  \ })
" lua local cmp = require('cmp')
"   \ cmp.setup.buffer({
"   \   sources = { { name = 'neorepl' } },
"   \ })
" lua require('neorepl.ext.cmp').default()
