#!/usr/bin/env sh

WAITING=${PB_UPDATES_WAITING:-󰏗 Checking}
AVAILABLE=${PB_UPDATES_AVAILABLE:-󰏗 }
UPTODATE=${PB_UPDATES_UPTODATE:-󰏗 None}

sleep_pid=0

trap recheck HUP

recheck() {
    if [ "$sleep_pid" -ne 0 ]; then
        kill $sleep_pid >/dev/null 2>&1
    fi
}

check_updates() {
    echo $WAITING

    if ! updates=$(pamac checkupdates -q 2> /dev/null | wc -l); then
        udpates=0
    fi

    if [ $updates -gt 0 ]; then
        echo $AVAILABLE$updates
    else
        echo $UPTODATE
    fi
}

while :; do
    check_updates
    sleep 1800 &
    sleep_pid=$!
    wait
done
