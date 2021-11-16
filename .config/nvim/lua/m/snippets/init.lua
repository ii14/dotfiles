local M = {}

require('luasnip.config').set_config {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  ext_base_prio = 200,
  ext_prio_increase = 1,
  enable_autosnippets = true,
}

local lookup = {
  c          = 'm.snippets.c',
  cpp        = 'm.snippets.cpp',
  css        = 'm.snippets.css',
  html       = 'm.snippets.html',
  lua        = 'm.snippets.lua',
  make       = 'm.snippets.make',
  javascript = 'm.snippets.js',
  typescript = 'm.snippets.js',
  go         = 'm.snippets.go',
}

function M.require_format(filetype)
  local mod = lookup[filetype]
  if mod then require(mod) end
end

vim.api.nvim_exec([[
  augroup VimrcSnippets
    autocmd!
    autocmd FileType * lua require('m.snippets').require_format(vim.o.filetype)
  augroup end
]], false)

local function imap(lhs, rhs, opts) vim.api.nvim_set_keymap('i', lhs, rhs, opts) end
local function smap(lhs, rhs, opts) vim.api.nvim_set_keymap('s', lhs, rhs, opts) end
local expr = { silent = true, expr = true }
local noremap = { silent = true, noremap = true }

imap('<Tab>',   [[luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>']], expr)
imap('<S-Tab>', [[<cmd>lua require('luasnip').jump(-1)<CR>]], noremap)
smap('<Tab>',   [[<cmd>lua require('luasnip').jump(1)<CR>]],  noremap)
smap('<S-Tab>', [[<cmd>lua require('luasnip').jump(-1)<CR>]], noremap)
-- imap('<C-E>', [[luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<End>']], expr)
-- smap('<C-E>', [[luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<End>']], expr)
imap('<Esc>', [[<Esc><cmd>silent LuaSnipUnlinkCurrent<CR>]], noremap)
smap('<Esc>', [[<Esc><cmd>silent LuaSnipUnlinkCurrent<CR>]], noremap)

return M
