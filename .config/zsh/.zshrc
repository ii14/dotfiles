ZSH_PLUGIN_PATH=~/.config/zsh/plugins
[[ $(ps -ho comm $PPID) == 'mc' ]] && ZSH_MC=1

# PROMPT /////////////////////////////////////////////////////////////////////////////////
autoload -U colors && colors

# Git prompt -----------------------------------------------------------------------------
if [[ -f $ZSH_PLUGIN_PATH/git-prompt.zsh/git-prompt.zsh ]]; then
    source $ZSH_PLUGIN_PATH/git-prompt.zsh/git-prompt.zsh
    ZSH_GIT_PROMPT_SHOW_UPSTREAM="no"
    ZSH_THEME_GIT_PROMPT_PREFIX="%K{233}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%K{233} "
    ZSH_THEME_GIT_PROMPT_SEPARATOR="%K{233} "
    ZSH_THEME_GIT_PROMPT_DETACHED="%K{233}%{$fg[cyan]%}:"
    ZSH_THEME_GIT_PROMPT_BRANCH="%K{233}%{$fg[yellow]%}"
    ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%K{233}%{$fg[yellow]%}⟳ "
    ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%K{233}%{$fg[red]%}(%{$fg[yellow]%}"
    ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%K{233}%{$fg[red]%})"
    ZSH_THEME_GIT_PROMPT_BEHIND="%K{233}↓"
    ZSH_THEME_GIT_PROMPT_AHEAD="%K{233}↑"
    ZSH_THEME_GIT_PROMPT_UNMERGED="%K{233}%{$fg[red]%}x"
    ZSH_THEME_GIT_PROMPT_STAGED="%K{233}%{$fg[green]%}●"
    ZSH_THEME_GIT_PROMPT_UNSTAGED="%K{233}%{$fg[red]%}+"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%K{233}…"
    ZSH_THEME_GIT_PROMPT_STASHED="%K{233}%{$fg[blue]%}⚑"
    ZSH_THEME_GIT_PROMPT_CLEAN="%K{233}%{$fg[green]%}✔"
    _zsh_gitprompt_loaded=0
fi

# Vim mode indicator ---------------------------------------------------------------------
_zsh_vim_ins_mode=2 # main mode color: green
_zsh_vim_cmd_mode=4 # vim mode color: blue
_zsh_vim_mode=$_zsh_vim_ins_mode

function zle-keymap-select {
    _zsh_vim_mode="${${KEYMAP/vicmd/${_zsh_vim_cmd_mode}}/(main|viins)/${_zsh_vim_ins_mode}}"
    zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
    _zsh_vim_mode=$_zsh_vim_ins_mode
}
zle -N zle-line-finish

function TRAPINT() {
    _zsh_vim_mode=$_zsh_vim_ins_mode
    return $(( 128 + $1 ))
}

# Prompt ---------------------------------------------------------------------------------
if [[ "$TERM" == 'linux' || -n "$ZSH_MC" ]]; then
    # no fancy prompt on linux tty
    PROMPT='%n@%m:%~$ '
else
    PROMPT='%K{233}%f '

    # print user@host if logged in through ssh
    if [[ -v SSH_CONNECTION ]]; then
        PROMPT+='%b%n@%m%B '
    fi

    # print directory
    PROMPT+='%B%(4~|%-1~/…/%2~|%3~)%b '

    # print git branch
    if [[ -v _zsh_gitprompt_loaded ]]; then
        PROMPT+='$(gitprompt)'
    fi

    # print emacs/vim mode indicator
    PROMPT+='%F{233}%K{${_zsh_vim_mode}}%k%F{${_zsh_vim_mode}}%f '

    # set terminal window title
    if [[ -v SSH_CONNECTION ]]; then
        _set_title() {
            local _title
            [[ -n $TITLE ]] && _title="${TITLE}: " || _title=''
            (echo -ne "\033]0;$_title$USER@$HOST:$(dirs -p | head -n 1) - zsh\007") 2>/dev/null
        }
    else
        _set_title() {
            local _title
            [[ -n $TITLE ]] && _title="${TITLE}: " || _title=''
            (echo -ne "\033]0;$_title$(dirs -p | head -n 1) - zsh\007") 2>/dev/null
        }
    fi
    precmd_functions+=(_set_title)
fi

# INCLUDES ///////////////////////////////////////////////////////////////////////////////
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
[ -f "$HOME/.local/share/shortcuts" ] && source "$HOME/.local/share/shortcuts"


# OPTIONS ////////////////////////////////////////////////////////////////////////////////
# setopt menu_complete            # insert first match of the completion
setopt list_packed              # fit more completions on the screen
setopt auto_cd                  # change directory by writing the directory name
setopt notify                   # report job status immediately
setopt no_flow_control          # disable flow control - Ctrl+S and Ctrl+Q keys
setopt interactive_comments     # allow comments
setopt noclobber                # >! or >| for existing files

# History --------------------------------------------------------------------------------
setopt append_history
setopt share_history            # share history between sessions
setopt hist_ignore_all_dups     # remove duplicate commands from history
setopt hist_ignore_space        # don't add commands with leading space to history
SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.cache/zsh/history

# Directory stack ------------------------------------------------------------------------
setopt auto_pushd               # automatically push previous directory to the stack
setopt pushd_minus              # swap + and -
setopt pushd_silent             # silend pushd and popd
setopt pushd_to_home            # pushd defaults to $HOME
DIRSTACKSIZE=12
alias dh='dirs -v'


