# vim: ft=zsh ts=2 sts=2 sw=2 et
#
# Aliases in this file are only `zsh' compatible

################################################################################
# Global aliases
################################################################################

# Directory navigation
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Piped utils
# alias -g C='| wc -l'
# alias -g H='| head'
# alias -g L="| less"
# alias -g N="| /dev/null"
# alias -g S='| sort'
# alias -g G='| grep' # now you can do: ls foo G something

################################################################################
# Functions
################################################################################

# (f)ind by (n)ame
# usage: fn foo
# to find all files containing 'foo' in the name
#function fn() { ls **/*$1* }

################################################################################
# nocorrect
################################################################################

# Override rm -i alias which makes rm prompt for every action
alias rm='nocorrect rm'

################################################################################
# noglob
################################################################################

# Use zmv, which is amazing
autoload -Uz zmv
alias zmv="noglob zmv -W"
