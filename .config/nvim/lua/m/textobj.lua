local fn = vim.fn

local function t(s)
  return vim.api.nvim_replace_termcodes(s, true, false, true)
end

local function indent_obj(inner)
  local lnum = fn.line('.')
  local last = fn.line('$')
  local indent = fn.getline(lnum):find('%S')

  -- if current line is empty, look around for
  -- indentation level and pick the higher one
  if not indent then
    local old = lnum
    for i = old, 1, -1 do
      local v = fn.getline(i):find('%S')
      if v then
        indent = v
        lnum = i
        break
      end
    end

    for i = old, last do
      local v = fn.getline(i):find('%S')
      if v then
        if v > indent then
          indent = v
          lnum = i
        end
        break
      end
    end

    -- bail if there is no intentation
    if not indent then
      return ''
    end
  end

  local func
  if inner then
    func = function(v)
      return v and v < indent
    end
  else
    func = function(v)
      return v and v < indent or false
    end
  end

  local s, e = lnum, lnum

  for i = lnum, 1, -1 do
    local res = func(fn.getline(i):find('%S'))
    if res == true then
      break
    elseif res == false then
      s = i
    end
  end

  for i = lnum, last do
    local res = func(fn.getline(i):find('%S'))
    if res == true then
      break
    elseif res == false then
      e = i
    end
  end

  return t((':<C-U>sil!norm!%dGV%dG<CR>'):format(s, e))
end

return {
  inner_indent = function()
    return indent_obj(true)
  end,
  outer_indent = function()
    return indent_obj(false)
  end,
}
