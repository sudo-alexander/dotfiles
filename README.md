# My Dotfiles

## ⚙️ Installation
```bash
git clone https://github.com/sudo-alexander/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

## 🦊 Firefox UI customization
![Firefox customization](screenshots/firefox-preview.png)

## 🖥️ Zsh config
![Zsh config](screenshots/zsh-preview.png)

## 📦 What's inside?

## 1. 🖥️ Zsh config
### ✨ Key Features

This setup is designed for those who love the **classic GNOME/Bash aesthetics** but want the **modern power of Zsh**.

* **Classic Look, Zsh Power:** Styled to resemble the standard GNOME Console (Bash-rice), keeping it familiar and clean.
* **Enhanced Highlighting:** Unlike basic Bash, this config highlights not just the username and folders, but also specific commands, aliases, and paths.
* **Two-Line Prompt:** A smart two-line layout ensures your commands always start from the same position, regardless of how deep you are in the file system.
* **Root Awareness:** The prompt symbol turns **Bold Red (#)** when running as root, providing a clear visual warning.
* **Smart Completion:** Includes `zsh-autosuggestions` and `compinit` for a faster, "IDE-like" terminal experience.
* **Focused Syntax:** Intentionally disables the distracting "red-on-type" error highlighting, keeping the interface calm and focused.

## 2. 🦊 Firefox Minimalist UI
### ✨ Key Features

A clean, distraction-free interface modification achieved strictly through `userChrome.css` and `userContent.css`.

* **Pure Minimalism:** Hidden tab close buttons, "New Tab" plus icon, and the "List all tabs" arrow to eliminate UI clutter.
* **Enhanced New Tab Icons:** Website titles are removed for a cleaner look. Icons are enlarged and centered to focus on visual recognition.
* **Smooth Animations:** Added a scale-up transition effect when hovering over top sites, making the dashboard feel responsive and modern.

## 3. ⌨️ Vim config
### ✨ Key Features

A clean and functional `.vimrc` designed for comfortable text editing without bloating it with too many plugins.

* **Smart Indentation:** Configured with 4-space tabs and auto-indentation.
* **Navigation:** Relative line numbers are enabled to help you jump between lines faster.
* **Persistent Undo:** Your undo history is saved even after you close the file (stored in `~/.vim/undo`).
* **Russian Layout Support:** Commands like `:w` or `dd` work even if you forget to switch from the Russian keyboard layout.
* **Fast Exit:** Added a shortcut: typing `jj` in Insert mode returns you to Normal mode instantly.
* **System Clipboard:** Integrated with the system clipboard for easy copy-pasting.

## 📂 Structure

```text
.
├── zsh/
│   └── .zshrc
├── firefox/
│   ├── userChrome.css
│   └── userContent.css
└── screenshots/
    ├── firefox-homepage.png
    └── zsh-preview.png