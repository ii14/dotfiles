highlight clear
if exists('syntax_on')
  syntax reset
endif
set t_Co=256
let g:colors_name = 'onedark'

"DEFINE red             #E06C75
"DEFINE dark_red        #BE5046
"DEFINE green           #98C379
"DEFINE yellow          #E5C07B
"DEFINE orange          #D19A66
"DEFINE blue            #61AFEF
"DEFINE purple          #C678DD
"DEFINE cyan            #56B6C2
"DEFINE white           #ABB2BF
"DEFINE black           #282C34
"DEFINE dim             #21252C
"DEFINE visual_black    NONE
"DEFINE light_grey      #848b98
"DEFINE comment_grey    #5C6370
"DEFINE gutter_fg_grey  #4B5263
"DEFINE cursor_grey     #2C323C
"DEFINE visual_grey     #3E4452
"DEFINE menu_grey       #3E4452
"DEFINE special_grey    #3B4048
"DEFINE vertsplit       #181A1F
"DEFINE diff_delete     #3D333B
"DEFINE diff_add        #353D3C
"DEFINE diff_change     #2F3136
"DEFINE diff_text       #44423E
"DEFINE italic          italic

hi Comment        guibg=NONE guifg=#5C6370 gui=italic
hi Constant       guibg=NONE guifg=#56B6C2         gui=NONE
hi String         guibg=NONE guifg=#98C379        gui=NONE
hi Character      guibg=NONE guifg=#98C379        gui=NONE
hi Number         guibg=NONE guifg=#D19A66       gui=NONE
hi Boolean        guibg=NONE guifg=#D19A66       gui=NONE
hi Float          guibg=NONE guifg=#D19A66       gui=NONE
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
hi SpecialChar    guibg=NONE guifg=#D19A66       gui=NONE
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
hi DiffChange       guibg=#2F3136  guifg=NONE               gui=NONE
hi DiffText         guibg=#44423E    guifg=NONE               gui=NONE
hi ErrorMsg         guibg=NONE            guifg=#E06C75             gui=NONE
hi VertSplit        guibg=NONE            guifg=#181A1F       gui=NONE
hi Folded           guibg=NONE            guifg=#5C6370    gui=NONE
hi FoldColumn       guibg=NONE            guifg=#5C6370    gui=NONE
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
hi SpecialKey       guibg=NONE            guifg=#61AFEF            gui=NONE
hi SpecialKeyWin    guibg=NONE            guifg=#3B4048    gui=NONE
set winhighlight=SpecialKey:SpecialKeyWin
hi SpellBad         guibg=NONE            guifg=#E06C75             gui=underline
hi SpellCap         guibg=NONE            guifg=#D19A66          gui=NONE
hi SpellLocal       guibg=NONE            guifg=#D19A66          gui=NONE
hi SpellRare        guibg=NONE            guifg=#D19A66          gui=NONE
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

hi Dim guibg=#21252C guifg=#ABB2BF

" indent-blankline
hi IndentBlanklineChar guifg=#4B5263 gui=nocombine
hi link IndentBlanklineSpaceChar          IndentBlanklineChar
hi link IndentBlanklineSpaceCharBlankline IndentBlanklineChar

" Neovim diagnostics
hi DiagnosticError guifg=#E06C75
hi DiagnosticWarn  guifg=#E5C07B
hi DiagnosticInfo  guifg=#61AFEF
hi DiagnosticHint  guifg=#56B6C2
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
hi link FernBranchSymbol LineNr

" Termdebug
hi debugPC          guibg=#3B4048
hi debugBreakpoint  guibg=#E06C75 guifg=#282C34

" CSS
hi cssAttrComma         guifg=#C678DD
hi cssAttributeSelector guifg=#98C379
hi cssBraces            guifg=#ABB2BF
hi cssClassName         guifg=#D19A66
hi cssClassNameDot      guifg=#D19A66
hi cssDefinition        guifg=#C678DD
hi cssFontAttr          guifg=#D19A66
hi cssFontDescriptor    guifg=#C678DD
hi cssFunctionName      guifg=#61AFEF
hi cssIdentifier        guifg=#61AFEF
hi cssImportant         guifg=#C678DD
hi cssInclude           guifg=#ABB2BF
hi cssIncludeKeyword    guifg=#C678DD
hi cssMediaType         guifg=#D19A66
hi cssProp              guifg=#ABB2BF
hi cssPseudoClassId     guifg=#D19A66
hi cssSelectorOp        guifg=#C678DD
hi cssSelectorOp2       guifg=#C678DD
hi cssTagName           guifg=#E06C75

