#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

cd "$(dirname "$0")"

declare FAN_DIR=
declare FAN_NAME=
declare FAN_STEP=1000
declare FAN_SPEED_PID=

main() {
    # parse options
    while getopts ":d:f:p:h" opt; do
        case $opt in
            d)
                [[ -n "$OPTARG" ]] || { echoerr -h "invalid argument for option -- '$opt'"; exit 2; }
                FAN_DIR=$(realpath -- "$OPTARG")
                ;;
            f)
                [[ -n "$OPTARG" ]] || { echoerr -h "invalid argument for option -- '$opt'"; exit 2; }
                FAN_NAME="$OPTARG"
                ;;
            p)
                [[ "$OPTARG" =~ ^[1-9][[:digit:]]*$ ]] || { echoerr -h "invalid argument for option -- '$opt'"; exit 2; }
                FAN_SPEED_PID="$OPTARG"
                ;;
            h)   usage; exit 0 ;;
            ':') echoerr -h "option requires an argument -- '$OPTARG'"; exit 2 ;;
            '?') echoerr -h "invalid option -- '$OPTARG'"; exit 2 ;;
            *)   echoerr -h; exit 2 ;;
        esac
    done
    shift $(($OPTIND - 1))

    # check options
    case "x${FAN_DIR}x${FAN_NAME}x" in
        xxx)    echoerr -h "missing mandatory options -- 'd' and 'f'"; exit 2 ;;
        xx?*x)  echoerr -h "missing mandatory option -- 'd'"; exit 2 ;;
        x?*xx)  echoerr -h "missing mandatory option -- 'f'"; exit 2 ;;
    esac

    # variables for fan files
    local FAN_MANUAL_FILE="$FAN_DIR/${FAN_NAME}_manual"
    local FAN_MAX_FILE="$FAN_DIR/${FAN_NAME}_max"
    local FAN_MIN_FILE="$FAN_DIR/${FAN_NAME}_min"
    local FAN_OUTPUT_FILE="$FAN_DIR/${FAN_NAME}_output"

    # parse command
    local cmd=${1-}
    case $cmd in
        toggle) toggle_mode ;;
        up)     speed_up ;;
        down)   speed_down ;;
        '')     echoerr -h "missing command"; exit 2 ;;
        *)      echoerr -h "invalid command -- '$cmd'"; exit 2 ;;
    esac
}

check_fan_files() {
    for f ; do
        [[ -r "$f" ]] || { echoerr "not found file '$f'"; exit 3; }
    done
}

toggle_mode() {
    check_fan_files "$FAN_MANUAL_FILE" || exit $?
    local fan_manual=$(< $FAN_MANUAL_FILE)
    # echo $fan_manual

    echo $((! $fan_manual)) > $FAN_MANUAL_FILE
    [[ -z $FAN_SPEED_PID ]] || sig
}

speed_up() {
    check_fan_files "$FAN_MANUAL_FILE" "$FAN_MAX_FILE" "$FAN_OUTPUT_FILE" || exit $?
    local fan_manual=$(< $FAN_MANUAL_FILE)
    local fan_max=$(< $FAN_MAX_FILE)
    local fan_speed=$(< $FAN_OUTPUT_FILE)
    # echo $fan_manual $fan_max $fan_speed

    (($fan_manual == 1)) || { echoerr "not in manual mode"; exit 1; }
    (($fan_speed < $fan_max)) || { echoerr "already at fastest speed"; exit 1; }

    local newspeed=$(($fan_speed / $FAN_STEP * $FAN_STEP + $FAN_STEP))
    (($newspeed <= $fan_max)) || newspeed=$fan_max
    echo $newspeed > $FAN_OUTPUT_FILE
    [[ -z $FAN_SPEED_PID ]] || sig
}

speed_down() {
    check_fan_files "$FAN_MANUAL_FILE" "$FAN_MIN_FILE" "$FAN_OUTPUT_FILE" || exit $?
    local fan_manual=$(< $FAN_MANUAL_FILE)
    local fan_min=$(< $FAN_MIN_FILE)
    local fan_speed=$(< $FAN_OUTPUT_FILE)
    # echo $fan_manual $fan_min $fan_speed

    (($fan_manual == 1)) || { echoerr "not in manual mode"; exit 1; }
    (($fan_speed > $fan_min)) || { echoerr "already at slowest speed"; exit 1; }

    local newspeed=$((($fan_speed - 1 + $FAN_STEP) / $FAN_STEP * $FAN_STEP - $FAN_STEP))
    (($newspeed >= $fan_min)) || newspeed=$fan_min
    echo $newspeed > $FAN_OUTPUT_FILE
    [[ -z $FAN_SPEED_PID ]] || sig
}

sig() {
    if ps -q $FAN_SPEED_PID --no-headers &>/dev/null; then
        kill -HUP $FAN_SPEED_PID
    fi
}

echoerr() {
    [[ $1 != -h ]] || { local echo_usage=1; shift; }
    [[ -z "$@" ]] || cat <<< "$(basename $0): $@" >&2
    [[ ${echo_usage-} -ne 1 ]] || usage >&2
}

usage() {
    cat <<-EOF
Usage: $(basename $0) -d <FAN_DIR> -f <FAN_NAME> [-p <PID>] {toggle|increase|decrease}

Options:
    -d <FAN_DIR>  fan sysfs dir
    -f <FAN_NAME> fan name
    -p <PID>      PID of monitor daemon to recheck fan speed for bars

    -h            display this information

Commands:
    toggle        toggle the mode of fan speed between auto and manual
    up            increase fan speed
    down          decrease fan speed
EOF
}

main "$@"
