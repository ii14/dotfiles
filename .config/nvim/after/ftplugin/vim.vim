setl formatoptions-=o
setl formatoptions-=r
let &l:include = '\v<((do|load)file|require|Plug)[^''"]*[''"]\zs[^''"]+'
let &l:includeexpr = 'luaeval(''require"m.util".vim_includeexpr()'')'
