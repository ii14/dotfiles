local Drawer = require 'drawer'

local Term = {}

local terms = {}

local function tmap(lhs, rhs)
  vim.api.nvim_buf_set_keymap(0, 't', lhs, rhs, { silent = true })
end

function Term.getterm(id)
  if terms[id] == nil then
    vim.cmd('enew')
    local title = 'Term '..id
    vim.fn.termopen(vim.o.shell, { env = { TITLE = title } })
    vim.api.nvim_buf_set_var(0, 'term_title', title)
    vim.cmd('autocmd TermClose <buffer> ++nested lua require"drawer.term"._termclose('..id..')')
    vim.cmd('setl nobuflisted signcolumn=no')
    terms[id] = vim.api.nvim_get_current_buf()

    tmap('<F1>', [[<cmd>lua require"drawer".term(1)<CR>]])
    tmap('<F2>', [[<cmd>lua require"drawer".term(2)<CR>]])
    tmap('<F3>', [[<cmd>lua require"drawer".term(3)<CR>]])
    tmap('<F4>', [[<cmd>lua require"drawer".term(4)<CR>]])
    tmap('<F5>', [[<cmd>lua require"drawer".qf()<CR>]])

    vim.cmd('startinsert')
    return 0
  end

  local bufnr = terms[id]
  if bufnr == vim.api.nvim_get_current_buf() then
    return 2
  end

  vim.cmd(bufnr..'b')
  vim.cmd('startinsert')
  return 1
end

function Term.term(id)
  local a = Drawer.getwin()
  local b = Term.getterm(id)
  if a == 2 and b == 2 then
    vim.cmd('close')
  end
end

function Term._termclose(id)
  local bufnr = terms[id]
  if bufnr ~= nil then
    pcall(vim.cmd, bufnr..'bdelete!')
    terms[id] = nil
  end
end

return Term
