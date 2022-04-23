local setup = require('m.lsp.setup')
local util = require('lspconfig.util')

setup.clangd {
  cmd = {'clangd', '--background-index'},
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
  root_dir = function(fname)
    return util.root_pattern('.luarc.json')(fname)
        or util.find_git_ancestor(fname)
  end,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = (function()
          local rtp = vim.split(package.path, ';')
          table.insert(rtp, 'lua/?.lua')
          table.insert(rtp, 'lua/?/init.lua')
          return rtp
        end)(),
      },
      diagnostics = {
        globals = {'vim'},
        disable = {
          'empty-block',
          'trailing-space',
        },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
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
