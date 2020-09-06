#!/bin/bash
onedark_black="#282c34"
onedark_blue="#61afef"
onedark_yellow="#e5c07b"
onedark_red="#e06c75"
onedark_white="#aab2bf"
onedark_green="#98c379"
onedark_visual_grey="#3e4452"
onedark_comment_grey="#5c6370"
onedark_vertsplit="#181a1f"

set() {
   local option=$1
   local value=$2
   tmux set-option -gq "$option" "$value"
}

setw() {
   local option=$1
   local value=$2
   tmux set-window-option -gq "$option" "$value"
}

set "status" "on"
set "status-justify" "left"

set "status-left-length" "100"
set "status-right-length" "100"
set "status-right-attr" "none"

set "message-fg" "$onedark_white"
set "message-bg" "$onedark_black"

set "message-command-fg" "$onedark_white"
set "message-command-bg" "$onedark_black"

set "status-attr" "none"
set "status-left-attr" "none"

setw "window-status-fg" "$onedark_black"
setw "window-status-bg" "$onedark_black"
setw "window-status-attr" "none"

setw "window-status-activity-bg" "$onedark_black"
setw "window-status-activity-fg" "$onedark_black"
setw "window-status-activity-attr" "none"

setw "window-status-separator" ""

# set "window-style" "fg=$onedark_comment_grey"
set "window-style" "fg=$onedark_white"
set "window-active-style" "fg=$onedark_white"

set "pane-border-fg" "$onedark_vertsplit"
set "pane-border-bg" "default"
set "pane-active-border-fg" "$onedark_green"
set "pane-active-border-bg" "default"

set "display-panes-active-colour" "$onedark_yellow"
set "display-panes-colour" "$onedark_blue"

set "status-bg" "$onedark_black"
set "status-fg" "$onedark_white"

set "@prefix_highlight_fg" "$onedark_black"
set "@prefix_highlight_bg" "$onedark_green"
set "@prefix_highlight_copy_mode_attr" "fg=$onedark_black,bg=$onedark_green"
set "@prefix_highlight_output_prefix" "  "

set "status-right" "#[fg=$onedark_white, bg=$onedark_visual_grey] W#I P#P #[fg=$onedark_black,bg=$onedark_green] #h "
set "status-left" "#[fg=$onedark_black,bg=$onedark_green] #S #{prefix_highlight}"

set "window-status-format" "#[fg=$onedark_white,bg=$onedark_black] #I #W "
set "window-status-current-format" "#[fg=$onedark_white,bg=$onedark_visual_grey,nobold] #I #W "
