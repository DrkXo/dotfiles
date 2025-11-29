### -- HISTORY CONFIG ----------------------------------------------------

# Where to store history
export HISTFILE="$HOME/.zsh_history"

# How many lines of history to keep in memory / on disk
export HISTSIZE=100000
export SAVEHIST=100000

# Good history behavior
setopt hist_ignore_dups      # no duplicate commands
setopt hist_ignore_space     # ignore commands starting with space
setopt share_history         # share history between sessions
setopt append_history        # append instead of rewrite
setopt inc_append_history    # save after each command
setopt extended_history      # save timestamps

# Prevent history loss with aggressive Zinit or plugins
setopt no_hist_beep



### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk



### ---------------------------------------------------------
### 2. PATH variables (AFTER Zinit block)
### ---------------------------------------------------------
export PATH="$HOME/.cargo/bin:$PATH"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/29.0.14033849"

export PATH="$PATH:$HOME/SDK/flutter/bin"
export PATH="$PATH:$HOME/.pub-cache/bin"
export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable


### ---------------------------------------------------------
### 3. Plugins
### ---------------------------------------------------------
# ---- Completion System ----
autoload -Uz compinit
compinit
zmodload zsh/complist
zstyle ':completion:*' menu select

# Menu navigation
bindkey -M menuselect '^[[Z' reverse-menu-complete

# ---- Zinit Plugins ----
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# Fzf enhancement
zinit light Aloxaf/fzf-tab
zstyle ':fzf-tab:complete:*' fzf-preview 'ls --color=always $realpath'

# ---- Fzf binary ----
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"


### ---------------------------------------------------------
### 4. Aliases
### ---------------------------------------------------------
alias c="clear"
alias q="exit"

alias ls="ls --color=auto"
alias ll="ls -la"
alias la="ls -A"
alias l="ls -CF"
alias grep="grep --color=auto"

alias mkdir="mkdir -p"

# Git
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

# Network
alias wc='warp-cli connect'
alias wd='warp-cli disconnect'
alias myip='curl -s https://ipinfo.io/ip'

# GPU/Gaming
alias winegpu="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=1 MANGOHUD=1"
alias winerun="$winegpu wine"

# Flutter
alias brb='dart run build_runner build --delete-conflicting-outputs'

# Audio share
alias audio_share="$HOME/Apps/audio-share-server-cmd/bin/as-cmd -b"

# n-m3u8dl-re
alias m3u8dl='n-m3u8dl-re'


### ---------------------------------------------------------
### 5. Prompt (Starship)
### ---------------------------------------------------------
eval "$(starship init zsh)"

# Fallback prompt
if [[ -z "$STARSHIP_SHELL" ]]; then
  PROMPT='%F{cyan}[%n@%m %1~]%f$ '
fi



### ---------------------------------------------------------
### Keybindings Fix
### ---------------------------------------------------------

# Main keymap
bindkey "${terminfo[kcuu1]}" up-line-or-history
bindkey "${terminfo[kcud1]}" down-line-or-history
bindkey "${terminfo[kcub1]}" backward-char
bindkey "${terminfo[kcuf1]}" forward-char

# Menuselect keymap (completion menu)
bindkey -M menuselect '^[[A' up-line-or-history
bindkey -M menuselect '^[[B' down-line-or-history
bindkey -M menuselect '^[[C' forward-char
bindkey -M menuselect '^[[D' backward-char



# --- Ctrl + Arrow keys word navigation ---
# Ctrl + Left: backward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[5D'    backward-word       # some terminals use this

# Ctrl + Right: forward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[5C'    forward-word        # alternate sequence

