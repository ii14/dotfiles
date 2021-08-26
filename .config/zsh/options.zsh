# GENERAL
# setopt menu_complete            # insert first match of the completion
setopt list_packed              # fit more completions on the screen
setopt auto_cd                  # change directory by writing the directory name
setopt notify                   # report job status immediately
setopt no_flow_control          # disable flow control - Ctrl+S and Ctrl+Q keys
setopt interactive_comments     # allow comments
setopt noclobber                # >! or >| for existing files

# HISTORY
setopt append_history
setopt share_history            # share history between sessions
setopt hist_ignore_all_dups     # remove duplicate commands from history
setopt hist_ignore_space        # don't add commands with leading space to history
SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.cache/zsh/history

# DIRECTORY STACK
setopt auto_pushd               # automatically push previous directory to the stack
setopt pushd_ignore_dups        # ignore duplicates in directory stack
setopt pushd_minus              # swap + and -
setopt pushd_silent             # silend pushd and popd
setopt pushd_to_home            # pushd defaults to $HOME
DIRSTACKSIZE=12
