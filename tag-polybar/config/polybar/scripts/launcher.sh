#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

cd "$(dirname "$0")"

declare -r CONFIG='~/.config/rofi/launcher.rasi'
declare -r DEFAULT_SHOW=drun

# prepare positional parameters
set -- -config $CONFIG "$@"
[[ " $@ " == *' -show '* ]] || set -- -show $DEFAULT_SHOW "$@"

rofi "$@"
