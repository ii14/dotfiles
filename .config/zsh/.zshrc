# PROMPT =================================================================================
autoload -U colors && colors

# Git prompt -----------------------------------------------------------------------------
source ~/.config/zsh/plugins/git-prompt.zsh/git-prompt.zsh
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

# Prompt ---------------------------------------------------------------------------------
if [[ "$TERM" == 'linux' ]]; then
    # no fancy prompt on linux tty
    PROMPT='%n@%m:%~$ '
elif [[ -v SSH_CONNECTION ]]; then
    # print user@host if logged in through ssh
    PROMPT='%K{233}%f%B %b%n@%m%B %(4~|%-1~/…/%2~|%3~) %b$(gitprompt)%F{233}%K{2}%k%F{2}%f '

    # terminal window title
    _set_title() {
        echo -ne "\033]0;$USER@$HOST:$(dirs -p | head -n 1) - zsh\007" 2>/dev/null;
    }
    precmd_functions+=(_set_title)
else
    # local prompt
    PROMPT='%K{233}%f %B%(4~|%-1~/…/%2~|%3~)%b $(gitprompt)%F{233}%K{2}%k%F{2}%f '

    # terminal window title
    _set_title() {
        echo -ne "\033]0;$(dirs -p | head -n 1) - zsh\007" 2>/dev/null;
    }
    precmd_functions+=(_set_title)
fi

# 

# set -o vi
# vim_ins_mode="%F{233}%K{2}%k%F{2}%f"
# vim_cmd_mode="%F{233}%K{4}%k%F{4}%f"
# vim_mode=$vim_ins_mode

# function zle-keymap-select {
#     vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
#     zle reset-prompt
# }
# zle -N zle-keymap-select

# function zle-line-finish {
#     vim_mode=$vim_ins_mode
# }
# zle -N zle-line-finish

# PROMPT='%K{233}%f %B%(4~|%-1~/…/%2~|%3~)%b $(gitprompt)${vim_mode} '


# INCLUDES ===============================================================================
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
[ -f "$HOME/.local/share/shortcuts" ] && source "$HOME/.local/share/shortcuts"


# COMMAND HISTORY ========================================================================
setopt append_history
setopt share_history
setopt histignorealldups
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history


# DIRECTORY STACK ========================================================================
DIRSTACKSIZE=12
setopt autopushd pushdminus pushdsilent pushdtohome
alias dh='dirs -v'


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
bindkey '^p'    up-line-or-beginning-search
bindkey '^[[B'  down-line-or-beginning-search
bindkey '^[OB'  down-line-or-beginning-search
bindkey '^n'    down-line-or-beginning-search

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

# One directory up --------------------------------------------------------------- [Alt-U]
bindkey -s '\eu' 'cd ..^M'

# Edit command line ------------------------------------------------------------- [Ctrl-E]
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line


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


# FZF ====================================================================================
export FZF_DEFAULT_OPTS='--bind=ctrl-a:select-all,ctrl-u:page-up,ctrl-d:page-down,ctrl-space:toggle'

if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude ".git"'
    export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --exclude ".git"'
    export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude ".git"'
    _fzf_compgen_path() { fd --hidden --exclude ".git" . "$@"; }
    _fzf_compgen_dir() { fd --type d --hidden --exclude ".git" . "$@"; }
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey '^g' fzf-cd-widget
