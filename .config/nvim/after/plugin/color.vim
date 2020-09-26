" quickfix
hi! link QuickFixLine PMenuSel

" nvim-lsp
sign define LspDiagnosticsErrorSign       text=\ E
sign define LspDiagnosticsWarningSign     text=\ W
sign define LspDiagnosticsInformationSign text=\ i

hi! link LspDiagnosticsError       ErrorMsg
hi! link LspDiagnosticsWarning     WarningMsg
hi! link LspDiagnosticsInformation Function
hi! link LspDiagnosticsUnderline   Underlined

" vim-lsp-cxx-highlight
hi! link LspCxxHlSymUnknown        Normal
hi! link LspCxxHlSymTypeParameter  Structure
hi! link LspCxxHlSymFunction       Function
hi! link LspCxxHlSymMethod         Function
hi! link LspCxxHlSymStaticMethod   Function
hi! link LspCxxHlSymConstructor    Function
hi! link LspCxxHlSymEnumMember     Constant
hi! link LspCxxHlSymMacro          Macro
hi! link LspCxxHlSymNamespace      Keyword
hi! link LspCxxHlSymVariable       Normal
hi! link LspCxxHlSymParameter      Normal
hi! link LspCxxHlSymField          Normal
hi! LspCxxHlSymField     ctermfg=145 guifg=#ABB2BF cterm=bold gui=bold
hi! LspCxxHlSymClass     ctermfg=180 guifg=#E5C07B cterm=bold gui=bold
hi! LspCxxHlSymStruct    ctermfg=180 guifg=#E5C07B cterm=bold gui=bold
hi! LspCxxHlSymEnum      ctermfg=180 guifg=#E5C07B cterm=bold gui=bold
hi! LspCxxHlSymTypeAlias ctermfg=180 guifg=#E5C07B
