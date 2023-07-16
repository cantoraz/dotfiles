#!/usr/bin/env bash

# Add this script to your wm startup file.

CONFIG_DIR="$HOME/.config/polybar"
RUNTIME_DIR="$XDG_RUNTIME_DIR/polybar"

# Bars to launch
BARS=($HOSTNAME-top $HOSTNAME-bottom)
[[ $HOSTNAME == imac ]] && BARS+=left

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bars
# polybar bar1 2>&1 | tee -a /tmp/polybar1.log & disown
# polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown
mkdir -p $RUNTIME_DIR
for bar in ${BARS[@]}; do
    echo "---" >> $RUNTIME_DIR/$XDG_SESSION_ID-$bar.log
    polybar -r -c $CONFIG_DIR/config.ini $bar &>> $RUNTIME_DIR/$XDG_SESSION_ID-$bar.log & disown
done

echo "Bars launched…"
