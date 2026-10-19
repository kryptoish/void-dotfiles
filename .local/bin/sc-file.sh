#!/bin/sh
mkdir -p ~/Pictures/Screenshots
grim -g "$(slurp)" ~/Pictures/Screenshots/sc-$(date +'%Y-%m-%d-%H%M%S').png
