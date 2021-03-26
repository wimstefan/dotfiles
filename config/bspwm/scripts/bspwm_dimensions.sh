#!/bin/sh
# rule example:
# bspc rule -a <your_app> state=floating sticky=on rectangle="$newwidth"x"$newheight"+"$hor"+"$ver"
# and add next line to bspwmrc. POINT is important!
# source ~/.config/bspwm/scripts/bspwm_dimensions.sh
offset=$((4 * $(bspc config border_width)))

monwidth=$(xdotool getdisplaygeometry | awk '{print $1}')
monheight=$(xdotool getdisplaygeometry | awk '{print $2}')

newwidth=$((monwidth / 2))
newheight=$((monheight / 2))
hor=$((monwidth - newwidth - offset)) \
ver=$((monheight - newheight - offset))
