#!/bin/bash

export PATH=$PATH:~/.cabal/bin:~/bin

xsetroot  -xcf /usr/share/icons/Adwaita/cursors/arrow 16
hsetroot -solid '#262626'
xmodmap .xmodmaprc
xset -b r 232 r 233 +dpms
#xcompmgr -c -f &
unclutter &
start-pulseaudio-x11

#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --alpha 255 --tint 0x262626 --height 12 --padding 2&
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent true --alpha 0 --tint 0x262626  --height 23 --padding 2&

xscreensaver -no-splash &

urxvtd -q -o -f

syndaemon -i 1 -t -k -d

gtk-redshift -l 37.8569:-122.2510 -g 0.8 -m randr &

eval `dbus-launch --auto-syntax`
volnoti

#exec ck-launch-session xmonad
exec xmonad
