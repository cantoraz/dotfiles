#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

print_usage() {
    echo "Usage: $(basename $0) {mute|up|down}"
}

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    print_usage
    exit
fi

cd "$(dirname "$0")"

[[ $# != 1 ]] && { print_usage; exit 1; }

declare -r SINK=@DEFAULT_SINK@
declare -r STEP=5
declare -r SOUND=/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga

main() {
    local -r OLD_MUTE=$(pactl get-sink-mute $SINK)
    local -r IS_MUTE=*' 'yes
    case $1 in
        mute)
            pulseaudio-ctl mute
            [[ $OLD_MUTE == $IS_MUTE ]] && paplay $SOUND || exit 0
            ;;
        up)
            pulseaudio-ctl up $STEP
            [[ $OLD_MUTE == $IS_MUTE ]] && pactl set-sink-mute $SINK no
            paplay $SOUND
            ;;
        down)
            pulseaudio-ctl down $STEP
            [[ $OLD_MUTE == $IS_MUTE ]] && pactl set-sink-mute $SINK no
            paplay $SOUND
            ;;
        *)
            print_usage; exit 1
            ;;
    esac
}

main "$@"