" Fish Shell
hi fishKeyword     guifg=#C678DD
hi fishConditional guifg=#C678DD

" Go
hi goDeclaration  guifg=#C678DD
hi goBuiltins     guifg=#56B6C2
hi goFunctionCall guifg=#61AFEF
hi goVarDefs      guifg=#E06C75
hi goVarAssign    guifg=#E06C75
hi goVar          guifg=#C678DD
hi goConst        guifg=#C678DD
hi goType         guifg=#E5C07B
hi goTypeName     guifg=#E5C07B
hi goDeclType     guifg=#56B6C2
hi goTypeDecl     guifg=#C678DD

" HTML (keep consistent with Markdown, below)
hi htmlArg            guifg=#D19A66
hi htmlBold           guifg=#D19A66 gui=bold
hi htmlEndTag         guifg=#ABB2BF
hi htmlH1             guifg=#E06C75
hi htmlH2             guifg=#E06C75
hi htmlH3             guifg=#E06C75
hi htmlH4             guifg=#E06C75
hi htmlH5             guifg=#E06C75
hi htmlH6             guifg=#E06C75
hi htmlItalic         guifg=#C678DD gui=italic
hi htmlLink           guifg=#56B6C2 gui=underline
hi htmlSpecialChar    guifg=#D19A66
hi htmlSpecialTagName guifg=#E06C75
hi htmlTag            guifg=#ABB2BF
hi htmlTagN           guifg=#E06C75
hi htmlTagName        guifg=#E06C75
hi htmlTitle          guifg=#ABB2BF

" JavaScript
hi javaScriptBraces     guifg=#ABB2BF
hi javaScriptFunction   guifg=#C678DD
hi javaScriptIdentifier guifg=#C678DD
hi javaScriptNull       guifg=#D19A66
hi javaScriptNumber     guifg=#D19A66
hi javaScriptRequire    guifg=#56B6C2
hi javaScriptReserved   guifg=#C678DD
" http//github.com/pangloss/vim-javascript
hi jsArrowFunction   guifg=#C678DD
hi jsClassKeyword    guifg=#C678DD
hi jsClassMethodType guifg=#C678DD
hi jsDocParam        guifg=#61AFEF
hi jsDocTags         guifg=#C678DD
hi jsExport          guifg=#C678DD
hi jsExportDefault   guifg=#C678DD
hi jsExtendsKeyword  guifg=#C678DD
hi jsFrom            guifg=#C678DD
hi jsFuncCall        guifg=#61AFEF
hi jsFunction        guifg=#C678DD
hi jsGenerator       guifg=#E5C07B
hi jsGlobalObjects   guifg=#E5C07B
hi jsImport          guifg=#C678DD
hi jsModuleAs        guifg=#C678DD
hi jsModuleWords     guifg=#C678DD
hi jsModules         guifg=#C678DD
hi jsNull            guifg=#D19A66
hi jsOperator        guifg=#C678DD
hi jsStorageClass    guifg=#C678DD
hi jsSuper           guifg=#E06C75
hi jsTemplateBraces  guifg=#BE5046
hi jsTemplateVar     guifg=#98C379
hi jsThis            guifg=#E06C75
hi jsUndefined       guifg=#D19A66
" http//github.com/othree/yajs.vim
hi javascriptArrowFunc    guifg=#C678DD
hi javascriptClassExtends guifg=#C678DD
hi javascriptClassKeyword guifg=#C678DD
hi javascriptDocNotation  guifg=#C678DD
hi javascriptDocParamName guifg=#61AFEF
hi javascriptDocTags      guifg=#C678DD
hi javascriptEndColons    guifg=#ABB2BF
hi javascriptExport       guifg=#C678DD
hi javascriptFuncArg      guifg=#ABB2BF
hi javascriptFuncKeyword  guifg=#C678DD
hi javascriptIdentifier   guifg=#E06C75
hi javascriptImport       guifg=#C678DD
hi javascriptMethodName   guifg=#ABB2BF
hi javascriptObjectLabel  guifg=#ABB2BF
hi javascriptOpSymbol     guifg=#56B6C2
hi javascriptOpSymbols    guifg=#56B6C2
hi javascriptPropertyName guifg=#98C379
hi javascriptTemplateSB   guifg=#BE5046
hi javascriptVariable     guifg=#C678DD

