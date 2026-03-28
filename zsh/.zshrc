# ==============================================================================
#                               USER ZSH CONFIG
# ==============================================================================

autoload -Uz compinit
compinit

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# Shell Behavior
setopt AUTO_CD
setopt COMPLETE_IN_WORD
setopt EXTENDED_GLOB
setopt SHARE_HISTORY
setopt PROMPT_SUBST 

# History Settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Aliases
alias ls='ls --color=auto'
alias ll='ls -la'
alias grep='grep --color=auto'

# ==============================================================================
#                                    PROMPT
# ==============================================================================

git_branch() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    [[ -n $branch ]] && echo " %F{141}[$branch]%f"
}

# Prompt Symbol: Red '#' for root, White '$' for regular user
USER_COLOR="%(#.%F{196}.%F{green})"

PROMPT='%B${USER_COLOR}%n@%m%f %F{yellow}%~%f$(git_branch)
${USER_COLOR}%(#.#.$)%f '

# Zsh Autosuggestions
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
fi

if [[ -z "$TMUX" && $- == *i* ]]; then
    tmux attach-session -t default || tmux new-session -s default
fi

# ==============================================================================
#                              SYNTAX HIGHLIGHTING
# ==============================================================================

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    
    # Commands, builtins and aliases - Cyan
    ZSH_HIGHLIGHT_STYLES[command]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
    
    # Sudo / Precommands - Orange
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=#FF9104,bold'
    
    # Paths - Yellow
    ZSH_HIGHLIGHT_STYLES[path]='fg=yellow,bold'
    
    # Unknown commands - White (to avoid distracting red colors)
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
fi

