#!/usr/bin/env bash
# -*- sh-basic-offset: 2; -*-

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

ROFI_DIR="~/.config/rofi"
uptime="󰥔 Uptime: $(uptime -p | sed -e 's/up //g')"

ROFI_CMD="rofi -config $ROFI_DIR/powermenu.rasi"

# Options
OPT_SHUTDOWN="󰐥 Shutdown"
OPT_REBOOT="󰜉 Restart"
OPT_LOCK="󰍁 Lock"
OPT_SUSPEND=" Sleep"
OPT_LOGOUT="󰍃 Logout"

# Confirmation
confirm_exit() {
  rofi -dmenu \
       -p "Are you sure?" \
       -i \
       -mesg "Available Options: yes / y / no / n" \
       -config $ROFI_DIR/confirm.rasi
}

# Message
msg() {
	rofi -config $ROFI_DIR/error.rasi \
       -e "Available Options: yes / y / no / n"
}

# Variable passed to rofi
OPTIONS=$(cat << EOF
$OPT_LOCK
$OPT_SUSPEND
$OPT_LOGOUT
$OPT_REBOOT
$OPT_SHUTDOWN
EOF
)

chosen="$(echo -e "$OPTIONS" | $ROFI_CMD -dmenu -p "$uptime")"
case $chosen in
  $OPT_SHUTDOWN)
    ans=$(confirm_exit &)
    if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
      # systemctl poweroff
      i3exit shutdown
    elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
      exit 0
    else
      msg
    fi
    ;;
  $OPT_REBOOT)
    ans=$(confirm_exit &)
    if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
      # systemctl reboot
      i3exit reboot
    elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
      exit 0
    else
      msg
    fi
    ;;
  $OPT_LOCK)
    # if [[ -f /usr/bin/i3exit ]]; then
    #   i3exit lock
    if command -v i3exit &>/dev/null; then
      i3exit lock
    elif [[ -f /usr/bin/i3lock ]]; then
      i3lock
    elif [[ -f /usr/bin/betterlockscreen ]]; then
      betterlockscreen -l
    fi
    ;;
  $OPT_SUSPEND)
    ans=$(confirm_exit &)
    if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
      mpc -q pause
      # amixer set Master mute
      # systemctl suspend
      i3exit suspend
    elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
      exit 0
    else
      msg
    fi
    ;;
  $OPT_LOGOUT)
    ans=$(confirm_exit &)
    if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
      if [[ "$DESKTOP_SESSION" == "Openbox" ]]; then
        openbox --exit
      elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
        bspc quit
      elif [[ "$DESKTOP_SESSION" == @("i3"|"i3-with-shmlog") ]]; then
        # i3-msg exit
        i3exit logout
      fi
    elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
      exit 0
    else
      msg
    fi
    ;;
esac
