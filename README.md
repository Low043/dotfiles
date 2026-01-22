# Dotfiles

Personal configuration files for my **Arch Linux** setup, featuring **Hyprland**.
Managed using [GNU Stow](https://www.gnu.org/software/stow/).

## Dependencies

- **OS:** Arch Linux
- **WM:** Hyprland
- **Terminal:** Kitty
- **Shell:** Zsh (Oh My Zsh + Powerlevel10k)
- **Manager:** GNU Stow
- **AUR Helper:** Yay
- **Packages:** Listed in `packages.txt`

## Initial Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Low043/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the installation script:**
   This script will install `yay` (if missing) and all packages listed in `packages.txt`.
   ```bash
   ./install.sh
   ```

3. **Configure SDDM (Login Screen):**
   To setup the SDDM theme and configuration, run the separate config script. This will copy system-wide configurations.
   ```bash
   ./sddm-config.sh
   ```

4. **Apply configurations:**
   Run stow for the packages you want to install (e.g., `hypr`, `kitty`, `zsh`):
   ```bash
   stow hypr
   stow kitty
   stow zsh
   # WARNING: sddm foulder should not be loaded
   ```

## Animated Wallpapers

This setup uses animated wallpapers for both the **SDDM login screen** and the **Hyprland desktop**. Both components are configured to use a file named `default.mp4` as the source.

**Path Detection:**
The configuration automatically checks for `default.mp4` in both `~/Videos/Wallpapers/` and `~/Vídeos/Wallpapers/`, so it works out-of-the-box regardless of your system language.

**How to change your wallpaper:**

1.  Place your video wallpapers in your `~/Videos/Wallpapers/` (or `~/Vídeos/Wallpapers/`) folder.
2.  Create a symbolic link named `default.mp4` pointing to the video you want to use.

```bash
# Example:
mkdir -p ~/Videos/Wallpapers
cd ~/Videos/Wallpapers/
ln -sf my_cool_animation.mp4 default.mp4
```

This updates both your login screen and desktop wallpaper simultaneously.

## How to Apply Modifications

To add new configurations or modify existing ones:

1. **Move** the config file to the corresponding folder in `~/dotfiles` (maintaining the directory structure relative to `$HOME`).
   *Example:* `mv ~/.config/new-app/config.ini ~/dotfiles/new-app/.config/new-app/config.ini`

2. **Add Dependencies:**
   If the new configuration requires new software, add the package name to `packages.txt` so it gets installed automatically in the future.

3. **Link** it using Stow:
   ```bash
   cd ~/dotfiles
   stow new-app
   ```

4. **Commit** your changes:
   ```bash
   git add .
   git commit -m "feat: added new-app config"
   git push
   ```

## Notes

- **Conflicts:** If a config file already exists in your `$HOME`, Stow will refuse to overwrite it. You must backup/delete the existing file before running `stow`.
