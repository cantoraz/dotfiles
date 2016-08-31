# vim: ft=zsh ts=2 sts=2 sw=2 et

# Use Ctrl-x,Ctrl-l to get the output of the last command
zmodload -i zsh/parameter

insert-last-command-output() {
  LBUFFER+="$(eval $history[$((HISTCMD-1))])"
}

zle -N insert-last-command-output
bindkey "^X^L" insert-last-command-output
