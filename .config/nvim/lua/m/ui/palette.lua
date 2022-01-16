local M = {}

local c = {
  blue   = '#61afef',
  green  = '#98c379',
  purple = '#c678dd',
  red    = '#e06c75',
  yellow = '#e5c07b',
  fg     = '#abb2bf',
  gray1  = '#5c6370',
  gray2  = '#4B5263',
  gray3  = '#3e4452',
  gray4  = '#2c323d',
  bg     = '#282c34',
  dark   = '#21252C',
}

local highlights = {
  N  = { bg = c.green,  fg = c.bg     },
  I  = { bg = c.blue,   fg = c.bg     },
  V  = { bg = c.purple, fg = c.bg     },
  R  = { bg = c.red,    fg = c.bg     },

  FN = { bg = c.gray4,  fg = c.green  },
  FI = { bg = c.gray4,  fg = c.blue   },
  FV = { bg = c.gray4,  fg = c.purple },
  FR = { bg = c.gray4,  fg = c.red    },

  A  = { bg = c.fg,     fg = c.bg     },
  B  = { bg = c.gray3,  fg = c.fg     },
  C  = { bg = c.gray4,  fg = c.fg     },
  L  = { bg = c.gray2,  fg = c.fg     }, -- alternate buffer

  AS = { bg = c.fg,     fg = c.bg     }, -- A separator
  BS = { bg = c.gray3,  fg = c.bg     }, -- B separator
  CS = { bg = c.gray4,  fg = c.gray1  }, -- C separator
  LS = { bg = c.gray2,  fg = c.bg     }, -- L separator
  DS = { bg = c.gray4,  fg = c.gray3  },
  BG = { bg = c.bg,     fg = c.gray3  }, -- background
  EL = { bg = c.bg,     fg = c.gray1  }, -- ellipsis
  NB = { bg = c.gray3,  fg = c.bg     }, -- no buffers
}

function M.hl(name)
  return '%#Statusline'..name..'#'
end

for name, value in pairs(highlights) do
  vim.cmd('highlight Statusline'..name..' guifg='..value.fg..' guibg='..value.bg)
end

-- local p = {
--   ['b'] = '#61afef',
--   ['g'] = '#98c379',
--   ['p'] = '#c678dd',
--   ['r'] = '#e06c75',
--   ['y'] = '#e5c07b',
--   ['0'] = '#abb2bf',
--   ['1'] = '#5c6370',
--   ['2'] = '#4B5263',
--   ['3'] = '#3e4452',
--   ['4'] = '#2c323d',
--   ['5'] = '#282c34',
--   ['6'] = '#21252C',
-- }

-- local m = {}
-- function M.H(x)
--   if not m[x] then
--     local bg = p[x:sub(1,1)]
--     local fg = p[x:sub(2,2)]
--     vim.cmd('highlight Statusline'..x..' guifg='..fg..' guibg='..bg)
--     m[x] = true
--   end
--   return 'Statusline'..x
-- end

return M
