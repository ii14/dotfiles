#!/bin/bash

# filesystem module

primary="#777"
secondary="#fff"
underline="#61afef"

awk_script='
BEGIN {
    first_record = 1
}
$1 ~ /^\// {
    if (first_record) {
        first_record = 0
    } else {
        printf " "
    }
    printf "%s", "%{u" underline "}%{+u}%{F" primary "}" $6 " %{F" secondary "}" $5 "%{-u}"
}'

df -h | awk \
    -v primary="$primary" \
    -v secondary="$secondary" \
    -v underline="$underline" \
    "$awk_script"
