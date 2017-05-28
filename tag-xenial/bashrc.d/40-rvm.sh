# -*- mode: sh; -*-

# RVM is installed as Single-User mode.
# This is accomplished by sourcing $HOME/.rvm/scripts/rvm at starting a login shell.
# But byobu or its window/pane starts a non login shell.
# So it is required that put the sourcing in ~/.bashrc file!
#
# Load RVM into a shell session *as a function*
if [ -s "$HOME/.rvm/scripts/rvm" ]; then
    source "$HOME/.rvm/scripts/rvm"
elif [ -s "/usr/local/rvm/scripts/rvm" ]; then
    source "/usr/local/rvm/scripts/rvm"
fi