" JSON
hi jsonCommentError      guifg=#ABB2BF
hi jsonKeyword           guifg=#E06C75
hi jsonBoolean           guifg=#D19A66
hi jsonNumber            guifg=#D19A66
hi jsonQuote             guifg=#ABB2BF
hi jsonMissingCommaError guifg=#E06C75 gui=reverse
hi jsonNoQuotesError     guifg=#E06C75 gui=reverse
hi jsonNumError          guifg=#E06C75 gui=reverse
hi jsonString            guifg=#98C379
hi jsonStringSQError     guifg=#E06C75 gui=reverse
hi jsonSemicolonError    guifg=#E06C75 gui=reverse

" LESS
hi lessVariable      guifg=#C678DD
hi lessAmpersandChar guifg=#ABB2BF
hi lessClass         guifg=#D19A66

" Markdown (keep consistent with HTML, above)
hi markdownBlockquote        guifg=#5C6370
hi markdownBold              guifg=#D19A66 gui=bold
hi markdownCode              guifg=#98C379
hi markdownCodeBlock         guifg=#98C379
hi markdownCodeDelimiter     guifg=#98C379
hi markdownH1                guifg=#E06C75
hi markdownH2                guifg=#E06C75
hi markdownH3                guifg=#E06C75
hi markdownH4                guifg=#E06C75
hi markdownH5                guifg=#E06C75
hi markdownH6                guifg=#E06C75
hi markdownHeadingDelimiter  guifg=#E06C75
hi markdownHeadingRule       guifg=#5C6370
hi markdownId                guifg=#C678DD
hi markdownIdDeclaration     guifg=#61AFEF
hi markdownIdDelimiter       guifg=#C678DD
hi markdownItalic            guifg=#C678DD gui=italic
hi markdownLinkDelimiter     guifg=#C678DD
hi markdownLinkText          guifg=#61AFEF
hi markdownListMarker        guifg=#E06C75
hi markdownOrderedListMarker guifg=#E06C75
hi markdownRule              guifg=#5C6370
hi markdownUrl               guifg=#56B6C2 gui=underline

" Perl
hi perlFiledescRead      guifg=#98C379
hi perlFunction          guifg=#C678DD
hi perlMatchStartEnd     guifg=#61AFEF
hi perlMethod            guifg=#C678DD
hi perlPOD               guifg=#5C6370
hi perlSharpBang         guifg=#5C6370
hi perlSpecialString     guifg=#D19A66
hi perlStatementFiledesc guifg=#E06C75
hi perlStatementFlow     guifg=#E06C75
hi perlStatementInclude  guifg=#C678DD
hi perlStatementScalar   guifg=#C678DD
hi perlStatementStorage  guifg=#C678DD
hi perlSubName           guifg=#E5C07B
hi perlVarPlain          guifg=#61AFEF

" PHP
hi phpVarSelector    guifg=#E06C75
hi phpOperator       guifg=#ABB2BF
hi phpParent         guifg=#ABB2BF
hi phpMemberSelector guifg=#ABB2BF
hi phpType           guifg=#C678DD
hi phpKeyword        guifg=#C678DD
hi phpClass          guifg=#E5C07B
hi phpUseClass       guifg=#ABB2BF
hi phpUseAlias       guifg=#ABB2BF
hi phpInclude        guifg=#C678DD
hi phpClassExtends   guifg=#98C379
hi phpDocTags        guifg=#ABB2BF
hi phpFunction       guifg=#61AFEF
hi phpFunctions      guifg=#56B6C2
hi phpMethodsVar     guifg=#D19A66
hi phpMagicConstants guifg=#D19A66
hi phpSuperglobals   guifg=#E06C75
hi phpConstants      guifg=#D19A66

