require('m')

require('m.global')
require('m.keymaps')

if not vim.g.options.NoLsp then
  require('m.lsp')
  require('m.lint')
  vim.diagnostic.config { severity_sort = true }
end

vim.filetype.add {
  pattern = {
    ['.*/cmus/rc'] = 'cmusrc',
  },
  extension = {
    conf = 'dosini',
  },
}

require('m.snippets')
require('m.term')

require('autosplit')
require('mru')

require('Comment').setup { ignore = '^$' }

-- require('nvim-surround').setup {
--   delimiters = {
--     pairs = {
--       c = { 'const ', '&' },
--     },
--   },
-- }

-- require('hop').setup()

vim.o.termguicolors = true
vim.cmd('colorscheme onedark')

vim.o.showmode = false
require('m.ui.bufferline').setup()
require('m.ui.statusline').setup()

require('gitsigns').setup {
  preview_config = { border = 'none' },
  on_attach = require('m.keymaps').gitsigns,
}

require('m.cmp')
require('m.lir')
require('m.fzf')

-- TODO: lazy load
-- require('diffview.config').setup {
--   use_icons = false,
--   signs = {
--     fold_closed = ">",
--     fold_open = "v",
--   },
--   hooks = {
--     diff_buf_read = function(bufnr)
--       local setopt = vim.api.nvim_win_set_option
--       setopt(0, 'wrap', false)
--       setopt(0, 'list', false)
--       setopt(0, 'number', true)
--       setopt(0, 'relativenumber', false)
--       setopt(0, 'cursorline', true)
--       vim.w.diffview = true
--       vim.defer_fn(function()
--         pcall(vim.api.nvim_buf_call, bufnr, function()
--           vim.cmd('IndentBlanklineRefresh')
--         end)
--       end, 100)
--     end,
--     view_closed = function()
--       vim.cmd('IndentBlanklineRefresh!')
--     end,
--     view_opened = function(view)
--       vim.api.nvim_buf_call(view.panel.bufid, function()
--         vim.cmd('setl signcolumn=auto')
--       end)
--     end,
--   },
-- }
