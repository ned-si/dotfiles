#!/bin/sh
export SSH_AUTH_SOCK DEFAULT="${XDG_RUNTIME_DIR}/ssh-agent.socket"
xinput set-prop 12 "libinput Click Method Enabled" 0 1
xbindkeys
exec --no-startup-id autorandr --change
xrdb /home/"$USER"/.Xresources
exec i3
