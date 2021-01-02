#!/bin/bash

repos='
git@github.com:woefe/git-prompt.zsh.git
git@github.com:zsh-users/zsh-syntax-highlighting.git
git@github.com:zsh-users/zsh-autosuggestions.git
'

for repo in $repos; do
    dir=$(echo "$repo" | sed 's#.*/\(.*\).git#\1#')
    if [ ! -d "$dir" ]; then
        git clone "$repo"
    else
        git -C "$dir" pull
    fi
done
