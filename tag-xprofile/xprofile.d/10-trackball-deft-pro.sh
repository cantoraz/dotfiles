for i in $(xinput list | grep "ELECOM TrackBall Mouse DEFT Pro TrackBall" | perl -n -e'/id=(\d+)/ && print "$1\n"')
do if xinput get-button-map "$i" 2>/dev/null| grep -q 12; then
       xinput set-button-map "$i" 1 12 3 4 5 6 7 8 9 10 11 2
       # enable natural scrolling in xorg.conf
       # xinput set-prop "$i" "libinput Natural Scrolling Enabled" 1
   fi
done
