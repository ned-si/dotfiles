#!/bin/sh
xinput set-prop 12 "libinput Click Method Enabled" 0 1
xbindkeys
exec --no-startup-id autorandr --change
xrdb /home/"$USER"/.Xresources
[ -f ~/.xprofile ] && . ~/.xprofile
exec i3
