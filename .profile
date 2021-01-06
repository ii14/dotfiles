[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# XDG SPECS ------------------------------------------------------------------------------
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# PATH -----------------------------------------------------------------------------------
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

PathAppend() { [ -d "$1" ] && PATH="$PATH:$1"; }
PathAppend "/usr/local/go/bin"
PathAppend "$XDG_DATA_HOME/go/bin"
PathAppend "/opt/ghc/bin"
PathAppend "/opt/cabal/bin"
PathAppend "$XDG_DATA_HOME/cargo/bin"
PathAppend "$XDG_DATA_HOME/gem/bin"
unset PathAppend

# APPLICATIONS ---------------------------------------------------------------------------
export TERMINAL='alacritty'
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export BROWSER='firefox'
export READER='zathura'
export MEDIAPLAYER='mpv'

# XDG COMPLIANCE -------------------------------------------------------------------------
export ZDOTDIR="$HOME/.config/zsh"
export LESSHISTFILE="$XDG_CACHE_HOME/lesshst"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/pythonrc.py"
export DOCKER_CONFIG="$XDG_DATA_HOME/docker"
export GOPATH="$XDG_DATA_HOME/go"
export PYLINTHOME="$XDG_DATA_HOME/pylint"
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export NIMBLE_DIR="$XDG_DATA_HOME/nimble"
export CABAL_DIR="$XDG_DATA_HOME/cabal"
export CABAL_CONFIG="$XDG_CONFIG_HOME/cabal/config"
export GHCUP_INSTALL_BASE_PREFIX="$XDG_DATA_HOME"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export SOLARGRAPH_CACHE="$XDG_CACHE_HOME/solargraph"
export PSQL_HISTORY="$XDG_CACHE_HOME/psql_history"
export WINEPREFIX="$XDG_DATA_HOME/wine"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# MISC -----------------------------------------------------------------------------------
export LESS='-iMR'
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_so=$'\e[1;44;30m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_ue=$'\e[0m'
export GROFF_NO_SGR=1
export GODOCC_STYLE='dracula'

[ -f "$HOME/.secrets" ] && . "$HOME/.secrets"

[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec startx

# [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"
