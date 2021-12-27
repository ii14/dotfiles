highlight clear
if exists('syntax_on')
  syntax reset
endif
set t_Co=256
let g:colors_name = 'mydark'

"DEFINE red             #E06C75
"DEFINE dark_red        #BE5046
"DEFINE green           #98C379
"DEFINE yellow          #E5C07B
"DEFINE dark_yellow     #D19A66
"DEFINE blue            #61AFEF
"DEFINE purple          #C678DD
"DEFINE cyan            #56B6C2
"DEFINE white           #ABB2BF
"DEFINE black           #282C34
"DEFINE dark_black      #21252C
"DEFINE visual_black    NONE
"DEFINE comment_grey    #5C6370
"DEFINE gutter_fg_grey  #4B5263
"DEFINE cursor_grey     #2C323C
"DEFINE visual_grey     #3E4452
"DEFINE menu_grey       #3E4452
"DEFINE special_grey    #3B4048
"DEFINE vertsplit       #181A1F
"DEFINE diff_delete     #3D333B
"DEFINE diff_add        #353D3C
"DEFINE diff_change     #303237
"DEFINE diff_text       #4D4942
"DEFINE italic          italic

hi Comment        guibg=NONE guifg=#5C6370 gui=italic
hi Constant       guibg=NONE guifg=#56B6C2         gui=NONE
hi String         guibg=NONE guifg=#98C379        gui=NONE
hi Character      guibg=NONE guifg=#98C379        gui=NONE
hi Number         guibg=NONE guifg=#D19A66  gui=NONE
hi Boolean        guibg=NONE guifg=#D19A66  gui=NONE
hi Float          guibg=NONE guifg=#D19A66  gui=NONE
hi Identifier     guibg=NONE guifg=#E06C75          gui=NONE
hi Function       guibg=NONE guifg=#61AFEF         gui=NONE
hi Statement      guibg=NONE guifg=#C678DD       gui=NONE
hi Conditional    guibg=NONE guifg=#C678DD       gui=NONE
hi Repeat         guibg=NONE guifg=#C678DD       gui=NONE
hi Label          guibg=NONE guifg=#C678DD       gui=NONE
hi Operator       guibg=NONE guifg=#C678DD       gui=NONE
hi Keyword        guibg=NONE guifg=#E06C75          gui=NONE
hi Exception      guibg=NONE guifg=#C678DD       gui=NONE
hi PreProc        guibg=NONE guifg=#E5C07B       gui=NONE
hi Include        guibg=NONE guifg=#61AFEF         gui=NONE
hi Define         guibg=NONE guifg=#C678DD       gui=NONE
hi Macro          guibg=NONE guifg=#C678DD       gui=NONE
hi PreCondit      guibg=NONE guifg=#E5C07B       gui=NONE
hi Type           guibg=NONE guifg=#E5C07B       gui=NONE
hi StorageClass   guibg=NONE guifg=#E5C07B       gui=NONE
hi Structure      guibg=NONE guifg=#E5C07B       gui=NONE
hi Typedef        guibg=NONE guifg=#E5C07B       gui=NONE
hi Special        guibg=NONE guifg=#61AFEF         gui=NONE
hi SpecialChar    guibg=NONE guifg=#D19A66  gui=NONE
hi Tag            guibg=NONE guifg=NONE            gui=NONE
hi Delimiter      guibg=NONE guifg=NONE            gui=NONE
hi SpecialComment guibg=NONE guifg=#5C6370 gui=NONE
hi Debug          guibg=NONE guifg=NONE            gui=NONE
hi Underlined     guibg=NONE guifg=NONE            gui=underline
hi Ignore         guibg=NONE guifg=NONE            gui=NONE
hi Error          guibg=NONE guifg=#E06C75          gui=NONE
hi Todo           guibg=NONE guifg=#C678DD       gui=NONE

