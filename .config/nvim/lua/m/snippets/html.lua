local snippets = require('m.snippets.util')
local copy = snippets.copy
local snip = snippets.snip
local begins = snippets.begins

local ls = require('luasnip')
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node

ls.add_snippets('html', {

  snip{
    name='html document', trig='html',
    condition = begins'html',
    t{
      '<!doctype html>',
      '<html lang="en">',
      '<head>',
      '\t<title></title>',
      '\t<meta charset="utf-8">',
      '\t<meta name="viewport" content="width=device-width, initial-scale=1">',
      '\t<link rel="stylesheet" type="text/css" href="'}, i(1, 'style'), t{'.css">',
      '</head>',
      '<body>',
      '\t<script src="'}, i(2, 'main'), t{'.js"></script>',
      '</body>',
      '</html>',
    },
  },

  snip{
    name='css link tag', trig='css',
    t'<link rel="stylesheet" type="text/css" href="', i(1, 'style'), t'.css">',
  },

})
