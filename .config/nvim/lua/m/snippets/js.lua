local snippets = require('m.snippets.util')
local copy = snippets.copy
local snip = snippets.snip

local ls = require('luasnip')
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node

local nl = t{'', ''}

local s = {

  snip{
    name='function', trig='fn',
    t'function ', i(1, 'func'), t'(', i(2), t{') {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='console.log', trig='cl',
    t'console.log(', i(1), t');',
  },

  snip{
    name='console.warn', trig='cw',
    t'console.warn(', i(1), t');',
  },

  snip{
    name='console.error', trig='ce',
    t'console.error(', i(1), t');',
  },

  snip{
    name='console.info', trig='ci',
    t'console.info(', i(1), t');',
  },

  snip{
    name='console.trace', trig='ct',
    t'console.trace(', i(1), t');',
  },

  snip{
    name='document.getElementById', trig='gi',
    t'document.getElementById(\'', i(1), t'\');',
  },

  snip{
    name='document.getElementsByClassName', trig='gc',
    t'document.getElementsByClassName(\'', i(1), t'\');',
  },

  snip{
    name='document.querySelector', trig='qs',
    t'document.querySelector(\'', i(1), t'\');',
  },

  snip{
    name='document.querySelectorAll', trig='qsa',
    t'document.querySelectorAll(\'', i(1), t'\');',
  },

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
    t'for (let ', i(2, 'i'), t' = 0; ', copy(2), t' < ', i(1, 'count'), t'; ',
    copy(2), t{'++) {', '\t'}, i(0), t{'', '}'},
  },

  snip{
    name='try/catch', trig='try',
    t{
      'try {',
      '\t'}, i(0), t{'',
      '} catch ('}, i(1, 'e'), t{') {',
      '}',
    },
  },

  snip{
    name='new Error', trig='err',
    t'throw new Error(\'', i(1, 'error'), t'\');',
  },

  snip{
    name='JSON.parse', trig='jp',
    t'JSON.parse(', i(1), t')',
  },

  snip{
    name='JSON.stringify', trig='js',
    t'JSON.stringify(', i(1), t')',
  },

}

ls.add_snippets('javascript', s)
ls.add_snippets('typescript', s)