" Ruby
hi rubyBlockParameter            guifg=#E06C75
hi rubyBlockParameterList        guifg=#E06C75
hi rubyClass                     guifg=#C678DD
hi rubyConstant                  guifg=#E5C07B
hi rubyControl                   guifg=#C678DD
hi rubyEscape                    guifg=#E06C75
hi rubyFunction                  guifg=#61AFEF
hi rubyGlobalVariable            guifg=#E06C75
hi rubyInclude                   guifg=#61AFEF
hi rubyIncluderubyGlobalVariable guifg=#E06C75
hi rubyInstanceVariable          guifg=#E06C75
hi rubyInterpolation             guifg=#56B6C2
hi rubyInterpolationDelimiter    guifg=#E06C75
hi rubyInterpolationDelimiter    guifg=#E06C75
hi rubyRegexp                    guifg=#56B6C2
hi rubyRegexpDelimiter           guifg=#56B6C2
hi rubyStringDelimiter           guifg=#98C379
hi rubySymbol                    guifg=#56B6C2

" Sass
" http//github.com/tpope/vim-haml
hi sassAmpersand      guifg=#E06C75
hi sassClass          guifg=#D19A66
hi sassControl        guifg=#C678DD
hi sassExtend         guifg=#C678DD
hi sassFor            guifg=#ABB2BF
hi sassFunction       guifg=#56B6C2
hi sassId             guifg=#61AFEF
hi sassInclude        guifg=#C678DD
hi sassMedia          guifg=#C678DD
hi sassMediaOperators guifg=#ABB2BF
hi sassMixin          guifg=#C678DD
hi sassMixinName      guifg=#61AFEF
hi sassMixing         guifg=#C678DD
hi sassVariable       guifg=#C678DD
" http//github.com/cakebaker/scss-syntax.vim
hi scssExtend       guifg=#C678DD
hi scssImport       guifg=#C678DD
hi scssInclude      guifg=#C678DD
hi scssMixin        guifg=#C678DD
hi scssSelectorName guifg=#D19A66
hi scssVariable     guifg=#C678DD

" TeX
hi texStatement    guifg=#C678DD
hi texSubscripts   guifg=#D19A66
hi texSuperscripts guifg=#D19A66
hi texTodo         guifg=#BE5046
hi texBeginEnd     guifg=#C678DD
hi texBeginEndName guifg=#61AFEF
hi texMathMatcher  guifg=#61AFEF
hi texMathDelim    guifg=#61AFEF
hi texDelimiter    guifg=#D19A66
hi texSpecialChar  guifg=#D19A66
hi texCite         guifg=#61AFEF
hi texRefZone      guifg=#61AFEF

" TypeScript
hi typescriptReserved  guifg=#C678DD
hi typescriptEndColons guifg=#ABB2BF
hi typescriptBraces    guifg=#ABB2BF

" XML
hi xmlAttrib  guifg=#D19A66
hi xmlEndTag  guifg=#E06C75
hi xmlTag     guifg=#E06C75
hi xmlTagName guifg=#E06C75

" plasticboy/vim-markdown (keep consistent with Markdown, above)
hi mkdDelimiter guifg=#C678DD
hi mkdHeading   guifg=#E06C75
hi mkdLink      guifg=#61AFEF
hi mkdURL       guifg=#56B6C2 gui=underline

" tpope/vim-fugitive
hi diffAdded   guifg=#98C379
hi diffRemoved guifg=#E06C75
hi diffChanged guifg=#E5C07B

" lewis6991/gitsigns.nvim
hi GitSignsAdd    guifg=#98C379
hi GitSignsChange guifg=#E5C07B
hi GitSignsDelete guifg=#E06C75
hi GitSignsCurrentLineBlame guifg=#5C6370