hi ColorColumn      guibg=#2C323C  guifg=NONE               gui=NONE
hi Conceal          guibg=NONE            guifg=NONE               gui=NONE
hi Cursor           guibg=#61AFEF         guifg=#282C34           gui=NONE
hi CursorIM         guibg=NONE            guifg=NONE               gui=NONE
hi CursorColumn     guibg=#2C323C  guifg=NONE               gui=NONE
hi CursorLine       guibg=#2C323C  guifg=NONE               gui=NONE
hi Directory        guibg=NONE            guifg=#61AFEF            gui=NONE
hi DiffAdd          guibg=#353D3C     guifg=NONE               gui=NONE
hi DiffDelete       guibg=#3D333B  guifg=#282C34           gui=NONE
hi DiffChange       guibg=#303237  guifg=NONE               gui=NONE
hi DiffText         guibg=#4D4942    guifg=NONE               gui=NONE
hi ErrorMsg         guibg=NONE            guifg=#E06C75             gui=NONE
hi VertSplit        guibg=NONE            guifg=#181A1F       gui=NONE
hi Folded           guibg=NONE            guifg=#5C6370    gui=NONE
hi FoldColumn       guibg=NONE            guifg=NONE               gui=NONE
hi SignColumn       guibg=NONE            guifg=NONE               gui=NONE
hi IncSearch        guibg=#5C6370 guifg=#E5C07B          gui=NONE
hi LineNr           guibg=NONE            guifg=#4B5263  gui=NONE
hi CursorLineNr     guibg=NONE            guifg=NONE               gui=NONE
hi MatchParen       guibg=NONE            guifg=#61AFEF            gui=underline
hi ModeMsg          guibg=NONE            guifg=NONE               gui=NONE
hi MoreMsg          guibg=NONE            guifg=NONE               gui=NONE
hi NonText          guibg=NONE            guifg=#3B4048    gui=NONE
hi Normal           guibg=#282C34        guifg=#ABB2BF           gui=NONE
hi Pmenu            guibg=#3E4452    guifg=NONE               gui=NONE
hi PmenuSel         guibg=#61AFEF         guifg=#282C34           gui=NONE
hi PmenuSbar        guibg=#3B4048 guifg=NONE               gui=NONE
hi PmenuThumb       guibg=#ABB2BF        guifg=NONE               gui=NONE
hi Question         guibg=NONE            guifg=#C678DD          gui=NONE
hi QuickFixLine     guibg=#61AFEF         guifg=#282C34           gui=NONE
hi Search           guibg=#E5C07B       guifg=#282C34           gui=NONE
hi SpecialKey       guibg=NONE            guifg=#3B4048    gui=NONE
hi SpellBad         guibg=NONE            guifg=#E06C75             gui=underline
hi SpellCap         guibg=NONE            guifg=#D19A66     gui=NONE
hi SpellLocal       guibg=NONE            guifg=#D19A66     gui=NONE
hi SpellRare        guibg=NONE            guifg=#D19A66     gui=NONE
hi StatusLine       guibg=#2C323C  guifg=#ABB2BF           gui=NONE
hi StatusLineNC     guibg=NONE            guifg=#5C6370    gui=NONE
hi StatusLineTerm   guibg=#2C323C  guifg=#ABB2BF           gui=NONE
hi StatusLineTermNC guibg=NONE            guifg=#5C6370    gui=NONE
hi TabLine          guibg=NONE            guifg=#5C6370    gui=NONE
hi TabLineFill      guibg=NONE            guifg=NONE               gui=NONE
hi TabLineSel       guibg=NONE            guifg=#ABB2BF           gui=NONE
hi Terminal         guibg=#282C34        guifg=#ABB2BF           gui=NONE
hi Title            guibg=NONE            guifg=#98C379           gui=NONE
hi Visual           guibg=#3E4452  guifg=NONE    gui=NONE
hi VisualNOS        guibg=#3E4452  guifg=NONE               gui=NONE
hi WarningMsg       guibg=NONE            guifg=#E5C07B          gui=NONE
hi WildMenu         guibg=#61AFEF         guifg=#282C34           gui=NONE

hi NormalDark       guibg=#21252C   guifg=#ABB2BF

" indent-blankline
hi      IndentBlanklineChar               guifg=#4B5263 gui=nocombine
hi link IndentBlanklineSpaceChar          IndentBlanklineChar
hi link IndentBlanklineSpaceCharBlankline IndentBlanklineChar

" Neovim diagnostics
hi DiagnosticError            guifg=#E06C75
hi DiagnosticWarn             guifg=#E5C07B
hi DiagnosticInfo             guifg=#61AFEF
hi DiagnosticHint             guifg=#56B6C2
if $TERM ==# 'xterm-kitty'
  hi DiagnosticUnderlineError guisp=#E06C75    gui=underline
  hi DiagnosticUnderlineWarn  guisp=#E5C07B gui=underline
  hi DiagnosticUnderlineInfo  guisp=#61AFEF   gui=underline
  hi DiagnosticUnderlineHint  guisp=#56B6C2   gui=underline
else
  hi DiagnosticUnderlineError guifg=#E06C75    gui=underline
  hi DiagnosticUnderlineWarn  guifg=#E5C07B gui=underline
  hi DiagnosticUnderlineInfo  guifg=#61AFEF   gui=underline
  hi DiagnosticUnderlineHint  guifg=#56B6C2   gui=underline
