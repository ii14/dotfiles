" COLORS ///////////////////////////////////*colors*//////////////////////////////////////

" Dark background ------------------------------------------------------------------------
hi! NormalDark guibg=#21252C guifg=#ABB2BF

" quickfix -------------------------------------------------------------------------------
hi! link QuickFixLine PMenuSel

" Fern -----------------------------------------------------------------------------------
hi! link FernRootText     String
hi! link FernRootSymbol   String
hi! link FernMarkedLine   WarningMsg
hi! link FernMarkedText   WarningMsg
hi! link FernLeafSymbol   LineNr
hi! link FernBranchSymbol Comment

" indent-blankline -----------------------------------------------------------------------
hi! IndentBlanklineChar guifg=#4B5263 gui=nocombine
hi! link IndentBlanklineSpaceChar IndentBlanklineChar
hi! link IndentBlanklineSpaceCharBlankline IndentBlanklineChar

" nvim-lsp -------------------------------------------------------------------------------
sign define LspDiagnosticsSignError       text=E
sign define LspDiagnosticsSignWarning     text=W
sign define LspDiagnosticsSignInformation text=i
sign define LspDiagnosticsSignHint        text=H

" nvim-lightbulb -------------------------------------------------------------------------
sign define LightBulbSign text=! texthl=Number

" vim: tw=90 ts=2 sts=2 sw=2 et
