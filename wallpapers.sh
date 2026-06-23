#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}==> Configuring Wallpapers & SDDM...${NC}"

# 1. Identificar a pasta do usuário (suporta sudo)
if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    REAL_USER="$SUDO_USER"
else
    USER_HOME=$HOME
    REAL_USER=$USER
fi

WALLPAPER_SRC="$USER_HOME/Videos/Wallpapers/default.mp4"
# Suporte para caminhos em português
if [ ! -f "$WALLPAPER_SRC" ]; then
    WALLPAPER_SRC="$USER_HOME/Vídeos/Wallpapers/default.mp4"
fi

if [ ! -f "$WALLPAPER_SRC" ]; then
    echo -e "\033[0;31mErro: 'default.mp4' não encontrado em $USER_HOME/Videos/Wallpapers\033[0m"
    echo "Baixe o vídeo, renomeie para 'default.mp4' e tente novamente."
    exit 1
fi

if [ -d "sddm" ]; then
    echo "Configuring SDDM theme..."
    
    THEME_REPO="https://github.com/Keyitdev/sddm-astronaut-theme.git"
    THEME_PATH="/usr/share/sddm/themes/sddm-astronaut-theme"

    # 1. Install/Update Theme
    if [ -d "$THEME_PATH" ]; then
        if [ -d "$THEME_PATH/.git" ]; then
             echo "Theme directory exists. Updating..."
             sudo git -C "$THEME_PATH" pull
        else
            sudo rm -rf "$THEME_PATH"
            sudo git clone "$THEME_REPO" "$THEME_PATH"
        fi
    else
        echo "Cloning theme from $THEME_REPO..."
        sudo git clone "$THEME_REPO" "$THEME_PATH"
    fi

    # 2. Install Fonts
    if [ -d "$THEME_PATH/Fonts" ]; then
        echo "Installing fonts..."
        sudo cp -r "$THEME_PATH/Fonts/"* /usr/share/fonts/
        sudo fc-cache -fv > /dev/null
    fi

    sudo mkdir -p "$THEME_PATH/Themes"
    sudo mkdir -p "$THEME_PATH/Backgrounds"
    
    # 3. Copy custom theme config
    if [ -f "sddm/custom" ]; then
        echo "Installing custom theme configuration..."
        sudo rm -f "$THEME_PATH/Themes/custom"
        sudo cp "sddm/custom" "$THEME_PATH/Themes/"
        
        echo "Updating metadata.desktop to use 'custom' config..."
        if grep -q "ConfigFile=" "$THEME_PATH/metadata.desktop"; then
            sudo sed -i 's|^ConfigFile=.*|ConfigFile=Themes/custom|' "$THEME_PATH/metadata.desktop"
        else
            echo "ConfigFile=Themes/custom" | sudo tee -a "$THEME_PATH/metadata.desktop" > /dev/null
        fi
    fi
    
    # 4. Configure SDDM Wallpaper (CÓPIA FÍSICA PARA EVITAR BLACK SCREEN)
    echo "Copying $WALLPAPER_SRC to SDDM Backgrounds..."
    sudo cp "$WALLPAPER_SRC" "$THEME_PATH/Backgrounds/default.mp4"
    sudo chmod 644 "$THEME_PATH/Backgrounds/default.mp4"
    
    # 5. Activate SDDM Theme and Virtual Keyboard
    echo "Activating SDDM theme..."
    echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf > /dev/null
    
    echo "Configuring virtual keyboard..."
    sudo mkdir -p /etc/sddm.conf.d
    echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf > /dev/null
    
    echo -e "${GREEN}SDDM configured successfully.${NC}"
else
    echo "Directory 'sddm/' not found. Skipping SDDM config."
fi

# 6. Apply Wallpaper to current Hyprland Session
echo "Applying wallpaper to desktop session..."
# Executa o script do hyprland usando o usuário real (para ter acesso ao Wayland)
sudo -u "$REAL_USER" bash "$USER_HOME/.config/hypr/scripts/start-wallpaper.sh"

echo -e "${GREEN}==> All done! Enjoy your Cat in the Swamp!${NC}"