local api, fn = vim.api, vim.fn
local actions = require('lir.actions')
local mark_actions = require('lir.mark.actions')
local clipboard_actions = require('lir.clipboard.actions')

require('lir').setup {
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
      if fn.confirm('Trash?: ' .. name, '&Yes\n&No', 1) == 1 then
        fn.system({'trash', ctx.dir .. name})
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
    api.nvim_buf_set_keymap(0, 'x', 'J',
      [[:<C-u>lua require'lir.mark.actions'.toggle_mark('v')<CR>]],
      { noremap = true, silent = true })
  end,
}
