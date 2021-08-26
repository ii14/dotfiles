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
zstyle ':completion:*:*:*:users' ignored-patterns \
    _apt _rpc avahi avahi-autoipd backup bin colord cups-pk-helper daemon dnsmasq \
    games geoclue gitlab-runner gnats hplip irc jicofo jvb kernoops libvirt-dnsmasq \
    libvirt-qemu lightdm list lp mail man messagebus mosquitto mpd news nobody postgres \
    prosody proxy pulse rtkit saned sddm sshd sync sys syslog systemd-coredump \
    systemd-network systemd-resolve systemd-timesync tcpdump timidity tss turnserver \
    usbmux uucp uuidd whoopsie www-data

if [ -r $HOME/.ssh/known_hosts ]; then
    _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*})
    _cfg_ssh_hosts=(${${${(M)${(f)"$(<$HOME/.ssh/config)"}##Host *}#Host }#\*})
fi
hosts=( "$_ssh_hosts[@]" "$_cfg_ssh_hosts[@]" `hostname` localhost)
zstyle ':completion:*:*:*:*:hosts' hosts $hosts

# zstyle ':completion:*' menu select

# zstyle ':completion:*' list-dirs-first true
# zstyle ':completion:*:manuals' separate-sections true
