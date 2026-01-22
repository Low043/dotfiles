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

3. **Apply configurations:**
   Run stow for the packages you want to install (e.g., `hypr`, `kitty`, `zsh`):
   ```bash
   stow hypr
   stow kitty
   stow zsh
   # Or install everything at once:
   # stow *
   ```

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
