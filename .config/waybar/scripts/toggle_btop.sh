#!/usr/bin/env bash

if pgrep -f "alacritty --class btop" >/dev/null 2>&1 || pgrep -x btop >/dev/null 2>&1; then
    pkill -f "alacritty --class btop" 2>/dev/null
    pkill -x btop 2>/dev/null
else
    nohup alacritty --class btop,btop -o window.dimensions.columns=120 -o window.dimensions.lines=35 -e btop >/dev/null 2>&1 &
fi
exit 0
