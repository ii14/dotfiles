local api = vim.api
local augroup = api.nvim_create_augroup('VimrcLspSetup', { clear = true })
local M = {}

local initialized = false
local function on_init()
  if not initialized then
    initialized = true
    if M.on_init then
      M.on_init()
    end
  end
end

api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  callback = function(args)
    local bufnr = args.buf
    local id = args.data.client_id

    vim.g.lsp_event = {
      event = 'attach',
      bufnr = bufnr,
      client_id = id,
      client_name = vim.lsp.get_client_by_id(id).name,
    }

    api.nvim_buf_call(bufnr, function()
      vim.opt_local.signcolumn = 'yes'
      for _, win in ipairs(api.nvim_list_wins()) do
        if api.nvim_win_get_buf(win) == bufnr then
          api.nvim_win_call(win, function()
            vim.opt_local.signcolumn = 'yes'
          end)
        end
      end
      vim.cmd('source '..vim.env.VIMCONFIG..'/lsp.vim')
    end)
  end,
})

api.nvim_create_autocmd('LspDetach', {
  group = augroup,
  callback = function(args)
    local bufnr = args.buf

    local active = vim.lsp.get_active_clients({ bufnr = bufnr })
    active[args.data.client_id] = nil
    if next(active) ~= nil then return end

    api.nvim_buf_call(bufnr, function()
      local global = vim.opt_global.signcolumn:get()
      vim.opt_local.signcolumn = global
      for _, win in ipairs(api.nvim_list_wins()) do
        if api.nvim_win_get_buf(win) == bufnr then
          api.nvim_win_call(win, function()
            vim.opt_local.signcolumn = global
          end)
        end
      end
    end)
  end,
})

local SPECIAL_KEYS = { on_init = true }

return setmetatable(M, {
  __index = function(t, k)
    if SPECIAL_KEYS[k] then
      return rawget(t, k)
    end

    assert(type(k) == 'string', 'invalid key')
    local server = require('lspconfig')[k]
    assert(server ~= nil, 'config does not exist: '..k)

    local function setup(config)
      if not config.on_init then
        config.on_init = on_init
      else
        local prev_init = config.on_init
        config.on_init = function(...)
          on_init()
          prev_init(...)
        end
      end
      server.setup(config)
    end

    rawset(t, k, setup)
    return setup
  end,
  __newindex = function(t, k, v)
    assert(SPECIAL_KEYS[k], 'invalid key')
    assert(type(v) == 'function', 'invalid value')
    rawset(t, k, v)
  end,
})
