local api, fn = vim.api, vim.fn

local DIR = fn.stdpath('config') .. '/templates'

local function complete(lead)
  local ok, ents = pcall(fn.readdir, DIR)
  local res = {}
  if ok then
    for _, ent in ipairs(ents) do
      if ent:sub(1, #lead) == lead then
        res[#res+1] = ent
      end
    end
  end
  return res
end

local function run(file)
  assert(type(file) == 'string')
  file = DIR .. '/' .. file
  if fn.filereadable(file) == 0 then
    api.nvim_err_writeln('Template not found')
    return
  end

  local ok, template = pcall(fn.readfile, file)
  if not ok then
    api.nvim_err_writeln('Failed to read template')
    return
  end

  if fn.line('$') == 1 and fn.wordcount().words == 0 then
    api.nvim_buf_set_lines(0, 0, -1, false, template)
  else
    local line = fn.line('.')
    api.nvim_buf_set_lines(0, line, line, false, template)
  end
end

return {
  run = run,
  complete = complete,
}
