" Transparent background
" hi! Normal guibg=NONE ctermbg=NONE

" quickfix
hi! link QuickFixLine PMenuSel

" nvim-lsp
sign define LspDiagnosticsSignError       text=E
sign define LspDiagnosticsSignWarning     text=W
sign define LspDiagnosticsSignInformation text=i
sign define LspDiagnosticsSignHint        text=H

" nvim-lightbulb
sign define LightBulbSign text=? texthl=LspDiagnosticsSignInformation

" " DAP
" sign define DapBreakpoint text=● texthl=ErrorMsg
" sign define DapLogPoint   text=L texthl=Function
" sign define DapStopped    text=→ texthl=WarningMsg linehl=Visual

" " vim-lsp-cxx-highlight
" hi! link LspCxxHlSymUnknown        Normal
" hi! link LspCxxHlSymTypeParameter  Structure
" hi! link LspCxxHlSymFunction       Function
" hi! link LspCxxHlSymMethod         Function
" hi! link LspCxxHlSymStaticMethod   Function
" hi! link LspCxxHlSymConstructor    Function
" hi! link LspCxxHlSymEnumMember     Constant
" hi! link LspCxxHlSymMacro          Macro
" hi! link LspCxxHlSymNamespace      Keyword
" hi! link LspCxxHlSymVariable       Normal
" hi! link LspCxxHlSymParameter      Normal
" hi! link LspCxxHlSymField          Normal
" hi! LspCxxHlSymField     ctermfg=145 guifg=#ABB2BF cterm=bold gui=bold
" hi! LspCxxHlSymClass     ctermfg=180 guifg=#E5C07B cterm=bold gui=bold
" hi! LspCxxHlSymStruct    ctermfg=180 guifg=#E5C07B cterm=bold gui=bold
" hi! LspCxxHlSymEnum      ctermfg=180 guifg=#E5C07B cterm=bold gui=bold
" hi! LspCxxHlSymTypeAlias ctermfg=180 guifg=#E5C07B

" " treesitter
" hi! link TSPunctDelimiter     Delimiter
" hi! link TSPunctBracket       Delimiter
" hi! link TSPunctSpecial       Delimiter

" hi! link TSConstant           Constant
" hi! link TSConstBuiltin       Special
" hi! link TSConstMacro         Define
" hi! link TSString             String
" hi! link TSStringRegex        String
" hi! link TSStringEscape       SpecialChar
" hi! link TSCharacter          Character
" hi! link TSNumber             Number
" hi! link TSBoolean            Boolean
" hi! link TSFloat              Float

" hi! link TSFunction           Function
" hi! link TSFuncBuiltin        Special
" hi! link TSFuncMacro          Macro
" hi! link TSParameter          TSNone
" hi! link TSParameterReference TSParameter
" hi! link TSMethod             Function
" hi! link TSField              TSNone
" hi! link TSProperty           TSNone
" hi! link TSConstructor        Special
" hi! link TSAnnotation         PreProc
" hi! link TSAttribute          PreProc
" hi! link TSNamespace          Include
" hi! link TSSymbol             Identifier

" hi! link TSConditional        Conditional
" hi! link TSRepeat             Repeat
" hi! link TSLabel              Label
" hi! link TSOperator           Operator
" hi! link TSKeyword            Statement
" hi! link TSKeywordFunction    Statement
" hi! link TSKeywordOperator    TSOperator
" hi! link TSException          Exception

" hi! link TSType               Type
" hi! link TSTypeBuiltin        Type
" hi! link TSInclude            Include

" hi! link TSVariableBuiltin    Special

" hi! link TSText               TSNone
" hi! TSStrong    term=bold cterm=bold gui=bold
" hi! TSEmphasis  term=italic cterm=italic gui=italic
" hi! TSUnderline term=underline cterm=underline gui=underline
" hi! TSStrike    term=strikethrough cterm=strikethrough gui=strikethrough
" hi! link TSMath               Special
" hi! link TSTextReference      Constant
" hi! link TSEnviroment         Macro
" hi! link TSEnviromentName     Type
" hi! link TSTitle              Title
" hi! link TSLiteral            String
" hi! link TSURI                Underlined

" hi! link TSNote               SpecialComment
" hi! link TSWarning            Todo
" hi! link TSDanger             WarningMsg

" hi! link TSTag                Label
" hi! link TSTagDelimiter       Delimiter
