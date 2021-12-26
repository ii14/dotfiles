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

  local ch = vim.fn.getchar()
  vim.cmd('redraw')
  if ch == 0 or ch == 27 --[[<Esc>]] then
    return
  elseif ch == 13 --[[<CR>]] then
    vim.cmd('Files')
  elseif ch == 32 --[[<Space>]] then
    vim.api.nvim_feedkeys(':Files ', 'n', false)
  else
    ch = vim.fn.nr2char(ch)
    for _, item in ipairs(bookmarks) do
      if item[1] == ch then
        vim.cmd(item[3] or ('Files '..item[2]))
        return
      end
    end
  end
end

local options = {
  {'w', 'wrap',       [[set wrap! | set wrap?]]},
  {'W', 'wrapscan',   [[set wrapscan! | set wrapscan?]]},
  {'s', 'ignorecase', [[set ignorecase! | set ignorecase?]]},
  {'l', 'list',       [[set list! | set list?]]},
  {'m', 'mouse',      [[let &mouse = (&mouse ==# '' ? 'nvi' : '') | set mouse?]]},
  {'n', 'number',     [[call m#command#toggle_line_numbers()]]},
  {'i', 'indent',     [[IndentBlanklineToggle]]},
  {'c', 'colorizer',  [[ColorizerToggle]]},
  {'S', 'syntax',     [[exec 'syntax '..(exists('syntax_on') ? 'off' : 'on')]]},
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

  local ch = vim.fn.getchar()
  vim.cmd('redraw')
  if ch == 0 or ch == 27 or ch == 13 then
    return
  elseif ch == 32 then
    vim.api.nvim_feedkeys(':set ', 'n', false)
  else
    ch = vim.fn.nr2char(ch)
    for _, item in ipairs(options) do
      if item[1] == ch then
        vim.cmd(item[3])
        return
      end
    end
  end
end

return M
