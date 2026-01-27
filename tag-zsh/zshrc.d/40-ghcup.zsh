# -*- mode: sh; sh-basic-offset: 2; -*-
# vim: ft=zsh ts=2 sts=2 sw=2 et

if [[ ! -v GHCUP_USE_XDG_DIRS ]]; then
  export path=(
    ${GHCUP_INSTALL_BASE_PREFIX:-$HOME}/.ghcup/bin(N)
    $path
  )
fi
