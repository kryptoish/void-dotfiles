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

# Screen sharing / OBS: give portals the Wayland session env, then (re)start them
dbus-update-activation-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=mango XDG_SESSION_TYPE DISPLAY
(sleep 1 && pkill -f '^/usr/libexec/xdg-desktop-portal'; /usr/libexec/xdg-desktop-portal-wlr & sleep 0.5; /usr/libexec/xdg-desktop-portal &) &

# Notification daemon
mako &

# Wallpaper daemon and image
swww-daemon &
(sleep 0.5 && swww img /home/krish/Pictures/wallpapers/wallpaper_destruction.png --transition-type fade --transition-duration 1) &

# Status bar and tray
(sleep 0.5 && ~/.config/waybar/scripts/launch.sh) &
(sleep 1.2 && nm-applet --indicator) &

# Idle power saving
swayidle -w \
  timeout 900 'brightnessctl -s set 10%' resume 'brightnessctl -r' \
  timeout 990 'loginctl suspend' \
  before-sleep 'swaylock -c 000000 -f' &
