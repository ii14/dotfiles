require('m')

require('m.global')
require('m.keymaps')
require('m.cmd')

if not vim.g.options.NoLsp then
  vim.diagnostic.config { severity_sort = true }
  require('m.lsp')
  require('m.lint')
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

vim.o.termguicolors = true
vim.cmd('colorscheme onedark')

vim.o.showmode = false
require('m.ui.bufferline').setup()
require('m.ui.statusline').setup()

if not vim.g.options.NoCmp then
  require('m.cmp')
end
require('m.lir')
require('m.fzf')

require('gitsigns').setup {
  preview_config = { border = 'none' },
  on_attach = require('m.keymaps').gitsigns,
}

require('Comment').setup { ignore = '^$' }

pcall(require, 'neorepl.cmdline')

local function config(plugin)
  return function(opts)
    for k, v in pairs(opts) do
      vim.g[plugin .. '_' .. k] = v
    end
  end
end

config 'indent_blankline' {
  buftype_exclude = { 'help', 'terminal' },
  filetype_exclude = { '', 'man', 'lir', 'floggraph', 'fugitive', 'gitcommit' },
  show_trailing_blankline_indent = false,
  char = '¦',
}

config 'autosplit' {
  ft = { 'man', 'fugitive', 'gitcommit', 'startuptime' },
  bt = { 'help' },
}

config 'undotree' {
  DiffAutoOpen = 0,
  WindowLayout = 2,
  HelpLine = 0,
  ShortIndicators = 1,
}

config 'vimwiki' {
  key_mappings = { global = 0 },
  list = {{ path = '~/vimwiki/', syntax = 'markdown', ext = '.md' }},
}

config 'targets' {
  aiAI = 'aIAi',
}

config 'termdebug' {
  wide = 1,
}

config 'startuptime' {
  tries = 10,
  sourced = 0,
  event_width = 40,
}

-- do -- exrc.vim
--   vim.g['exrc#names'] = { '.exrc' }

--   local augroup = vim.api.nvim_create_augroup('m_exrc', {})
--   local autocmd = vim.api.nvim_create_autocmd

--   autocmd('BufWritePost', {
--     group = augroup,
--     pattern = '.exrc',
--     nested = true,
--     command = 'silent ExrcTrust',
--   })

--   autocmd('VimEnter', {
--     group = augroup,
--     once = true,
--     callback = function()
--       autocmd('SourcePost', {
--         group = augroup,
--         pattern = '.exrc',
--         command = 'silent Pro!',
--       })
--     end,
--   })
-- end

-- Disable builtin plugins
for _, plugin in ipairs({
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'tutor_mode_plugin',
  '2html_plugin',
  'spellfile_plugin',
  'tarPlugin',
  'zipPlugin',
  'gzip',
}) do
  vim.g['loaded_' .. plugin] = 1
end


-- require('nvim-surround').setup {
--   delimiters = {
--     pairs = {
--       c = { 'const ', '&' },
--     },
--   },
-- }

-- require('hop').setup()

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
