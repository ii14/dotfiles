# neopm

Plugin manager for neovim, pre-alpha stage.

## TODO

- [X] Install plugins
- [X] Update plugins
- [X] Automatic plugin patching
- [ ] Error reporting
- [ ] Show git log
- [ ] Show git reflog and restore updates
- [ ] Fetch and review pending updates
- [ ] Show diffs
- [ ] Manage patches
- [ ] Lockfile
- [ ] Overview
- [ ] Commands
- [X] Generate help tags
- [ ] Plugin options
  - [X] Plugin dependencies
  - [X] Post load hook
  - [ ] Post install hook
  - [ ] Lazy loading
    - [X] Filetype
    - [X] Commands
    - [ ] Key mappings
    - [ ] Events
    - [ ] Functions
    - [ ] Lua modules
    - [ ] On demand
  - [ ] Clone
    - [ ] branch
    - [ ] tag
    - [ ] commit

## Install

```
mkdir -p ~/.config/nvim/lua
git clone https://github.com/ii14/neopm ~/.config/nvim/lua/neopm
```

## Managing plugins

```lua
-- can be a global or local variable, doesn't matter.
-- name can be anything, eg. you can use `p` or `P` if
-- you prefer it to be something shorter.
Plug = require('neopm')

-- default config:
-- Plug.config {
--   install_dir = vim.fn.stdpath('data')..'/neopm',
--   patch_dir   = vim.fn.stdpath('config')..'/patches',
--   git_command = 'git',
-- }

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
if vim.g.enable_lua_theme == nil then
  Plug 'itchyny/lightline.vim'
  Plug 'mengelbrecht/lightline-bufferline'
end
Plug 'lukas-reineke/indent-blankline.nvim'

-- File management --
Plug 'junegunn/fzf' { run = ':call fzf#install()' } -- post install hook, not implemented
Plug 'junegunn/fzf.vim' { depends = 'junegunn/fzf' } -- depend on other plugin
Plug 'lambdalisue/fern.vim' { depends = 'antoinemadec/FixCursorHold.nvim' }
Plug 'LumaKernel/fern-mapping-fzf.vim'
Plug 'bogado/file-line'

-- Autocompletion --
if vim.g.disable_lsp == nil then
  Plug 'neovim/nvim-lspconfig'
  Plug 'ii14/lsp-command'
  Plug 'jose-elias-alvarez/null-ls.nvim' { depends = 'nvim-lua/plenary.nvim' }
  Plug 'folke/trouble.nvim'
end
Plug 'hrsh7th/nvim-compe'
Plug 'L3MON4D3/LuaSnip'

-- Development --
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'lewis6991/gitsigns.nvim' { depends = 'nvim-lua/plenary.nvim' }
Plug 'sindrets/diffview.nvim' { depends = 'nvim-lua/plenary.nvim' }
Plug 'tpope/vim-dispatch'
Plug 'ii14/exrc.vim'
if vim.env.NO_NREPL == nil then
  Plug 'ii14/nrepl.nvim'
end

-- Syntax --
Plug 'sheerun/vim-polyglot'
Plug 'fedorenchik/qt-support.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'ii14/vim-rasi'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'milisims/nvim-luaref'

-- Misc --
Plug 'vimwiki/vimwiki' { on = 'VimwikiIndex', ft = { 'vimwiki', 'markdown' } }
Plug 'kizza/actionmenu.nvim'

-- Performance --
Plug 'tweekmonster/startuptime.vim'
Plug 'lewis6991/impatient.nvim'
Plug 'nathom/filetype.nvim'

-- checks if there are any uninstalled plugins
Plug.autoinstall(true)
-- finish it up by loading declared plugins
Plug.load()
```

### Install and update plugins

```
:Neopm install
:Neopm update
```

### Patching plugins

You can create automatically applied patches for plugins by saving diffs
to the `~/.config/nvim/patches` directory:

```
mkdir -p ~/.config/nvim/patches
cd ~/.local/share/nvim/neopm/some-vim-plugin
# make some edits
git diff > ~/.config/nvim/patches/some-vim-plugin.diff
```

This process will be more streamlined in the future.

---

Thanks to [junegunn/vim-plug](https://github.com/junegunn/vim-plug).
