[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"


[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

PathAppend()  { [ -d "$1" ] && PATH="$PATH:$1"; }
PathPrepend() { [ -d "$1" ] && PATH="$1:$PATH"; }

    # GO
    PathAppend "/usr/local/go/bin"
    PathAppend "$HOME/go/bin"
    # HASKELL
    PathAppend "/opt/ghc/bin"
    PathAppend "/opt/cabal/bin"
    # NIM
    PathAppend "$HOME/.nimble/bin"
    # RUST
    PathAppend "$HOME/.cargo/bin"

unset PathAppend
unset PathPrepend


export TERMINAL='alacritty'
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export BROWSER='firefox'
export READER='zathura'
export MEDIAPLAYER='mpv'


export ZDOTDIR="$HOME/.config/zsh"
export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"


export LESS='-R'
export LESSHISTFILE="$HOME/.cache/lesshst"
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


# if [ -e /home/ms/.nix-profile/etc/profile.d/nix.sh ]; then . /home/ms/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
