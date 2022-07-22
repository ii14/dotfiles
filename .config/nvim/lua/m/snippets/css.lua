local snippets = require('m.snippets.util')
local copy = snippets.copy
local snip = snippets.snip

local ls = require('luasnip')
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node

ls.add_snippets('css', {

  snip{name='background-color', trig='bg', t'background-color: #', i(1, '333'), t';'},

  snip{name='border', trig='bor', t'border: ', i(1, '1px solid #999'), t';'},

  snip{name='display: block',  trig='dp', t'display: block;'},
  snip{name='display: inline', trig='di', t'display: inline;'},
  snip{name='display: none',   trig='dn', t'display: none;'},

  snip{name='font-family', trig='ff', t'font-family: ', i(1), t';'},
  snip{name='font-size',   trig='fs', t'font-size: ', i(1, '14px'), t';'},

  snip{name='margin',  trig='mar', t'margin: ', i(1, '0'), t';'},
  snip{name='padding', trig='pad', t'padding: ', i(1, '0'), t';'},

})
