#!/bin/bash

set -eo pipefail

AVAILABLE_CONFIGS=("zsh" "vim" "alacritty" "tmux")

echo "=== Available Components ==="
for i in "${!AVAILABLE_CONFIGS[@]}"; do
    printf "[%d] %s\n" "$((i+1))" "${AVAILABLE_CONFIGS[$i]}"
done
echo "============================"
read -r -p "Enter numbers to install: " USER_INPUT

CLEANED_INPUT=$(echo "$USER_INPUT" | sed 's/[^1-4]//g')

if [ -z "$CLEANED_INPUT" ]; then
    echo "Error: No valid components selected." >&2
    exit 1
fi

DOTFILES=()
for (( i=0; i<${#CLEANED_INPUT}; i++ )); do
    INDEX=$(( ${CLEANED_INPUT:$i:1} - 1 ))
    DOTFILES+=("${AVAILABLE_CONFIGS[$INDEX]}")
done

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID=${ID}
    OS_LIKE=${ID_LIKE:-""}
else
    echo "Error: /etc/os-release not found." >&2
    exit 1
fi

if [[ "$OS_ID" =~ ^(arch|manjaro)$ ]] || [[ "$OS_LIKE" =~ "arch" ]]; then
    INSTALL_CMD="sudo pacman -S --needed --noconfirm"
    PACKAGES="stow zsh gvim alacritty tmux wl-clipboard"
elif [[ "$OS_ID" =~ ^(ubuntu|debian|pop|mint)$ ]] || [[ "$OS_LIKE" =~ "debian" ]]; then
    INSTALL_CMD="sudo apt-get update -y && sudo apt-get install -y"
    PACKAGES="stow zsh vim-gtk3 alacritty tmux wl-clipboard"
elif [[ "$OS_ID" =~ ^(fedora|rhel|centos)$ ]] || [[ "$OS_LIKE" =~ "rhel" ]]; then
    INSTALL_CMD="sudo dnf install -y"
    PACKAGES="stow zsh vim-X11 alacritty tmux wl-clipboard"
else
    echo "Distro $OS_ID is not supported." >&2
    exit 1
fi

echo "Installing system packages..."
$INSTALL_CMD $PACKAGES

echo "Applying dotfiles via GNU Stow..."
for ITEM in "${DOTFILES[@]}"; do
    if [ -d "$ITEM" ]; then
        if [ -f "$HOME/.$ITEM" ] && [ ! -h "$HOME/.$ITEM" ]; then
            echo "Backup created for existing file: $HOME/.$ITEM"
            mv "$HOME/.$ITEM" "$HOME/.$ITEM.bak"
        fi
        stow -R "$ITEM"
    else
        echo "Warning: Configuration directory '$ITEM' not found. Skipping." >&2
    fi
done

if [ -d "firefox" ]; then
    FF_USER_PROFILE=$(find "$HOME" -maxdepth 5 -type d -name "*default*" -print -quit 2>/dev/null || true)
    
    if [ -n "$FF_USER_PROFILE" ]; then
        RES_PATH="$FF_USER_PROFILE/chrome"
        mkdir -p "$RES_PATH/img"

        [ -f "firefox/userContent.css" ] && cp -a "firefox/userContent.css" "$RES_PATH/."
        [ -f "firefox/userChrome.css" ] && cp -a "firefox/userChrome.css" "$RES_PATH/."
        [ -f "firefox/img/dark-gradient-background.jpg" ] && cp -a "firefox/img/dark-gradient-background.jpg" "$RES_PATH/img/."
        
        echo "[Instruction]: Set 'toolkit.legacyUserProfileCustomizations.stylesheets' to true in about:config"
    else
        echo "Firefox profile (default) not found. Skipping."
    fi
fi

TARGET_SHELL=$(which zsh)
if [ "$SHELL" != "$TARGET_SHELL" ]; then
    echo "Changing system shell to zsh..."
    chsh -s "$TARGET_SHELL"
fi

echo "Deployment completed successfully."