#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}==> Configuring SDDM...${NC}"

if [ -d "sddm" ]; then
    echo "Configuring SDDM theme..."
    
    THEME_REPO="https://github.com/Keyitdev/sddm-astronaut-theme.git"
    THEME_PATH="/usr/share/sddm/themes/sddm-astronaut-theme"

    # 1. Install/Update Theme
    if [ -d "$THEME_PATH" ]; then
        if [ -d "$THEME_PATH/.git" ]; then
             echo "Theme directory exists and is a git repo. Updating..."
             sudo git -C "$THEME_PATH" pull
        else
            echo "Directory exists but is not a git repo. Removing and cloning fresh..."
            sudo rm -rf "$THEME_PATH"
            sudo git clone "$THEME_REPO" "$THEME_PATH"
        fi
    else
        echo "Theme not found. Cloning from $THEME_REPO..."
        sudo git clone "$THEME_REPO" "$THEME_PATH"
    fi

    # 2. Install Fonts
    if [ -d "$THEME_PATH/Fonts" ]; then
        echo "Installing fonts..."
        sudo cp -r "$THEME_PATH/Fonts/"* /usr/share/fonts/
    fi

    sudo mkdir -p "$THEME_PATH/Themes"
    sudo mkdir -p "$THEME_PATH/Backgrounds"
    
    # 3. Copy custom theme config
    if [ -f "sddm/themes/sddm-astronaut-theme/Themes/custom" ]; then
        echo "Installing custom theme configuration..."
        # Remove if exists (handles broken symlinks)
        sudo rm -f "$THEME_PATH/Themes/custom"
        sudo cp "sddm/themes/sddm-astronaut-theme/Themes/custom" "$THEME_PATH/Themes/"
        
        echo "Updating metadata.desktop to use 'custom' config..."
        if grep -q "ConfigFile=" "$THEME_PATH/metadata.desktop"; then
            sudo sed -i 's|^ConfigFile=.*|ConfigFile=Themes/custom|' "$THEME_PATH/metadata.desktop"
        else
            echo "ConfigFile=Themes/custom" | sudo tee -a "$THEME_PATH/metadata.desktop"
        fi
    fi
    
    # 4. Configure Wallpaper
    echo "Setting up default wallpaper symlink..."
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
        sudo rm -f "$THEME_PATH/Backgrounds/default.mp4"
        sudo ln -sf "$WALLPAPER_SRC" "$THEME_PATH/Backgrounds/default.mp4"
    else
        echo -e "\033[0;33mWarning: 'default.mp4' not found in $USER_HOME/Videos/Wallpapers or $USER_HOME/Vídeos/Wallpapers.\033[0m"
    fi
    
    # 5. Activate SDDM Theme and Virtual Keyboard
    echo "Activating SDDM theme..."
    if [ -f "sddm/etc/sddm.conf" ]; then
        sudo cp sddm/etc/sddm.conf /etc/sddm.conf
    fi
    
    echo "Configuring virtual keyboard..."
    sudo mkdir -p /etc/sddm.conf.d
    echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf > /dev/null
    
    echo -e "${GREEN}SDDM configured successfully.${NC}"
else
    echo "SDDM configuration directory 'sddm/' not found in current location."
fi