#!/bin/sh
# Slurp lets you drag a box, grim grabs that exact box, and wl-copy stores it as a PNG image
grim -g "$(slurp)" - | wl-copy -t image/png
