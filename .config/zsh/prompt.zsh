autoload -U colors && colors


# GIT PROMPT
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


# VIM MODE INDICATOR
PROMPT_COLOR=2

function zle-keymap-select {
    case $KEYMAP in
        main|viins)  PROMPT_COLOR=2 ;;
        vicmd)       PROMPT_COLOR=4 ;;
        vivis|vivli) PROMPT_COLOR=5 ;;
        *)           PROMPT_COLOR=2 ;;
    esac
    zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
    PROMPT_COLOR=2
}
zle -N zle-line-finish

function TRAPINT() {
    PROMPT_COLOR=2
    return $(( 128 + $1 ))
}


# PROMPT
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

    # print vim mode indicator
    PROMPT+='%F{233}%K{${PROMPT_COLOR}}%k%F{${PROMPT_COLOR}}%f '

    # set terminal window title
    if [[ -v SSH_CONNECTION ]]; then
        _set_title() {
            ( printf '\e]0;%s%s@%s:%s - zsh\007' \
                "${TITLE}${TITLE:+: }" \
                "$USER" "$HOST" \
                "$(dirs -p | head -n 1)"
            ) 2>/dev/null
        }
    else
        _set_title() {
            ( printf '\e]0;%s%s - zsh\007' \
                "${TITLE}${TITLE:+: }" \
                "$(dirs -p | head -n 1)"
            ) 2>/dev/null
        }
    fi
    precmd_functions+=(_set_title)
fi
