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
