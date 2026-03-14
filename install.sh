#!/bin/bash

DOTFILES=("firefox configs" ".zshrc" ".vimrc")
echo "Hi!"
read -p "Choose your dotfile (just select the number, default=ALL): 1 - firefox configs; 2 - .zshrc 3 - .vimrc" SELECTION
if [[ -z $SELECTION ]]; then
    SELECTION="1 2 3"
fi

for CHOICE in $SELECTION; do
    ITEM="${DOTFILES[((CHOICE - 1))]}"
    if [[ "$ITEM" == "firefox configs" ]]; then
        PATH_TO_USER_FF_PROFILE="$(find "$HOME/.mozilla/firefox" -name "*default-release*")"
        if [[ ! -d "${PATH_TO_USER_FF_PROFILE}/chrome" ]]; then
            read -p "There's no chrome directory in your firefox profile directory, \
                it's required for applying configs. Do you want to create it? [y/N]" CONFIRM
            if [[ "${CONFIRM,,}" == "y" ]]; then
                echo "Creating chrome directory..." && mkdir "$PATH_TO_USER_FF_PROFILE/chrome" && echo "Done!"
            else
                echo "Couldn't install firefox configs: process interrupted by user"
                exit 1
            fi
        fi

        if [[ -d "${PATH_TO_USER_FF_PROFILE}/chrome" ]]; then
            echo "Enabling CSS support in Firefox preferences..." \
            && echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "${PATH_TO_USER_FF_PROFILE}/user.js"
            CSS_FILES=("userChrome.css" "userContent.css")
            for CONFIG in "${CSS_FILES[@]}"; do
                if [[ -f "${PATH_TO_USER_FF_PROFILE}/chrome/$CONFIG" ]]; then
                    read -p "file "$CONFIG" already exists. Do you want to create a backup and replace it? [y/N]" CONFIRM
                    if [[ ${CONFIRM,,} == "y" ]];then
                        echo "Creating $CONFIG.bak..." \
                        && mv "${PATH_TO_USER_FF_PROFILE}/chrome/$CONFIG" "${PATH_TO_USER_FF_PROFILE}/chrome/$CONFIG.bak" \
                        && ln -sf "$(pwd)/firefox/$CONFIG" "$PATH_TO_USER_FF_PROFILE/chrome/$CONFIG" \
                        && echo "Done!"
                    else
                        echo "Couldn't create $CONFIG: process interrupted by user"
                    fi
                else
                    ln -sf "$(pwd)/firefox/$CONFIG" "$PATH_TO_USER_FF_PROFILE/chrome/$CONFIG"
                fi
            done
        fi

    else
        if [[ -f "$HOME/$ITEM" ]]; then
            read -p "$ITEM is already exists. Do you want to make a backup and replace it? [y/N]" CONFIRM
            if [[ "${CONFIRM,,}" == "y" ]]; then
                mv "$HOME/$ITEM" "$HOME/$ITEM.bak" \
                && ln -sf "$(find $(pwd) -name $ITEM)" "$HOME/$ITEM" \
                && echo "Done."
            fi
        else
            ln -sf "$(pwd)/$ITEM" "$HOME/$ITEM"
        fi
    fi
done