endif
hi DiagnosticSignError        guifg=#E06C75
hi DiagnosticSignWarn         guifg=#E5C07B
hi DiagnosticSignInfo         guifg=#61AFEF
hi DiagnosticSignHint         guifg=#56B6C2
hi DiagnosticVirtualTextError guifg=#E06C75    guibg=#2C323C
hi DiagnosticVirtualTextWarn  guifg=#E5C07B guibg=#2C323C
hi DiagnosticVirtualTextInfo  guifg=#61AFEF   guibg=#2C323C
hi DiagnosticVirtualTextHint  guifg=#56B6C2   guibg=#2C323C

" Neovim LSP
hi link LspReferenceText  Visual
hi link LspReferenceRead  Visual
hi link LspReferenceWrite Visual

" lightbulb
sign define LightBulbSign text=? texthl=Number

" Fern
hi link FernRootText     String
hi link FernRootSymbol   String
hi link FernMarkedLine   WarningMsg
hi link FernMarkedText   WarningMsg
hi link FernLeafSymbol   LineNr
hi link FernBranchSymbol Comment

" Termdebug
hi debugPC          guibg=#3B4048 guifg=NONE     gui=NONE
hi debugBreakpoint  guibg=#E06C75          guifg=#282C34 gui=NONE

" CSS
hi cssAttrComma         guibg=NONE guifg=#C678DD      gui=NONE
hi cssAttributeSelector guibg=NONE guifg=#98C379       gui=NONE
hi cssBraces            guibg=NONE guifg=#ABB2BF       gui=NONE
hi cssClassName         guibg=NONE guifg=#D19A66 gui=NONE
hi cssClassNameDot      guibg=NONE guifg=#D19A66 gui=NONE
hi cssDefinition        guibg=NONE guifg=#C678DD      gui=NONE
hi cssFontAttr          guibg=NONE guifg=#D19A66 gui=NONE
hi cssFontDescriptor    guibg=NONE guifg=#C678DD      gui=NONE
hi cssFunctionName      guibg=NONE guifg=#61AFEF        gui=NONE
hi cssIdentifier        guibg=NONE guifg=#61AFEF        gui=NONE
hi cssImportant         guibg=NONE guifg=#C678DD      gui=NONE
hi cssInclude           guibg=NONE guifg=#ABB2BF       gui=NONE
hi cssIncludeKeyword    guibg=NONE guifg=#C678DD      gui=NONE
hi cssMediaType         guibg=NONE guifg=#D19A66 gui=NONE
hi cssProp              guibg=NONE guifg=#ABB2BF       gui=NONE
hi cssPseudoClassId     guibg=NONE guifg=#D19A66 gui=NONE
hi cssSelectorOp        guibg=NONE guifg=#C678DD      gui=NONE
hi cssSelectorOp2       guibg=NONE guifg=#C678DD      gui=NONE
hi cssTagName           guibg=NONE guifg=#E06C75         gui=NONE

" Fish Shell
hi fishKeyword     guibg=NONE guifg=#C678DD gui=NONE
hi fishConditional guibg=NONE guifg=#C678DD gui=NONE

" Go
hi goDeclaration  guibg=NONE guifg=#C678DD gui=NONE
hi goBuiltins     guibg=NONE guifg=#56B6C2   gui=NONE
hi goFunctionCall guibg=NONE guifg=#61AFEF   gui=NONE
hi goVarDefs      guibg=NONE guifg=#E06C75    gui=NONE
hi goVarAssign    guibg=NONE guifg=#E06C75    gui=NONE
hi goVar          guibg=NONE guifg=#C678DD gui=NONE
hi goConst        guibg=NONE guifg=#C678DD gui=NONE
hi goType         guibg=NONE guifg=#E5C07B gui=NONE
hi goTypeName     guibg=NONE guifg=#E5C07B gui=NONE
hi goDeclType     guibg=NONE guifg=#56B6C2   gui=NONE
hi goTypeDecl     guibg=NONE guifg=#C678DD gui=NONE

