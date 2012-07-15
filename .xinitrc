#!/bin/bash

xsetroot -solid '#262626' -xcf /usr/share/icons/Adwaita/cursors/arrow 16
xmodmap .xmodmaprc
xset -b
sudo tpb -d

#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --alpha 255 --tint 0x262626 --height 12 --padding 2&
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --alpha 0 --tint 0x262626  --height 12 --padding 2&

xscreensaver -no-splash &

urxvtd -q -o -f

exec xmonad
