local M = {}

local colors = {
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
  N = { fg = colors.bg, bg = colors.green },
  I = { fg = colors.bg, bg = colors.blue },
  V = { fg = colors.bg, bg = colors.purple },
  R = { fg = colors.bg, bg = colors.red },

  FN = { fg = colors.green, bg = colors.gray4 },
  FI = { fg = colors.blue, bg = colors.gray4 },
  FV = { fg = colors.purple, bg = colors.gray4 },
  FR = { fg = colors.red, bg = colors.gray4 },

  A = { fg = colors.bg, bg = colors.fg },
  B = { fg = colors.fg, bg = colors.gray3 },
  C = { fg = colors.fg, bg = colors.gray4 },

  AS = { fg = colors.bg, bg = colors.fg },       -- A separator
  BS = { fg = colors.bg, bg = colors.gray3 },    -- B separator
  CS = { fg = colors.gray1, bg = colors.gray4 }, -- C separator
  DS = { fg = colors.gray3, bg = colors.gray4 },
  BG = { fg = colors.gray3, bg = colors.bg },    -- background
  EL = { fg = colors.gray1, bg = colors.bg },    -- ellipsis
  NB = { fg = colors.bg, bg = colors.gray3 },    -- no buffers
}

function M.hl(name)
  return '%#Statusline'..name..'#'
end

for name, value in pairs(highlights) do
  vim.cmd('highlight Statusline'..name..' guifg='..value.fg..' guibg='..value.bg)
end

return M
