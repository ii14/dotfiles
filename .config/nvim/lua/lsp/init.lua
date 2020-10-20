local nvim_lsp = require 'nvim_lsp'
local root_pattern = nvim_lsp.util.root_pattern
local util = require 'lsp/util'
require 'lsp/callbacks'

local configs = require 'nvim_lsp/configs'

local on_attach = util.on_attach


-- C/C++
-- TODO: semantic highlighting in clangd. works fine on ccls.
nvim_lsp.clangd.setup{
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    util.map('n', '<leader>a', ':ClangdSwitchSourceHeader<CR>')
  end;
  cmd = {"clangd", "--background-index"};
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
-- nvim_lsp.sumneko_lua.setup{
--   on_attach = on_attach;
-- }

-- Ruby
-- nvim_lsp.solargraph.setup{
--   on_attach = on_attach;
--   settings = {
--     solargraph = {
--       diagnostics = true;
--     }
--   };
-- }

-- Dlang
-- configs.dls = {
--   default_config = {
--     cmd = {"dls"};
--     filetypes = {"d"};
--     root_dir = root_pattern("dub.sdl", "dub.json");
--   };
-- }
-- nvim_lsp.dls.setup{
--   on_attach = on_attach;
-- }
