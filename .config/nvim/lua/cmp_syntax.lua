-- Vim syntax completion

local uv = vim.loop
local cache = {}

local function line_iterator(s)
  local pos = 1
  return function()
    local nl = s:find('\n', pos, true)
    if not nl then
      -- TODO: return last line
      return nil
    end

    while true do
      if not s:find('^[ \t]*\\', nl + 1) then
        break
      end

      local nl2 = s:find('\n', nl + 1, true)
      if not nl2 then break end
      nl = nl2
    end

    local res = s:sub(pos, nl)
    pos = nl + 1
    return res
  end
end

local function scan(filetype)
  local res = {}
  local get_runtime_file = vim.api.nvim_get_runtime_file
  for _, pat in ipairs({
    'syntax/'..filetype..'.vim',
    'syntax/'..filetype..'.lua',
    'syntax/'..filetype..'/**/*.vim',
    'syntax/'..filetype..'/**/*.lua',
  }) do
    for _, path in ipairs(get_runtime_file(pat, true)) do
      res[#res+1] = path
    end
  end
  return res
end

local IGNORE = {
	conceal = true,
	cchar = true,
	contained = true,
	containedin = true,
	nextgroup = true,
	transparent = true,
	skipwhite = true,
	skipnl = true,
	skipempty = true,
}

local function keywords(filetype)
  local res = {}

  for _, f in ipairs(scan(filetype)) do
    local fd = assert(uv.fs_open(f, 'r', 438))
    local stat = assert(uv.fs_fstat(fd))
    local data = assert(uv.fs_read(fd, stat.size, 0))
    assert(uv.fs_close(fd))

    for line in line_iterator(data) do
      local cmd, kwords = line:match('^[%s:]*([a-z]+)%s+keyword%s+[A-Za-z]+%s+(.*)')
      if cmd and cmd == ('syntax'):sub(1, #cmd) then
        for kword in kwords:gmatch('\\?(%S+)') do
          kword = kword:gsub('[%[%]]', '')
          if not kword:find('=') then
            res[kword] = true
          end
        end
      end
    end
  end

  res['\\'] = nil -- quick fix: line breaks are included in results
  for kword in pairs(IGNORE) do
    res[kword] = nil
  end

  res = vim.tbl_keys(res)
  table.sort(res)
  return res
end

local function gather_candidates(filetype)
  filetype = filetype or vim.bo.filetype
  if not filetype or filetype == '' then
    return {}
  end

  local kwords
  if cache[filetype] then
    kwords = cache[filetype]
  else
    kwords = keywords(filetype)
    cache[filetype] = kwords
  end
  return kwords
end

local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end

function source:complete(_, callback)
  local items = {}
  for _, item in ipairs(gather_candidates()) do
    items[#items+1] = { label = item }
  end
  callback(items)
end

return source.new()
