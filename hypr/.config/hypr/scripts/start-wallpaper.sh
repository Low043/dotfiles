#!/bin/bash

# Kill existing instances to prevent duplicates
killall mpvpaper 2>/dev/null

# Find wallpaper file
WALLPAPER=""
if [ -f "$HOME/Videos/Wallpapers/default.mp4" ]; then
    WALLPAPER="$HOME/Videos/Wallpapers/default.mp4"
elif [ -f "$HOME/Vídeos/Wallpapers/default.mp4" ]; then
    WALLPAPER="$HOME/Vídeos/Wallpapers/default.mp4"
fi

if [ -z "$WALLPAPER" ]; then
    echo "Wallpaper not found!"
    exit 1
fi

# Apply wallpaper to all connected monitors
for monitor in $(hyprctl monitors | grep "Monitor" | awk '{print $2}'); do
    mpvpaper -o "loop-file=inf no-audio" "$monitor" "$WALLPAPER" &
done
