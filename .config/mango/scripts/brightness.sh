#!/usr/bin/env bash

step="5%"

case "$1" in
    up)
        brightnessctl set +${step} >/dev/null
        ;;
    down)
        brightnessctl set ${step}- >/dev/null
        ;;
esac

# Get current brightness percentage
bright=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
if [ -z "$bright" ]; then bright=0; fi

notify-send -a "OSD" -h string:x-canonical-private-synchronous:osd \
    -h int:value:"$bright" -i display-brightness-symbolic -t 1500 "Brightness: ${bright}%"
