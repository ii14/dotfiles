local snippets = require('m.snippets.util')
local copy = snippets.copy
local snip = snippets.snip

local ls = require('luasnip')
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node

local nl = t{'', ''}

ls.add_snippets('lua', {

  snip{
    name='function', trig='fn',
    t'function ', i(1, 'func'), t'(', i(2), t{')', '\t'}, i(0), t{'', 'end'},
  },

  snip{
    name='inline function', trig='fi',
    t'function(', i(1), t{')', '\t'}, i(0), t{'', 'end'},
  },

  snip{
    name='require', trig='re',
    t"require('", i(1), t"')",
  },

  snip{
    name='if', trig='if',
    t'if ', i(1, 'true'), t{' then', '\t'}, i(0), t{'', 'end'},
  },

  snip{
    name='while', trig='wh',
    t'while ', i(1, 'true'), t{' do', '\t'}, i(0), t{'', 'end'},
  },

  -- iterators --

  snip{
    name='pairs', trig='ps',
    t'for ', i(2, '_'), t', ', i(3, '_'), t' in pairs(', i(1), t{') do', '\t'}, i(0),
    t{'', 'end'},
  },

  snip{
    name='ipairs', trig='ips',
    t'for ', i(2, '_'), t', ', i(3, '_'), t' in ipairs(', i(1), t{') do', '\t'}, i(0),
    t{'', 'end'},
  },

  -- stdlib --

  snip{
    name='table.insert', trig='ti',
    t'table.insert(', i(0), t')',
  },

  snip{
    name='table.remove', trig='tr',
    t'table.remove(', i(0), t')',
  },

  snip{
    name='table.concat', trig='tc',
    t'table.concat(', i(0), t')',
  },

  snip{
    name='table.sort', trig='ts',
    t'table.sort(', i(0), t')',
  },

  snip{
    name='string.format', trig='sf',
    t'string.format(', i(0), t')',
  },

  snip{
    name='coroutine.create', trig='cc',
    t'coroutine.create(', i(0), t')',
  },

  snip{
    name='coroutine.resume', trig='cr',
    t'coroutine.resume(', i(0), t')',
  },

  snip{
    name='coroutine.yield', trig='cy',
    t'coroutine.yield(', i(0), t')',
  },

  snip{
    name='coroutine.status', trig='cs',
    t'coroutine.status(', i(0), t')',
  },

  -- neovim --

  snip{
    name='vim.schedule', trig='vs',
    t{'vim.schedule(function()', '\t'}, i(0), t{'', 'end)'},
  },

  snip{
    name='nvim_get_current_buf', trig='ngcb',
    t'vim.api.nvim_get_current_buf()',
  },

  snip{
    name='nvim_get_current_win', trig='ngcw',
    t'vim.api.nvim_get_current_win()',
  },

  snip{
    name='nvim_set_current_buf', trig='nscb',
    t'vim.api.nvim_set_current_buf(', i(0), t')',
  },

  snip{
    name='nvim_set_current_win', trig='nscw',
    t'vim.api.nvim_set_current_win(', i(0), t')',
  },

  snip{
    name='nvim_buf_get_lines', trig='nbgl',
    t'vim.api.nvim_buf_get_lines(', i(0), t')',
  },

  snip{
    name='nvim_buf_set_lines', trig='nbsl',
    t'vim.api.nvim_buf_set_lines(', i(0), t')',
  },

  snip{
    name='nvim_buf_set_text', trig='nbst',
    t'vim.api.nvim_buf_set_text(', i(0), t')',
  },

  snip{
    name='nvim_buf_set_name', trig='nbsn',
    t'vim.api.nvim_buf_set_name(', i(0), t')',
  },

  snip{
    name='nvim_buf_get_option', trig='nbgo',
    t'vim.api.nvim_buf_get_option(', i(0), t')',
  },

  snip{
    name='nvim_buf_set_option', trig='nbso',
    t'vim.api.nvim_buf_set_option(', i(0), t')',
  },

  snip{
    name='nvim_win_get_option', trig='nwgo',
    t'vim.api.nvim_win_get_option(', i(0), t')',
  },

  snip{
    name='nvim_win_set_option', trig='nwso',
    t'vim.api.nvim_win_set_option(', i(0), t')',
  },

  snip{
    name='nvim_get_option', trig='ngo',
    t'vim.api.nvim_get_option(', i(0), t')',
  },

  snip{
    name='nvim_set_option', trig='nso',
    t'vim.api.nvim_set_option(', i(0), t')',
  },

  snip{
    name='nvim_create_namespace', trig='ncn',
    t'vim.api.nvim_create_namespace(', i(0), t')',
  },

  snip{
    name='nvim_buf_clear_namespace', trig='nbcn',
    t'vim.api.nvim_buf_clear_namespace(', i(0), t')',
  },

})