" HTML (keep consistent with Markdown, below)
hi htmlArg            guibg=NONE guifg=#D19A66 gui=NONE
hi htmlBold           guibg=NONE guifg=#D19A66 gui=bold
hi htmlEndTag         guibg=NONE guifg=#ABB2BF       gui=NONE
hi htmlH1             guibg=NONE guifg=#E06C75         gui=NONE
hi htmlH2             guibg=NONE guifg=#E06C75         gui=NONE
hi htmlH3             guibg=NONE guifg=#E06C75         gui=NONE
hi htmlH4             guibg=NONE guifg=#E06C75         gui=NONE
hi htmlH5             guibg=NONE guifg=#E06C75         gui=NONE
hi htmlH6             guibg=NONE guifg=#E06C75         gui=NONE
hi htmlItalic         guibg=NONE guifg=#C678DD      gui=italic
hi htmlLink           guibg=NONE guifg=#56B6C2        gui=underline
hi htmlSpecialChar    guibg=NONE guifg=#D19A66 gui=NONE
hi htmlSpecialTagName guibg=NONE guifg=#E06C75         gui=NONE
hi htmlTag            guibg=NONE guifg=#ABB2BF       gui=NONE
hi htmlTagN           guibg=NONE guifg=#E06C75         gui=NONE
hi htmlTagName        guibg=NONE guifg=#E06C75         gui=NONE
hi htmlTitle          guibg=NONE guifg=#ABB2BF       gui=NONE

" JavaScript
hi javaScriptBraces     guibg=NONE guifg=#ABB2BF       gui=NONE
hi javaScriptFunction   guibg=NONE guifg=#C678DD      gui=NONE
hi javaScriptIdentifier guibg=NONE guifg=#C678DD      gui=NONE
hi javaScriptNull       guibg=NONE guifg=#D19A66 gui=NONE
hi javaScriptNumber     guibg=NONE guifg=#D19A66 gui=NONE
hi javaScriptRequire    guibg=NONE guifg=#56B6C2        gui=NONE
hi javaScriptReserved   guibg=NONE guifg=#C678DD      gui=NONE
" http//github.com/pangloss/vim-javascript
hi jsArrowFunction   guibg=NONE guifg=#C678DD      gui=NONE
hi jsClassKeyword    guibg=NONE guifg=#C678DD      gui=NONE
hi jsClassMethodType guibg=NONE guifg=#C678DD      gui=NONE
hi jsDocParam        guibg=NONE guifg=#61AFEF        gui=NONE
hi jsDocTags         guibg=NONE guifg=#C678DD      gui=NONE
hi jsExport          guibg=NONE guifg=#C678DD      gui=NONE
hi jsExportDefault   guibg=NONE guifg=#C678DD      gui=NONE
hi jsExtendsKeyword  guibg=NONE guifg=#C678DD      gui=NONE
hi jsFrom            guibg=NONE guifg=#C678DD      gui=NONE
hi jsFuncCall        guibg=NONE guifg=#61AFEF        gui=NONE
hi jsFunction        guibg=NONE guifg=#C678DD      gui=NONE
hi jsGenerator       guibg=NONE guifg=#E5C07B      gui=NONE
hi jsGlobalObjects   guibg=NONE guifg=#E5C07B      gui=NONE
hi jsImport          guibg=NONE guifg=#C678DD      gui=NONE
hi jsModuleAs        guibg=NONE guifg=#C678DD      gui=NONE
hi jsModuleWords     guibg=NONE guifg=#C678DD      gui=NONE
hi jsModules         guibg=NONE guifg=#C678DD      gui=NONE
hi jsNull            guibg=NONE guifg=#D19A66 gui=NONE
hi jsOperator        guibg=NONE guifg=#C678DD      gui=NONE
hi jsStorageClass    guibg=NONE guifg=#C678DD      gui=NONE
hi jsSuper           guibg=NONE guifg=#E06C75         gui=NONE
hi jsTemplateBraces  guibg=NONE guifg=#BE5046    gui=NONE
hi jsTemplateVar     guibg=NONE guifg=#98C379       gui=NONE
hi jsThis            guibg=NONE guifg=#E06C75         gui=NONE
hi jsUndefined       guibg=NONE guifg=#D19A66 gui=NONE
" http//github.com/othree/yajs.vim
hi javascriptArrowFunc    guibg=NONE guifg=#C678DD   gui=NONE
hi javascriptClassExtends guibg=NONE guifg=#C678DD   gui=NONE
hi javascriptClassKeyword guibg=NONE guifg=#C678DD   gui=NONE
hi javascriptDocNotation  guibg=NONE guifg=#C678DD   gui=NONE
hi javascriptDocParamName guibg=NONE guifg=#61AFEF     gui=NONE
hi javascriptDocTags      guibg=NONE guifg=#C678DD   gui=NONE
hi javascriptEndColons    guibg=NONE guifg=#ABB2BF    gui=NONE
hi javascriptExport       guibg=NONE guifg=#C678DD   gui=NONE
hi javascriptFuncArg      guibg=NONE guifg=#ABB2BF    gui=NONE
hi javascriptFuncKeyword  guibg=NONE guifg=#C678DD   gui=NONE
hi javascriptIdentifier   guibg=NONE guifg=#E06C75      gui=NONE
hi javascriptImport       guibg=NONE guifg=#C678DD   gui=NONE
hi javascriptMethodName   guibg=NONE guifg=#ABB2BF    gui=NONE
hi javascriptObjectLabel  guibg=NONE guifg=#ABB2BF    gui=NONE
hi javascriptOpSymbol     guibg=NONE guifg=#56B6C2     gui=NONE
hi javascriptOpSymbols    guibg=NONE guifg=#56B6C2     gui=NONE
hi javascriptPropertyName guibg=NONE guifg=#98C379    gui=NONE
hi javascriptTemplateSB   guibg=NONE guifg=#BE5046 gui=NONE
hi javascriptVariable     guibg=NONE guifg=#C678DD   gui=NONE

