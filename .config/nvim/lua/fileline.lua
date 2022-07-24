-- Resolve line:col from `file.txt:10:99`
local api, fn = vim.api, vim.fn
api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  group = api.nvim_create_augroup('fileline', {}),
  desc = 'fileline: detect',
  callback = function()
    local file = fn.bufname('%')
    if file == '' or fn.filereadable(file) ~= 0 then
      return
    end

    local line, col do
      local res = vim.split(file, ':', { plain = true })
      file, line, col = res[1], res[2], res[3]
    end

    if not file or file == '' then
      return
    elseif not line or not line:find('^%d+$') then
      return
    elseif col and not col:find('^%d+$') then
      col = nil
    end

    api.nvim_command(('file %s | edit'):format(file:gsub(' ', '\\ ')))
    api.nvim_command(('silent %s | normal! %s|'):format(line, col or '0'))

    if fn.foldlevel(tonumber(line)) > 0 then
      api.nvim_command('normal! zv')
    end
    api.nvim_command('normal! zz')
  end,
  nested = true,
})
