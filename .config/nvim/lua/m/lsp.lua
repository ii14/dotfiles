local setup = require('m.lsp.setup')
local util = require('lspconfig.util')
local lazy = require('m').lazy

function setup.on_init()
  require('m.lsp.callbacks')
  require('m.lsp.lightbulb')
  require('fidget').setup{
    text = { spinner = 'dots_scrolling' },
  }
end


setup.clangd {
  cmd = {'clangd', '--background-index'},
  commands = {
    ClangdSwitchSourceHeader = {
      -lazy.require('m.lsp.util').switch_source_header(0),
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
          local rtp = vim.split(package.path, ';', { plain = true })
          rtp[#rtp+1] = './lua/?.lua'
          rtp[#rtp+1] = './lua/?/init.lua'
          return rtp
        end)(),
        pathStrict = true,
      },
      diagnostics = {
        globals = { 'vim' },
        disable = { 'empty-block', 'trailing-space' },
      },
      workspace = {
        library = (function()
          -- local lib = vim.api.nvim_get_runtime_file('', true)
          local lib = {}
          for _, path in ipairs(vim.api.nvim_get_runtime_file('lua', true)) do
            lib[#lib+1] = path:sub(1, -5)
          end
          lib[#lib+1] = vim.env.HOME..'/dev/lua/nvim-lua-language-server'
          return lib
        end)(),
        -- ignoreSubmodules = true,
        -- useGitIgnore = true,
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}

setup.tsserver {}

setup.gopls {}

setup.zls {
  cmd = { vim.env.HOME..'/repos/zls/zig-out/bin/zls' },
}
