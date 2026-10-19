#!/usr/bin/env bash

step="5%"

case "$1" in
    up)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        pactl set-sink-volume @DEFAULT_SINK@ +${step}
        ;;
    down)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        pactl set-sink-volume @DEFAULT_SINK@ -${step}
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
esac

# Get current volume and mute status
mute=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | awk '{print $2}')
vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -Po '\d+(?=%)' | head -n 1)

if [ "$mute" = "yes" ]; then
    notify-send -a "OSD" -h string:x-canonical-private-synchronous:osd \
        -i audio-volume-muted -t 1500 "Volume Muted"
else
    if [ -z "$vol" ]; then vol=0; fi
    if [ "$vol" -ge 65 ]; then
        icon="audio-volume-high"
    elif [ "$vol" -ge 30 ]; then
        icon="audio-volume-medium"
    else
        icon="audio-volume-low"
    fi
    notify-send -a "OSD" -h string:x-canonical-private-synchronous:osd \
        -h int:value:"$vol" -i "$icon" -t 1500 "Volume: ${vol}%"
fi
