" Dark background
hi! NormalDark guibg=#21252C guifg=#ABB2BF

" quickfix
hi! link QuickFixLine PMenuSel

" Fern
hi! link FernRootText     String
hi! link FernRootSymbol   String
hi! link FernMarkedLine   WarningMsg
hi! link FernMarkedText   WarningMsg
hi! link FernLeafSymbol   LineNr
hi! link FernBranchSymbol Comment

" indent-blankline
hi! IndentBlanklineChar guifg=#4B5263 gui=nocombine
hi! link IndentBlanklineSpaceChar IndentBlanklineChar
hi! link IndentBlanklineSpaceCharBlankline IndentBlanklineChar

" nvim-lightbulb
sign define LightBulbSign text=? texthl=Number

hi! link LspReferenceText Visual
hi! link LspReferenceRead Visual
hi! link LspReferenceWrite Visual
