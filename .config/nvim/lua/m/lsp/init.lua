local util = require 'm.lsp.util'
local setup = util.setup
require 'm.lsp.callbacks'

setup.clangd {
  cmd = {"clangd", "--background-index"},
  commands = {
    ClangdSwitchSourceHeader = {
      function() util.switch_source_header(0) end,
      description = 'Switch between source/header',
    },
  },
}

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
    local root = vim.fn.expand('$HOME')..'/repos/lua-language-server'
    -- local root = '/opt/lua-language-server'
    return { root..'/bin/Linux/lua-language-server', '-E', root..'/main.lua' }
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

do
  local null_ls = require 'null-ls'
  local diagnostics = null_ls.builtins.diagnostics
  null_ls.setup {
    sources = {
      diagnostics.shellcheck.with{ diagnostics_format="[#{c}] #{m}" },
      diagnostics.qmllint.with{ args={"$FILENAME"} },
      diagnostics.php,
    },
  }
end


vim.diagnostic.config {
  severity_sort = true,
}

require 'm.lsp.lightbulb'

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
  padding = false,
}
