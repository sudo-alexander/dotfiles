#!/bin/bash

DOTFILES=("firefox configs" ".zshrc" ".vimrc")
echo "Hi!"
read -p "Choose your dotfile (just select the number): 1 - firefox configs; 2 - .zshrc 3 - .vimrc" DOTFILE
DOTFILE=${DOTFILES[((DOTFILE - 1))]}
if [[ "$DOTFILE" == "firefox configs" ]]; then
    PATH_TO_USER_FF_PROFILE="$(find "$HOME/.mozilla/firefox" -name "*default-release*")"
    if [[ ! -d "${PATH_TO_USER_FF_PROFILE}/chrome" ]]; then
        read -p "There's no chrome directory in your firefox profile directory, it's required for applying configs. Do you want to create it? [y/N]" CONFIRM
        if [[ "${CONFIRM,,}" == "y" ]]; then
            echo "Creating chrome directory..." && mkdir "$PATH_TO_USER_FF_PROFILE/chrome" && echo "Done!"
        else
            echo "Couldn't install firefox configs: process interrupted by user"
        fi
    fi

    if [[ -d "${PATH_TO_USER_FF_PROFILE}/chrome" ]]; then
        CSS_FILES=("userChrome.css" "userContent.css")
        for CONFIG in "${CSS_FILES[@]}"; do
            if [[ -f "${PATH_TO_USER_FF_PROFILE}/chrome/$CONFIG" ]]; then
                read -p "file "$CONFIG" already exists. Do you want to create a backup and replace it? [y/N]" CONFIRM
                if [[ ${CONFIRM,,} == "y" ]];then
                    echo "Creating $CONFIG.bak..." && mv "${PATH_TO_USER_FF_PROFILE}/chrome/$CONFIG" "${PATH_TO_USER_FF_PROFILE}/chrome/$CONFIG.bak" && ln -sf "$(pwd)/firefox/$CONFIG" "$PATH_TO_USER_FF_PROFILE/chrome/$CONFIG" && echo "Done!"
                else
                    echo "Couldn't create $CONFIG: process interrupted by user"
                fi
            fi
        done
    fi

else
    if [[ -f "$HOME/$DOTFILE" ]]; then
        read -p "$DOTFILE is already exists. Do you want to make a backup and replace it? [y/N]" CONFIRM
        if [[ "${CONFIRM,,}" == "y" ]]; then
            mv "$HOME/$DOTFILE" "$HOME/$DOTFILE.bak" && ln -sf "$(find $(pwd) -name $DOTFILE)" "$HOME/$DOTFILE"
        fi
    else
        ln -sf "$(pwd)/$DOTFILE" "$HOME/$DOTFILE"
    fi
fi
