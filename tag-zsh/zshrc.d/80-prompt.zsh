# vim: ft=zsh ts=2 sts=2 sw=2 et

# Load themes from the prompts directory
autoload -Uz promptinit
fpath=(${0:a:h}/prompts $fpath)
promptinit

# prompt skwp

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
