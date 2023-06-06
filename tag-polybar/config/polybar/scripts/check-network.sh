#!/usr/bin/env sh

CONNECTED=${PB_CHECKNET_CONNECTED:-Online}
DISCONNECTED=${PB_CHECKNET_DISCONNECTED:-Offline}

CONNECTED_SLEEP=${PB_CHECKNET_CONNECTED_SLEEP:-25}
DISCONNECTED_SLEEP=${PB_CHECKNET_DISCONNECTED_SLEEP:-5}

ping_net() {
    ping -c1 aliyun.com ||
    ping -c1 archlinux.org ||
    # ping -c1 google.com ||
    # ping -c1 bitbucket.org ||
    # ping -c1 github.com ||
    # ping -c1 sourceforge.net
    ping -c1 baidu.com
}

while true; do
    if ping_net &>/dev/null; then
        echo "$CONNECTED" ; sleep $CONNECTED_SLEEP
    else
        echo "$DISCONNECTED" ; sleep $DISCONNECTED_SLEEP
    fi
done
