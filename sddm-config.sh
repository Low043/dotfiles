#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}==> Configuring SDDM...${NC}"

if [ -d "sddm" ]; then
    echo "Copying SDDM theme configuration..."
    
    # Define the theme path (adjust based on the actual theme name installed by packages.txt or manual setup)
    # Assuming sddm-astronaut-theme is installed via AUR or manually
    THEME_PATH="/usr/share/sddm/themes/sddm-astronaut-theme"

    # Ensure target directories exist
    if [ ! -d "$THEME_PATH" ]; then
        echo -e "\033[0;33mWarning: SDDM theme directory '$THEME_PATH' does not exist. Please ensure the theme is installed.\033[0m"
        # Optional: Install it if it's missing, but packages.txt usually handles installation.
    fi

    sudo mkdir -p "$THEME_PATH/Themes"
    sudo mkdir -p "$THEME_PATH/Backgrounds"
    
    # Copy custom theme config
    if [ -f "sddm/themes/sddm-astronaut-theme/Themes/custom" ]; then
        echo "Installing custom theme configuration..."
        sudo cp "sddm/themes/sddm-astronaut-theme/Themes/custom" "$THEME_PATH/Themes/"
    fi
    
    # Configure Wallpaper
    echo "Setting up default wallpaper symlink..."
    # The user typically keeps wallpapers in ~/Videos/Wallpapers/
    # We link the system theme background to a file in the user's home (careful with permissions) 
    # OR we link to a specific location this script expects.
    # The previous logic linked to $HOME/Vídeos/Wallpapers/default.mp4.
    
    # Using 'eval echo ~' or $HOME to resolve user path if running with sudo might be tricky if sudo changes $HOME.
    # Typically sudo keeps the target user's home if not -i, but let's be safe.
    if [ -n "$SUDO_USER" ]; then
        USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    else
        USER_HOME=$HOME
    fi

    WALLPAPER_SRC="$USER_HOME/Videos/Wallpapers/default.mp4"
    # Portuguese path support
    if [ ! -f "$WALLPAPER_SRC" ]; then
        WALLPAPER_SRC="$USER_HOME/Vídeos/Wallpapers/default.mp4"
    fi

    if [ -f "$WALLPAPER_SRC" ]; then
        echo "Linking $WALLPAPER_SRC to $THEME_PATH/Backgrounds/default.mp4"
        sudo ln -sf "$WALLPAPER_SRC" "$THEME_PATH/Backgrounds/default.mp4"
    else
        echo -e "\033[0;33mWarning: 'default.mp4' not found in $USER_HOME/Videos/Wallpapers or $USER_HOME/Vídeos/Wallpapers.\033[0m"
        echo "Please create a symlink named 'default.mp4' in your wallpapers directory pointing to your desired video."
    fi
    
    echo "Activating SDDM theme..."
    if [ -f "sddm/etc/sddm.conf" ]; then
        sudo cp sddm/etc/sddm.conf /etc/sddm.conf
    fi
    
    echo -e "${GREEN}SDDM configured.${NC}"
else
    echo "SDDM configuration directory 'sddm/' not found in current location."
fi
