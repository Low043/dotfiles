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
    
    # Read packages.txt line by line
    while IFS= read -r package || [ -n "$package" ]; do
        # Trim whitespace
        package=$(echo "$package" | xargs)
        
        # Skip empty lines and comments
        if [[ -z "$package" || "$package" == \#* ]]; then
            continue
        fi

        echo -e "-> Installing ${package}..."
        if yay -S --needed --noconfirm "$package"; then
            echo -e "${GREEN}Successfully installed ${package}${NC}"
        else
            echo -e "\033[0;31mFailed to install ${package}\033[0m"
        fi
    done < packages.txt

else
    echo "packages.txt file not found!"
fi

echo -e "${GREEN}==> Package installation complete!${NC}"
echo -e "${GREEN}==> Remember to run 'stow <package>' to link your configurations.${NC}"