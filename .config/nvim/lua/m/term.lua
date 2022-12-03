local m, api = require('m'), vim.api
local map = m.map

local augroup = api.nvim_create_augroup('m_term', {})

-- Disable insert mode after process exited ----------------------------------------------
api.nvim_create_autocmd('TermClose', {
  callback = function(ctx)
    vim.b[ctx.buf].term_closed = true -- for :Bd and :Bw

    if ctx.buf == api.nvim_get_current_buf() then
      api.nvim_command('stopinsert')
    end

    api.nvim_create_autocmd('TermEnter', {
      callback = function()
        api.nvim_command('stopinsert')
        vim.schedule(function()
          m.echo('Process exited', 'ErrorMsg')
        end)
      end,
      buffer = ctx.buf,
      desc = 'm.term: disable insert mode',
      group = augroup,
    })
  end,
  desc = 'm.term: disable insert mode',
  nested = true,
  group = augroup,
})

-- Forward escape key --------------------------------------------------------------------
api.nvim_create_autocmd('TermOpen', {
  callback = function(ctx)
    vim.b[ctx.buf].term_fwd_esc = 1
  end,
  desc = 'm.term: setup terminal',
  group = augroup,
})

do
  local REGEX
  local function find_child_proc(pid, accum)
    if accum > 9 then
      return false
    end

    local proc = api.nvim_get_proc(pid)
    if proc then
      REGEX = REGEX or vim.regex([[\v^(n?vim|fzf)]])
      if REGEX:match_str(proc.name) then
        return true
      end
    end

    local children = api.nvim_get_proc_children(pid)
    children[9] = nil -- trim array to 8 elements
    for _, child in ipairs(children) do
      if find_child_proc(child, accum + 1) then
        return true
      end
    end

    return false
  end

  map.t('<Esc>', function()
    local chan = vim.o.channel
    if chan == 0 then
      return '<Esc>'
    end
    local pid = vim.fn.jobpid(chan)
    local override = vim.b.term_fwd_esc
    if override and (override == false or override == 0) then
      return '<C-\\><C-N>'
    end
    return (pid and find_child_proc(pid, 0)) and '<Esc>' or '<C-\\><C-N>'
  end, { nowait = true, silent = true, expr = true })
end

map.t({
  ['<C-\\><Esc>'] = '<Esc>',
  ['<C-\\><C-C>'] = '<Nop>',
})

-- Scroll --------------------------------------------------------------------------------
map.t({
  ['<S-PageUp>']   = [[<C-\><C-N><C-B>]],
  ['<S-PageDown>'] = [[<C-\><C-N><C-F>]],
})
