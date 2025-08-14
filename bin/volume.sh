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
declare -r SOUND=audio-volume-change

main() {
    local -r OLD_MUTE=$(pactl get-sink-mute $SINK)
    local -r IS_MUTE=*' 'yes
    case $1 in
        mute)
            # pulseaudio-ctl mute
            pactl set-sink-mute $SINK toggle
            [[ $OLD_MUTE == $IS_MUTE ]] && canberra-gtk-play -i $SOUND || exit 0
            ;;
        up)
            # pulseaudio-ctl up $STEP
            pactl set-sink-volume $SINK +$STEP%
            [[ $OLD_MUTE == $IS_MUTE ]] && pactl set-sink-mute $SINK no
            canberra-gtk-play -i $SOUND
            ;;
        down)
            # pulseaudio-ctl down $STEP
            pactl set-sink-volume $SINK -$STEP%
            [[ $OLD_MUTE == $IS_MUTE ]] && pactl set-sink-mute $SINK no
            canberra-gtk-play -i $SOUND
            ;;
        *)
            print_usage; exit 1
            ;;
    esac
}

main "$@"
