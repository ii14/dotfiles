-- Snippets shared between C and C++

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
local postfix = require("luasnip.extras.postfix").postfix

return {

  -- PREPROCESSOR
  snip{
    name='#include', trig='#i',
    condition = begins'#i',
    t'#include ',
  },

  snip{
    name='#pragma once', trig='#p',
    condition = begins'#p',
    t{'#pragma once', ''},
  },

  snip{
    name='#define', trig='#d',
    condition = begins'#d',
    t'#define ',
  },

  snip{
    name='#if', trig='#if',
    condition = begins'#if',
    t'#if ', i(1, '1'), t{'', ''},
    i(0), t{'', ''},
    t'#endif // ', copy(1),
  },

  -- MAIN
  snip{
    name='main function', trig='main',
    condition = begins'main',
    t{'int main(int argc, char* argv[])', '{', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='main function with no arguments', trig='mainn',
    condition = begins'mainn',
    t{'int main()', '{', '\t'}, i(0), t{'', '}'},
  },

  -- TYPES
  snip{
    name='function', trig='fn',
    i(1, 'void'), t' ', i(2, 'function_name'), t'(', i(3), t{')', '{', '\t'}, i(0), t{'', '}'}
  },

  snip{name='char*', trig='cs', t('char*')},
  snip{name='const char*', trig='cc', t('const char*')},

  -- CONTROL FLOW
  snip{
    name='if', trig='if',
    t'if (', i(1, 'true'), t{') {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='else if', trig='ei',
    t'else if (', i(1, 'true'), t{') {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='else', trig='el',
    t{'else {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='for loop', trig='for',
    t'for (int ', i(2, 'i'), t' = 0; ', copy(2), t' < ', i(1, 'count'), t'; ++',
    copy(2), t{') {', '\t'}, i(0), t{'', '}'},
  },

  -- MISC
  snip{name='assert', trig='as', t'assert(', i(1), t');'},
  snip{name='printf', trig='pf', t'printf("', i(1), t'"', i(2), t');'},
  snip{name='fprintf', trig='fp', t'printf(stderr, "', i(1), t'"', i(2), t');'},

  -- POSTFIX
  postfix({trig='`c', match_pattern='[%w%.%_%-<>:]+$'}, {
    f(function(_, parent)
      return 'const '..parent.snippet.env.POSTFIX_MATCH
    end, {}),
  }),

  postfix({trig='`p', match_pattern='[%w%.%_%-<>:]+$'}, {
    f(function(_, parent)
      return '('..parent.snippet.env.POSTFIX_MATCH..')'
    end, {}),
  }),

}
