setl formatoptions-=o
setl formatoptions-=r
let &l:include = '\v<((do|load)file|require)[^''"]*[''"]\zs[^''"]+'
let &l:includeexpr = 'luaeval(''require"m.misc".includeexpr()'')'
