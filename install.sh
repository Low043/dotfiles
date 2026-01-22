#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}==> Starting dotfiles setup...${NC}"

# 1. Check/Install yay
if ! command -v yay &> /dev/null; then
    echo "Yay not found. Installing..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
else
    echo "Yay is already installed."
fi

# 2. Install packages from list
if [ -f "packages.txt" ]; then
    echo -e "${GREEN}==> Installing packages from packages.txt...${NC}"
    # Filter empty lines and comments
    PACKAGES=$(grep -vE "^\s*#|^\s*$" packages.txt | tr '\n' ' ')
    
    if [ -n "$PACKAGES" ]; then
        yay -S --needed --noconfirm $PACKAGES
    else
        echo "No packages found in packages.txt."
    fi
else
    echo "packages.txt file not found!"
fi

echo -e "${GREEN}==> Package installation complete!${NC}"
echo -e "${GREEN}==> Remember to run 'stow <package>' to link your configurations.${NC}"