if [[ -z $ZSH_MC ]]; then # mc fix

KEYTIMEOUT=1

# Emacs key bindings with Vim normal mode [Esc]
bindkey -e
# bindkey '^x\e' vi-cmd-mode
# bindkey -M vicmd '\e' vi-add-next
bindkey -r '^j'
bindkey -rM vicmd '^j'

WORDCHARS=${WORDCHARS//[\/=]/}

# Backward/forward word/char [{Ctrl,Alt}+{B,F}]
bindkey '^b' emacs-backward-word
bindkey '^f' emacs-forward-word
bindkey '^[b' backward-char
bindkey '^[f' forward-char

# Backward delete {word,line} [Ctrl+{W,U}]
bindkey '^w' backward-delete-word
bindkey '^u' backward-kill-line

# Filter history [Up] [Down]
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^p'    up-line-or-beginning-search
bindkey '^[[A'  up-line-or-beginning-search
bindkey '^[OA'  up-line-or-beginning-search
bindkey '^n'    down-line-or-beginning-search
bindkey '^[[B'  down-line-or-beginning-search
bindkey '^[OB'  down-line-or-beginning-search

# Search backward for string [Ctrl+R] (NOTE: replaced by fzf)
bindkey '^r' history-incremental-search-backward

# Completion menu backwards [Shift+Tab]
[[ "${terminfo[kcbt]}" != "" ]] && bindkey "${terminfo[kcbt]}" reverse-menu-complete

# Edit command line [Ctrl+X,Ctrl+X]
function my-edit-command-line {
    () {
        exec < /dev/tty
        setopt localoptions nomultibyte noksharrays
        (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[2]
        integer byteoffset=$(( $#PREBUFFER + $#LBUFFER + 1 ))
        # assumes vi is a minimal configuration of (n)vim
        vi -c "normal! ${byteoffset}go" -- $1
        (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[1]
        print -Rz - "$(<$1)"
    } =(<<<"$PREBUFFER$BUFFER")
    zle send-break
}
zle -N my-edit-command-line
bindkey '^x^x' my-edit-command-line

# Completion menu vim movement [Ctrl+{h,j,k,l}]
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

# Switch between background and foreground [Ctrl+Z]
function fg-bg {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER=fg
        zle accept-line
    else
        zle push-input
    fi
}
zle -N fg-bg
bindkey '^z' fg-bg

# Expand "!" with space
bindkey ' ' magic-space

fi # mc fix
