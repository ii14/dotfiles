local Win = {}

local POSITIONS = {
  h = 'H', H = 'H',
  j = 'J', J = 'J',
  k = 'K', K = 'K',
  l = 'L', L = 'L',
}

local height = 12
local position = 'J'

local function findwin()
  local tabnr = vim.api.nvim_get_current_tabpage()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.tabnr == tabnr and win.variables.drawer ~= nil then
      return win.winid
    end
  end
  return 0
end

function Win.setupwin()
  vim.cmd('wincmd '..position)
  if position == 'J' or position == 'K' then
    vim.api.nvim_win_set_height(0, height)
  end
  vim.cmd('setl winfixheight')
  vim.api.nvim_win_set_var(0, 'drawer', true)
end

function Win.getwin()
  local winid = findwin()
  if winid == 0 then
    vim.cmd('vsplit')
    Win.setupwin()
    return 0
  elseif winid ~= vim.api.nvim_get_current_win() then
    vim.api.nvim_set_current_win(winid)
    return 1
  else
    return 2
  end
end

function Win.resize(h)
  height = h
  if position == 'J' or position == 'K' then
    local winid = findwin()
    if winid ~= 0 then
      vim.api.nvim_win_set_height(winid, height)
    end
  end
end

function Win.move(pos)
  if POSITIONS[pos] == nil then return end
  position = POSITIONS[pos]
  local winid = findwin()
  if winid == 0 then return end
  local win = vim.fn.win_id2win(winid)
  if win == 0 then return end
  vim.cmd(win..'wincmd '..position)
  if position == 'J' or position == 'K' then
    vim.api.nvim_win_set_height(winid, height)
  end
end

function Win._bufwinenter()
  local bufnr = vim.api.nvim_get_current_buf()
  local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
  if buftype == 'quickfix' and vim.b.qf_isLoc ~= 1 then
    -- close other drawer windows
    local tabnr = vim.api.nvim_get_current_tabpage()
    local winid = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.fn.getwininfo()) do
      if win.tabnr == tabnr and win.winid ~= winid and win.variables.drawer ~= nil then
        vim.api.nvim_win_close(win.winid, false)
      end
    end
    Win.setupwin()
  end
end

return Win
