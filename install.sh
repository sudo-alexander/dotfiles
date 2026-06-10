#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
AVAILABLE_CONFIGS=("zsh" "vim" "alacritty" "tmux" "firefox")

echo "=== Available Components ==="
for i in "${!AVAILABLE_CONFIGS[@]}"; do
    printf "[%d] %s\n" "$((i+1))" "${AVAILABLE_CONFIGS[$i]}"
done
echo "============================"
read -r -p "Enter numbers to install (e.g., 1,2,3 or 124): " USER_INPUT

CNT=${#AVAILABLE_CONFIGS[@]}
CLEANED_INPUT=$(echo "$USER_INPUT" | tr -cd "1-${CNT}")

if [ -z "$CLEANED_INPUT" ]; then
    echo "Error: No valid components selected." >&2
    exit 1
fi

DOTFILES=()
for (( i=0; i<${#CLEANED_INPUT}; i++ )); do
    INDEX=$(( ${CLEANED_INPUT:$i:1} - 1 ))
    DOTFILES+=("${AVAILABLE_CONFIGS[$INDEX]}")
done

echo ""
# Config management: install selected components immediately.
# Conflicts are handled per-file: the script will prompt before overwriting.

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
    PACKAGES="zsh gvim alacritty tmux wl-clipboard"
elif [[ "$OS_ID" =~ ^(ubuntu|debian|pop|mint)$ ]] || [[ "$OS_LIKE" =~ "debian" ]]; then
    INSTALL_CMD="sudo apt-get update -y && sudo apt-get install -y"
    PACKAGES="zsh vim-gtk3 alacritty tmux wl-clipboard"
elif [[ "$OS_ID" =~ ^(fedora|rhel|centos)$ ]] || [[ "$OS_LIKE" =~ "rhel" ]]; then
    INSTALL_CMD="sudo dnf install -y"
    PACKAGES="zsh vim-X11 alacritty tmux wl-clipboard"
else
    echo "Distro $OS_ID is not supported." >&2
    exit 1
fi

if [ -z "${SKIP_PKGS:-}" ]; then
    echo "Installing system packages..."
    $INSTALL_CMD $PACKAGES
else
    echo "SKIP_PKGS set; skipping package installation."
fi

# Сreate symlink from repo to destination with conflict handling
confirm() {
    local prompt="$1"
    local default=${2:-n}
    local reply
    read -r -p "$prompt" reply
    reply=${reply:-$default}
    if [[ "$reply" =~ ^[Yy] ]]; then
        return 0
    fi
    return 1
}

install_link() {
    local src_rel="$1"
    local dest="$2"
    local src="$SCRIPT_DIR/$src_rel"
    if [ ! -e "$src" ]; then
        echo "Source not found: $src" >&2
        return 1
    fi
    if [ -L "$dest" ]; then
        local current_target
        current_target=$(readlink -f "$dest" 2>/dev/null || true)
        local src_real
        src_real=$(readlink -f "$src" 2>/dev/null || true)
        if [ "$current_target" = "$src_real" ]; then
            echo "Already linked: $dest → $src"
            return 0
        fi
    fi
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        read -r -p "Target exists: $dest. Overwrite? (y/N): " REPLY
        if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
            echo "Skipped: $dest"
            return 0
        fi
        rm -rf "$dest"
    fi
    mkdir -p "$(dirname "$dest")"
    ln -s "$src" "$dest"
    echo "Linked: $dest → $src"
}

install_copy() {
    local src_rel="$1"
    local dest="$2"
    local src="$SCRIPT_DIR/$src_rel"
    if [ ! -e "$src" ]; then
        echo "Source not found: $src" >&2
        return 1
    fi
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        read -r -p "Target exists: $dest. Overwrite? (y/N): " REPLY
        if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
            echo "Skipped: $dest"
            return 0
        fi
        rm -rf "$dest"
    fi
    mkdir -p "$(dirname "$dest")"
    cp -a "$src" "$dest"
    echo "Copied: $src → $dest"
}

# Deploy selected configs
UPDATED_ZSH=0
UPDATED_TMUX=0
for ITEM in "${DOTFILES[@]}"; do
    case "$ITEM" in
        zsh)
            if install_link "zsh/.zshrc" "$HOME/.zshrc"; then
                UPDATED_ZSH=1
            fi
            ;;
        vim)
            install_link "vim/.vimrc" "$HOME/.vimrc"
            ;;
        tmux)
            if install_link "tmux/.tmux.conf" "$HOME/.tmux.conf"; then
                UPDATED_TMUX=1
            fi
            ;;
        alacritty)
            install_link "alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
            ;;
        firefox)
            if [ -d "firefox" ]; then
                FF_USER_PROFILE=$(find "$HOME" -type d -name "*default*" -print -quit 2>/dev/null || true)
                if [ -n "$FF_USER_PROFILE" ]; then
                    RES_PATH="$FF_USER_PROFILE/chrome"
                    mkdir -p "$RES_PATH/img"
                    [ -f "firefox/userContent.css" ] && install_copy "firefox/userContent.css" "$RES_PATH/userContent.css"
                    [ -f "firefox/userChrome.css" ] && install_copy "firefox/userChrome.css" "$RES_PATH/userChrome.css"
                    if [ -d "firefox/img" ]; then
                        for img in firefox/img/*; do
                            [ -f "$img" ] || continue
                            fname=$(basename "$img")
                            install_copy "firefox/img/$fname" "$RES_PATH/img/$fname"
                        done
                    fi
                    echo "[Instruction]: Set 'toolkit.legacyUserProfileCustomizations.stylesheets' to true in about:config"
                else
                    echo "Firefox profile (default) not found. Skipping."
                fi
            else
                echo "No firefox folder in repo. Skipping firefox."
            fi
            ;;
        *)
            echo "Unknown item: $ITEM"
            ;;
    esac
done

# Change shell to zsh when available
TARGET_SHELL=$(which zsh || true)
if [ -n "$TARGET_SHELL" ] && [ "$SHELL" != "$TARGET_SHELL" ]; then
    echo "Changing system shell to zsh..."
    if [ -z "${SKIP_CHSH:-}" ]; then
        chsh -s "$TARGET_SHELL" || true
    else
        echo "SKIP_CHSH set; not changing shell."
    fi
fi

echo ""
echo "✓ Deployment completed successfully."

# Apply updated configs where possible
if [ "$UPDATED_ZSH" -eq 1 ]; then
    if [ -n "${ZSH_VERSION:-}" ]; then
        echo "Applying zsh config to current shell..."
        source "$HOME/.zshrc" || true
    else
        echo "Zsh updated. To apply: run 'source ~/.zshrc' or start a new zsh session."
    fi
fi

if [ "$UPDATED_TMUX" -eq 1 ]; then
    if tmux ls >/dev/null 2>&1; then
        echo "Reloading tmux config..."
        tmux source-file "$HOME/.tmux.conf" || true
    else
        echo "Tmux updated. To apply: run 'tmux source-file ~/.tmux.conf' in a tmux client or restart tmux."
    fi
fi