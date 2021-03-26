#!/bin/zsh
herbstclient list_keybinds | fzf --height=100% --ansi
cat ~/.config/herbstluftwm/sxhkdrc | awk '/^[a-z]/ && last {print $0,"\t",last} {last=""} /^#/{last=$0}' | column -t -s $'\t' | fzf --height=100% --ansi
