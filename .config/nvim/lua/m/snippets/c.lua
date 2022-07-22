local snippets = require('m.snippets.util')
local copy = snippets.copy
local snip = snippets.snip
local begins = snippets.begins

local ls = require('luasnip')
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node

ls.add_snippets('c', require('m.snippets.cxx'))

ls.add_snippets('c', {

  -- PREPROCESSOR
  snip{
    name='#include angle brackets', trig='#<',
    condition = begins'#<',
    t'#include <', i(1, 'stdio.h'), t'>', i(0),
  },

  snip{
    name='#include double quotes', trig='#"',
    condition = begins'#"',
    t'#include "', d(1, function()
      return sn(1, { i(1, vim.fn.expand('%<')..'.h') })
    end), t'"', i(0),
  },

  -- TYPES
  snip{
    name='struct definition', trig='s',
    condition = begins's',
    t{'typedef struct {', '\t'}, i(0), t{'', '} '}, i(1), t(';'),
  },

  -- CONTROL FLOW
  snip{
    name='if null', trig='in',
    t'if (', i(1), t{' == NULL) {', '\t'}, i(0), t{'', '}'},
  },

  -- MALLOC
  snip{
    name='malloc', trig='malloc',
    i(2, 'char'), t'* ', i(1, 'var'), t' = malloc(sizeof(',
    copy(2), t') * ', i(3, '1'), t');', i(0),
  },

  snip{
    name='calloc', trig='calloc',
    i(2, 'char'), t'* ', i(1, 'var'), t' = calloc(', i(3, '1'),
    t', sizeof(', copy(2), t'));', i(0),
  },

  snip{
    name='realloc', trig='realloc',
    i(2, 'char'), t'* ', i(3, 'nbuf'), t' = realloc(', i(1, 'buf'),
    t', sizeof(', copy(2), t') * ', i(4, '1'), t');', i(0),
  },

})
