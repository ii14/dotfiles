-- Edit register

local api, fn = vim.api, vim.fn

local AUGROUP = api.nvim_create_augroup('m_regedit', { clear = false })

local function run(reg)
  if not reg or reg == '' then
    api.nvim_echo({{'Select register...', 'Question'}}, false, {})
    local ok, ch = pcall(fn.getchar)
    api.nvim_echo({{''}}, false, {})
    vim.cmd('redraw')
    if not ok or ch == 0 or ch == 27 then -- Ctrl-C or Escape
      return
    end
    reg = fn.nr2char(ch)
  end

  assert(type(reg) == 'string', 'expected string')

  if not reg:match('^["0-9a-z]$') then
    api.nvim_err_writeln('Unknown register: ' .. tostring(reg))
    return
  end

  vim.cmd([[
    new
    wincmd J
    resize 1
  ]])

  local buf = api.nvim_get_current_buf()
  local function set(name, value)
    api.nvim_set_option_value(name, value, { buf = buf })
  end

  set('winfixheight', true)
  set('winhighlight', 'SpecialKey:SpecialKey,Whitespace:SpecialKey')

  set('buftype', 'acwrite')
  set('bufhidden', 'wipe')
  set('buflisted', false)
  set('swapfile', false)
  set('undofile', false)
  set('number', false)
  set('relativenumber', false)
  set('wrap', false)
  set('list', false)
  set('colorcolumn', '')

  api.nvim_buf_set_name(buf, 'reg://@' .. reg)
  -- lua is strict about newline characters, viml is not
  vim.cmd(([[call nvim_buf_set_lines(%d, 0, -1, v:false, [@%s])]]):format(buf, reg))
  set('modified', false)

  -- TODO: display tabs as ^I, somehow
  -- set('list', true)
  -- set('listchars', 'tab:^I')
  -- set('expandtab', false)
  -- set('tabstop', 2)
  -- set('shiftwidth', 2)
  -- set('softtabstop', 2)

  api.nvim_buf_set_keymap(buf, 'i', '<CR>', '<C-V><CR>', { noremap = true })
  api.nvim_buf_set_keymap(buf, 'i', '<NL>', '<C-V>000', { noremap = true })
  api.nvim_buf_set_keymap(buf, 'n', '<CR>', '<cmd>x<CR>@' .. reg, { noremap = true })

  api.nvim_clear_autocmds({ group = AUGROUP, buffer = buf })
  api.nvim_create_autocmd('BufWriteCmd', {
    callback = function()
      -- lua is strict about newline characters, viml is not
      vim.cmd(('let @%s = nvim_buf_get_lines(%d, 0, -1, v:false)[0]'):format(reg, buf))
      set('modified', false)
    end,
    desc = 'm.cmd.regedit: write to register @' .. reg,
    buffer = buf,
    group = AUGROUP,
  })
end

return { run = run }
