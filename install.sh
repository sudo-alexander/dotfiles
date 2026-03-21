#!/bin/bash

set -eo pipefail

echo "Hi!"
DOTFILES=("zsh" "vim" "alacritty" "tmux")

# define your distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
fi

# install required packages
case $OS in
    arch|manjaro)
        INSTALL_CMD="sudo pacman -S --needed"
        PACKAGES="stow zsh gvim alacritty tmux wl-clipboard"
        ;;
    ubuntu|debian|pop)
        INSTALL_CMD="sudo apt update && sudo apt install -y"
        PACKAGES="stow zsh vim-gtk3 alacritty tmux wl-copy" 
        ;;
    fedora)
        INSTALL_CMD="sudo dnf install -y"
        PACKAGES="stow zsh vim-X11 alacritty tmux wl-clipboard"
        ;;
    *)
        echo "Unknown OS: $OS. Install packages manually."
        exit 1
        ;;
esac
$INSTALL_CMD $PACKAGES

# create dotfiles symlinks in system
for ITEM in "${DOTFILES[@]}"; do
    stow $ITEM
done

# configure firefox
cd firefox
FF_USER_PROFILE="$(find "$HOME" -type d -name "*.default-release*" 2>/dev/null | grep -i -v "cache" | head -n 1)"
mkdir -p "$FF_USER_PROFILE/chrome/img"
RES_PATH="$FF_USER_PROFILE/chrome"
cp -a "$(pwd)/userContent.css" "$RES_PATH/."
cp -a "$(pwd)/userChrome.css" "$RES_PATH/."
cp -a "$(pwd)/img/dark-gradient-background.jpg" "$RES_PATH/img"
echo "Set 'toolkit.legacyUserProfileCustomizations.stylesheets' to true"
cd ..

if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing shell to zsh..."
    chsh -s $(which zsh)
fi

echo "Done."
