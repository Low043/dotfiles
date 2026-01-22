# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
# Arch Linux installs Oh My Zsh to /usr/share/oh-my-zsh/
export ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load
# ZSH_THEME="powerlevel10k/powerlevel10k"
# Arch Linux Powerlevel10k Fix: Source the theme directly
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Custom Zsh Configuration ---

# 1. Autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_PRIORITY_COMMANDS=(
    "sudo pacman -S "
    "poweroff"
    "reboot"
    "ls -l"
    "clear"
    "fastfetch"
    "btop"
    "git commit -m "
    "git push origin "
    "git pull origin "
    "git checkout "
    "git restore "
    "git status"
)

_zsh_autosuggest_strategy_manual() {
    local prefix="$1"
    for command in "${ZSH_PRIORITY_COMMANDS[@]}"; do
        if [[ "$command" == "$prefix"* ]]; then
        typeset -g suggestion="$command"
        return
        fi
    done
}

ZSH_AUTOSUGGEST_STRATEGY=(manual completion history)

# 2. Keybindings
bindkey '^I' autosuggest-accept
bindkey '^[[Z' forward-word

# 3. Completion Priorities (zstyle)
zstyle ':completion:*' group-order directories files
zstyle ':completion:*' tag-order 'directories' 'files' 'commands'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # Case-insensitive
