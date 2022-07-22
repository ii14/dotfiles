local m, api, uv = require('m'), vim.api, vim.loop
local echo = m.echo
local lint

-- TODO: needs a more generic solution
if vim.fn.executable('shellcheck') == 0 then
  return
end

local LINTERS = {
  sh = {'shellcheck'},
}

local DEBOUNCE = 50

local UPDATE_EVENTS = {
  'TextChanged',
  'InsertLeave',
  'BufRead',
}

local attached = {}
local disabled = {}

local augroup = api.nvim_create_augroup('m_lint', {})

local function attach(bufnr, filetype)
  if disabled[bufnr] then return end
  local buf = attached[bufnr]

  -- remove previous diagnostics
  if not LINTERS[filetype] then
    if buf then
      buf.detach()
      buf.clear()
    end
    return
  elseif buf then
    -- skip if already attached
    if buf.filetype == filetype then
      return
    end
    -- clear diagnostics from previous filetype
    buf.clear()
    buf.filetype = filetype
    buf.update()
    return
  end

  local timer = uv.new_timer()
  buf = { filetype = filetype }

  local au1 = api.nvim_create_autocmd(UPDATE_EVENTS, {
    buffer = bufnr,
    desc = 'm.lint: Lint buffer',
    callback = function()
      buf.update()
    end,
    group = augroup,
  })

  local au2 = api.nvim_create_autocmd('BufDelete', {
    buffer = bufnr,
    desc = 'm.lint: Delete buffer',
    callback = function()
      buf.detach()
    end,
    group = augroup,
  })

  buf.update = m.debounce_wrap(function()
    if not lint then
      lint = require('lint')
      lint.linters_by_ft = LINTERS
    end
    api.nvim_buf_call(bufnr, function()
      lint.try_lint()
    end)
  end, DEBOUNCE, false)

  function buf.clear()
    local linters = LINTERS[buf.filetype]
    if not linters then return end
    local nss = api.nvim_get_namespaces()
    for _, linter in ipairs(linters) do
      local ns = nss[linter]
      if ns then
        vim.diagnostic.reset(ns, bufnr)
      end
    end
  end

  function buf.detach()
    api.nvim_del_autocmd(au1)
    api.nvim_del_autocmd(au2)
    timer:stop()
    timer:close()
    attached[bufnr] = nil
  end

  attached[bufnr] = buf
  buf.update()
end

local function disable(bufnr, value)
  if value and not disabled[bufnr] then
    disabled[bufnr] = true
    local buf = attached[bufnr]
    if buf then
      buf.detach()
      buf.clear()
    end
  elseif not value and disabled[bufnr] then
    disabled[bufnr] = nil
    attach(bufnr, api.nvim_buf_get_option(bufnr, 'filetype'))
  end
end

api.nvim_create_autocmd('FileType', {
  desc = 'm.lint: Attach linter',
  callback = function(ctx)
    attach(ctx.buf, ctx.match)
  end,
  group = augroup,
})

api.nvim_create_user_command('Lint', function(ctx)
  local bufnr = api.nvim_get_current_buf()
  if ctx.args == 'on' then
    disable(bufnr, false)
  elseif ctx.args == 'off' then
    disable(bufnr, true)
  elseif ctx.args == '' or ctx.args == 'toggle' then
    disable(bufnr, not disabled[bufnr])
  else
    echo('Lint: invalid option', 'ErrorMsg')
  end
end, {
  desc = 'm.lint: Enable/disable linting for current buffer',
  force = true,
  nargs = '?',
  complete = function(arg, _, _)
    local res = {}
    for _, c in ipairs({'on', 'off', 'toggle'}) do
      if c:sub(1, #arg) == arg then
        res[#res+1] = c
      end
    end
    return res
  end,
})

return {
  attached = attached,
  disabled = disabled,
  attach = attach,
  disable = disable,
}
