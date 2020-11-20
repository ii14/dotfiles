local lspconfig = require 'lspconfig'
local root_pattern = lspconfig.util.root_pattern
local util = require 'lsp/util'
require 'lsp/callbacks'

local configs = require 'lspconfig/configs'

local on_attach = util.on_attach


-- C/C++
-- TODO: semantic highlighting in clangd. works fine on ccls.
lspconfig.clangd.setup{
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    util.map('n', '<leader>a', ':ClangdSwitchSourceHeader<CR>')
    util.map('n', '<leader>A', ':vs | ClangdSwitchSourceHeader<CR>')
  end;
  cmd = {"clangd", "--background-index"};
}

-- lspconfig.ccls.setup{
--   on_attach = on_attach;
--   init_options = {
--     highlight = { lsRanges = true };
--   };
--   root_dir = root_pattern("compile_commands.json");
-- }


-- Python
lspconfig.pyls.setup{
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
lspconfig.gopls.setup{
  on_attach = on_attach;
}

-- Lua
-- lspconfig.sumneko_lua.setup{
--   on_attach = on_attach;
-- }

-- Ruby
-- lspconfig.solargraph.setup{
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
-- lspconfig.dls.setup{
--   on_attach = on_attach;
-- }
