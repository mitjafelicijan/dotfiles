#!/bin/sh

export XCURSOR_SIZE=12

xkbset bo 50
xset r rate 400 30
xset dpms 0 0 1800

xinput --set-prop "pointer:Logitech MX Master 3" "libinput Accel Speed" -0.3
picom --vsync --backend glx -D 0 -c -o 0 &

exec i3
