local initialized = false

local function init()
  if initialized then return end
  initialized = true

  local config = require('luasnip.config')
  config._setup() -- TODO: remove when loading on demand is implemented in neopm
  config.set_config {
    history = true,
    updateevents = 'TextChanged,TextChangedI',
    ext_base_prio = 200,
    ext_prio_increase = 1,
    enable_autosnippets = true,
  }

  require('m.keymaps').luasnip()
end

local MODULES = {
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

vim.api.nvim_create_autocmd('FileType', {
  desc = 'm.snippets: Loads snippets for current filetype',
  callback = function(ctx)
    init()
    local mod = MODULES[ctx.match]
    if mod then require(mod) end
  end,
  group = vim.api.nvim_create_augroup('m_snippets', {}),
})

return { init = init }
