# PROMPT =================================================================================

autoload -U colors && colors

# Git prompt -----------------------------------------------------------------------------
source ~/.zsh/git-prompt.zsh/git-prompt.zsh
ZSH_GIT_PROMPT_SHOW_UPSTREAM="no"

ZSH_THEME_GIT_PROMPT_PREFIX="%K{233}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%K{233} "
ZSH_THEME_GIT_PROMPT_SEPARATOR="%K{233} "
ZSH_THEME_GIT_PROMPT_DETACHED="%K{233}%{$fg_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%K{233}%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%K{233}%{$fg_bold[yellow]%}⟳ "
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%K{233}%{$fg[red]%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%K{233}%{$fg[red]%})"
ZSH_THEME_GIT_PROMPT_BEHIND="%K{233}↓"
ZSH_THEME_GIT_PROMPT_AHEAD="%K{233}↑"
ZSH_THEME_GIT_PROMPT_UNMERGED="%K{233}%{$fg[red]%}x"
ZSH_THEME_GIT_PROMPT_STAGED="%K{233}%{$fg[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%K{233}%{$fg[red]%}+"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%K{233}…"
ZSH_THEME_GIT_PROMPT_STASHED="%K{233}%{$fg[blue]%}⚑"
ZSH_THEME_GIT_PROMPT_CLEAN="%K{233}%{$fg_bold[green]%}✔"

# Prompt ---------------------------------------------------------------------------------
if [[ "$TERM" == 'linux' ]]; then
    # no fancy prompt on linux tty
    PROMPT='%n@%m:%~$ '
elif [[ -v SSH_CONNECTION ]]; then
    # print user@host if logged in through ssh
    PROMPT='%K{233}%f%B %b%n@%m%B %(4~|%-1~/…/%2~|%3~) %b$(gitprompt)%F{233}%K{2}%k%F{2}%f '
else
    # local prompt
    PROMPT='%K{233}%f %B%(4~|%-1~/…/%2~|%3~)%b $(gitprompt)%F{233}%K{2}%k%F{2}%f '

    # terminal window title
    _ms_customtitle=1
    _ms_settitle() {
        [[ $_ms_customtitle != 0 ]] && echo -ne "\033]0;$(dirs) - zsh\007"
    }
    title() {
        _ms_customtitle=0
        echo -ne "\033]0;$1\007"
    }
    restoretitle() {
        _ms_customtitle=1
    }
    precmd_functions+=(_ms_settitle)
fi

# 


# INCLUDES ===============================================================================

[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

[ -f "$HOME/.local/share/shortcuts" ] && source "$HOME/.local/share/shortcuts"

[ -d "$HOME/.emacs.d/bin" ] && export PATH="$PATH:$HOME/.emacs.d/bin"
# [ -d "$HOME/repos/depot_tools" ] && export PATH="$PATH:$HOME/repos/depot_tools"


# KEY BINDINGS ===========================================================================

export KEYTIMEOUT=1

# Emacs key bindings ---------------------------------------------------------------------
bindkey -e

# Filter history ------------------------------------------------------------- [Up] [Down]
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A'  up-line-or-beginning-search
bindkey '^[OA'  up-line-or-beginning-search
bindkey '^[[B'  down-line-or-beginning-search
bindkey '^[OB'  down-line-or-beginning-search

# Search backward for string ---------------------------------------------------- [Ctrl-R]
bindkey '^r' history-incremental-search-backward

# Jump between words ---------------------------------------------- [Alt-Left] [Alt-Right]
bindkey '\e[1;3C' forward-word
bindkey '\e[1;3D' backward-word

# Completion menu backwards -------------------------------------------------- [Shift-Tab]
[[ "${terminfo[kcbt]}" != "" ]] && bindkey "${terminfo[kcbt]}" reverse-menu-complete

# Go to beginning of line --------------------------------------------------------- [Home]
[[ "${terminfo[khome]}" != "" ]] && bindkey "${terminfo[khome]}" beginning-of-line

# Go to end of line ---------------------------------------------------------------- [End]
[[ "${terminfo[kend]}" != "" ]] && bindkey "${terminfo[kend]}" end-of-line

# One directory up -------------------------------------------------------------- [Ctrl-U]
# bindkey -s '^u' 'cd ..^M'

# Edit command line ------------------------------------------------------------- [Ctrl-E]
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line


# HISTORY ================================================================================

setopt append_history
setopt share_history
setopt histignorealldups
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history


# COMPLETION =============================================================================

fpath=(~/.config/zsh/completions $fpath)

autoload -Uz compinit
compinit -d ~/.cache/zsh/zcompdump

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# ignored
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/).pyc'

setopt auto_cd
setopt notify

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

