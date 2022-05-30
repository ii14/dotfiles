local fn = vim.fn
local api = vim.api

local diag, ns, autocmd
local prev = {}

local function update()
  diag = diag or vim.diagnostic
  ns = ns or api.nvim_create_namespace('qfdiag')

  local all = diag.fromqflist(fn.getqflist())
  local bufs = {}

  for _, item in ipairs(all) do
    local bufnr = item.bufnr
    local buf = bufs[bufnr]

    if buf then
      buf[#buf+1] = item
    elseif bufnr ~= 0 and api.nvim_buf_is_loaded(bufnr) then
      bufs[bufnr] = { item }
    end
  end

  for bufnr, items in pairs(bufs) do
    diag.set(ns, bufnr, items)
    bufs[bufnr], prev[bufnr] = true, nil
  end

  for bufnr in pairs(prev) do
    if api.nvim_buf_is_loaded(bufnr) then
      diag.reset(ns, bufnr)
    end
  end

  prev = bufs
end

local function reset()
  if ns and next(prev) ~= nil then
    diag = diag or vim.diagnostic
    for bufnr in pairs(prev) do
      if api.nvim_buf_is_loaded(bufnr) then
        diag.reset(ns, bufnr)
      end
    end
  end
end

local function enable()
  if not autocmd then
    autocmd = api.nvim_create_autocmd('QuickFixCmdPost', {
      desc = 'Update diagnostics',
      callback = update,
      nested = true,
    })
    update()
  end
end

local function disable()
  if autocmd then
    api.nvim_del_autocmd(autocmd)
    autocmd = nil
    reset()
  end
end

local function toggle()
  if not autocmd then
    enable()
  else
    disable()
  end
end

return {
  update = update,
  reset = reset,
  enable = enable,
  disable = disable,
  toggle = toggle,
}
