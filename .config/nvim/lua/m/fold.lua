-- folding for init.vim

local api = vim.api
local fn = vim.fn
local v = vim.v

local M = {}

M._cache = {}

local HEADING1 = [[^" (.*) ///*]]
local HEADING2 = [[^  " (.*) [-][-][-]*]]

-- TODO: make it incremental?
-- so far there are no performance issues though
local parse = function(lines)
  local len = #lines
  local level = 0

  for i, line in pairs(lines) do
    if line:match(HEADING1) then
      level = 1
      lines[i] = '>1'
      goto next
    end

    if (level == 1 or level == 2) and line:match(HEADING2) then
      level = 2
      lines[i] = '>2'
      goto next
    end

    if level == 1 then
      if line:match('^  .') then
        level = 1
        lines[i] = 1
        goto next
      elseif line:match('^%s*$') then
        local j = i
        while j < len do
          j = j + 1
          local nline = lines[j]
          if nline:match('^%s*$') then
          elseif nline:match('^  .') then
            level = 1
            lines[i] = 1
            goto next
          else
            level = 0
            lines[i] = 0
            goto next
          end
        end
      end
    elseif level == 2 then
      if line:match('^    .') then
        level = 2
        lines[i] = 2
        goto next
      elseif line:match('^%s*$') then
        local j = i
        while j < len do
          j = j + 1
          local nline = lines[j]
          if nline:match('^%s*$') then
          elseif nline:match('^    .') or nline:match(HEADING2) then
            level = 2
            lines[i] = 2
            goto next
          elseif nline:match('^  .') then
            level = 1
            lines[i] = 1
            goto next
          else
            level = 0
            lines[i] = 0
            goto next
          end
        end
      end
    end

    level = 0
    lines[i] = 0
    ::next::
  end

  return lines
end

M.update = function(bufnr)
  if bufnr == nil or bufnr == 0 then
    bufnr = api.nvim_get_current_buf()
  end
  local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  M._cache[bufnr] = parse(lines)
end

M.foldexpr = function(lnum)
  local bufnr = api.nvim_get_current_buf()
  if M._cache[bufnr] == nil then
    M.update(bufnr)
  end
  return M._cache[bufnr][lnum] or 0
end

M.foldtext = function()
  local foldstart = v.foldstart
  local foldlevel = v.foldlevel

  local line = api.nvim_buf_get_lines(0, foldstart - 1, foldstart, false)
  if line == nil then return '' end
  line = line[1]

  if foldlevel == 1 then
    local header = line:match(HEADING1)
    if header == nil then return line end
    local lhs = '> ' .. header .. ' '
    local rhs = ' (' .. v.foldend - foldstart .. ' lines)'
    local pad = api.nvim_buf_get_option(0, 'textwidth') - #lhs - #rhs
    return lhs .. fn['repeat']('/', pad) .. rhs
  elseif foldlevel == 2 then
    local header = line:match(HEADING2)
    if header == nil then return line end
    local lhs = '  > ' .. header .. ' '
    local rhs = ' (' .. v.foldend - foldstart .. ' lines)'
    local pad = api.nvim_buf_get_option(0, 'textwidth') - #lhs - #rhs
    return lhs .. fn['repeat']('-', pad) .. rhs
  end

  return line
end

M.show_toc = function()
  local bufnr = api.nvim_get_current_buf()

  local toc = {}
  for lnum, line in ipairs(api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    local match

    match = line:match(HEADING1)
    if match then
      table.insert(toc, { bufnr = bufnr, lnum = lnum, text = match })
      goto next
    end

    match = line:match(HEADING2)
    if match then
      table.insert(toc, { bufnr = bufnr, lnum = lnum, text = '  '..match })
      goto next
    end

    ::next::
  end

  fn.setloclist(bufnr, toc, ' ')
  fn.setloclist(bufnr, {}, 'a', {title = 'Vimrc TOC'})
  vim.cmd('lopen')
end

M.attach = function()
  local bufnr = api.nvim_get_current_buf()

  vim.cmd([[let &l:foldmethod = 'expr']])
  vim.cmd([[let &l:foldexpr = 'luaeval(printf("require\"m.fold\".foldexpr(%d)", v:lnum))']])
  vim.cmd([[let &l:foldtext = 'luaeval("require\"m.fold\".foldtext()")']])
  vim.cmd([[let &l:foldlevel = 2]])
  vim.cmd([[let &l:fillchars = 'fold: ']])

  api.nvim_buf_set_keymap(0, 'n', 'gO',
    [[<cmd>lua require 'm.fold'.show_toc()<CR>]],
    { noremap = true, silent = true })

  api.nvim_buf_attach(bufnr, false, {
    on_lines = function()
      M.update(bufnr)
    end,
    on_reload = function()
      M.update(bufnr)
    end,
    on_detach = function()
      M._cache[bufnr] = nil
    end,
  })
end

api.nvim_exec([[
  augroup VimrcFold
    autocmd!
    autocmd FileType vim ++nested if expand('%:p') == $MYVIMRC | call luaeval('require"m.fold".attach()') | endif
  augroup end
]], false)

return M
