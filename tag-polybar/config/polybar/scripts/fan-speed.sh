#!/usr/bin/env bash

SPEED_AUTO=${PB_FAN_SPEED_AUTO:-"auto "}
SPEED_SLOW=${PB_FAN_SPEED_SLOW:-"slow "}
SPEED_MIDD=${PB_FAN_SPEED_MIDD:-"mid "}
SPEED_FAST=${PB_FAN_SPEED_FAST:-"fast "}
SPEED_UNIT=${PB_FAN_SPEED_UNIT:-rpm}
SLEEP=${PB_FAN_SPEED_SLEEP:-1}

HWMON_PATH=$1

sleep_pid=0

trap recheck HUP

recheck() {
    [ $sleep_pid -ne 0 ] && kill $sleep_pid >/dev/null 2>&1
}

fan_speed() {
    FAN_SPEED=$(< $HWMON_PATH)
    # fan_ouput=$(< ${HWMON_PATH%_*}_output)
    FAN_MANUAL=$(< ${HWMON_PATH%_*}_manual)
    FAN_MAX=$(< ${HWMON_PATH%_*}_max)
    FAN_MIN=$(< ${HWMON_PATH%_*}_min)

    STEP=$((($FAN_MAX - $FAN_MIN) / 3))

    if [[ $FAN_MANUAL == 0 ]]; then
        prefix=$SPEED_AUTO
    elif (( $FAN_SPEED >= $FAN_MAX - $STEP)); then
        prefix=$SPEED_FAST
    elif (( $FAN_SPEED > $FAN_MIN + $STEP)); then
        prefix=$SPEED_MIDD
    else
        prefix=$SPEED_SLOW
    fi

    echo $prefix$FAN_SPEED$SPEED_UNIT
}

while :; do
    fan_speed
    sleep $SLEEP &
    sleep_pid=$!
    wait
done
