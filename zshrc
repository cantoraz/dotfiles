#
# Executes commands at the start of an interactive session.
#

# Source zshrc from Prezto
prezto_zshrc="${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
[[ -s $prezto_zshrc ]] && source $prezto_zshrc
unset prezto_zshrc

# Source my customization
for config_file ($HOME/.zshrc.d/*.zsh(N)) source $config_file
