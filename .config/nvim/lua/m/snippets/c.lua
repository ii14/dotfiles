local snippets = require('m.snippets.util')
local copy = snippets.copy
local snip = snippets.snip

local ls = require('luasnip')
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node

local nl = t{'', ''}

ls.add_snippets('c', {

  -- PREPROCESSOR
  snip{
    name='#include', trig='^#i', regTrig=true,
    t'#include ',
  },

  snip{
    name='#include angle brackets', trig='^#<', regTrig=true,
    t'#include <', i(1, 'stdio.h>'), i(0),
  },

  snip{
    name='#include double quotes', trig='^#"', regTrig=true,
    t'#include "', d(1, function()
      local fname = vim.fn.expand('%<')
      if fname then fname = fname..'.h' end
      return i(1, fname..'"')
    end, {}), i(0),
  },

  snip{
    name='#pragma once', trig='^#p', regTrig=true,
    t{'#pragma once', ''},
  },

  snip{
    name='#define', trig='^#d', regTrig=true,
    t'#define ',
  },

  snip{
    name='#if', trig='^#if', regTrig=true,
    t'#if ', i(1, '1'), nl,
    i(0), nl,
    t'#endif // ', copy(1),
  },

  -- MAIN
  snip{
    name='main function', trig='^main', regTrig=true,
    t{'int main(int argc, char* argv[])', '{', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='main function with no arguments', trig='^mainn', regTrig=true,
    t{'int main()', '{', '\t'}, i(0), t{'', '}'},
  },

  -- TYPES
  snip{
    name='struct definition', trig='^s', regTrig=true,
    t{'typedef struct {', '\t'}, i(0), t{'', '} '}, i(1), t(';'),
  },

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
    name='if null', trig='in',
    t'if (', i(1), t{' == NULL) {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='for loop', trig='for',
    t'for (int ', i(2, 'i'), t' = 0; ', copy(2), t' < ', i(1, 'count'), t'; ++',
    copy(2), t{') {', '\t'}, i(0), t{'', '}'},
  },

  -- MALLOC
  snip{
    name='malloc', trig='malloc',
    i(2, 'char'), t'* ', i(1, 'var'), t' = (', copy(2), t'*)malloc(sizeof(',
    copy(2), t'));', i(0),
  },

  snip{
    name='calloc', trig='calloc',
    i(2, 'char'), t'* ', i(1, 'var'), t' = (', copy(2), t'*)calloc(', i(3),
    t', sizeof(', copy(2), t'));', i(0),
  },

  snip{
    name='realloc', trig='realloc',
    i(2, 'char'), t'* r', i(1, 'var'), t' = (', copy(2), t'*)realloc(', copy(1),
    t', sizeof(', copy(2), t'));', i(0),
  },

  -- MISC
  snip{name='assert', trig='as', t'assert(', i(1), t');'},
  snip{name='printf', trig='pf', t'printf("', i(1), t'"', i(2), t');'},
  snip{name='fprintf', trig='fp', t'printf(stderr, "', i(1), t'"', i(2), t');'},

})