" JSON
hi jsonCommentError      guibg=NONE guifg=#ABB2BF       gui=NONE
hi jsonKeyword           guibg=NONE guifg=#E06C75         gui=NONE
hi jsonBoolean           guibg=NONE guifg=#D19A66 gui=NONE
hi jsonNumber            guibg=NONE guifg=#D19A66 gui=NONE
hi jsonQuote             guibg=NONE guifg=#ABB2BF       gui=NONE
hi jsonMissingCommaError guibg=NONE guifg=#E06C75         gui=reverse
hi jsonNoQuotesError     guibg=NONE guifg=#E06C75         gui=reverse
hi jsonNumError          guibg=NONE guifg=#E06C75         gui=reverse
hi jsonString            guibg=NONE guifg=#98C379       gui=NONE
hi jsonStringSQError     guibg=NONE guifg=#E06C75         gui=reverse
hi jsonSemicolonError    guibg=NONE guifg=#E06C75         gui=reverse

" LESS
hi lessVariable      guibg=NONE guifg=#C678DD      gui=NONE
hi lessAmpersandChar guibg=NONE guifg=#ABB2BF       gui=NONE
hi lessClass         guibg=NONE guifg=#D19A66 gui=NONE

" Markdown (keep consistent with HTML, above)
hi markdownBlockquote        guibg=NONE guifg=#5C6370 gui=NONE
hi markdownBold              guibg=NONE guifg=#D19A66  gui=bold
hi markdownCode              guibg=NONE guifg=#98C379        gui=NONE
hi markdownCodeBlock         guibg=NONE guifg=#98C379        gui=NONE
hi markdownCodeDelimiter     guibg=NONE guifg=#98C379        gui=NONE
hi markdownH1                guibg=NONE guifg=#E06C75          gui=NONE
hi markdownH2                guibg=NONE guifg=#E06C75          gui=NONE
hi markdownH3                guibg=NONE guifg=#E06C75          gui=NONE
hi markdownH4                guibg=NONE guifg=#E06C75          gui=NONE
hi markdownH5                guibg=NONE guifg=#E06C75          gui=NONE
hi markdownH6                guibg=NONE guifg=#E06C75          gui=NONE
hi markdownHeadingDelimiter  guibg=NONE guifg=#E06C75          gui=NONE
hi markdownHeadingRule       guibg=NONE guifg=#5C6370 gui=NONE
hi markdownId                guibg=NONE guifg=#C678DD       gui=NONE
hi markdownIdDeclaration     guibg=NONE guifg=#61AFEF         gui=NONE
hi markdownIdDelimiter       guibg=NONE guifg=#C678DD       gui=NONE
hi markdownItalic            guibg=NONE guifg=#C678DD       gui=italic
hi markdownLinkDelimiter     guibg=NONE guifg=#C678DD       gui=NONE
hi markdownLinkText          guibg=NONE guifg=#61AFEF         gui=NONE
hi markdownListMarker        guibg=NONE guifg=#E06C75          gui=NONE
hi markdownOrderedListMarker guibg=NONE guifg=#E06C75          gui=NONE
hi markdownRule              guibg=NONE guifg=#5C6370 gui=NONE
hi markdownUrl               guibg=NONE guifg=#56B6C2         gui=underline

