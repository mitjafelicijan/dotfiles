#!/bin/sh

export XCURSOR_SIZE=12

xset r on
xset r rate 700 5
xset dpms 0 0 1800

xinput --set-prop "pointer:Logitech MX Master 3" "libinput Accel Speed" -0.3
picom --vsync --backend glx &

pulseaudio --start
exec dbus-run-session i3
# exec dbus-run-session glitch
