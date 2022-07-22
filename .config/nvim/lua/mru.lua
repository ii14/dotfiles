-- Most recently used files

local api, fn, uv = vim.api, vim.fn, vim.loop

-- TODO: debounce
-- TODO: check for --headless

local FILES = {}
local MAX_FILES = 50
local MRU_PATH = fn.stdpath('cache')..'/mru'
local TMP_PATH = MRU_PATH..'_'..tostring(assert(uv.getpid()))

local augroup = api.nvim_create_augroup('mru', {})
local autocmd = api.nvim_create_autocmd

local function read()
  local file = io.open(MRU_PATH, 'rb')
  if file then
    FILES = vim.split(file:read('*a'), '\n', { plain = true, trimempty = true })
    file:close()
  end
end

local function write()
  local file = io.open(TMP_PATH, 'w+b')
  if file then
    file:write(table.concat(FILES, '\n'))
    file:flush()
    file:close()
    assert(uv.fs_rename(TMP_PATH, MRU_PATH))
  end
end

local function get()
  for i = #FILES, 1, -1 do
    if not uv.fs_stat(FILES[i]) then
      table.remove(FILES, i)
    end
  end
  return FILES
end

read()

autocmd('BufEnter', {
  group = augroup,
  desc = 'mru: add file',
  callback = function(ctx)
    if api.nvim_buf_get_option(ctx.buf, 'buftype') ~= '' then
      return
    end

    local file = ctx.file
    if not file or file == '' then return end

    file = uv.fs_realpath(ctx.file)
    if not file then return end

    for i = #FILES, 1, -1 do
      if FILES[i] == file then
        table.remove(FILES, i)
        break
      end
    end

    table.insert(FILES, 1, file)

    for i = MAX_FILES + 1, #FILES do
      FILES[i] = nil
    end
  end,
})

autocmd({'FocusLost', 'VimSuspend', 'VimLeavePre'}, {
  group = augroup,
  desc = 'mru: write',
  callback = write,
})

autocmd({'FocusGained', 'VimResume'}, {
  group = augroup,
  desc = 'mru: read',
  callback = read,
})

return {
  get = get,
  read = read,
  write = write,
}
