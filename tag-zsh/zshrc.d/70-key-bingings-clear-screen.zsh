# -*- mode: sh; sh-basic-offset: 2; -*-
# vim: ft=zsh ts=2 sts=2 sw=2 et

# Use Ctrl-l scroll the current screen contents into the scrollback
# buffer and clear the screen.

clear-only-screen() {
  printf "\e[H\e[2J"
}

clear-screen-and-scrollback() {
  printf "\e[H\e[3J"
}

clear-screen-saving-contents-in-scrollback() {
  printf "\e[H\e[22J"
}

scroll-and-clear-screen() {
  # printf '\n%.0s' {1..$LINES}
  # zle clear-screen
  builtin print -rn -- $'\r\e[0J\e[H\e[22J' >"$TTY"
  builtin zle .reset-prompt
  builtin zle -R
}

zle -N scroll-and-clear-screen
bindkey '^l' scroll-and-clear-screen