" Perl
hi perlFiledescRead      guibg=NONE guifg=#98C379        gui=NONE
hi perlFunction          guibg=NONE guifg=#C678DD       gui=NONE
hi perlMatchStartEnd     guibg=NONE guifg=#61AFEF         gui=NONE
hi perlMethod            guibg=NONE guifg=#C678DD       gui=NONE
hi perlPOD               guibg=NONE guifg=#5C6370 gui=NONE
hi perlSharpBang         guibg=NONE guifg=#5C6370 gui=NONE
hi perlSpecialString     guibg=NONE guifg=#D19A66  gui=NONE
hi perlStatementFiledesc guibg=NONE guifg=#E06C75          gui=NONE
hi perlStatementFlow     guibg=NONE guifg=#E06C75          gui=NONE
hi perlStatementInclude  guibg=NONE guifg=#C678DD       gui=NONE
hi perlStatementScalar   guibg=NONE guifg=#C678DD       gui=NONE
hi perlStatementStorage  guibg=NONE guifg=#C678DD       gui=NONE
hi perlSubName           guibg=NONE guifg=#E5C07B       gui=NONE
hi perlVarPlain          guibg=NONE guifg=#61AFEF         gui=NONE

" PHP
hi phpVarSelector    guibg=NONE guifg=#E06C75         gui=NONE
hi phpOperator       guibg=NONE guifg=#ABB2BF       gui=NONE
hi phpParent         guibg=NONE guifg=#ABB2BF       gui=NONE
hi phpMemberSelector guibg=NONE guifg=#ABB2BF       gui=NONE
hi phpType           guibg=NONE guifg=#C678DD      gui=NONE
hi phpKeyword        guibg=NONE guifg=#C678DD      gui=NONE
hi phpClass          guibg=NONE guifg=#E5C07B      gui=NONE
hi phpUseClass       guibg=NONE guifg=#ABB2BF       gui=NONE
hi phpUseAlias       guibg=NONE guifg=#ABB2BF       gui=NONE
hi phpInclude        guibg=NONE guifg=#C678DD      gui=NONE
hi phpClassExtends   guibg=NONE guifg=#98C379       gui=NONE
hi phpDocTags        guibg=NONE guifg=#ABB2BF       gui=NONE
hi phpFunction       guibg=NONE guifg=#61AFEF        gui=NONE
hi phpFunctions      guibg=NONE guifg=#56B6C2        gui=NONE
hi phpMethodsVar     guibg=NONE guifg=#D19A66 gui=NONE
hi phpMagicConstants guibg=NONE guifg=#D19A66 gui=NONE
hi phpSuperglobals   guibg=NONE guifg=#E06C75         gui=NONE
hi phpConstants      guibg=NONE guifg=#D19A66 gui=NONE

" Ruby
hi rubyBlockParameter            guibg=NONE guifg=#E06C75    gui=NONE
hi rubyBlockParameterList        guibg=NONE guifg=#E06C75    gui=NONE
hi rubyClass                     guibg=NONE guifg=#C678DD gui=NONE
hi rubyConstant                  guibg=NONE guifg=#E5C07B gui=NONE
hi rubyControl                   guibg=NONE guifg=#C678DD gui=NONE
hi rubyEscape                    guibg=NONE guifg=#E06C75    gui=NONE
hi rubyFunction                  guibg=NONE guifg=#61AFEF   gui=NONE
hi rubyGlobalVariable            guibg=NONE guifg=#E06C75    gui=NONE
hi rubyInclude                   guibg=NONE guifg=#61AFEF   gui=NONE
hi rubyIncluderubyGlobalVariable guibg=NONE guifg=#E06C75    gui=NONE
hi rubyInstanceVariable          guibg=NONE guifg=#E06C75    gui=NONE
hi rubyInterpolation             guibg=NONE guifg=#56B6C2   gui=NONE
hi rubyInterpolationDelimiter    guibg=NONE guifg=#E06C75    gui=NONE
hi rubyInterpolationDelimiter    guibg=NONE guifg=#E06C75    gui=NONE
hi rubyRegexp                    guibg=NONE guifg=#56B6C2   gui=NONE
hi rubyRegexpDelimiter           guibg=NONE guifg=#56B6C2   gui=NONE
hi rubyStringDelimiter           guibg=NONE guifg=#98C379  gui=NONE
hi rubySymbol                    guibg=NONE guifg=#56B6C2   gui=NONE

