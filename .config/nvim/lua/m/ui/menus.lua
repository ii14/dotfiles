local M = {}

local function echo(chunks)
  vim.api.nvim_echo(chunks, false, {})
end

function M.bookmarks()
  local bookmarks = vim.g.bookmarks
  if type(bookmarks) ~= 'table' then
    echo {{'Invalid g:bookmarks', 'ErrorMsg'}}
    return
  end

  for _, item in ipairs(bookmarks) do
    local hl
    if item[3] then
      hl = 'Function'
    end
    echo {
      {' [', 'LineNr'},
      {item[1], 'WarningMsg'},
      {'] ', 'LineNr'},
      {item[2], hl},
    }
  end
  echo {{':Files'}}

  local ok, ch = pcall(vim.fn.getchar)
  vim.cmd('redraw')
  if not ok then return end
  if ch == 0 or ch == 27 --[[<Esc>]] then
    return
  elseif ch == 13 --[[<CR>]] then
    vim.cmd('Files')
  elseif ch == 32 --[[<Space>]] then
    vim.api.nvim_feedkeys(':Files ', 'n', false)
  else
    ch = vim.fn.nr2char(ch)
    for _, item in ipairs(bookmarks) do
      local s1, s2 = item[1], nil
      -- make lowercase characters work with ctrl
      if s1:match('^%l$') then
        s2 = T('<C-'..s1..'>')
      end
      if s1 == ch or (s2 and s2 == ch) then
        vim.cmd(item[3] or ('Files '..item[2]))
        return
      end
    end
  end
end

local function get_tab()
  echo {{'Tab width...', 'Question'}}
  local ok, ch = pcall(vim.fn.getchar)
  echo {{''}}
  vim.cmd('redraw')
  if not ok or ch == 0 or ch == 27 or ch == 13 then
    return
  end
  ch = vim.fn.nr2char(ch)
  if not ch:match('^%d$') then
    echo {{'Invalid tab value', 'ErrorMsg'}}
    return
  end
  return tonumber(ch)
end

local options = {
  {'w', 'wrap',         [[setl wrap! | setl wrap?]]},
  {'W', 'wrapscan',     [[set wrapscan! | set wrapscan?]]},
  {'C', 'ignorecase',   [[set ignorecase! | set ignorecase?]]},
  {'s', 'spell',        [[setl spell! | setl spell?]]},
  {'l', 'list',         [[setl list! | setl list?]]},
  {'f', 'folds',        [[setl foldenable! | setl foldenable?]]},
  {'m', 'mouse',        [[let &mouse = (&mouse ==# '' ? 'nvi' : '') | set mouse?]]},
  {'n', 'line numbers', [[call luaeval('require"m.misc".toggle_line_numbers()')]]},
  {'i', 'indent',       [[IndentBlanklineToggle]]},
  {'c', 'colorizer',    [[ColorizerToggle]]},
  {'S', 'syntax',       [[exec 'syntax '..(exists('syntax_on') ? 'off' : 'on')]]},
  {'d', 'diagnostics', function()
    vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
  end},
  {'t', 'soft tabs', function()
    local value = get_tab()
    if not value then return end
    vim.opt_local.expandtab = true
    vim.opt_local.softtabstop = value
    vim.opt_local.shiftwidth = value
    echo {{ (':setl et sw=%d sts=%d'):format(value, value) }}
  end},
  {'T', 'hard tabs', function()
    local value = get_tab()
    if not value then return end
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = value
    echo {{ (':setl noet ts=%d'):format(value) }}
  end},
}

function M.options()
  for _, item in ipairs(options) do
    echo {
      {' [', 'LineNr'},
      {item[1], 'WarningMsg'},
      {'] ', 'LineNr'},
      {item[2]},
    }
  end
  echo {{':set'}}

  local ok, ch = pcall(vim.fn.getchar)
  vim.cmd('redraw')
  if not ok then return end
  if ch == 0 or ch == 27 or ch == 13 then
    return
  elseif ch == 32 then
    vim.api.nvim_feedkeys(':set ', 'n', false)
  else
    ch = vim.fn.nr2char(ch)
    for _, item in ipairs(options) do
      if item[1] == ch then
        local cmd = item[3]
        if type(cmd) == 'function' then
          cmd()
        else
          vim.cmd(cmd)
        end
        return
      end
    end
  end
end

return M
