# vim: ft=zsh ts=2 sts=2 sw=2 et

# Load themes from the prompts directory
autoload -Uz promptinit
fpath=(${0:a:h}/prompts $fpath)
promptinit

prompt skwp
