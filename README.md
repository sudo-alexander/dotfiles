# 🛠️ My Dotfiles

## ⚙️ Installation
```bash
git clone https://github.com/ai-xandr/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

This repository utilizes **GNU Stow** for symbolic link management and automated deployment.

## Preview
### 🦊 Firefox UI customization
![Firefox](./.screenshots/firefox-preview.png)

### 💻 Zsh + Alacritty + Tmux
![Zsh + Alacritty](./.screenshots/zsh-alacritty-preview.png)

## Technical Details

- **Zsh** — fast interactive shell with sensible defaults, prompt, autosuggestions and highlighting (`zsh/.zshrc`).
- **Alacritty** — terminal configuration and color scheme (`alacritty/alacritty.toml`).
- **Vim** — minimal, ergonomic `.vimrc` for comfortable editing (`vim/.vimrc`).
- **Tmux** — lightweight session defaults tuned for clipboard and Alacritty (`tmux/.tmux.conf`).
- **Firefox** — small UI improvements via `userChrome.css` / `userContent.css` (manual enable required).

## 📂 Structure

```text
.
├── alacritty
│   ├── .config
│   │   └── alacritty
│   └── alacritty.toml
├── firefox
│   ├── img
│   │   └── dark-gradient-background.jpg
│   ├── userChrome.css
│   └── userContent.css
├── .screenshots
│   ├── firefox-preview.png
│   └── zsh-preview.png
├── tmux
│   └── .tmux.conf
├── vim
│   └── .vimrc
├── zsh
│   └── .zshrc
├── install.sh
└── README.md
```