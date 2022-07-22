local snippets = require('m.snippets.util')
local copy = snippets.copy
local snip = snippets.snip

local ls = require('luasnip')
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node

ls.add_snippets('go', {

  snip{
    name='append', trig='ap',
    t'append(', i(1, 'slice'), t', ', i(2, 'value'), t')',
  },

  snip{
    name='interface{}', trig='in',
    t'interface{}',
  },

  snip{
    name='if', trig='if',
    t'if ', i(1, 'true'), t{' {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='else if', trig='ei',
    t'else if ', i(1, 'true'), t{' {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='else', trig='el',
    t{'else {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='if err != nil', trig='ie',
    t{'if err != nil {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='for loop', trig='for',
    t'for ', i(1), t{'{', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='range loop', trig='ran',
    t'for ', i(1, 'e'), t' := range ', i(2, 'container'), t{' {', '\t'}, i(0), t{'', '}'},
  },

})
