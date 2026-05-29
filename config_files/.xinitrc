#!/bin/bash

export XDG_CURRENT_DESKTOP=dwm

feh --bg-fill ~/Wallpaper/stars.jpg &
dwmblocks &
picom -b &
dunst &

exec dwm
