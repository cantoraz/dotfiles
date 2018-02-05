# Hook direnv into ZSH
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi
