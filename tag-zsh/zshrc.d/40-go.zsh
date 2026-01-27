# -*- mode: sh; sh-basic-offset: 2; -*-
# vim: ft=zsh ts=2 sts=2 sw=2 et

export GOPATH=$HOME/.local/lib/go
export path=(
  $GOPATH/bin(N)
  $path
)
