local nvim_lsp = require 'nvim_lsp'
local api = vim.api
local root_pattern = nvim_lsp.util.root_pattern

require 'lsp/callbacks'

local on_attach = function(_, bufnr)
  api.nvim_command('setlocal signcolumn=yes')
  api.nvim_command('call VimrcLspOnAttach()')
end

-- C/C++
-- TODO: semantic highlighting in clangd. works fine on ccls.
nvim_lsp.clangd.setup{
  on_attach = on_attach;
  cmd = { "clangd-10", "--background-index" };
}

-- nvim_lsp.ccls.setup{
--   on_attach = on_attach;
--   init_options = {
--     highlight = { lsRanges = true };
--   };
--   root_dir = root_pattern("compile_commands.json");
-- }


-- Python
nvim_lsp.pyls.setup{
  on_attach = on_attach;
  settings = {
    pyls = {
      plugins = {
        mccabe = { enabled = false };
      }
    }
  }
}

-- Golang
nvim_lsp.gopls.setup{
  on_attach = on_attach;
}

-- Lua
nvim_lsp.sumneko_lua.setup{
  on_attach = on_attach;
}