" Git Highlighting
hi gitcommitComment       guifg=#5C6370
hi gitcommitUnmerged      guifg=#98C379
hi gitcommitOnBranch      guifg=NONE
hi gitcommitBranch        guifg=#C678DD
hi gitcommitDiscardedType guifg=#E06C75
hi gitcommitSelectedType  guifg=#98C379
hi gitcommitHeader        guifg=NONE
hi gitcommitUntrackedFile guifg=#56B6C2
hi gitcommitDiscardedFile guifg=#E06C75
hi gitcommitSelectedFile  guifg=#98C379
hi gitcommitUnmergedFile  guifg=#E5C07B
hi gitcommitFile          guifg=NONE
hi gitcommitSummary       guifg=#ABB2BF
hi gitcommitOverflow      guifg=#E06C75
hi link gitcommitNoBranch       gitcommitBranch
hi link gitcommitUntracked      gitcommitComment
hi link gitcommitDiscarded      gitcommitComment
hi link gitcommitSelected       gitcommitComment
hi link gitcommitDiscardedArrow gitcommitDiscardedFile
hi link gitcommitSelectedArrow  gitcommitSelectedFile
hi link gitcommitUnmergedArrow  gitcommitUnmergedFile

hi link DiffviewNormal Dim
hi DiffviewFilePanelTitle    guifg=#61AFEF
hi DiffviewFilePanelFileName guifg=#ABB2BF
hi DiffviewNonText           guifg=#5C6370

hi LirDir          guifg=#61AFEF
hi LirSymLink      guifg=#56B6C2
hi LirEmptyDirText guifg=#ABB2BF

" Neovim terminal colors
let g:terminal_color_0  = '#3E4452'
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
let g:terminal_color_background = '#282C34'
let g:terminal_color_foreground = '#ABB2BF'

set background=dark
finish

" hi TSAnnotation         guifg=${white}
" hi TSAttribute          guifg=${cyan}
" hi TSBoolean            guifg=${orange}
" hi TSCharacter          guifg=${orange}
" hi TSComment            guifg=${comment_grey}
" hi TSConditional        guifg=${purple}
" hi TSConstant           guifg=${orange}
" hi TSConstBuiltin       guifg=${orange}
" hi TSConstMacro         guifg=${orange}
" hi TSConstructor        guifg=${yellow} gui=bold
" hi TSError              guifg=${white}
" hi TSException          guifg=${purple}
" hi TSField              guifg=${cyan}
" hi TSFloat              guifg=${orange}
" hi TSFunction           guifg=${blue}
" hi TSFuncBuiltin        guifg=${cyan}
" hi TSFuncMacro          guifg=${cyan}
" hi TSInclude            guifg=${purple}
" hi TSKeyword            guifg=${purple}
" hi TSKeywordFunction    guifg=${purple}
" hi TSKeywordOperator    guifg=${purple}
" hi TSLabel              guifg=${red}
" hi TSMethod             guifg=${blue}
" hi TSNamespace          guifg=${yellow}
" hi TSNone               guifg=${white}
" hi TSNumber             guifg=${orange}
" hi TSOperator           guifg=${white}
" hi TSParameter          guifg=${red}
" hi TSParameterReference guifg=${white}
" hi TSProperty           guifg=${cyan}
" hi TSPunctDelimiter     guifg=#848b98
" hi TSPunctBracket       guifg=#848b98
" hi TSPunctSpecial       guifg=${red}
" hi TSRepeat             guifg=${purple}
" hi TSString             guifg=${green}
" hi TSStringRegex        guifg=${blue}
" hi TSStringEscape       guifg=${orange}
" hi TSSymbol             guifg=${cyan}
" hi TSTag                guifg=${red}
" hi TSTagDelimiter       guifg=${red}
" hi TSText               guifg=${white}
" hi TSStrong             guifg=${white} gui=bold
" hi TSEmphasis           guifg=${white} gui=italic
" hi TSUnderline          guifg=${white} gui=underline
" hi TSStrike             guifg=${white} gui=strikethrough
" hi TSTitle              guifg=${orange} gui=bold
" hi TSLiteral            guifg=${green}
" hi TSURI                guifg=${cyan} gui=underline
" hi TSMath               guifg=${white}
" hi TSTextReference      guifg=${blue}
" hi TSEnviroment         guifg=${white}
" hi TSEnviromentName     guifg=${white}
" hi TSNote               guifg=${white}
" hi TSWarning            guifg=${white}
" hi TSDanger             guifg=${white}
" hi TSType               guifg=${yellow}
" hi TSTypeBuiltin        guifg=${orange}
" hi TSVariable           guifg=${white}
" hi TSVariableBuiltin    guifg=${white}

" vim: ft=vim
