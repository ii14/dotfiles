Plug = require('neopm')

-- Plug.config {
--   install_dir = vim.fn.stdpath('data')..'/neopm2',
-- }

local function lazy(name)
  return function()
    require('m.lazy')[name]()
  end
end

-- Editing --
Plug 'ii14/vim-surround'
-- Plug 'kylechui/nvim-surround'
Plug 'numToStr/Comment.nvim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'wellle/targets.vim'
Plug 'tommcdo/vim-exchange'
Plug 'haya14busa/vim-asterisk'
Plug 'RRethy/nvim-align'
Plug 'ii14/vim-bbye'
Plug 'mbbill/undotree'
Plug 'wellle/visual-split.vim'
-- Plug 'phaazon/hop.nvim'

-- Visual --
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'romainl/vim-cool'

-- File management --
Plug 'junegunn/fzf' { run = ':call fzf#install()' }
Plug 'junegunn/fzf.vim' { depends = 'junegunn/fzf' }
Plug 'tamago324/lir.nvim'
Plug 'bogado/file-line'

-- LSP, linting --
if not vim.g.options.NoLsp then
  Plug 'neovim/nvim-lspconfig'
  Plug 'ii14/lsp-command'
  Plug 'mfussenegger/nvim-lint'
  Plug 'folke/trouble.nvim' {
    setup = lazy 'trouble',
    on = { 'Trouble', 'TroubleClose', 'TroubleRefresh', 'TroubleToggle' },
  }
  Plug 'j-hui/fidget.nvim'
end

-- Completion, snippets --
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

-- Development --
Plug 'tpope/vim-dispatch'
Plug 'ii14/exrc.vim'
Plug 'ii14/nrepl.nvim'

-- Git --
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'lewis6991/gitsigns.nvim' { depends = 'nvim-lua/plenary.nvim' }
-- Plug 'sindrets/diffview.nvim' { depends = 'nvim-lua/plenary.nvim' }

-- Syntax, language support --
Plug 'sheerun/vim-polyglot'
Plug 'fedorenchik/qt-support.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'ii14/vim-rasi'
Plug 'norcalli/nvim-colorizer.lua'
if vim.g.options.Ts then
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'nvim-treesitter/playground'
end
-- Plug 'teal-language/vim-teal'

-- Misc --
Plug 'vimwiki/vimwiki' { on = 'VimwikiIndex', ft = { 'vimwiki', 'markdown' } }

-- Docs --
Plug 'milisims/nvim-luaref'
Plug 'ii14/luv-vim-docs'
-- Plug 'ii14/emmylua-nvim'
-- Plug 'bfredl/luarefvim'

-- Performance --
Plug 'tweekmonster/startuptime.vim'
Plug 'lewis6991/impatient.nvim'

Plug.autoinstall(true)
Plug.load()
