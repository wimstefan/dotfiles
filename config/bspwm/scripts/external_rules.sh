#! /bin/sh

logfile=/tmp/bspwm_external_rules.log
wid="$1"
class="$2"
instance="$3"
consequences="$4"
title="$(xwininfo -id "$wid" | sed '/^xwininfo/!d ; s,.*"\(.*\)".*,\1,')"
type="$(xprop -id "$wid" _NET_WM_WINDOW_TYPE | sed '/^_NET_WM_WINDOW_TYPE/!d ; s/^.* = \(.*\),.*/\1/')"

case "$type" in
  *DIALOG* )
    echo "state=floating"
    echo "center=on"
    echo "rectangle=${newwidth}x${newheight}+${hor}+${ver}"
    ;;
esac
case "$title" in
  Calculator|Explore|Keybindings|Ranger|Scratchpad|calendar )
    echo "state=floating"
    ;;
esac
case "$class" in
  [Dd]arktable|[Gg]imp )
    case "$type" in
      *NORMAL* )
        echo "state=fullscreen"
        ;;
    esac
    ;;
esac
case "$class" in
  [Mm]ixxx )
    case "$type" in
      *NORMAL* )
        echo "state=tiled"
        ;;
    esac
    ;;
esac
case "$class" in
  [Ss]cribus )
    case "$title" in
      Outline|Properties )
        echo "state=floating"
        ;;
      * )
        echo "state=fullscreen"
        ;;
    esac
    ;;
esac


echo "Id: $wid" >> "$logfile"
echo "Class: $class" >> "$logfile"
echo "Instance: $instance" >> "$logfile"
echo "Consequences: $consequences" >> "$logfile"
echo "Title: $title" >> "$logfile"
echo "Type: $type" >> "$logfile"
echo "---" >> "$logfile"
