#!/usr/bin/env bash

# Kill any lingering instances on fresh start
pkill -x waybar 2>/dev/null
pkill -x mako 2>/dev/null
pkill -x swww-daemon 2>/dev/null
pkill -x nm-applet 2>/dev/null
pkill -x blueman-tray 2>/dev/null

# Unblock bluetooth if soft-blocked by hardware switch/kernel
rfkill unblock bluetooth 2>/dev/null &

# Sound daemons
pipewire &
wireplumber &
pipewire-pulse &

# Notification daemon
mako &

# Wallpaper daemon and image
swww-daemon &
(sleep 0.5 && swww img "$HOME/Pictures/wallpapers/wallpaper_destruction.png" --transition-type fade --transition-duration 1) &

# Status bar and tray
(sleep 0.5 && waybar) &
(sleep 1.2 && nm-applet --indicator) &

# Idle power saving
swayidle -w \
  timeout 900 'brightnessctl -s set 10%' resume 'brightnessctl -r' \
  timeout 990 'loginctl suspend' \
  before-sleep 'swaylock -c 000000 -f' &
