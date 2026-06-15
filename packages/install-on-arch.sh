#!/usr/bin/env bash
set -e

read -rp "Do you want to update the system packages now? (y/N): " choice
case "$choice" in
  y|Y )
    echo "Updating system..."
    sudo pacman -Syu --noconfirm
    ;;
  * )
    echo "Skipping system update."
    ;;
esac

if ! command -v yay &> /dev/null; then
    echo "yay not found. Installing yay..."

    sudo pacman -S --needed --noconfirm git base-devel

    tmp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"

    (cd "$tmp_dir/yay" && makepkg -si --noconfirm)

    rm -rf "$tmp_dir"

    echo "yay installed successfully."
else
    echo "yay is already installed."
fi

echo "Installing official packages..."
sudo yay -S --needed --noconfirm - < packages/base.txt
# sudo pacman -S --needed --noconfirm - < packages/hyprland.txt
# sudo pacman -S --needed --noconfirm - < packages/tools.txt

echo "Installing AUR packages..."
if ! command -v yay &> /dev/null; then
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
fi

# yay -S --needed --noconfirm - < packages/aur.txt

echo "Linking dotfiles..."

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sf "$DOTFILES_DIR/hypr" ~/.config/hypr
ln -sf "$DOTFILES_DIR/helix" ~/.config/helix
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
echo "Done."
