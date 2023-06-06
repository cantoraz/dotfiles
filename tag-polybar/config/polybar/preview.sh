#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/polybar"

# Bars to launch
BARS=(top mid bottom)

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
# polybar-msg cmd quit
# Otherwise you can use the nuclear option:
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the preview bar
for bar in ${BARS[@]}; do
    polybar -q $bar -c $CONFIG_DIR/preview.ini &
done
