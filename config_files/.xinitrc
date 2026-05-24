#!/bin/bash

feh --bg-fill ~/Wallpaper/stars.jpg &
dwmblocks &
picom -b &

exec dwm
