#!/usr/bin/env bash
# -*- sh-basic-offset: 2; -*-
#
# Simple screenshot script using shotgun/dunst for i3 by cantoraz@gmail.com

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
  set -o xtrace
fi

cd "$(dirname "$0")"

declare     SHOT_DIR=$(xdg-user-dir PICTURES)
if [ $(xdg-user-dir) = $SHOT_DIR ]; then
  SHOT_DIR="~/Pictures"
fi

if ! [ -d $SHOT_DIR ]; then
  mkdir -p $SHOT_DIR
fi

declare -r  SHOT_EXT=png
declare -r  SHOT_FNAME="Screenshot_$(date +%Y%m%d_%H%M%S).$SHOT_EXT"
declare -r  SHOT_PATH="$SHOT_DIR/$SHOT_FNAME"
declare -r  SHOT_TMP=$(mktemp -q)
declare     SHOT_MODE=
declare     SHOT_COPY=0

declare -r  NOTIFY_APP_NAME=screenshot
declare     NOTIFY_CATEGORY=string:category:screenshot
declare     NOTIFY_SUMMARY=
declare     NOTIFY_BODY="A screenshot was saved as '$SHOT_FNAME' to your ${SHOT_DIR/#$HOME/\~} folder."

print_usage() {
  echo "Usage: $(basename $0) [options]

Options:
  -h    display this information

  -s    current screen (default)
  -f    full screen
  -r    selected region/window
  -w    active window

  -c    copy to clipboard

The default screenshot destination is your 'XDG_PICTURES_DIR' if available, otherwise '~/Pictures'."
}

add_shadow() {
  convert - \( +clone -background black -shadow 100x4+0+0 \) +swap -background none -layers merge +repage $1
}

capture() {
  add_shadow "$SHOT_TMP"
  if [ $SHOT_COPY = 0 ]; then
    # add_shadow $SHOT_PATH
    cp "$SHOT_TMP" "$SHOT_PATH"
  else
    # add_shadow - | xclip -sel clip -t image/png
    xclip -sel clip -t image/png "$SHOT_TMP"
  fi
}

main() {
  case $SHOT_MODE in
    screen|'')
      NOTIFY_SUMMARY="Current Screen"
      shotgun -s - | capture
      # ksnip -m
      ;;
    fullscreen)
      NOTIFY_SUMMARY="Fullscreen"
      shotgun - | capture
      # ksnip -f
      ;;
    region)
      NOTIFY_SUMMARY="Rectangular Region"
      local -r sel=$(slop -b 1 -c 0.239,0.682,0.914,0.4 -f '-i %i -g %g' -l -q)
      if [ -z "$sel" ]; then
        NOTIFY_CATEGORY=$NOTIFY_CATEGORY.abort
        NOTIFY_BODY="Screenshot aborted."
        local -r ret=1
      else
        shotgun $sel - | capture
        # ksnip -r
      fi
      ;;
    window)
      NOTIFY_SUMMARY="Active Window"
      shotgun -i $(xdotool getactivewindow) - | capture
      # ksnip -a
      ;;
  esac

  if [ -v ret ]; then
    dunstify -a "$NOTIFY_APP_NAME" -h "$NOTIFY_CATEGORY" "$NOTIFY_SUMMARY" "$NOTIFY_BODY"
  else
    dunstify -a "$NOTIFY_APP_NAME" -h "$NOTIFY_CATEGORY" -I "$SHOT_TMP" "$NOTIFY_SUMMARY" "$NOTIFY_BODY"
  fi

  [ -O "$SHOT_TMP" ] && rm "$SHOT_TMP"
  exit ${ret:-0}
}

while getopts ":frswch" options; do
  case $options in
    f) # full screen
      SHOT_MODE=fullscreen
      ;;
    r) # selected region/window
      SHOT_MODE=region
      ;;
    s) # current screen
      SHOT_MODE=screen
      ;;
    w) # active window
      SHOT_MODE=window
      ;;
    c) # copy to clipboard
      SHOT_COPY=1
      NOTIFY_BODY="A screenshot was saved to your clipboard."
      ;;
    h)
      print_usage; exit 0
      ;;
    *)
      print_usage >&2; exit 2
      ;;
  esac
done

main "$@"