# KEY BINDINGS ///////////////////////////////////////////////////////////////////////////
if [[ -z $ZSH_MC ]]; then # mc fix
export KEYTIMEOUT=1

# Emacs key bindings with Vim normal mode ------------------------------------------ [Esc]
bindkey -e
# bindkey '^x\e' vi-cmd-mode
# bindkey -M vicmd '\e' vi-add-next
bindkey -r '^j'
bindkey -rM vicmd '^j'

# Filter history ------------------------------------------------------------- [Up] [Down]
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A'  up-line-or-beginning-search
bindkey '^[OA'  up-line-or-beginning-search
bindkey '^p'    up-line-or-beginning-search
bindkey '^[[B'  down-line-or-beginning-search
bindkey '^[OB'  down-line-or-beginning-search
bindkey '^n'    down-line-or-beginning-search

# Backward delete word ---------------------------------------------------------- [Ctrl+W]
my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^w' my-backward-delete-word

# Backward delete line ---------------------------------------------------------- [Ctrl+U]
bindkey '^u' backward-kill-line

# Backward/forward word/char ------------------------------------------ [{Ctrl,Alt}+{B,F}]
bindkey '^b' backward-word
bindkey '^f' forward-word
bindkey '^[b' backward-char
bindkey '^[f' forward-char

# Jump between words ------------------------------------------------- [Ctrl+{Left,Right}]
[[ "${terminfo[kLFT5]}" != "" ]] && bindkey "${terminfo[kLFT5]}" backward-word
[[ "${terminfo[kRIT5]}" != "" ]] && bindkey "${terminfo[kRIT5]}" forward-word
# bindkey '\e[1;5D' backward-word
# bindkey '\e[1;5C' forward-word

# Search backward for string ---------------------------------------------------- [Ctrl+R]
# replaced by fzf
bindkey '^r' history-incremental-search-backward

# Completion menu backwards -------------------------------------------------- [Shift+Tab]
[[ "${terminfo[kcbt]}" != "" ]] && bindkey "${terminfo[kcbt]}" reverse-menu-complete

# Go to beginning or end of line -------------------------------------------- [Home] [End]
[[ "${terminfo[khome]}" != "" ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ "${terminfo[kend]}" != "" ]] && bindkey "${terminfo[kend]}" end-of-line

# Edit command line ------------------------------------------------------ [Ctrl+X,Ctrl+E]
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Completion menu vim movement ------------------------------------------ [Ctrl+{h,j,k,l}]
# zmodload zsh/complist
# bindkey -M menuselect '^k' up-line-or-history
# bindkey -M menuselect '^p' up-line-or-history
# bindkey -M menuselect '^j' down-line-or-history
# bindkey -M menuselect '^n' down-line-or-history
# bindkey -M menuselect '^l' forward-char
# bindkey -M menuselect '^h' backward-char

# bindkey -M menuselect '^y' accept-search
# bindkey -M menuselect '^e' send-break
# bindkey -M menuselect '\e' send-break
# bindkey -M menuselect '^r' history-incremental-search-forward

bindkey '^y' accept-search

# Switch between background and foreground -------------------------------------- [Ctrl+Z]
function fg-bg() {
    if [[ $#BUFFER -eq 0 ]]; then
        fg
    else
        zle push-input
    fi
}
zle -N fg-bg
bindkey '^z' fg-bg

# Expand "!" with space
bindkey ' ' magic-space

fi # mc fix


# COMPLETION /////////////////////////////////////////////////////////////////////////////
fpath=(~/.config/zsh/completions $fpath)

autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump
compdef _rc rc
compdef g=git
compdef dot=git

zstyle ':completion:*' add-space false

zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' use-compctl false

zstyle ':completion:*' verbose true
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*:descriptions' format '%B%F{2}%d%f%b'
zstyle ':completion:*:messages' format '%F{5}%d%f'
zstyle ':completion:*:warnings' format '%F{1}No matches for: %d%f'
zstyle ':completion:*:corrections' format '%B%F{3}%d (errors: %e)%f%b'
zstyle ':completion:*' group-name ''

zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/).pyc'

# zstyle ':completion:*' menu select

# zstyle ':completion:*' list-dirs-first true
# zstyle ':completion:*:manuals' separate-sections true


# SYNTAX HIGHLIGHTING ////////////////////////////////////////////////////////////////////
if [[ -f $ZSH_PLUGIN_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    typeset -A ZSH_HIGHLIGHT_STYLES
    ZSH_HIGHLIGHT_STYLES[comment]='fg=black'
    source $ZSH_PLUGIN_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi


# FZF ////////////////////////////////////////////////////////////////////////////////////
export FZF_DEFAULT_OPTS='--bind=ctrl-a:select-all,ctrl-u:page-up,ctrl-d:page-down,ctrl-space:toggle'

if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude ".git"'
    export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --exclude ".git"'
    export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude ".git"'
    _fzf_compgen_path() { fd --hidden --exclude ".git" . "$@"; }
    _fzf_compgen_dir() { fd --type d --hidden --exclude ".git" . "$@"; }
fi

# install fzf with ./install --xdg
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

bindkey '^g' fzf-cd-widget


# SAFER RM ///////////////////////////////////////////////////////////////////////////////
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


# DIRECTORY HASHES ///////////////////////////////////////////////////////////////////////
hash -d trash="$HOME/.local/share/Trash"
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

# [[ -s "$HOME/.xmake/profile" ]] && source "$HOME/.xmake/profile" # load xmake profile
