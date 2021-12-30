require('m.global')

if not vim.g.disable_lsp then
  require('m.lsp')

  vim.diagnostic.config{
    severity_sort = true,
  }

  require('trouble').setup{
    icons = false,
    fold_open = "v",
    fold_closed = ">",
    signs = {
      error = "E",
      warning = "W",
      hint = "H",
      information = "i",
      other = "-",
    },
    padding = false,
  }
end

require('filetype').setup{
  overrides = {
    extensions = {
      pro = 'qmake',
    },
    endswith = {
      ['/i3/config'] = 'i3',
    },
  },
}

require('Comment').setup{
  ignore = '^$',
}

require('gitsigns').setup{
  preview_config = {
    border = 'none',
  },
}

require('m.snippets')

require('m.compiledb')

if vim.g.enable_lua_theme then
  vim.o.termguicolors = true
  vim.o.showmode = false

  -- See $VIMCONFIG/colors/onedark.vim.in
  local colorscheme = vim.env.VIMCONFIG..'/colors/onedark.vim'
  if require('m.util.preproc').ensure(colorscheme) then
    vim.cmd('colorscheme onedark')
  end

  require('m.ui.bufferline').setup()

  vim.o.statusline = [[%!v:lua.require('m.ui.statusline').render()]]
  vim.cmd([[
    augroup Statusline
      autocmd!
      autocmd WinLeave,BufLeave *  lua vim.wo.statusline = require('m.ui.statusline').render(1)
      autocmd FileType          qf lua vim.wo.statusline = require('m.ui.statusline').render()
      autocmd WinEnter,BufEnter *  set statusline<
    augroup end
  ]])
end
