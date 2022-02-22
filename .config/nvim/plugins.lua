Plug = require('plug')

local function lazy(name)
  return function()
    require('m.lazy')[name]()
  end
end

-- Editing --
Plug 'ii14/vim-surround'
Plug 'numToStr/Comment.nvim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'wellle/targets.vim'
Plug 'tommcdo/vim-exchange'
Plug 'haya14busa/vim-asterisk'
Plug 'romainl/vim-cool'
Plug 'godlygeek/tabular'
Plug 'ii14/vim-bbye'
Plug 'mbbill/undotree'
Plug 'wellle/visual-split.vim'

-- Visual --
Plug 'lukas-reineke/indent-blankline.nvim'

-- File management --
Plug 'junegunn/fzf' { run = ':call fzf#install()' }
Plug 'junegunn/fzf.vim' { depends = 'junegunn/fzf' }
-- Plug 'lambdalisue/fern.vim' { depends = 'antoinemadec/FixCursorHold.nvim' }
-- Plug 'LumaKernel/fern-mapping-fzf.vim'
Plug 'tamago324/lir.nvim'
Plug 'bogado/file-line'

-- Completion, LSP --
if vim.g.disable_lsp == nil then
  Plug 'neovim/nvim-lspconfig'
  Plug 'ii14/lsp-command'
  Plug 'jose-elias-alvarez/null-ls.nvim' { depends = 'nvim-lua/plenary.nvim' }
  Plug 'folke/trouble.nvim' {
    setup = lazy 'trouble',
    on = { 'Trouble', 'TroubleClose', 'TroubleRefresh', 'TroubleToggle' },
  }
  Plug 'j-hui/fidget.nvim'
  -- Plug 'mfussenegger/nvim-lint'
end
Plug 'hrsh7th/nvim-compe'
-- Plug 'tamago324/compe-necosyntax'
-- Plug 'Shougo/neco-syntax'
Plug 'L3MON4D3/LuaSnip'

-- Development --
Plug 'tpope/vim-dispatch'
Plug 'ii14/exrc.vim'
Plug 'ii14/pro.vim'
if vim.env.NO_NREPL == nil then
  Plug 'ii14/nrepl.nvim'
end

-- Git --
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'lewis6991/gitsigns.nvim' { depends = 'nvim-lua/plenary.nvim' }
Plug 'sindrets/diffview.nvim' { depends = 'nvim-lua/plenary.nvim' }

-- Syntax --
Plug 'sheerun/vim-polyglot'
Plug 'fedorenchik/qt-support.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'ii14/vim-rasi'
Plug 'norcalli/nvim-colorizer.lua'

-- Misc --
Plug 'vimwiki/vimwiki' { on = 'VimwikiIndex', ft = { 'vimwiki', 'markdown' } }
Plug 'kizza/actionmenu.nvim'

-- Docs --
Plug 'milisims/nvim-luaref'
Plug 'ii14/luv-vim-docs'

-- Performance --
Plug 'tweekmonster/startuptime.vim'
Plug 'lewis6991/impatient.nvim'
-- Plug 'nathom/filetype.nvim'

Plug.autoinstall(true)
Plug.load()