" Sass
" http//github.com/tpope/vim-haml
hi sassAmpersand      guibg=NONE guifg=#E06C75         gui=NONE
hi sassClass          guibg=NONE guifg=#D19A66 gui=NONE
hi sassControl        guibg=NONE guifg=#C678DD      gui=NONE
hi sassExtend         guibg=NONE guifg=#C678DD      gui=NONE
hi sassFor            guibg=NONE guifg=#ABB2BF       gui=NONE
hi sassFunction       guibg=NONE guifg=#56B6C2        gui=NONE
hi sassId             guibg=NONE guifg=#61AFEF        gui=NONE
hi sassInclude        guibg=NONE guifg=#C678DD      gui=NONE
hi sassMedia          guibg=NONE guifg=#C678DD      gui=NONE
hi sassMediaOperators guibg=NONE guifg=#ABB2BF       gui=NONE
hi sassMixin          guibg=NONE guifg=#C678DD      gui=NONE
hi sassMixinName      guibg=NONE guifg=#61AFEF        gui=NONE
hi sassMixing         guibg=NONE guifg=#C678DD      gui=NONE
hi sassVariable       guibg=NONE guifg=#C678DD      gui=NONE
" http//github.com/cakebaker/scss-syntax.vim
hi scssExtend       guibg=NONE guifg=#C678DD      gui=NONE
hi scssImport       guibg=NONE guifg=#C678DD      gui=NONE
hi scssInclude      guibg=NONE guifg=#C678DD      gui=NONE
hi scssMixin        guibg=NONE guifg=#C678DD      gui=NONE
hi scssSelectorName guibg=NONE guifg=#D19A66 gui=NONE
hi scssVariable     guibg=NONE guifg=#C678DD      gui=NONE

" TeX
hi texStatement    guibg=NONE guifg=#C678DD      gui=NONE
hi texSubscripts   guibg=NONE guifg=#D19A66 gui=NONE
hi texSuperscripts guibg=NONE guifg=#D19A66 gui=NONE
hi texTodo         guibg=NONE guifg=#BE5046    gui=NONE
hi texBeginEnd     guibg=NONE guifg=#C678DD      gui=NONE
hi texBeginEndName guibg=NONE guifg=#61AFEF        gui=NONE
hi texMathMatcher  guibg=NONE guifg=#61AFEF        gui=NONE
hi texMathDelim    guibg=NONE guifg=#61AFEF        gui=NONE
hi texDelimiter    guibg=NONE guifg=#D19A66 gui=NONE
hi texSpecialChar  guibg=NONE guifg=#D19A66 gui=NONE
hi texCite         guibg=NONE guifg=#61AFEF        gui=NONE
hi texRefZone      guibg=NONE guifg=#61AFEF        gui=NONE

" TypeScript
hi typescriptReserved  guibg=NONE guifg=#C678DD gui=NONE
hi typescriptEndColons guibg=NONE guifg=#ABB2BF  gui=NONE
hi typescriptBraces    guibg=NONE guifg=#ABB2BF  gui=NONE

" XML
hi xmlAttrib  guibg=NONE guifg=#D19A66 gui=NONE
hi xmlEndTag  guibg=NONE guifg=#E06C75         gui=NONE
hi xmlTag     guibg=NONE guifg=#E06C75         gui=NONE
hi xmlTagName guibg=NONE guifg=#E06C75         gui=NONE

" plasticboy/vim-markdown (keep consistent with Markdown, above)
hi mkdDelimiter guibg=NONE guifg=#C678DD gui=NONE
hi mkdHeading   guibg=NONE guifg=#E06C75    gui=NONE
hi mkdLink      guibg=NONE guifg=#61AFEF   gui=NONE
hi mkdURL       guibg=NONE guifg=#56B6C2   gui=underline

" tpope/vim-fugitive
hi diffAdded   guibg=NONE guifg=#98C379 gui=NONE
hi diffRemoved guibg=NONE guifg=#E06C75   gui=NONE

" lewis6991/gitsigns.nvim
hi GitSignsAdd    guibg=NONE guifg=#98C379  gui=NONE
hi GitSignsChange guibg=NONE guifg=#E5C07B gui=NONE
hi GitSignsDelete guibg=NONE guifg=#E06C75    gui=NONE
hi GitSignsCurrentLineBlame guifg=#5C6370

" Git Highlighting
hi gitcommitComment       guibg=NONE guifg=#5C6370 gui=NONE
hi gitcommitUnmerged      guibg=NONE guifg=#98C379        gui=NONE
hi gitcommitOnBranch      guibg=NONE guifg=NONE            gui=NONE
hi gitcommitBranch        guibg=NONE guifg=#C678DD       gui=NONE
hi gitcommitDiscardedType guibg=NONE guifg=#E06C75          gui=NONE
hi gitcommitSelectedType  guibg=NONE guifg=#98C379        gui=NONE
hi gitcommitHeader        guibg=NONE guifg=NONE            gui=NONE
hi gitcommitUntrackedFile guibg=NONE guifg=#56B6C2         gui=NONE
hi gitcommitDiscardedFile guibg=NONE guifg=#E06C75          gui=NONE
hi gitcommitSelectedFile  guibg=NONE guifg=#98C379        gui=NONE
hi gitcommitUnmergedFile  guibg=NONE guifg=#E5C07B       gui=NONE
hi gitcommitFile          guibg=NONE guifg=NONE            gui=NONE
hi gitcommitSummary       guibg=NONE guifg=#ABB2BF        gui=NONE
hi gitcommitOverflow      guibg=NONE guifg=#E06C75          gui=NONE
hi link gitcommitNoBranch       gitcommitBranch
hi link gitcommitUntracked      gitcommitComment
hi link gitcommitDiscarded      gitcommitComment
hi link gitcommitSelected       gitcommitComment
hi link gitcommitDiscardedArrow gitcommitDiscardedFile
hi link gitcommitSelectedArrow  gitcommitSelectedFile
hi link gitcommitUnmergedArrow  gitcommitUnmergedFile

