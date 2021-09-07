local util = require 'm.lsp.util'
local setup = util.setup
-- local lspconfig = require 'lspconfig'
-- local root_pattern = lspconfig.util.root_pattern
require 'm.lsp.callbacks'

setup.clangd {
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

-- setup.ccls {
--   init_options = {
--     highlight = { lsRanges = true };
--   },
--   root_dir = root_pattern("compile_commands.json"),
-- }

setup.pylsp {
  settings = {
    pylsp = {
      plugins = {
        mccabe = { enabled = false },
        -- pycodestyle = { enabled = false },
      },
    },
  },
}

setup.sumneko_lua {
  cmd = (function()
    -- local root = vim.fn.expand('$HOME')..'/repos/lua-language-server'
    local root = '/opt/lua-language-server'
    return { root..'/bin/Linux/lua-language-server', '-E', root .. '/main.lua' }
  end)(),
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = (function()
          local runtime_path = vim.split(package.path, ';')
          table.insert(runtime_path, "lua/?.lua")
          table.insert(runtime_path, "lua/?/init.lua")
          return runtime_path
        end)(),
      },
      diagnostics = { globals = {'vim'} },
      workspace = { library = vim.api.nvim_get_runtime_file("lua/", true) },
      telemetry = { enable = false },
    },
  },
}

setup.tsserver {}

setup.gopls {}

-- setup.zls {
--   cmd = {'/home/ms/repos/zls/zig-cache/bin/zls'},
-- }

require 'trouble'.setup {
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

require 'lsp_signature'.setup {
  bind = true,
  max_width = 80,
  max_height = 12,
  hint_enable = false,
  hint_prefix = '',
  handler_opts = { border = 'none' },
  toggle_key = '<C-K>',
  doc_lines = 2,
}
