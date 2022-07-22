local api, fn, uv = vim.api, vim.fn, vim.loop
local m = require('m')

vim.env.FZF_DEFAULT_OPTS = table.concat({
  '--bind=ctrl-a:select-all,ctrl-u:page-up,ctrl-d:page-down,ctrl-space:toggle',
  '--pointer=" "',
  '--marker="*"',
}, ' ')

vim.g.fzf_action = {
  ['ctrl-s'] = 'split',
  ['ctrl-v'] = 'vsplit',
  ['ctrl-t'] = 'tab split',
}

vim.g.fzf_layout = {
  window = {
    width = 1,
    height = 0.45,
    yoffset = 1,
    border = 'none',
  }
}

vim.g.fzf_preview_window = { 'right:50%:hidden', '?' }

vim.g.fzf_colors = {
  ['fg']      = { 'fg', 'Normal' },
  ['bg']      = { 'bg', 'Normal' },
  ['bg+']     = { 'bg', 'Visual' },
  ['hl']      = { 'fg', 'Identifier' },
  ['hl+']     = { 'fg', 'Identifier' },
  ['gutter']  = { 'bg', 'Normal' },
  ['info']    = { 'fg', 'Comment' },
  ['border']  = { 'fg', 'LineNr' },
  ['prompt']  = { 'fg', 'Function' },
  ['pointer'] = { 'fg', 'Exception' },
  ['marker']  = { 'fg', 'WarningMsg' },
  ['spinner'] = { 'fg', 'WarningMsg' },
  ['header']  = { 'fg', 'Comment' },
}

local fzf = {}

---Most recently used files
function fzf.mru()
  local current
  if api.nvim_buf_get_option(0, 'buftype') == '' then
    current = uv.fs_realpath(api.nvim_buf_get_name(0))
  end

  local files = {}
  for _, file in ipairs(require('mru').get()) do
    if file ~= current then
      files[#files+1] = fn.fnamemodify(file, ':~')
    end
  end

  if #files > 0 then
    fn['fzf#run'](fn['fzf#wrap']({
      source = files,
      sink = 'edit',
      options = { '--prompt', 'mru> ' },
    }))
  else
    m.echo('No recently used files', 'WarningMsg')
  end
end

---Find lua modules in runtime path
function fzf.lua_modules()
  local lookup = {}

  ---@diagnostic disable-next-line: undefined-field
  local files = api.nvim_get_runtime_file('lua/**/*.lua', true)
  for i, file in ipairs(files) do
    local repr = file:match('/lua/(.*)%.lua$'):gsub('/', '.')
    repr = repr:match('^(.*)%.init$') or repr
    lookup[repr] = file
    files[i] = repr
  end
  table.sort(files)

  if #files > 0 then
    fn['fzf#run'](fn['fzf#wrap']({
      source = files,
      sink = function(match)
        if lookup[match] then
          vim.cmd('edit '..lookup[match])
        end
      end,
      options = { '--prompt', 'lua> ' },
    }))
  else
    m.echo('No lua modules found', 'WarningMsg')
  end
end

return fzf
