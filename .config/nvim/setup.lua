if vim.env.VIMNOLUACACHE == nil then
  pcall(require, 'impatient')
end

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
      ['/cmus/rc'] = 'cmusrc',
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

require('diffview').setup{
  use_icons = false,
  signs = {
    fold_closed = ">",
    fold_open = "v",
  },
  hooks = {
    diff_buf_read = function(bufnr)
      local setopt = vim.api.nvim_win_set_option
      setopt(0, 'wrap', false)
      setopt(0, 'list', false)
      setopt(0, 'number', true)
      setopt(0, 'relativenumber', false)
      setopt(0, 'cursorline', true)
      vim.w.diffview = true
      vim.defer_fn(function()
        pcall(vim.api.nvim_buf_call, bufnr, function()
          vim.cmd('IndentBlanklineRefresh')
        end)
      end, 100)
    end,
    view_closed = function()
      vim.cmd('IndentBlanklineRefresh!')
    end,
    view_opened = function(view)
      vim.api.nvim_buf_call(view.panel.bufid, function()
        vim.cmd('setl signcolumn=auto')
      end)
    end,
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
  require('m.ui.statusline').setup()
end
