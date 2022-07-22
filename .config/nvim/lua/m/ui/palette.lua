local blue   = '#61afef'
local green  = '#98c379'
local purple = '#c678dd'
local red    = '#e06c75'
local yellow = '#e5c07b'
local fg     = '#abb2bf'
local lgray  = '#848b98'
local gray1  = '#5c6370'
local gray2  = '#4B5263'
local gray3  = '#3e4452'
local gray4  = '#2c323d'
local bg     = '#282c34'
local dark   = '#21252C'

local set_hl = vim.api.nvim_set_hl

for k, v in pairs({
  N  = { bg = green,  fg = bg     },
  I  = { bg = blue,   fg = bg     },
  V  = { bg = purple, fg = bg     },
  R  = { bg = red,    fg = bg     },
  E  = { bg = yellow, fg = bg     },

  FN = { bg = gray4,  fg = green  },
  FI = { bg = gray4,  fg = blue   },
  FV = { bg = gray4,  fg = purple },
  FR = { bg = gray4,  fg = red    },
  FE = { bg = gray4,  fg = yellow },

  A  = { bg = fg,     fg = bg     },
  B  = { bg = gray3,  fg = fg     },
  C  = { bg = gray4,  fg = fg     },
  L  = { bg = gray2,  fg = fg     }, -- alternate buffer

  AS = { bg = fg,     fg = bg     }, -- A separator
  BS = { bg = gray3,  fg = bg     }, -- B separator
  CS = { bg = gray4,  fg = gray1  }, -- C separator
  LS = { bg = gray2,  fg = bg     }, -- L separator
  DS = { bg = gray4,  fg = gray3  },
  BG = { bg = bg,     fg = gray3  }, -- background
  EL = { bg = bg,     fg = gray1  }, -- ellipsis
  NB = { bg = gray3,  fg = bg     }, -- no buffers
}) do
  set_hl(0, 'Statusline'..k, v)
end

local cache = {}

return {
  hl = function(name)
    if not cache[name] then
      cache[name] = '%#Statusline'..name..'#'
    end
    return cache[name]
  end,
}
