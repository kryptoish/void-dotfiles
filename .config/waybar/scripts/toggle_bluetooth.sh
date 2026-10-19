#!/usr/bin/env bash

# If blueman-manager is currently open, toggle it off
if pgrep -x blueman-manager >/dev/null 2>&1; then
    pkill -x blueman-manager 2>/dev/null
    exit 0
fi

# Ensure bluetooth is unblocked and powered on
rfkill unblock bluetooth 2>/dev/null
bluetoothctl power on >/dev/null 2>&1

# Launch blueman-manager
nohup blueman-manager >/dev/null 2>&1 &
