ZSH_PLUGIN_PATH="$ZDOTDIR/plugins"

[[ $(ps -ho comm $PPID) == 'mc' ]] && ZSH_MC=1


source "$ZDOTDIR/prompt.zsh"
source "$ZDOTDIR/options.zsh"
source "$ZDOTDIR/keys.zsh"
source "$ZDOTDIR/completion.zsh"


[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
[ -f "$HOME/.local/share/shortcuts" ] && source "$HOME/.local/share/shortcuts"


if [[ -f $ZSH_PLUGIN_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    typeset -A ZSH_HIGHLIGHT_STYLES
    ZSH_HIGHLIGHT_STYLES[comment]='fg=black'
    source $ZSH_PLUGIN_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi


[[ -f $ZSH_PLUGIN_PATH/zsh-vimode-visual/zsh-vimode-visual.plugin.zsh ]] \
    && source $ZSH_PLUGIN_PATH/zsh-vimode-visual/zsh-vimode-visual.plugin.zsh


# install fzf with ./install --xdg
FZF_DEFAULT_OPTS='--bind=ctrl-a:select-all,ctrl-u:page-up,ctrl-d:page-down,ctrl-space:toggle'
if command -v fd >/dev/null 2>&1; then
    FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude ".git"'
    FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --exclude ".git"'
    FZF_ALT_C_COMMAND='fd --type d --hidden --exclude ".git"'
    _fzf_compgen_path() { fd --hidden --exclude ".git" . "$@"; }
    _fzf_compgen_dir() { fd --type d --hidden --exclude ".git" . "$@"; }
fi
if [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ]]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
    bindkey '^g' fzf-cd-widget
fi


setopt rmstarsilent
function rm {
    echo 'Continue? [enter/y]:'
    echo -n 'rm'
    for i in "$@"; do
        if [[ $i == '-'* ]]; then
            echo -ne " \e[33m$i\e[0m"
        else
            echo -ne " $i"
        fi
    done
    read -rsk r; echo
    if [[ $r != $'\n' && $r != 'y' && $r != 'Y' ]]; then
        echo 'Operation cancelled.'
        return 1
    fi
    command rm -v "$@"
    return $?
}

alias t='trash -v'


hash -d trash="$HOME/.local/share/Trash"
hash -d lcs="$HOME/.local/share"
hash -d lcb="$HOME/.local/bin"
hash -d dls="$(xdg-user-dir DOWNLOAD)"
hash -d pic="$(xdg-user-dir PICTURES)"
hash -d vid="$(xdg-user-dir VIDEOS)"
function hashcwd {
    if [[ -z $1 ]]; then
        echo 'Argument expected' >&2
        return 1
    fi
    hash -d "$1"="$PWD"
    return $?
}


if [[ $TERM == 'alacritty' ]]; then
    eval "$(TERM=xterm-256color dircolors)"
fi
