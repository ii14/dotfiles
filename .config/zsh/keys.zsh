if [[ -z $ZSH_MC ]]; then # mc fix

KEYTIMEOUT=1

# Emacs key bindings with Vim normal mode [Esc]
bindkey -e
# bindkey '^x\e' vi-cmd-mode
# bindkey -M vicmd '\e' vi-add-next
bindkey -r '^j'
bindkey -rM vicmd '^j'

# Filter history [Up] [Down]
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A'  up-line-or-beginning-search
bindkey '^[OA'  up-line-or-beginning-search
bindkey '^p'    up-line-or-beginning-search
bindkey '^[[B'  down-line-or-beginning-search
bindkey '^[OB'  down-line-or-beginning-search
bindkey '^n'    down-line-or-beginning-search

# Backward delete word [Ctrl+W]
my-backward-delete-word() {
    local WORDCHARS=${WORDCHARS/\//}
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^w' my-backward-delete-word

# Backward delete line [Ctrl+U]
bindkey '^u' backward-kill-line

# Backward/forward word/char [{Ctrl,Alt}+{B,F}]
bindkey '^b' backward-word
bindkey '^f' forward-word
bindkey '^[b' backward-char
bindkey '^[f' forward-char

# Jump between words [Ctrl+{Left,Right}]
# [[ "${terminfo[kLFT5]}" != "" ]] && bindkey "${terminfo[kLFT5]}" backward-word
# [[ "${terminfo[kRIT5]}" != "" ]] && bindkey "${terminfo[kRIT5]}" forward-word
bindkey '\e[1;5D' backward-word
bindkey '\e[1;5C' forward-word

# Search backward for string [Ctrl+R]
# replaced by fzf
bindkey '^r' history-incremental-search-backward

# Completion menu backwards [Shift+Tab]
[[ "${terminfo[kcbt]}" != "" ]] && bindkey "${terminfo[kcbt]}" reverse-menu-complete

# Go to beginning or end of line [Home] [End]
[[ "${terminfo[khome]}" != "" ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ "${terminfo[kend]}" != "" ]] && bindkey "${terminfo[kend]}" end-of-line

# Edit command line [Ctrl+X,Ctrl+E]
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

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
