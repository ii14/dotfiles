local util = require 'm.lsp.util'
local m = util.m
-- local lspconfig = require 'lspconfig'
-- local root_pattern = lspconfig.util.root_pattern
require 'm.lsp.callbacks'

m.clangd{
  on_attach = function()
    util.map('n', '<leader>a', ':ClangdSwitchSourceHeader<CR>')
    util.map('n', '<leader>A', ':vs | ClangdSwitchSourceHeader<CR>')
  end,
  cmd = {"clangd", "--background-index"},
}

-- m.ccls{
--   init_options = {
--     highlight = { lsRanges = true };
--   },
--   root_dir = root_pattern("compile_commands.json"),
-- }

m.pyls{
  settings = {
    pyls = {
      plugins = {
        mccabe = { enabled = false },
        -- pycodestyle = { enabled = false },
      },
    },
  },
}

m.gopls{}

local sumneko_root_path = '/opt/lua-language-server'
local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'
m.sumneko_lua{
  cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'},
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim', 'P', 'R'},
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

m.tsserver{}

-- m.denols{
--   -- cmd = {'deno', 'lsp', '-L', 'debug'},
--   init_options = {
--     config = "./tsconfig.json",
--   },
-- }

-- m.solargraph{
--   settings = {
--     solargraph = {
--       diagnostics = true,
--     },
--   },
-- }

m.zls{
  cmd = {'/home/ms/repos/zls/zig-cache/bin/zls'},
}

-- m.kotlin_language_server{
--   root_dir = root_pattern("settings.gradle.kts"),
-- }

require('trouble').setup{
  icons = false,
  fold_open = "v",
  fold_closed = ">",
  signs = {
    error = "E",
    warning = "W",
    hint = "H",
    information = "i",
    other = "-",
  },
}

-- require('symbols-outline').setup{
--   highlight_hovered_item = false,
--   show_guides = true,
-- }
