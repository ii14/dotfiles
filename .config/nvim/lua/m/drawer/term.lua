local Term = {}

local terms = {}

local function tmap(lhs, rhs)
  vim.api.nvim_buf_set_keymap(0, 't', lhs, rhs, { silent = true })
end

function Term.getterm(id)
  if terms[id] == nil then
    vim.cmd('enew')
    local title = 'Term '..id
    local job = vim.fn.termopen(vim.o.shell, { env = { TITLE = title } })
    vim.api.nvim_buf_set_var(0, 'term_title', title)
    vim.cmd('autocmd TermClose <buffer> ++nested lua require"m.drawer.term"._termclose('..id..')')
    vim.cmd('setl nobuflisted signcolumn=no')
    terms[id] = {
      bufnr = vim.api.nvim_get_current_buf(),
      job = job,
    }

    tmap('<F1>', [[<cmd>lua require"m.drawer.term".term(1)<CR>]])
    tmap('<F2>', [[<cmd>lua require"m.drawer.term".term(2)<CR>]])
    tmap('<F3>', [[<cmd>lua require"m.drawer.term".term(3)<CR>]])
    tmap('<F4>', [[<cmd>lua require"m.drawer.term".term(4)<CR>]])
    tmap('<F5>', [[<cmd>lua require"m.drawer.qf".qf()<CR>]])

    vim.cmd('startinsert')
    return 0
  end

  local bufnr = terms[id].bufnr
  if bufnr == vim.api.nvim_get_current_buf() then
    return 2
  end

  vim.cmd(bufnr..'b')
  vim.cmd('startinsert')
  return 1
end

function Term.term(id)
  local a = require('m.drawer.win').getwin()
  local b = Term.getterm(id)
  if a == 2 and b == 2 then
    vim.cmd('stopinsert')
    vim.cmd('close')
  end
end

function Term.send(id, keys)
  local term = terms[id]
  if term == nil then return end
  vim.fn.chansend(term.job, vim.api.nvim_replace_termcodes(keys, true, false, true))
end

function Term._termclose(id)
  local term = terms[id]
  if term ~= nil then
    pcall(vim.cmd, term.bufnr..'bdelete!')
    terms[id] = nil
  end
end

return Term
