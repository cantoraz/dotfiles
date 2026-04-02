# -*- mode: sh; sh-basic-offset: 2; -*-
# vim: ft=zsh ts=2 sts=2 sw=2 et

clear-only-screen() {
  printf "\e[H\e[2J"
}

clear-screen-and-scrollback() {
  # NOTE: It works in bare shell, but not enough in tmux.
  printf "\e[H\e[3J"
}

clear-screen-saving-contents-in-scrollback() {
  printf "\e[H\e[22J"
}

# Use Control-L to clear the screen that scroll the current screen
# contents into the scrollback buffer.

clear-screen-into-scrollback() {
  # printf '\n%.0s' {1..$LINES}
  # zle clear-screen
  builtin print -rn -- $'\r\e[0J\e[H\e[22J' >"$TTY"
  builtin zle .reset-prompt
  builtin zle -R
}

zle -N clear-screen-into-scrollback
bindkey '^L' clear-screen-into-scrollback

# Use Meta-Control-L to clear the screen, and then the scrollback.

clear-screen-then-scrollback() {
  # NOTE: It's not enough that send "\e[H\e[3J", because tmux will save
  # the current screen contents into the history buffer.
  # So clear the screen first, and then clear the scrollback.
  builtin print -rn -- $'\r\e[0J\e[H\e[2J\e[3J' >"$TTY"
  builtin zle .reset-prompt
  builtin zle -R
}

zle -N clear-screen-then-scrollback
bindkey '^[^L' clear-screen-then-scrollback
