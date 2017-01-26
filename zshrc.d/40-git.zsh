# vim: ft=zsh ts=2 sts=2 sw=2 et

# Makes git auto completion faster favouring for local completions
__git_files() {
  _wanted files expl 'local files' _files
}

# Don't try to glob with zsh so you can do
# stuff like ga *foo* and correctly have
# git add the right stuff
alias git='noglob git'
