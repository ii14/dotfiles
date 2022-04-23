local M = {}

local SIGN_GROUP = 'lightbulb'
local SIGN_NAME = 'LightBulbSign'
local DEBOUNCE = 500
local PRIORITY = 20

local timer = vim.loop.new_timer()
local sign_bufnr = nil
local sign_line = nil

local function has_capability(bufnr)
  local lsp = rawget(vim, 'lsp')
  if lsp then
    for _, client in pairs(lsp.buf_get_clients(bufnr)) do
      if client.supports_method('textDocument/codeAction') then
        return true
      end
    end
  end
  return false
end

local function update_sign(bufnr, line)
  if bufnr == sign_bufnr and sign_line == line then
    return
  end

  if sign_bufnr and sign_line then
    vim.fn.sign_unplace(SIGN_GROUP, { id = sign_line, buffer = sign_bufnr })
    sign_bufnr = nil
    sign_line = nil
  end

  if bufnr and line then
    vim.fn.sign_place(line, SIGN_GROUP, SIGN_NAME, bufnr, { lnum = line, priority = PRIORITY })
    sign_bufnr = bufnr
    sign_line = line
  end
end

local function mk_handler(bufnr, line)
  return function(responses)
    for _, resp in pairs(responses) do
      if resp.result and not vim.tbl_isempty(resp.result) then
        update_sign(bufnr, line + 1)
        return
      end
    end
    update_sign()
  end
end

local function update()
  if not has_capability() then return end
  local params = vim.lsp.util.make_range_params()
  params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
  local handler = mk_handler(vim.api.nvim_get_current_buf(), params.range.start.line)
  vim.lsp.buf_request_all(0, 'textDocument/codeAction', params, handler)
end

function M.update()
  timer:stop()
  update_sign()
  timer:start(DEBOUNCE, 0, function()
    timer:stop()
    vim.schedule(update)
  end)
end

vim.api.nvim_create_autocmd('CursorMoved', {
  desc = '[LSP] Update lightbulb',
  callback = function() M.update() end,
  group = vim.api.nvim_create_augroup('VimrcLightbulb', {}),
})

return M
