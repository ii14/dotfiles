" Transparent background
" hi! Normal guibg=NONE ctermbg=NONE

" quickfix
hi! link QuickFixLine PMenuSel

" quick-scope
hi! link QuickScopePrimary Search
hi! link QuickScopeSecondary WildMenu

" nvim-lsp
sign define LspDiagnosticsSignError       text=\ E
sign define LspDiagnosticsSignWarning     text=\ W
sign define LspDiagnosticsSignInformation text=\ i
sign define LspDiagnosticsSignHint        text=\ H

hi! link LspDiagnosticsDefaultError       ErrorMsg
hi! link LspDiagnosticsDefaultWarning     WarningMsg
hi! link LspDiagnosticsDefaultInformation Function
hi! link LspDiagnosticsDefaultHint        Function
hi! LspDiagnosticsUnderlineHint           ctermfg=39 guifg=#61AFEF cterm=underline gui=underline

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