" Neovim terminal colors
let g:terminal_color_0  = '#282C34'
let g:terminal_color_1  = '#E06C75'
let g:terminal_color_2  = '#98C379'
let g:terminal_color_3  = '#E5C07B'
let g:terminal_color_4  = '#61AFEF'
let g:terminal_color_5  = '#C678DD'
let g:terminal_color_6  = '#56B6C2'
let g:terminal_color_7  = '#ABB2BF'
let g:terminal_color_8  = '#3E4452'
let g:terminal_color_9  = '#BE5046'
let g:terminal_color_10 = '#98C379'
let g:terminal_color_11 = '#D19A66'
let g:terminal_color_12 = '#61AFEF'
let g:terminal_color_13 = '#C678DD'
let g:terminal_color_14 = '#56B6C2'
let g:terminal_color_15 = '#5C6370'
let g:terminal_color_background = g:terminal_color_0
let g:terminal_color_foreground = g:terminal_color_7

" lightline
let g:lightline#colorscheme#onedark#palette = #{
  \ normal: #{
  \   left: [
  \     ['#282C34', '#98C379', '235', '114'],
  \     ['#ABB2BF', '#3E4452', '145', '236']],
  \   right: [
  \     ['#282C34', '#98C379', '235', '114'],
  \     ['#ABB2BF', '#3E4452', '145', '236']],
  \   middle: [
  \     ['#98C379', '#2C323C', '145', '235']],
  \   error: [
  \     ['#282C34', '#E06C75', '235', '204']],
  \   warning: [
  \     ['#282C34', '#E5C07B', '235', '180']],
  \ },
  \ inactive: #{
  \   left: [
  \     ['#ABB2BF', '#3E4452', '145', '236'],
  \     ['#ABB2BF', '#3E4452', '145', '236']],
  \   right: [
  \     ['#282C34', '#ABB2BF', '235', '145'],
  \     ['#282C34', '#ABB2BF', '235', '145']],
  \   middle: [
  \     ['#ABB2BF', '#3E4452', '145', '236']],
  \ },
  \ insert: #{
  \   left:  [
  \     ['#282C34', '#61AFEF', '235', '39'],
  \     ['#ABB2BF', '#3E4452', '145', '236']],
  \   right: [
  \     ['#282C34', '#61AFEF', '235', '39'],
  \     ['#ABB2BF', '#3E4452', '145', '236']],
  \   middle: [
  \     ['#61AFEF', '#2C323C', '145', '235']],
  \ },
  \ visual: #{
  \   left:  [
  \     ['#282C34', '#C678DD', '235', '170'],
  \     ['#ABB2BF', '#3E4452', '145', '236']],
  \   right: [
  \     ['#282C34', '#C678DD', '235', '170'],
  \     ['#ABB2BF', '#3E4452', '145', '236']],
  \   middle: [
  \     ['#C678DD', '#2C323C', '145', '235']],
  \ },
  \ replace: #{
  \   left:  [
  \     ['#282C34', '#E06C75', '235', '204'],
  \     ['#ABB2BF', '#3E4452', '145', '236']],
  \   right: [
  \     ['#282C34', '#E06C75', '235', '204'],
  \     ['#ABB2BF', '#3E4452', '145', '236']],
  \   middle: [
  \     ['#E06C75', '#2C323C', '145', '235']],
  \ },
  \ tabline: #{
  \   left:   [
  \     ['#ABB2BF', '#3E4452', '145', '236']],
  \   tabsel: [
  \     ['#282C34', '#ABB2BF', '235', '145']],
  \   middle: [
  \     ['#ABB2BF', '#282C34', '145', '235']],
  \   right:  [
  \     ['#ABB2BF', '#3E4452', '145', '236']],
  \ },
  \ }

set background=dark

" vim: ft=vim
