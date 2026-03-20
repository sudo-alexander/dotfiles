#!/bin/bash

set -eo pipefail

echo "Hi!"
DOTFILES=("zsh" "vim" "alacritty" "tmux")

# install required packages
sudo pacman -S --needed stow zsh gvim alacritty tmux wl-clipboard

# create dotfiles symlinks in system
for ITEM in "${DOTFILES[@]}"; do
    stow $ITEM
done

# configure firefox
FF_USER_PROFILE="$(find "$HOME" -type d -name "*.default-release*" 2>/dev/null | grep -i -v "cache" | head -n 1)"
mkdir -p "$FF_USER_PROFILE/chrome"
RES_PATH="$FF_USER_PROFILE/chrome"
ln -sf "$(pwd)/firefox/userContent.css" "$RES_PATH/userContent.css"
ln -sf "$(pwd)/firefox/userChrome.css" "$RES_PATH/userChrome.css"
echo "Set 'toolkit.legacyUserProfileCustomizations.stylesheets' to true"
echo "Done."
