local M = {}

local height = 12

local function findwin()
  local tabnr = vim.fn.tabpagenr()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.tabnr == tabnr and win.variables.drawer ~= nil then
      return win.winid
    end
  end
  return 0
end

function M.setupwin()
  vim.cmd('wincmd J')
  vim.api.nvim_win_set_height(0, height)
  vim.cmd('setl winfixheight')
  vim.api.nvim_win_set_var(0, 'drawer', true)
end

function M.getwin()
  local winid = findwin()
  if winid == 0 then
    vim.cmd('vsplit')
    M.setupwin()
    return 0
  elseif winid ~= vim.api.nvim_get_current_win() then
    vim.api.nvim_set_current_win(winid)
    return 1
  else
    return 2
  end
end

function M.resize(h)
  height = h
  local winid = findwin()
  if winid ~= 0 then
    vim.api.nvim_win_set_height(winid, height)
  end
end

function M._bufwinenter()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.fn.getbufvar(bufnr, '&buftype') == 'quickfix' then
    -- close other drawer windows
    local tabnr = vim.fn.tabpagenr()
    local winid = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.fn.getwininfo()) do
      if win.tabnr == tabnr and win.winid ~= winid and win.variables.drawer ~= nil then
        vim.api.nvim_win_close(win.winid, false)
      end
    end
    M.setupwin()
  end
end

function M.term(id)
  require'drawer.term'.term(id)
end

function M.qf()
  require'drawer.qf'.qf()
end

return M
