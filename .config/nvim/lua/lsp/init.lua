local lspconfig = require 'lspconfig'
local util = require 'lsp/util'
require 'lsp/callbacks'

local on_attach = util.on_attach
-- local root_pattern = lspconfig.util.root_pattern


lspconfig.clangd.setup{
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    util.map('n', '<leader>a', ':ClangdSwitchSourceHeader<CR>')
    util.map('n', '<leader>A', ':vs | ClangdSwitchSourceHeader<CR>')
  end,
  cmd = {"clangd", "--background-index"},
}

-- lspconfig.ccls.setup{
--   on_attach = on_attach;
--   init_options = {
--     highlight = { lsRanges = true };
--   };
--   root_dir = root_pattern("compile_commands.json");
-- }

lspconfig.pyls.setup{
  on_attach = on_attach,
  settings = {
    pyls = {
      plugins = {
        mccabe = { enabled = false },
        -- pycodestyle = { enabled = false },
      },
    },
  },
}

lspconfig.gopls.setup{
  on_attach = on_attach,
}

local sumneko_root_path = '/opt/lua-language-server'
local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'
lspconfig.sumneko_lua.setup{
  on_attach = on_attach,
  cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'},
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua/")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
      },
    },
  },
}

-- lspconfig.denols.setup{
--   on_attach = on_attach,
--   -- cmd = {'deno', 'lsp', '-L', 'debug'},
--   init_options = {
--     config = "./tsconfig.json",
--   },
-- }

-- lspconfig.solargraph.setup{
--   on_attach = on_attach,
--   settings = {
--     solargraph = {
--       diagnostics = true,
--     },
--   },
-- }
