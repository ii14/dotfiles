setl formatoptions-=o
setl formatoptions-=r
let &l:include = '\v<((do|load)file|require)[^''"]*[''"]\zs[^''"]+'
let &l:includeexpr = 'm#lua_include(v:fname)'
