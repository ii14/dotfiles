local util = require 'm.lsp.util'
local setup = util.setup
-- local lspconfig = require 'lspconfig'
-- local root_pattern = lspconfig.util.root_pattern
require 'm.lsp.callbacks'

require 'lsp_signature'.setup{
  bind = true,
  max_width = 80,
  max_height = 12,
  hint_enable = false,
  hint_prefix = '',
  handler_opts = { border = 'none' },
  toggle_key = '<C-K>',
  doc_lines = 2,
}

setup.clangd{
  cmd = {"clangd", "--background-index"},
  on_attach = function()
    util.map('n', '<leader>a', ':ClangdSwitchSourceHeader<CR>')
  end,
  commands = {
    ClangdSwitchSourceHeader = {
      function() util.switch_source_header(0) end,
      description = 'Switch between source/header',
    },
  },
}

-- setup.ccls{
--   init_options = {
--     highlight = { lsRanges = true };
--   },
--   root_dir = root_pattern("compile_commands.json"),
-- }

setup.pylsp{
  settings = {
    pylsp = {
      plugins = {
        mccabe = { enabled = false },
        -- pycodestyle = { enabled = false },
      },
    },
  },
}

setup.gopls{}

local sumneko_root_path = '/opt/lua-language-server'
local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'
setup.sumneko_lua{
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
          [vim.fn.expand("$VIMCONFIG/lua")] = true,
        },
      },
    },
  },
}

setup.tsserver{}

-- setup.denols{
--   -- cmd = {'deno', 'lsp', '-L', 'debug'},
--   init_options = {
--     config = "./tsconfig.json",
--   },
-- }

-- setup.solargraph{
--   settings = {
--     solargraph = {
--       diagnostics = true,
--     },
--   },
-- }

setup.zls{
  cmd = {'/home/ms/repos/zls/zig-cache/bin/zls'},
}

-- setup.kotlin_language_server{
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
