if vim.env.VIMNOLUACACHE == nil then
  pcall(require, 'impatient')
end

require('m.global')

if not vim.g.disable_lsp then
  require('m.lsp')

  vim.diagnostic.config{
    severity_sort = true,
  }
end

if vim.filetype then
  vim.filetype.add{
    pattern = {
      ['.*/cmus/rc'] = 'cmusrc',
    },
  }
  vim.cmd([[
    augroup VimrcFiletypeDetect
      autocmd!
      autocmd BufNewFile,BufRead *
        \ if !did_filetype() && expand("<amatch>") !~ g:ft_ignore_pat
        \ | runtime! scripts.vim | endif
      autocmd StdinReadPost * if !did_filetype() | runtime! scripts.vim | endif
    augroup end
  ]])
end

-- require('filetype').setup{
--   overrides = {
--     extensions = {
--       pro = 'qmake',
--     },
--     endswith = {
--       ['/i3/config'] = 'i3',
--       ['/cmus/rc'] = 'cmusrc',
--     },
--   },
-- }

require('Comment').setup{
  ignore = '^$',
}

-- TODO: lazy load
require('gitsigns').setup{
  preview_config = {
    border = 'none',
  },
}

-- TODO: lazy load
require('diffview.config').setup{
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

do
  local actions = require('lir.actions')
  local mark_actions = require('lir.mark.actions')
  local clipboard_actions = require('lir.clipboard.actions')

  require('lir').setup{
    show_hidden_files = false,
    hide_cursor = true,

    mappings = {
      ['l'] = actions.edit,
      ['<CR>'] = actions.edit,
      ['<C-S>'] = actions.split,
      ['<C-V>'] = actions.vsplit,
      ['<C-T>'] = actions.tabedit,

      ['-'] = actions.up,
      ['h'] = actions.up,
      ['q'] = function()
        vim.cmd('Bd')
      end,

      ['@'] = actions.cd,
      ['Y'] = actions.yank_path,
      ['.'] = actions.toggle_show_hidden,

      ['K'] = actions.mkdir,
      ['N'] = actions.newfile,
      ['R'] = actions.rename,
      -- ['D'] = actions.delete,
      ['D'] = function()
        local ctx = require('lir.vim').get_context()
        local name = ctx:current_value()
        if vim.fn.confirm('Trash?: ' .. name, '&Yes\n&No', 1) == 1 then
          vim.fn.system({'trash', ctx.dir .. name})
          if vim.v.shell_error ~= 0 then
            require('lir.utils').error('Trash file failed')
          end
          actions.reload()
        end
      end,

      ['J'] = function()
        mark_actions.toggle_mark()
        vim.cmd('normal! j')
      end,
      ['C'] = clipboard_actions.copy,
      ['X'] = clipboard_actions.cut,
      ['P'] = clipboard_actions.paste,
    },

    on_init = function()
      vim.api.nvim_buf_set_keymap(0, 'x', 'J',
        [[:<C-u>lua require'lir.mark.actions'.toggle_mark('v')<CR>]],
        { noremap = true, silent = true }
      )
    end,
  }
end

require('m.snippets')

require('m.compiledb')

do
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
