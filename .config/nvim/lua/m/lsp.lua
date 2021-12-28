local setup = require 'm.lsp.setup'

setup.clangd {
  cmd = {"clangd", "--background-index"},
  commands = {
    ClangdSwitchSourceHeader = {
      function() require('m.lsp.util').switch_source_header(0) end,
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

setup.zls {}

local ok, null_ls = pcall(require, 'null-ls')
if ok then
  local diagnostics = null_ls.builtins.diagnostics
  null_ls.setup {
    on_init = setup.on_init,
    on_attach = setup.on_attach,
    on_exit = setup.on_exit,
    sources = {
      diagnostics.shellcheck.with{
        filetypes = { 'sh', 'bash' }, -- workaround for filetype.nvim bang detection
        diagnostics_format = '[#{c}] #{m}',
      },
      diagnostics.qmllint.with{
        args = { '$FILENAME' },
      },
      diagnostics.php,
    },
  }
end
