local snippets = require('m.snippets.util')
local copy = snippets.copy
local snip = snippets.snip

local ls = require('luasnip')
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node

local nl = t{'', ''}

ls.snippets.lua = {

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
    name='pairs', trig='pairs',
    t'for ', i(2, '_'), t', ', i(3, '_'), t' in pairs(', i(1), t{') do', '\t'}, i(0),
    t{'', 'end'},
  },

  snip{
    name='ipairs', trig='ipairs',
    t'for ', i(2, '_'), t', ', i(3, '_'), t' in ipairs(', i(1), t{') do', '\t'}, i(0),
    t{'', 'end'},
  },

}
