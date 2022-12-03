local api, fn = vim.api, vim.fn

local OPTIONS = {
  'allcaps',
  'bq',
  'code',
  'decorate',
  'dl',
  'headers',
  'link',
  'long',
  'medium',
  'ol',
  'plaintext',
  'prude',
  'short',
  'ul',
  'verylong',
}

local function complete(arg)
  local res = {}
  for _, opt in ipairs(OPTIONS) do
    if opt:sub(1, #arg) == arg then
      res[#res+1] = opt
    end
  end
  return res
end

local function run(args)
  if not args:find([[^[a-z0-9 ]*$]]) then
    api.nvim_err_writeln('Lorem: invalid arguments')
    return
  end

  args = table.concat(vim.split(args, '%s+'), '/')
  local res = fn.systemlist(('curl https://loripsum.net/api/%s 2>/dev/null'):format(args))
  if vim.v.shell_error ~= 0 then
    api.nvim_err_writeln(('Lorem: curl failed with code %d'):format(vim.v.shell_error))
    return
  end

  fn.append(fn.line('.'), res)
end

return {
  run = run,
  complete = complete,
}
