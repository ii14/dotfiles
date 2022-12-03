-- Most recently used files

local api, fn, uv = vim.api, vim.fn, vim.loop

-- TODO: don't run with --headless
-- TODO: cache real paths for buffers?

local FILES = {} -- current list
local LAST_FILES -- last known list written to file
local SYNC = false -- needs to read the list from file if false
local AUGROUP = api.nvim_create_augroup('mru', {})

local MAX_FILES = 100
local MRU_PATH = fn.stdpath('cache')..'/mru'
local TMP_PATH = MRU_PATH..'.'..tostring(assert(uv.getpid()))

---Filter table in place
---@generic T
---@param t T[]
---@param f fun(T): boolean
---@return T[]
local function filter(t, f)
  local len = #t
  local j = 1
  for i = 1, len do
    t[j], t[i] = t[i], nil
    if f(t[j]) then
      j = j + 1
    end
  end
  for i = j, len do
    t[i] = nil
  end
  return t
end

local function sync()
  if SYNC then return end
  SYNC = true

  local file = io.open(MRU_PATH, 'rb')
  if not file then return end
  FILES = vim.split(file:read('*a'), '\n', { plain = true, trimempty = true })
  LAST_FILES = vim.deepcopy(FILES)
  file:close()
end

api.nvim_create_autocmd({'FocusLost', 'VimSuspend', 'VimLeavePre'}, {
  group = AUGROUP,
  desc = 'mru: write',
  callback = function()
    -- don't write if desynced or nothing changed
    if not SYNC or vim.deep_equal(FILES, LAST_FILES) then
      return
    end

    -- we're leaving vim now and the file could be changed when we get back
    SYNC = false

    local file = io.open(TMP_PATH, 'w+b')
    if not file then return end
    file:write(table.concat(FILES, '\n'))
    file:flush()
    file:close()
    uv.fs_rename(TMP_PATH, MRU_PATH)
    LAST_FILES = FILES
  end,
})

api.nvim_create_autocmd({'BufEnter', 'BufWritePost'}, {
  group = AUGROUP,
  desc = 'mru: add file',
  callback = function(ctx)
    -- only normal buffers
    if api.nvim_buf_get_option(ctx.buf, 'buftype') ~= '' then
      return
    end

    local file = ctx.file
    if not file or file == '' then return end

    file = uv.fs_realpath(ctx.file)
    if not file then return end

    -- ignore commit messages
    local last = file:match('[^/]*$')
    if last and last == 'COMMIT_EDITMSG' then
      return
    end

    -- only files
    local stat = uv.fs_stat(file)
    if not stat or stat.type ~= 'file' then
      return
    end

    sync()

    -- remove duplicates
    filter(FILES, function(v)
      return v ~= file
    end)

    table.insert(FILES, 1, file)

    -- trim the list to MAX_FILES
    for i = MAX_FILES + 1, #FILES do
      FILES[i] = nil
    end
  end,
})

return {
  get = function()
    sync()
    -- clean up deleted files here
    filter(FILES, function(v)
      return not not uv.fs_stat(v)
    end)
    return vim.deepcopy(FILES)
  end,
}
