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
    [[ $# -gt 0 ]] && shift
    case $cmd in
        query)  query_speed $@ ;;
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

query_speed() {
    local FOLLOW=0

    # parse command options
    local OPTIND=
    while getopts ":f" opt; do
        case $opt in
            f)  FOLLOW=1 ;;
            ?)  echoerr -h "invalid ‘query’ command option --'$OPTARG'"; exit 2 ;;
            *)  echoerr -h; exit 2 ;;
        esac
    done
    shift $(($OPTIND - 1))

    local FAN_INPUT_FILE="$FAN_DIR/${FAN_NAME}_input"
    check_fan_files $FAN_INPUT_FILE

    # load config from env
    local SPEED_AUTO=${PB_FAN_SPEED_AUTO:-"auto "}
    local SPEED_SLOW=${PB_FAN_SPEED_SLOW:-"slow "}
    local SPEED_MIDD=${PB_FAN_SPEED_MIDD:-"mid "}
    local SPEED_FAST=${PB_FAN_SPEED_FAST:-"fast "}
    local SPEED_UNIT=${PB_FAN_SPEED_UNIT:-rpm}
    local SLEEP=${PB_FAN_SPEED_SLEEP:-1}

    # trap SIGHUP in follow mode
    [[ $FOLLOW -eq 1 ]] && trap 'kill %' HUP

    while :; do
        local fan_speed=$(< $FAN_INPUT_FILE)

        if [[ -r "$FAN_MANUAL_FILE" && -r "$FAN_MAX_FILE" && -r "$FAN_MIN_FILE" ]]; then
            local fan_manual=$(< $FAN_MANUAL_FILE)
            local fan_max=$(< $FAN_MAX_FILE)
            local fan_min=$(< $FAN_MIN_FILE)

            local speed_step=$((($fan_max - $fan_min) / 3))

            if [[ $fan_manual -eq 0 ]]; then
                prefix=$SPEED_AUTO
            elif (($fan_speed >= $fan_max - $speed_step)); then
                prefix=$SPEED_FAST
            elif (($fan_speed > $fan_min + $speed_step)); then
                prefix=$SPEED_MIDD
            else
                prefix=$SPEED_SLOW
            fi
        else
            prefix=$SPEED_AUTO
        fi

        echo $prefix$fan_speed$SPEED_UNIT

        # break loop unless in follow mode
        [[ $FOLLOW -eq 1 ]] || break

        sleep $SLEEP &
        wait || true
    done
}

toggle_mode() {
    check_fan_files "$FAN_MANUAL_FILE"
    local fan_manual=$(< $FAN_MANUAL_FILE)
    # echo $fan_manual

    echo $((! $fan_manual)) > $FAN_MANUAL_FILE
    [[ -z $FAN_SPEED_PID ]] || sig
}

speed_up() {
    check_fan_files "$FAN_MANUAL_FILE" "$FAN_MAX_FILE" "$FAN_OUTPUT_FILE"
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
    check_fan_files "$FAN_MANUAL_FILE" "$FAN_MIN_FILE" "$FAN_OUTPUT_FILE"
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
Usage: $(basename $0) -d <FAN_DIR> -f <FAN_NAME> [-p <PID>] COMMAND

Options:
    -d <FAN_DIR>  fan sysfs dir
    -f <FAN_NAME> fan name
    -p <PID>      PID of monitor daemon to recheck fan speed for bars

    -h            display this information

Commands:
    query         query current fan speed
    toggle        toggle the mode of fan speed between auto and manual
    up            increase fan speed
    down          decrease fan speed

‘query’ Command Options:
    -f            follow mode
EOF
}

main "$@"
